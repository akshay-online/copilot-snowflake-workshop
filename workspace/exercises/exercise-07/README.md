# Exercise 07: Path-Specific Instructions

**Time:** 15 minutes. **Prerequisite:** exercise 06. **Mode:** Agent.
**Example count:** 2. **Snowflake:** not required.

## What and Why

Separate general SQL rules from procedure and view rules using applyTo globs.
For a procedure under procs, both the broad SQL instructions and procedure instructions should apply.
View rules are part of the reusable kit; this exercise does not introduce a view-generation task.

## Steps

1. Keep [both standards](../../standards/) available as context.
2. Send prompt 1 and check its YAML frontmatter.
3. Send prompt 2 and check the two additional instruction files.
4. In later requests involving the history procedure, inspect References/customization diagnostics for both
   SQL and procedure instructions. Confirm the globs are relative to the open workspace root.

## Prompt 1: General SQL Rules

```text
Create .github/instructions/snowflake.instructions.md from
#file:standards/snowflake_standards.md and #file:specs/agent_requirements.md.
Use valid YAML frontmatter: a quoted description and applyTo: "**/*.sql".
Use concise tables/bullets for object/file naming, CSV column order and exact types,
NOT NULL and COMMENT rules, the five ordered history tracking columns and the three
ordered processing columns with types, SCD2 change/missing-key behavior, and processing-only
masking for SENSITIVE=Y. Preserve monthly snapshots and month-end rejection.
Link the authoritative standards with correct paths relative to this instruction file.
Do not duplicate detailed procedure/logging or reporting-view rules; those get separate files.
```

## Prompt 2: Procedure and View Rules

```text
From #file:standards/snowflake_standards.md and #file:standards/logging_standards.md,
create .github/instructions/procedures.instructions.md (applyTo: "procs/**/*.sql")
and .github/instructions/views.instructions.md (applyTo: "views/**/*.sql").
Give each valid YAML frontmatter with a quoted descriptive description.
Procedure rules: signature and UPPERCASE arguments; complete header; bound helper calls;
CREATE_JOB_UUID before try; validation then BEGIN; numbered DML with row-count logs;
COMMIT then SUCCESS audit and END log; guarded ROLLBACK then protected ERROR log and
FAILED audit then original throw. Never log raw source/error values.
Include validated stage-path exception, COPY FORCE=TRUE and count-after-COPY,
month-end rejection, month-scoped processing DELETE, and chronological SCD2 guard.
View rules: REPORTING schema, PROCESSING-only sources, explicit columns, sensitive-column
restrictions, aggregate children before joins, view/column comments and script header.
Use correct relative links, avoid full standards duplication, and do not generate views or procedures.
```

## Expected Output and Checks

- [ ] Three instruction files, each with frontmatter delimited by `---` and the specified applyTo.
- [ ] History columns total eleven; processing columns total nine. No column/type invented.
- [ ] No conflicting delete-all-processing or mid-month-normalization rule.
- [ ] Procedure rules preserve original failures and the post-COMMIT audit caveat.
- [ ] View instructions do not accidentally apply to procs or require a view in this workshop.

If an instruction is not loaded, check the matching file is actually in context, the path glob and YAML diagnostics.
Use VS Code's Chat customization settings rather than relying on a version-specific setting name.

Next: [exercise 08](../exercise-08/README.md).