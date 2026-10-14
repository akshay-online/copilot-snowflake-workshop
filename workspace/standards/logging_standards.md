# Workshop Logging Standards

Applies with [Snowflake standards](snowflake_standards.md). Setup provides the two logging utilities;
participants generate only the three AGENT loaders. Utilities are teaching infrastructure, not production services.

## Procedure Header

Inside the JavaScript body include one header with these fields:
PROCEDURE, TYPE=LOAD, PURPOSE, AUTHOR, VERSION, INPUTS, PARAMETERS, OUTPUTS, CALLS,
RUN_ORDER and CHANGE_LOG (date, author, LAB-101, description). Use N/A where inapplicable.
List ETL.LOAD_AUDIT and PROCESSING_LOG.JOB_LOG among outputs and both utility procedures among calls.
Increment VERSION and append a CHANGE_LOG entry when changing an existing loader.

## Interfaces

| Interface | Contract |
|---|---|
| PROCESSING_LOG.CREATE_JOB_UUID(P_PROC_NAME VARCHAR) | Returns a UUID and stores it in session variable JOB_UUID |
| PROCESSING_LOG.WRITE_LOG(P_PROC_NAME, P_TARGET_TABLE, P_LEVEL, P_SECTION, P_TEXT) | Five VARCHAR arguments; inserts a log in its own scoped transaction |
| ETL.LOAD_AUDIT | AUDIT_ID, PROC_NAME, TARGET_TABLE, STATUS, ROW_COUNT, MESSAGE, RUN_USER, RUN_TS |
| PROCESSING_LOG.JOB_LOG | JOB_UUID, PROC_NAME, TARGET_TABLE, LOG_LEVEL, LOG_SECTION, LOG_TEXT, LOG_USER, LOG_TS |

## Execution Order

1. Declare constants and exec(), scalar(), dml(), log() and audit() helpers. log() calls WRITE_LOG with binds.
2. Call CREATE_JOB_UUID before the main try block; if it fails, throw immediately.
3. In try: INFO/BEGIN log, validate arguments, BEGIN transaction, then perform DML.
4. Each DML has a matching `// STEP n` comment and INFO/STEP n log containing rows=<n>.
5. COMMIT, SUCCESS audit with inserted/loaded row count, INFO/END with the exact return message, return.
6. In catch: ROLLBACK if a transaction was opened; ERROR/ERROR log inside its own try/catch;
   FAILED audit with zero row count inside its own try/catch; throw the original error.

Track whether the data transaction is open. A validation failure before BEGIN must still log and audit;
do not issue a ROLLBACK against an unrelated transaction. Call loaders with no enclosing transaction.
Success auditing occurs after COMMIT: a later audit/log failure cannot undo committed data. Review operational
recovery separately before using this design in production.

## Log Content

- INFO: BEGIN, STEP n, END; DML messages include row counts.
- WARN: empty staging; processing may continue only when a human chooses to run it.
- DEBUG: reserved for non-sensitive diagnostics; not required for every step.
- ERROR: failure code/state and a fixed description. Never log source values, SQL literals, or raw
  error messages that could contain names/email. The caller receives the original thrown exception.
- Levels are DEBUG, INFO, WARN, ERROR; sections are nonempty. Utilities reject invalid values.
- Do not let a secondary logging/audit error replace the original failure.

The provided history loader is the executable body pattern. Reuse its bound helpers and error handling;
do not copy its history business logic into staging or processing.