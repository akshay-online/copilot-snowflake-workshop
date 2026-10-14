# Workshop Snowflake Standards

These rules and [agent requirements](../specs/agent_requirements.md) govern every exercise.
Logging details live in [logging standards](logging_standards.md). Do not import rules from other demos.

## Naming and Files

| Object | Name | File |
|---|---|---|
| Staging table | STAGING.STG_AGENT | ddl/agent/stg_agent.sql |
| History table | HISTORY.HIST_AGENT | ddl/agent/hist_agent.sql |
| Processing table | PROCESSING.PRC_AGENT | ddl/agent/prc_agent.sql |
| Loader | ETL.SP_LOAD_<LAYER>_AGENT | procs/agent/sp_load_<layer>_agent.sql |
| Stage / file format | STAGING.AGENT_STAGE / STAGING.FF_AGENT_CSV | setup/01_bootstrap.sql |
| Optional reporting view | REPORTING.VW_<SUBJECT> | views/agent/vw_<subject>.sql |
| Integration tests | test_<behavior> | tests/agent/test_sp_load_<layer>_agent.py |

Use UPPER_SNAKE_CASE identifiers and schema-qualified objects without database names in application SQL.
Only setup scripts choose the database. Every SQL file starts with a 2-4 line `--` header:
object, purpose, and when to run it. Use ticket LAB-101; never invent a business rule.

## Tables

Read the CSV spec with a CSV parser, preserving COLUMN_ORDER. DATA_TYPE is the complete SQL type.
NULLABLE=N means NOT NULL. Every table and column has a COMMENT; escape apostrophes in descriptions.
Use CREATE TABLE IF NOT EXISTS, not a destructive table replacement.

Staging has the six business columns only. History adds these NOT NULL columns, in order:

| Column | Type | Value |
|---|---|---|
| BEGIN_EFFECTIVE_DATE | DATE | Load date |
| END_EFFECTIVE_DATE | DATE | 9999-12-31 while current; next load date minus one when closed |
| CURRENT_IND | CHAR(1) | Y or N |
| LAST_UPDATE_USER | VARCHAR(100) | CURRENT_USER() |
| LAST_UPDATE_DATE | TIMESTAMP_NTZ | CURRENT_TIMESTAMP() |

Processing adds these NOT NULL columns, in order: VALUATION_DATE DATE,
LAST_UPDATE_USER VARCHAR(100), LAST_UPDATE_DATE TIMESTAMP_NTZ.
Apply PROCESSING.MP_MASK_STRING only to the two SENSITIVE=Y processing columns.
The workshop policy always returns ***MASKED*** for non-NULL values, regardless of role.
Staging and history remain unmasked: only synthetic data may be used.

## Procedures

- LANGUAGE JAVASCRIPT, EXECUTE AS CALLER, RETURNS VARCHAR with no length. Reference arguments in UPPERCASE.
- Parameter values use binds with `?`; do not concatenate them into SQL.
- Exception: COPY stage paths cannot use a value bind. Derive YYYYMM only after strict ISO-format,
  real-calendar-date and month-end validation; concatenate only the resulting six digits into a fixed stage prefix.
- Staging uses DELETE + COPY INTO, FORCE=TRUE, ON_ERROR=ABORT_STATEMENT. Count staging after COPY;
  do not assume the COPY result has a rows_loaded column for an empty folder.
- Validate staging key uniqueness, status and commission before committing. An empty staging load succeeds with WARN.
- For SCD2, HASH compares every non-key business column with the same order on each side. UPDATE then INSERT.
- Reject changed same-date/backdated history versions before closing them. Missing keys remain unchanged.
- Processing accepts month end only, filters CURRENT_IND='Y', and deletes only the requested VALUATION_DATE.
- Explicit column lists; no SELECT *. Use Statement.getNumRowsAffected() for DML counts.
- Create objects outside load transactions; DDL may auto-commit. Use BEGIN/COMMIT and ROLLBACK on DML failure.
- Follow the header, logging and audit sequence in [logging standards](logging_standards.md).

## Testing

Use pytest and snowflake-connector-python with the supplied sf fixture. Mark tests integration.
Tests use a disposable zero-copy database clone; never a production or shared training database directly.
Arrange: truncate and seed through sf; Act: call the procedure; Assert: data, return message and audit status.
Test successful loads, unchanged reruns, month isolation, date rejection and rollback. Use synthetic rows only.
No credentials in files or chat. Missing connection environment variables mean SKIPPED, not PASSED.
Local SQL review is not proof of Snowflake execution.

## Reporting Views

No view is required for this workshop; include these rules in the reusable instruction kit.
Views belong to REPORTING and read PROCESSING only. List columns explicitly, exclude sensitive columns
unless a requirement explicitly permits them, and aggregate child rows before joining to avoid multiplication.
Use CREATE OR REPLACE VIEW, a table-level view COMMENT and column COMMENTs.