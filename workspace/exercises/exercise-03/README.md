# Exercise 03: Fix a Broken Loader

**Time:** 15 minutes. **Prerequisite:** exercise 02. **Mode:** Agent. **Example count:** 1.
**Snowflake:** not required. Continue the same thread.

## What and Why

Repair an intentionally defective processing procedure using explicit requirements and a working body pattern.
The goal is to preserve monthly snapshots, not merely to make the SQL compile.
The history procedure supplies helpers and failure handling, not processing business logic.

## Steps

1. Open [broken processing procedure](../../procs/agent/sp_load_prc_agent.sql).
   Do not deploy this starter.
2. Attach the requirements, both standards and history reference listed below.
3. Send the prompt, review each proposed change, and keep only edits to the processing procedure.
4. Check the result with the checklist. The corrected file will be the test target in exercise 04.

## Prompt

```text
/fix #file:procs/agent/sp_load_prc_agent.sql #file:procs/agent/sp_load_hist_agent.sql
#file:specs/agent_requirements.md #file:specs/agent_column_spec.csv
#file:standards/snowflake_standards.md #file:standards/logging_standards.md
List each defect with the requirement it violates, then repair only SP_LOAD_PRC_AGENT.
Reuse the history loader's helpers/header/error-handling pattern, not its SCD2 logic.
Require a real ISO month-end P_VALUATION_DATE; reject, do not normalize, mid-month input.
Delete only that valuation month and insert current history rows using explicit columns
and binds. Preserve other months. Return SUCCESS: deleted=<n> inserted=<n>.
Include required process logs and audit rows. Use LAB-101; author: <your name>.
Update the file header to say it is repaired. Do not deploy or edit infrastructure.
```

## Expected Output and Checks

| Defect in starter | Evidence in repaired file |
|---|---|
| Lowercase argument reference | P_VALUATION_DATE used inside JavaScript |
| No date validation | Format, real date, month-end checks before DML |
| Unscoped DELETE | WHERE VALUATION_DATE = bound date |
| SELECT * includes tracking columns and old versions | Explicit mapping; CURRENT_IND='Y' |
| SQL value concatenation | `?` parameters with binds |
| No transaction or rethrow | BEGIN/COMMIT; guarded rollback; original error thrown |
| No counts, logs, audit or standard header | Required fields/helpers and exact return format |

- [ ] September rows survive an October load; a repeated October load cannot duplicate October rows.
- [ ] Sensitive name/email values and raw error messages are not written to audit/log text.
- [ ] Failure before BEGIN still writes a FAILED audit; successful audit ROW_COUNT equals inserted count.
- [ ] Only the processing file changed. No database execution occurred.

A model may overlook a defect. Compare its patch with every row above before moving on.
The optional Snowflake path deploys this corrected file, never the original starter.

Next, in the same thread: [exercise 04](../exercise-04/README.md).