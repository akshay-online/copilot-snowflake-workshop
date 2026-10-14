-- OBJECT: HISTORY.HIST_AGENT
-- PURPOSE: Store all synthetic agent versions; LAB-101
-- RUN: After setup/01_bootstrap.sql in your sandbox
CREATE TABLE IF NOT EXISTS HISTORY.HIST_AGENT (
    AGENT_ID VARCHAR(12) NOT NULL COMMENT 'Unique synthetic agent identifier',
    AGENT_NAME VARCHAR(80) NOT NULL COMMENT 'Synthetic agent display name',
    AGENT_EMAIL VARCHAR(120) COMMENT 'Synthetic contact email',
    AGENT_STATUS VARCHAR(12) NOT NULL COMMENT 'ACTIVE or INACTIVE',
    COMMISSION_RATE NUMBER(7,4) NOT NULL COMMENT 'Commission fraction between zero and one',
    HIRE_DATE DATE NOT NULL COMMENT 'Agent hire date',
    BEGIN_EFFECTIVE_DATE DATE NOT NULL COMMENT 'Load date that opened this version',
    END_EFFECTIVE_DATE DATE NOT NULL COMMENT '9999-12-31 while current; next load date minus one when closed',
    CURRENT_IND CHAR(1) NOT NULL COMMENT 'Y for current or N for closed',
    LAST_UPDATE_USER VARCHAR(100) NOT NULL COMMENT 'User who wrote the version',
    LAST_UPDATE_DATE TIMESTAMP_NTZ NOT NULL COMMENT 'Timestamp of the last change'
) COMMENT = 'Synthetic AGENT SCD Type 2 history';