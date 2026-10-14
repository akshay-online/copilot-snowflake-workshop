# Exercise 05: Compact a Long Thread

**Time:** 5 minutes. **Prerequisite:** exercises 02-04 in the same thread.
**Mode:** Chat. **Example count:** 2 short prompts. **Snowflake:** not required.

## What and Why

Long explanations, patches and test code consume chat context. Compaction summarizes the working history
so the conversation can continue with key decisions. It is not a guaranteed verbatim archive, and it does not
replace explicit file attachments. Starting a new chat is appropriate for a different task.

## Steps

1. Stay in the existing thread. Check that /compact is available in your installed version.
2. Send prompt 1 and inspect the resulting summary or context indicator.
3. Send prompt 2 to check retained decisions. Reattach files if the summary omitted something important.
4. Keep the concise result as evidence; the next lesson starts a fresh thread.

## Prompt 1: Compact

```text
/compact Keep the AGENT business key, six-column spec, month-end rejection rule,
monthly snapshot preservation, processing defects repaired, generated test path,
and actual test status (including NOT RUN or SKIPPED). Keep the logging and masking
rules. Drop long code listings and repeated explanations. Do not claim tests passed.
```

## Prompt 2: Verify Retained Context

```text
Without editing files, summarize our repaired processing-loader contract in five
bullets, name the generated test file and its actual execution status, and explain
why a mid-month rejection test alone does not prove rollback after DELETE.
```

## Expected Output and Checks

- [ ] Summary keeps month-end rejection, current-only rows and preservation of other months.
- [ ] Test path and honest execution status survived; no invented successful run.
- [ ] The distinction between validation failure and transaction rollback is retained.

If /compact is unavailable, follow the [version notes](../../README.md#prompt-and-version-notes): use the available summary control,
or keep a manual summary and mark the command NOT PRACTICED. A plain chat request is not equivalent to invoking compaction.

Next, in a fresh thread: [exercise 06](../exercise-06/README.md).