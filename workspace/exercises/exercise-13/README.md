# Exercise 13: Validate the Pipeline

**Time:** 20 minutes plus optional setup. **Prerequisite:** reviewed output from exercises 11-12.
**Mode:** Ask for review; humans execute optional SQL. **Example count:** 1 two-month scenario, 1 review prompt.

## What and Why

Check that the kit preserves the behavior established in the fundamentals.
Static review can identify mismatches, but only a live run proves Snowflake accepts the SQL and produces the expected data.
You may complete the code-only route without credentials and clearly mark runtime checks NOT RUN.

## Steps

1. Send the review prompt below and check its table against the requirements. This is the code-only route.
2. Optional live route: follow [sandbox setup](../../README.md) in a **fresh, empty** allocated database.
   Deploy the reviewed table files and all three reviewed procedures. Do not use the original broken starter.
3. Choose file mode or DML mode, not both. File mode uploads the two CSVs through
   [upload script](../../setup/02_upload_files.sql) or Snowsight.
   DML mode uses [September seed](../../dml/seed_september.sql) and
   [October seed](../../dml/seed_october.sql) instead of the corresponding staging CALLs.
4. Open [run/load_agent.sql](../../run/load_agent.sql). Run section 1, then section 2.
   In DML mode seed just before each month's history CALL. Do not seed both months before loading history.
5. Run [run/validate_agent.sql](../../run/validate_agent.sql).
   The named checks must say PASS; the BAD_AGENT_ID query must return zero rows. Inspect audits and logs too.
6. Run section 3 of the load script for unchanged October reruns, then repeat the validation queries.
7. Run section 4 alone: its mid-month processing CALL must fail. Run the audit/log queries separately afterward;
   expect FAILED audit and ERROR log, with snapshot counts still 3 and 4.
8. File mode only: run section 5 last. No November file means loaded=0 and WARN. Do not run downstream loaders afterward.
   DML mode must mark COPY/no-file behavior NOT RUN, rather than infer it from seed scripts.
9. Optionally run the generated pytest tests as described in the workspace guide. Report actual results, not expectations.

## Prompt: Pre-Execution Review

```text
#file:specs/agent_requirements.md #file:specs/agent_column_spec.csv
#file:procs/agent/sp_load_stg_agent.sql #file:procs/agent/sp_load_hist_agent.sql
#file:procs/agent/sp_load_prc_agent.sql #file:run/load_agent.sql #file:run/validate_agent.sql
Review the AGENT pipeline against the supplied two-month scenario without editing or executing.
Report a pass/fail static checklist with file evidence for key/hash columns, month-end
validation, snapshot isolation, masking-safe logging, rollback and audit behavior.
Predict first-load counts, unchanged rerun counts and mid-month/empty-file behavior.
Separate predictions from observations and label all unexecuted runtime checks NOT RUN.
Call out blockers before a human deploys; do not invent results or execute database commands.
```

## Expected Output and Checks

| Operation | Expected first-run result in a fresh sandbox |
|---|---|
| September staging (file mode) | SUCCESS: deleted=0 loaded=3 |
| September history | SUCCESS: inserted=3 closed=0 |
| September processing | SUCCESS: deleted=0 inserted=3 |
| October staging (file mode) | SUCCESS: deleted=3 loaded=3 |
| October history | SUCCESS: inserted=2 closed=1 |
| October processing | SUCCESS: deleted=0 inserted=4 |
| October history rerun | SUCCESS: inserted=0 closed=0 |
| October processing rerun | SUCCESS: deleted=4 inserted=4 |
| 2026-10-15 processing | Exception, ERROR log, FAILED audit; snapshot rows unchanged |
| November staging (file mode) | SUCCESS: deleted=3 loaded=0 and WARN; no downstream CALL |

- [ ] Five total history versions; four current; A003 remains current from September.
- [ ] A002's old version ends 2026-10-30; its new version begins 2026-10-31.
- [ ] September/October processing counts remain 3/4; names and non-NULL emails are ***MASKED***.
- [ ] Each successful loader run has its audit summary and UUID-linked BEGIN, STEP and END logs.
- [ ] Failure has a FAILED audit and ERROR log. Pytest's clone-only fault test separately proves DML rollback.
- [ ] Outcome honestly distinguishes static review, live results, failures, skips and not-run checks.

If counts differ, verify the sandbox was empty, the right procedures were deployed, and files loaded in chronological order.
Do not rerun September against October's current history to reconstruct a historical snapshot: that is outside this design.
Resolve a mismatch before marking completion. Do not erase logs or relax assertions just to produce PASS.

You have completed the learning path. Return to the [workshop index](../../README.md#learning-path).