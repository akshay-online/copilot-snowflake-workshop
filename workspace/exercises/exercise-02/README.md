# Exercise 02: Explain Existing Code

**Time:** 10 minutes. **Prerequisite:** exercise 01. **Mode:** Ask. **Example count:** 1.
**Snowflake:** not required. Start a new thread and keep it through exercise 05.

## What and Why

Read an existing SCD Type 2 loader before modifying anything. SCD2 closes the old version and inserts
a new one when a business value changes; an unchanged or absent key does not create a new version.
An explanation is useful only when it matches the actual code and inputs.

## Steps

1. Open [history procedure](../../procs/agent/sp_load_hist_agent.sql) and
   [requirements](../../specs/agent_requirements.md).
2. Attach the files named in the prompt and send it in Ask mode.
3. Trace the UPDATE, INSERT and catch block yourself. Compare the explanation with the two sample CSV files.
4. Keep the response in this thread. Do not ask Copilot to edit the procedure.

## Prompt

```text
/explain #file:procs/agent/sp_load_hist_agent.sql #file:specs/agent_requirements.md
#file:data/202609/agent.csv #file:data/202610/agent.csv
Explain this loader to a data engineer new to Snowflake JavaScript procedures.
Use the supplied September-to-October data as one before/after example: show new,
changed, unchanged and missing keys. Explain why UPDATE comes before INSERT,
which columns HASH compares, and the same-date/backdated-change guard.
Explain transaction boundaries, the separate process-log transaction, audit rows,
and why a post-COMMIT logging failure cannot undo committed data.
Finish with a small Mermaid flowchart. Do not edit files or execute SQL.
```

## Expected Output and Checks

- [ ] A001 stays unchanged; A002 closes its old row on 2026-10-30 and gets a new current row.
- [ ] A003 stays current despite being absent; A004 is inserted. Total: five versions, four current.
- [ ] AGENT_ID is excluded from HASH; the other five spec columns are included in matching order.
- [ ] The answer distinguishes logs from audits and notes that CREATE_JOB_UUID failures throw before the main try.
- [ ] The flowchart has both success and failure branches and does not imply rollback after COMMIT.

If the answer invents an extract-date column or deletion rule, verify the file attachments and correct the explanation
against the supplied files. Mermaid rendering is optional; the diagram source is sufficient for review.

Next, in the same thread: [exercise 03](../exercise-03/README.md).