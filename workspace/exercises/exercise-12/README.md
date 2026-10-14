# Exercise 11: Use the Skills Directly

**Time:** 15 minutes. **Prerequisite:** exercises 01-10. **Mode:** built-in Agent.
**Example count:** 2. **Snowflake:** not required.

## What and Why

Use the table and loader skills directly in Chat, then compare this focused workflow with the custom agent.
You already have three table definitions, a history reference and repaired processing code.
The kit should preserve correct work and generate the missing staging loader, not invent a second pipeline.

## Steps

1. Keep a copy or local diff of your current work so you can inspect proposed changes.
2. Send prompt 1 in the built-in Agent mode to use snowflake-tables.
3. Check its spec summary and changes before keeping them. Verify six business columns and two sensitive columns.
4. Send prompt 2 to use snowflake-loaders, replacing the author name.
   Answer only genuinely missing input questions; the stage, file format and scheduler are in requirements.
5. Review the generated staging loader and any changes to existing loaders. Inspect References for the relevant kit files.
6. Do not deploy automatically. Optional execution is a separate, human-controlled exercise.

## Prompt 1

```text
Use the snowflake-tables skill to create or review the AGENT layer tables for LAB-101.
Read #file:specs/agent_column_spec.csv and #file:specs/agent_requirements.md first.
Report the business key, business-column count and sensitive columns; stop if the spec/key is missing.
Preserve correct existing DDL and return the skill checklist with file evidence.
Do not generate procedures, deploy SQL or commit.
```

## Prompt 2

```text
Use the snowflake-loaders skill to create or review the AGENT loaders for LAB-101.
Author: <your name>. Read #file:specs/agent_column_spec.csv and
#file:specs/agent_requirements.md plus all three table DDL files before editing.
Stop if inputs or table definitions are missing/incomplete; ask for what is needed.
Confirm the file source, business key, hash columns, file format, stage and scheduler order.
Preserve correct existing behavior and append version/change-log entries for changed procedures.
Return the skill checklist and September CALL statements in staging -> history -> processing order.
Do not alter setup, tests or DDL, execute SQL, deploy or commit.
```

## Expected Output and Checks

| Output under workspace | Check |
|---|---|
| ddl/agent/stg_agent.sql | Six business columns |
| ddl/agent/hist_agent.sql | Six business plus five tracking columns |
| ddl/agent/prc_agent.sql | Six business plus three snapshot columns; two mask statements |
| procs/agent/sp_load_stg_agent.sql | Validated folder; DELETE/COPY; DQ; zero-row WARN |
| procs/agent/sp_load_hist_agent.sql | Same SCD2 behavior explained in exercise 02 |
| procs/agent/sp_load_prc_agent.sql | Same corrected month-isolated behavior tested in exercise 04 |

- [ ] Correct existing definitions are preserved; no unexplained replacement or dropped column.
- [ ] Generated application SQL has no unresolved template placeholders.
- [ ] Logging/header requirements are met and values are bound except the validated stage-folder exception.
- [ ] Supplied setup, CSV files, fixture and existing tests have not been rewritten to hide failures.
- [ ] CALL statements are supplied as text only, in staging -> history -> processing order.

If a skill was not used, check its discovery description and customization diagnostics, then explicitly
attach its SKILL.md from .github/skills and retry. Verify its template links; do not compensate by
adding unrelated rules to the business requirements.

Next: [exercise 12](../exercise-12/README.md).