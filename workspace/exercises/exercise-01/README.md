# Exercise 01: Inline Suggestions

**Time:** 10 minutes. **Workspace:** open the supplied workspace folder. **Prerequisite:** workshop setup.
**Example count:** 1. **Snowflake:** not required.

## What and Why

Complete the staging table using a comment as the request. Inline completion predicts code near your cursor;
the spec and neighboring DDL give it precise column names, types and style. You remain responsible for checking it.

## Steps

1. Open the [column spec](../../specs/agent_column_spec.csv),
   [standards](../../standards/snowflake_standards.md), and
   [history DDL](../../ddl/agent/hist_agent.sql) in editor tabs.
2. Open [staging DDL](../../ddl/agent/stg_agent.sql). Keep its supplied header.
3. Append the comment prompt below, then press Enter. Wait for an inline suggestion and accept useful code with Tab.
4. Continue until you have one complete CREATE TABLE statement. Do not generate history or processing again yet.
5. Compare every column against the CSV, not just the nearby history table.

## Prompt: Type in the SQL Editor

```sql
-- Complete STAGING.STG_AGENT using specs/agent_column_spec.csv in COLUMN_ORDER.
-- Use CREATE TABLE IF NOT EXISTS and exactly the six business columns.
-- DATA_TYPE already includes length/precision. NULLABLE=N means NOT NULL.
-- Add column COMMENTs from DESCRIPTION and a table COMMENT.
-- Follow ddl/agent/hist_agent.sql style, but do not include history tracking columns.
```

## Expected Output and Checks

- [ ] One CREATE TABLE IF NOT EXISTS STAGING.STG_AGENT statement, exactly six columns.
- [ ] AGENT_ID is VARCHAR(12); COMMISSION_RATE is NUMBER(7,4); HIRE_DATE is DATE.
- [ ] Only AGENT_EMAIL is nullable. All six columns and the table have comments.
- [ ] No history tracking columns, masking policy, database name or unrelated file edits.

If no suggestion appears, confirm inline suggestions are enabled for SQL and type `CREATE TABLE IF NOT EXISTS STAGING.`
as the beginning of the statement. Completion quality can vary; correct an inaccurate suggestion manually.
Do not execute SQL yet. The optional setup sequence is in the [workspace guide](../../README.md).

Next: [exercise 02](../exercise-02/README.md).