# Exercise 08: A Table-Building Skill

**Time:** 15 minutes. **Prerequisite:** exercises 06-07. **Mode:** Agent.
**Example count:** 1. **Snowflake:** not required.

## What and Why

A skill packages repeatable steps with reusable resources. Its name/description allow discovery;
the full workflow and templates can be loaded when relevant. You will build the skill here and use it in exercise 11.
Instructions say which rules apply; this skill says how to turn a spec into three table definitions.

## Steps

1. Inspect the [spec](../../specs/agent_column_spec.csv) and the three
   [DDL files](../../ddl/agent/), including your staging completion.
2. Send the prompt. The output is skill documentation and templates, not new application DDL yet.
3. Open SKILL.md and each template. Check that links resolve relative to the skill file.
4. Keep the changes after reviewing the checklist below.

## Prompt

```text
Create .github/skills/snowflake-tables/SKILL.md and templates/stg_table.sql,
templates/hist_table.sql, templates/prc_table.sql inside that skill directory.
Read #file:standards/snowflake_standards.md #file:specs/agent_column_spec.csv
#file:ddl/agent/hist_agent.sql #file:ddl/agent/prc_agent.sql.
SKILL.md frontmatter: name: snowflake-tables; quoted description saying to use this
skill when asked to create staging, SCD2 history or processing table DDL from a column spec.
Inputs: entity, spec path, requirements path, ticket. Steps: parse CSV by COLUMN_ORDER;
confirm exactly one BUSINESS_KEY=Y or stop and ask; preserve DATA_TYPE; map NULLABLE;
escape description apostrophes; fill templates; write ddl/<entity>/ layer files.
Use CREATE TABLE IF NOT EXISTS, ordered tracking columns, table/column COMMENTs,
and processing-only mask statements for SENSITIVE=Y string columns. Ask before unsupported
mask types. Templates use <ENTITY>, <BUSINESS_COLUMNS>, <MASK_STATEMENTS>, <TICKET>
only where needed, and include script headers. Link templates with ./templates/ paths.
For existing DDL, preserve correct definitions and show differences rather than overwriting blindly.
End with a pass/fail checklist: columns, types, nullability, comments, tracking order,
masking and no unresolved template placeholders in generated application SQL.
Create the skill and templates only; do not change ddl/ or deploy anything.
```

## Expected Output and Checks

- [ ] One SKILL.md plus three templates, all under .github/skills/snowflake-tables.
- [ ] Frontmatter name equals the folder name; description includes useful task triggers.
- [ ] Skill has input validation, generation steps and a checklist, not just a copy of standards.
- [ ] Templates have no fixed AGENT business columns or environment database names.
- [ ] Template placeholders are intentional; the no-placeholder rule applies to generated application SQL.
- [ ] Existing DDL is unchanged during this exercise.

If the skill is not later discovered, inspect its description and supported skill location,
then explicitly select/reference the skill. Instructions and skills are guidance, not hard enforcement.

Next: [exercise 09](../exercise-09/README.md).