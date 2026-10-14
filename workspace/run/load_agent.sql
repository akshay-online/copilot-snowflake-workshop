-- OBJECT: ETL AGENT loaders
-- PURPOSE: Exercise 13 two-month run, reruns and edge cases; LAB-101
-- RUN: Section by section in an empty personal sandbox after deployment/upload; never Run All

-- Section 1: September. DML route: run seed_september.sql instead of the first CALL.
CALL ETL.SP_LOAD_STG_AGENT('2026-09-30');
CALL ETL.SP_LOAD_HIST_AGENT('2026-09-30');
CALL ETL.SP_LOAD_PRC_AGENT('2026-09-30');

-- Section 2: October. DML route: run seed_october.sql instead of the first CALL.
CALL ETL.SP_LOAD_STG_AGENT('2026-10-31');
CALL ETL.SP_LOAD_HIST_AGENT('2026-10-31');
CALL ETL.SP_LOAD_PRC_AGENT('2026-10-31');

-- Section 3: Rerun October before any November staging load.
CALL ETL.SP_LOAD_HIST_AGENT('2026-10-31');
CALL ETL.SP_LOAD_PRC_AGENT('2026-10-31');

-- Section 4: Expected failure. Run this CALL alone, then inspect audit/log queries.
CALL ETL.SP_LOAD_PRC_AGENT('2026-10-15');

-- Section 5: File-route only. No November file exists: expect empty staging and WARN.
-- Do not call history or processing after this empty-file exercise.
CALL ETL.SP_LOAD_STG_AGENT('2026-11-30');