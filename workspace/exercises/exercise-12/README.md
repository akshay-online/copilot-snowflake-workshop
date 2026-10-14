# Exercise 12: Run the Custom Agent

**Time:** 15 minutes. **Prerequisite:** exercise 11 and the custom agent from exercise 10.
**Mode:** snowflake-builder in a fresh thread. **Example count:** 2. **Snowflake:** not required.

## What and Why

Compare the two direct skill requests with an agent that coordinates both workflows.
Then check the missing-spec guardrail using one negative example. The second request is expected to stop,
not create a new CLAIM domain.

## Steps

1. Select snowflake-builder in the agent dropdown and send prompt 1.
2. Review Gather's input table. Reply `confirmed` only when it matches the requirements.
3. Review Plan's file list and proposed changes. Reply `go` only for in-scope work.
   These replies are workflow approvals, not additional task examples.
4. Review its output and self-review checklist. Correct files may need no changes.
5. Send prompt 2 in a fresh snowflake-builder thread to test its response to missing context.

## Prompt 1: Coordinate the Existing Pipeline

```text
Build or review the AGENT pipeline for LAB-101 using
#file:specs/agent_column_spec.csv and #file:specs/agent_requirements.md.
Author: <your name>. Existing DDL and procedures came from earlier exercises;
preserve correct behavior, propose only necessary changes, and use your Gather/Plan
approval checkpoints before editing. Do not deploy or execute SQL.
```

## Prompt 2: Test the Guardrail

```text
Build the CLAIM entity for LAB-102. There is no CLAIM specification supplied in this workspace.
```

## Expected Output and Checks

- [ ] For AGENT, the agent pauses at Gather and Plan, then uses tables before loaders.
- [ ] It reports review results, any changed files, and runnable CALL text without claiming a live run.
- [ ] AGENT retains the original six business columns, two sensitive fields and monthly snapshot contract.
- [ ] For CLAIM, it requests the missing specification/key/requirements and makes no application files.
- [ ] It does not borrow CLAIM definitions from unrelated repositories or invent plausible insurance columns.

If the guardrail fails, reject those file edits and correct the custom-agent workflow before proceeding.
The point is to verify a specific boundary, not to trust a persona description as proof of correctness.

Next: [exercise 13](../exercise-13/README.md).