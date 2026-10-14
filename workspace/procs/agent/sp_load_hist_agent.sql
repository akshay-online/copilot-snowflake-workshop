-- OBJECT: ETL.SP_LOAD_HIST_AGENT
-- PURPOSE: SCD Type 2 reference for explanation and reusable skills; LAB-101
-- RUN: Deploy after setup and tables; call with no enclosing transaction
CREATE OR REPLACE PROCEDURE ETL.SP_LOAD_HIST_AGENT(P_LOAD_DATE VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
/*
PROCEDURE: ETL.SP_LOAD_HIST_AGENT
TYPE: LOAD
PURPOSE: Close changed agent versions and insert new current versions.
AUTHOR: Workshop authors
VERSION: 1.0
INPUTS: STAGING.STG_AGENT, HISTORY.HIST_AGENT
PARAMETERS: P_LOAD_DATE - real ISO date, chronological loads only
OUTPUTS: HISTORY.HIST_AGENT, ETL.LOAD_AUDIT, PROCESSING_LOG.JOB_LOG
CALLS: PROCESSING_LOG.CREATE_JOB_UUID, PROCESSING_LOG.WRITE_LOG
RUN_ORDER: AGENT_MONTHLY step 2
CHANGE_LOG: 2026-10-14, Workshop authors, LAB-101, Initial teaching reference
*/
var PROC_NAME = 'ETL.SP_LOAD_HIST_AGENT';
var TARGET = 'HISTORY.HIST_AGENT';
var transactionOpen = false;

function exec(sql, binds) {
    return snowflake.createStatement({sqlText: sql, binds: binds || []}).execute();
}
function scalar(sql, binds) {
    var result = exec(sql, binds);
    result.next();
    return result.getColumnValue(1);
}
function dml(sql, binds) {
    var statement = snowflake.createStatement({sqlText: sql, binds: binds || []});
    statement.execute();
    return statement.getNumRowsAffected();
}
function log(level, section, text) {
    exec('CALL PROCESSING_LOG.WRITE_LOG(?, ?, ?, ?, ?)', [PROC_NAME, TARGET, level, section, text]);
}
function audit(status, count, text) {
    exec('INSERT INTO ETL.LOAD_AUDIT ' +
        '(PROC_NAME, TARGET_TABLE, STATUS, ROW_COUNT, MESSAGE, RUN_USER, RUN_TS) ' +
        'SELECT ?, ?, ?, ?, ?, CURRENT_USER(), CURRENT_TIMESTAMP()',
        [PROC_NAME, TARGET, status, count, text]);
}

exec('CALL PROCESSING_LOG.CREATE_JOB_UUID(?)', [PROC_NAME]);
try {
    log('INFO', 'BEGIN', 'Begin history load rows=0');
    if (!/^\d{4}-\d{2}-\d{2}$/.test(P_LOAD_DATE || '') ||
        scalar("SELECT COALESCE(TO_CHAR(TRY_TO_DATE(?, 'YYYY-MM-DD'), 'YYYY-MM-DD') = ?, FALSE)",
            [P_LOAD_DATE, P_LOAD_DATE]) !== true) {
        throw new Error('Expected a real ISO load date');
    }
    exec('BEGIN');
    transactionOpen = true;
    if (scalar('SELECT COUNT(*) FROM (SELECT AGENT_ID FROM STAGING.STG_AGENT GROUP BY AGENT_ID HAVING COUNT(*) > 1)') > 0) {
        throw new Error('Duplicate staging keys');
    }
    if (scalar('SELECT COUNT(*) FROM STAGING.STG_AGENT source JOIN HISTORY.HIST_AGENT history ' +
        "ON source.AGENT_ID = history.AGENT_ID AND history.CURRENT_IND = 'Y' " +
        'WHERE HASH(source.AGENT_NAME, source.AGENT_EMAIL, source.AGENT_STATUS, source.COMMISSION_RATE, source.HIRE_DATE) ' +
        '<> HASH(history.AGENT_NAME, history.AGENT_EMAIL, history.AGENT_STATUS, history.COMMISSION_RATE, history.HIRE_DATE) ' +
        "AND TO_DATE(?, 'YYYY-MM-DD') <= history.BEGIN_EFFECTIVE_DATE", [P_LOAD_DATE]) > 0) {
        throw new Error('Changed versions require a later load date');
    }

    // STEP 1: Close changed versions so STEP 2 can find keys without a current row.
    var closed = dml('UPDATE HISTORY.HIST_AGENT AS history SET ' +
        "END_EFFECTIVE_DATE = DATEADD(DAY, -1, TO_DATE(?, 'YYYY-MM-DD')), CURRENT_IND = 'N', " +
        'LAST_UPDATE_USER = CURRENT_USER(), LAST_UPDATE_DATE = CURRENT_TIMESTAMP() ' +
        'FROM STAGING.STG_AGENT AS source ' +
        "WHERE history.AGENT_ID = source.AGENT_ID AND history.CURRENT_IND = 'Y' AND " +
        'HASH(history.AGENT_NAME, history.AGENT_EMAIL, history.AGENT_STATUS, history.COMMISSION_RATE, history.HIRE_DATE) <> ' +
        'HASH(source.AGENT_NAME, source.AGENT_EMAIL, source.AGENT_STATUS, source.COMMISSION_RATE, source.HIRE_DATE)',
        [P_LOAD_DATE]);
    log('INFO', 'STEP 1', 'Closed versions rows=' + closed);

    // STEP 2: New and changed keys now have no current history version.
    var inserted = dml('INSERT INTO HISTORY.HIST_AGENT ' +
        '(AGENT_ID, AGENT_NAME, AGENT_EMAIL, AGENT_STATUS, COMMISSION_RATE, HIRE_DATE, ' +
        'BEGIN_EFFECTIVE_DATE, END_EFFECTIVE_DATE, CURRENT_IND, LAST_UPDATE_USER, LAST_UPDATE_DATE) ' +
        'SELECT source.AGENT_ID, source.AGENT_NAME, source.AGENT_EMAIL, source.AGENT_STATUS, source.COMMISSION_RATE, source.HIRE_DATE, ' +
        "TO_DATE(?, 'YYYY-MM-DD'), TO_DATE('9999-12-31'), 'Y', CURRENT_USER(), CURRENT_TIMESTAMP() " +
        'FROM STAGING.STG_AGENT AS source LEFT JOIN HISTORY.HIST_AGENT AS history ' +
        "ON source.AGENT_ID = history.AGENT_ID AND history.CURRENT_IND = 'Y' WHERE history.AGENT_ID IS NULL",
        [P_LOAD_DATE]);
    log('INFO', 'STEP 2', 'Inserted versions rows=' + inserted);

    exec('COMMIT');
    transactionOpen = false;
    var message = 'SUCCESS: inserted=' + inserted + ' closed=' + closed;
    audit('SUCCESS', inserted, message);
    log('INFO', 'END', message);
    return message;
} catch (error) {
    if (transactionOpen) {
        try { exec('ROLLBACK'); } catch (rollbackError) {}
    }
    try { log('ERROR', 'ERROR', 'History load failed; code=' + (error.code || 'VALIDATION') + ' state=' + (error.state || 'N/A')); } catch (logError) {}
    try { audit('FAILED', 0, 'History load failed; inspect the caller error'); } catch (auditError) {}
    throw error;
}
$$;