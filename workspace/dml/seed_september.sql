-- OBJECT: STAGING.STG_AGENT
-- PURPOSE: Seed the same three rows as data/202609/agent.csv without file upload; LAB-101
-- RUN: In your sandbox after table deployment; replaces staging only, not history
BEGIN;
DELETE FROM STAGING.STG_AGENT;
INSERT INTO STAGING.STG_AGENT (AGENT_ID, AGENT_NAME, AGENT_EMAIL, AGENT_STATUS, COMMISSION_RATE, HIRE_DATE)
VALUES
    ('A001', 'Sample Agent One', 'agent.one@example.com', 'ACTIVE', 0.0500, '2024-01-15'),
    ('A002', 'Sample Agent Two', 'agent.two@example.com', 'ACTIVE', 0.0600, '2024-03-20'),
    ('A003', 'Sample Agent Three', NULL, 'ACTIVE', 0.0450, '2025-02-10');
COMMIT;