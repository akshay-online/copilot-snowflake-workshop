# AGENT Requirements

All records are synthetic. This is a learning pipeline, not a production design.

| Item | Contract |
|---|---|
| Entity / key | AGENT / AGENT_ID |
| Ticket | LAB-101 (training identifier, not a live Jira issue) |
| Author | Participant supplies their name |
| Scheduler | AGENT_MONTHLY: staging, history, processing, in that order; no scheduler installation needed |
| Source | Monthly full CSV in @STAGING.AGENT_STAGE/YYYYMM/agent.csv |
| File format | STAGING.FF_AGENT_CSV; header row; ISO YYYY-MM-DD dates |
| Business columns | Six columns, in the order in [agent_column_spec.csv](agent_column_spec.csv) |
| Sensitive columns | AGENT_NAME and AGENT_EMAIL; mask on processing only |
| Staging | Replace all staging rows for each load; reject duplicate keys, invalid status, or commission outside [0,1] |
| History | SCD Type 2; compare all five non-key business columns; close changed rows before inserting new versions |
| Missing source key | Leave history unchanged; absence is not a deletion |
| Processing | Retain snapshots by VALUATION_DATE; delete and reload only the requested month from current history |
| Dates | All loaders require a real ISO date; staging/processing require month end; history accepts any ISO load date |
| History ordering | Load chronologically; same-date unchanged reruns are allowed; reject changed keys when load date is <= their current begin date |
| Empty file month | Staging may become empty with a WARN log; do not automatically run downstream loads |
| Errors | Roll back DML, write an ERROR process log, write FAILED audit, then throw |

## Return Messages

- Staging: `SUCCESS: deleted=<n> loaded=<n>`
- History: `SUCCESS: inserted=<n> closed=<n>`
- Processing: `SUCCESS: deleted=<n> inserted=<n>`

## Two-Month Scenario

September starts with A001, A002 and A003. In October A001 is unchanged,
A002 becomes INACTIVE with a changed commission, A003 is absent, and A004 is new.
There is no extract-date business column, so a new file month alone does not create a history version.

| Check | September 2026 | October 2026 |
|---|---:|---:|
| Staging rows | 3 | 3 |
| History inserted / closed on first load | 3 / 0 | 2 / 1 |
| Total history versions | 3 | 5 |
| Current history rows | 3 | 4 |
| Processing rows for that month | 3 | 4 |

An unchanged October history rerun inserts 0 and closes 0. October processing reloads
4 rows without changing September's 3 rows. A003 remains current from September.
This workshop does not implement backdated corrections or historical snapshot reconstruction:
processing reads current history, so run each month's processing immediately after that month's history.