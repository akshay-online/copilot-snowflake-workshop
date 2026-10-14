# Exercise 04: Generate Integration Tests

**Time:** 20 minutes. **Prerequisite:** repaired processing loader from exercise 03.
**Mode:** Agent. **Example count:** 1. Continue the same thread. **Snowflake:** optional.

## What and Why

Generate pytest tests for the behavior you just repaired. These are integration tests because the JavaScript
procedure executes inside Snowflake. The supplied sf fixture clones your sandbox and cleans up afterward;
it is not a local Snowflake emulator.

## Steps

1. Read [test fixture](../../tests/conftest.py) and the Testing section of
   [standards](../../standards/snowflake_standards.md).
2. Send the prompt with your repaired procedure attached.
3. Review the generated test file for independent setup and meaningful assertions.
4. Code-only route: record the checklist as reviewed and execution as NOT RUN.
5. Live route: follow [optional setup and pytest execution](../../README.md#optional-pytest-execution) first,
   then run the generated test file. Redeploy the repaired procedure before testing; the fixture clones deployed objects.

## Prompt

```text
/tests #file:procs/agent/sp_load_prc_agent.sql #file:tests/conftest.py
#file:specs/agent_column_spec.csv #file:specs/agent_requirements.md
#file:standards/snowflake_standards.md #file:standards/logging_standards.md
Create tests/agent/test_sp_load_prc_agent.py using sf and pytest.mark.integration.
Use Arrange/Act/Assert and synthetic rows with all NOT NULL tracking fields.
Reset and seed each test's history, processing, audit and log tables through sf.
Cover current-only selection; exact return counts and SUCCESS audit; preservation of
September when October reloads; idempotent rerun; invalid and mid-month dates leaving
existing data unchanged with FAILED audit and ERROR log.
Also prove DML rollback: seed a processing row, temporarily rename its LAST_UPDATE_DATE
column to TEST_HIDDEN_COLUMN in the clone to make INSERT fail after DELETE, call with
a valid month end, and assert the original row survived. Restore the column in finally.
Use sf.call(procedure, *args), not a list as one argument. Processing names/emails are
masked: assert identifiers, amounts, dates and mask tokens, not cleartext names.
Never open another connection, change databases, modify the fixture, or execute tests now.
```

## Expected Output and Checks

- [ ] One test file under tests/agent, with integration markers and no hard-coded connection details.
- [ ] Each test seeds its own data; success is not dependent on another test's order.
- [ ] Tests assert data and audit/log behavior, not just a nonempty response.
- [ ] Rejection-before-BEGIN is distinguished from actual rollback after DELETE.
- [ ] The temporary schema change is clone-only and always restored, including when assertions fail.
- [ ] The fixture creates/drops only its generated clone; no test switches back to the source database.

If execution fails, first distinguish setup/authentication problems from assertion failures.
Missing connection variables produce SKIPPED. No collected tests means the file was not created/discovered.
Neither result proves the loader works. Keep the test path and outcome for the next exercise.

Next, in the same thread: [exercise 05](../exercise-05/README.md).