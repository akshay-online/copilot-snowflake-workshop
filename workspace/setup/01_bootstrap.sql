-- OBJECT: Workshop database and shared infrastructure
-- PURPOSE: Create isolated training objects for LAB-101; no production data
-- RUN: Edit WORKSHOP_DB to your allocated sandbox; review before executing
SET WORKSHOP_DB = 'COPILOT_LAB_YOURNAME';
CREATE DATABASE IF NOT EXISTS IDENTIFIER($WORKSHOP_DB);
USE DATABASE IDENTIFIER($WORKSHOP_DB);

CREATE SCHEMA IF NOT EXISTS STAGING;
CREATE SCHEMA IF NOT EXISTS HISTORY;
CREATE SCHEMA IF NOT EXISTS PROCESSING;
CREATE SCHEMA IF NOT EXISTS REPORTING;
CREATE SCHEMA IF NOT EXISTS ETL;
CREATE SCHEMA IF NOT EXISTS PROCESSING_LOG;

CREATE TABLE IF NOT EXISTS ETL.LOAD_AUDIT (
    AUDIT_ID NUMBER AUTOINCREMENT COMMENT 'Audit sequence',
    PROC_NAME VARCHAR(200) COMMENT 'Schema-qualified caller',
    TARGET_TABLE VARCHAR(200) COMMENT 'Schema-qualified target',
    STATUS VARCHAR(10) COMMENT 'SUCCESS or FAILED',
    ROW_COUNT NUMBER COMMENT 'Rows inserted or loaded; zero on failure',
    MESSAGE VARCHAR COMMENT 'Summary without sensitive values',
    RUN_USER VARCHAR(100) COMMENT 'Executing user',
    RUN_TS TIMESTAMP_NTZ COMMENT 'Audit timestamp'
) COMMENT = 'Workshop load summary';

CREATE TABLE IF NOT EXISTS PROCESSING_LOG.JOB_LOG (
    JOB_UUID VARCHAR(36) COMMENT 'Identifier shared by events in one run',
    PROC_NAME VARCHAR(200) COMMENT 'Schema-qualified caller',
    TARGET_TABLE VARCHAR(200) COMMENT 'Schema-qualified target',
    LOG_LEVEL VARCHAR(10) COMMENT 'DEBUG, INFO, WARN or ERROR',
    LOG_SECTION VARCHAR(30) COMMENT 'BEGIN, STEP n, END or ERROR',
    LOG_TEXT VARCHAR COMMENT 'Non-sensitive event description',
    LOG_USER VARCHAR(100) COMMENT 'Executing user',
    LOG_TS TIMESTAMP_NTZ COMMENT 'Event timestamp'
) COMMENT = 'Workshop step-level process log';

CREATE OR REPLACE PROCEDURE PROCESSING_LOG.CREATE_JOB_UUID(P_PROC_NAME VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
var result = snowflake.createStatement({sqlText: 'SELECT UUID_STRING()'}).execute();
result.next();
var jobId = result.getColumnValue(1);
snowflake.createStatement({sqlText: 'SET JOB_UUID = ?', binds: [jobId]}).execute();
return jobId;
$$;

CREATE OR REPLACE PROCEDURE PROCESSING_LOG.WRITE_LOG(
    P_PROC_NAME VARCHAR, P_TARGET_TABLE VARCHAR, P_LEVEL VARCHAR, P_SECTION VARCHAR, P_TEXT VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
if (['DEBUG', 'INFO', 'WARN', 'ERROR'].indexOf(P_LEVEL) < 0 || !P_SECTION || !P_SECTION.trim()) {
    throw new Error('Invalid log level or section');
}
var result = snowflake.createStatement({sqlText: 'SELECT $JOB_UUID'}).execute();
result.next();
var jobId = result.getColumnValue(1);
snowflake.execute({sqlText: 'BEGIN'});
try {
    snowflake.createStatement({
        sqlText: 'INSERT INTO PROCESSING_LOG.JOB_LOG ' +
            '(JOB_UUID, PROC_NAME, TARGET_TABLE, LOG_LEVEL, LOG_SECTION, LOG_TEXT, LOG_USER, LOG_TS) ' +
            'SELECT ?, ?, ?, ?, ?, ?, CURRENT_USER(), CURRENT_TIMESTAMP()',
        binds: [jobId, P_PROC_NAME, P_TARGET_TABLE, P_LEVEL, P_SECTION, P_TEXT]
    }).execute();
    snowflake.execute({sqlText: 'COMMIT'});
    return 'OK';
} catch (error) {
    snowflake.execute({sqlText: 'ROLLBACK'});
    throw error;
}
$$;

CREATE FILE FORMAT IF NOT EXISTS STAGING.FF_AGENT_CSV
    TYPE = CSV
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    EMPTY_FIELD_AS_NULL = TRUE
    TRIM_SPACE = TRUE
    DATE_FORMAT = 'YYYY-MM-DD'
    COMMENT = 'Workshop CSV with ISO dates';

CREATE STAGE IF NOT EXISTS STAGING.AGENT_STAGE
    FILE_FORMAT = STAGING.FF_AGENT_CSV
    COMMENT = 'Synthetic AGENT monthly input';

CREATE MASKING POLICY IF NOT EXISTS PROCESSING.MP_MASK_STRING
    AS (VALUE VARCHAR) RETURNS VARCHAR ->
    CASE WHEN VALUE IS NULL THEN NULL ELSE '***MASKED***' END
    COMMENT = 'Workshop policy: masks non-NULL strings for every role';