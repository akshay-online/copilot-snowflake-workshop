-- OBJECT: STAGING.STG_AGENT
-- PURPOSE: Seed the same three rows as data/202610/agent.csv without file upload; LAB-101
-- RUN: After September history and processing loads; replaces staging only
BEGIN;
DELETE FROM STAGING.STG_AGENT;
INSERT INTO STAGING.STG_AGENT (AGENT_ID, AGENT_NAME, AGENT_EMAIL, AGENT_STATUS, COMMISSION_RATE, HIRE_DATE)
VALUES
    ('A001', 'Sample Agent One', 'agent.one@example.com', 'ACTIVE', 0.0500, '2024-01-15'),
    ('A002', 'Sample Agent Two', 'agent.two@example.com', 'INACTIVE', 0.0400, '2024-03-20'),
    ('A004', 'Sample Agent Four', 'agent.four@example.com', 'ACTIVE', 0.0550, '2026-10-01');
COMMIT;