# Exercise 06: Repository Instructions

**Time:** 10 minutes. **Prerequisite:** exercises 01-05. **Mode:** Agent in a fresh thread.
**Example count:** 1. **Snowflake:** not required.

## What and Why

Create a short repository-level instruction file so future requests share the same ground rules.
Instructions guide Copilot; they do not enforce database permissions or guarantee correct output.
Detailed rules stay in source standards and the next exercise's path-specific files.

## Steps

1. Verify that VS Code's open folder is [workspace](../../), not the pack root.
2. Read the [Snowflake](../../standards/snowflake_standards.md) and
   [logging](../../standards/logging_standards.md) standards.
3. Send the prompt, inspect the new file under .github, and keep it only after checking every bullet.
4. On your next request, inspect the customization/reference details exposed by your VS Code version.
   An AI statement that instructions were used is not sufficient evidence by itself.

## Prompt

```text
Create .github/copilot-instructions.md from #file:standards/snowflake_standards.md,
#file:standards/logging_standards.md and #file:specs/agent_requirements.md.
Keep it under 30 lines: describe staging -> SCD2 history -> monthly processing snapshots;
link the two standards and specs/ using paths relative to .github/; identify ddl/,
procs/, dml/, tests/ and future .github/instructions/ and .github/skills/ as the layout.
Always use the supplied column spec, UPPER_SNAKE_CASE, schema-qualified application SQL,
script headers, and the ticket supplied by the user. Never invent keys/business rules,
log sensitive values, execute Snowflake SQL, or commit without explicit human approval.
List conflicts or missing inputs instead of guessing. Leave detailed rules in standards.
Do not create path instructions, skills or application code yet.
```

## Expected Output and Checks

- [ ] Exactly one new file, .github/copilot-instructions.md, under 30 lines.
- [ ] Links to standards/specs resolve from .github, not from the workspace root.
- [ ] No duplicated full standard, hard-coded participant identity or unrelated technology.
- [ ] No SQL deployment or Git commit occurred.

If VS Code does not discover it, check the open folder, exact filename and organization customization policy.
Do not move it to your personal profile: this exercise creates a team-shareable repository kit.

Next: [exercise 07](../exercise-07/README.md).