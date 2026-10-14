# Exercise 10: Create a Custom Agent

**Time:** 10 minutes. **Prerequisite:** exercises 06-09. **Mode:** built-in Agent.
**Example count:** 1. **Snowflake:** not required.

## What and Why

A custom agent gives the reusable kit a role, workflow and tool boundary. This one gathers inputs,
waits for approval, uses the two skills, and reviews the result. It is a VS Code Copilot custom agent,
not a deployed service or a Microsoft Foundry agent.

## Steps

1. Confirm the instructions, skills and templates from earlier exercises are present.
2. Send the prompt using the built-in Agent mode, not the not-yet-created custom agent.
3. Inspect the resulting file and use VS Code's tool picker to resolve any unsupported tool identifiers.
4. Confirm snowflake-builder appears in the agent dropdown. Do not run it yet.

## Prompt

```text
Create .github/agents/snowflake-builder.agent.md.
Use YAML frontmatter name: snowflake-builder, a quoted description for building one
Snowflake entity from its spec using the team's kit, and tools: ['search', 'edit', 'todos'].
If these tool names differ in this VS Code version, report what needs configuration;
do not silently grant terminal, database, network or deployment tools.
Role: Snowflake data engineer, never inventing business rules or source columns.
Reference the standards, path instructions, snowflake-tables and snowflake-loaders skills
using correct relative links. Use a tracked workflow:
1 Gather spec/requirements and confirm entity, key, source approach, sensitive fields,
  ticket, author, file format, stage and scheduler order; wait for confirmation.
2 Plan the six DDL/procedure output files and any changes to existing ones; wait for go.
3 Use snowflake-tables, then snowflake-loaders, preserving correct existing behavior.
4 Self-review against both standards and both skill checklists; fix failures in scope.
5 Hand over file links, changes, unresolved questions, ordered CALL statements and
  two read-only checks (current-key uniqueness and snapshot counts). Never claim execution.
Stop for a missing spec, unsupported source approach or conflicting requirements.
No Snowflake execution, infrastructure edits, destructive resets or Git commits.
Create only this custom-agent file now; no application edits.
```

## Expected Output and Checks

- [ ] One .agent.md file with valid YAML, a discoverable name and working relative links.
- [ ] Gather and Plan both require human approval; missing specs block generation.
- [ ] Both skills are referenced in the correct order, with a final self-review.
- [ ] Tools allow only the intended local work; no terminal/database tool was added automatically.
- [ ] The handoff distinguishes reviewed code from executed/validated code.

Tool restrictions reduce what the agent can do; text instructions alone are not a security boundary.
If the dropdown entry is missing, check the filename/location and customization diagnostics before retrying.

Next: [exercise 11](../exercise-11/README.md).