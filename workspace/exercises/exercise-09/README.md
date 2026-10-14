# Exercise 09: A Procedure-Building Skill

**Time:** 20 minutes. **Prerequisite:** exercise 08 and repaired procedure from exercise 03.
**Mode:** Agent. **Example count:** 1. **Snowflake:** not required.

## What and Why

Package the three load patterns into a skill. Reusing the bound helpers, header and error sequence reduces
repeated boilerplate, while layer-specific templates keep staging, history and processing behavior distinct.
Only file-based staging is in scope: no share source or new business rules are required.

## Steps

1. Open [history reference](../../procs/agent/sp_load_hist_agent.sql), your repaired
   [processing procedure](../../procs/agent/sp_load_prc_agent.sql), and
   [logging standards](../../standards/logging_standards.md).
2. Send the prompt and review each template separately.
3. Compare the processing template to the contract established in exercise 03 and the history template to exercise 02.
4. Keep only the skill and template edits. The staging application procedure is generated later.

## Prompt

```text
Create .github/skills/snowflake-loaders/SKILL.md and templates/sp_load_stg.sql,
templates/sp_load_hist.sql, templates/sp_load_prc.sql inside that skill directory.
Read #file:standards/snowflake_standards.md #file:standards/logging_standards.md
#file:specs/agent_requirements.md #file:procs/agent/sp_load_hist_agent.sql
#file:procs/agent/sp_load_prc_agent.sql.
Use frontmatter name: snowflake-loaders and a quoted discovery description for generating
file-based staging, SCD2 history and monthly processing JavaScript load procedures.
Inputs: entity, spec, requirements, ticket, author, scheduler job, file format and stage.
Stop for missing inputs/table DDL. Document output paths, template placeholders and checklist.
Reuse the reference helpers/header/transaction/log/audit pattern from standards.
Staging template: real ISO month-end validation; derive YYYYMM only after validation;
DELETE then COPY from fixed @STAGING.<ENTITY>_STAGE/YYYYMM/ with FORCE=TRUE,
ON_ERROR=ABORT_STATEMENT and supplied file format; count after COPY; validate duplicate
keys and explicit requirement DQ rules before COMMIT; WARN on zero rows.
History template: chronological changed-key guard; HASH of ordered non-key business
columns; close changed versions then insert keys without a current row; retain missing keys.
Processing template: reject non-month-end dates; delete only requested month; insert
current history with explicit columns and bound valuation date; preserve other months.
Return the exact layer-specific messages in requirements. No sensitive values in logs.
Use generic placeholders for entity, key, columns/hash expressions, metadata and source;
link all templates with ./templates/ paths. Existing correct application files must be
reviewed, not blindly replaced. Generate only skill/templates now, never deploy or commit.
```

## Expected Output and Checks

- [ ] One SKILL.md and three layer templates; no new application procedure yet.
- [ ] Staging path concatenation is limited to a validated six-digit folder, not arbitrary user text.
- [ ] History and processing templates do not mix SCD2 tracking columns with snapshot columns.
- [ ] All templates preserve ERROR log / FAILED audit / original throw ordering with guarded rollback.
- [ ] Each layer has exact return format, counts, logs and masking-safe error summaries.
- [ ] Only supported file-source logic is introduced; missing requirements cause a question.

If templates diverge from your working history/processing files, correct the templates before invoking the skill.
A generic template must still preserve this workshop's explicit month-end and no-deletion rules.

Next: [exercise 10](../exercise-10/README.md).