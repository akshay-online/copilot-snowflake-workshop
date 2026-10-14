# AGENT Workshop Workspace

Open **this folder alone** in VS Code. All lessons and starter files are inside it.
Open a lesson from the [exercises directory](exercises/) in Markdown preview alongside your code
in the same VS Code window. No separate folder or window is needed.
All prompt paths are relative to this folder, not the pack root.

## Start Here

1. Sign in to GitHub Copilot in VS Code and confirm inline suggestions and Chat work.
    Organization policy may restrict Agent mode, skills or custom agents; ask your administrator if needed.
2. Start [exercise 01](exercises/exercise-01/README.md) and follow the numbered lessons in order.
3. Review proposed changes before keeping them. Do not authorize deployment, commits or unrelated edits.
4. Keep the same chat thread for exercises 02-05, then start a fresh thread for exercise 06.

Required: VS Code, GitHub Copilot access and basic SQL familiarity. JavaScript knowledge helps but is not required.
Python 3.10+ and a Snowflake sandbox are optional for execution. Code-only practice still uses the Copilot service;
it means no database access, not offline AI. Allow 180 minutes (3 hours) plus optional environment setup.

## Learning Path

Each exercise contains one or two prompt examples, steps, expected output and completion checks.

| Exercise | Feature and outcome |
|---|---|
| [01](exercises/exercise-01/README.md) | Inline suggestions: complete staging DDL from the spec |
| [02](exercises/exercise-02/README.md) | /explain: understand SCD2 and transaction flow |
| [03](exercises/exercise-03/README.md) | /fix: repair a deliberately broken processing loader |
| [04](exercises/exercise-04/README.md) | /tests: generate clone-isolated integration tests |
| [05](exercises/exercise-05/README.md) | /compact: retain decisions in a long thread |
| [06](exercises/exercise-06/README.md) | Repository instructions: define persistent project rules |
| [07](exercises/exercise-07/README.md) | Path instructions: scope SQL, procedure and view rules |
| [08](exercises/exercise-08/README.md) | Table skill: package a workflow and templates |
| [09](exercises/exercise-09/README.md) | Procedure skill: package three load patterns |
| [10](exercises/exercise-10/README.md) | Custom agent: define a reviewable end-to-end workflow |
| [11](exercises/exercise-11/README.md) | Use skills directly to generate/review the AGENT pipeline |
| [12](exercises/exercise-12/README.md) | Use the custom agent and test its missing-spec guardrail |
| [13](exercises/exercise-13/README.md) | Validate two monthly loads, reruns, logs and failure behavior |

Record execution outcomes as PASS, FAIL, SKIPPED or NOT RUN. Code review and skipped tests never count as live validation.
Use only the supplied synthetic records; never substitute production data or credentials.

## Prompt and Version Notes

- Paste only the fenced prompt, not the whole lesson. Replace `<your name>` before sending.
- Attach each `#file:` reference with Chat's file picker if pasted text does not become an attachment.
   Explicit attachments are the intended source of truth; open tabs alone may not supply all context.
- Select /explain, /fix or /tests from the slash menu when available. If absent, remove the command
   and keep the natural-language request. Ask mode explains; Agent mode edits files.
- If /compact is unavailable, use the built-in context-summary control if offered. Otherwise keep a manual
   summary and reattach the named files. Mark the command NOT PRACTICED; plain chat is not equivalent to compaction.
- Check customization discovery in your installed VS Code version's Chat UI and diagnostics.
   Setting names and tool identifiers can change; organization policy may restrict these features.
- Request snowflake-tables and snowflake-loaders directly by name in Chat. If discovery fails, attach the
   corresponding SKILL.md explicitly. Skills may also appear in the slash menu in current versions.
- Instructions, skills and agents guide AI behavior; they do not replace review, permissions or tests.

## What Is Supplied

| Folder | Contents and purpose |
|---|---|
| [exercises](exercises/) | Thirteen numbered lessons to follow alongside the starter code |
| [standards](standards/) | The single rule set used throughout the workshop |
| [specs](specs/) | Six-column AGENT spec and business requirements |
| [ddl/agent](ddl/agent/) | Staging comment-only starter; complete history and processing DDL |
| [procs/agent](procs/agent/) | Working history reference; deliberately broken processing starter |
| [data](data/) | Synthetic September and October CSV files |
| [dml](dml/) | Equivalent staging seed scripts when upload is unavailable |
| [setup](setup/) | Optional sandbox infrastructure and file upload |
| [tests](tests/) | Pytest fixture and dependency list, not completed test answers |
| [run](run/) | Read-only two-month acceptance queries |

The staging procedure, generated tests, and all `.github/` customizations are intentionally absent.
You create them in the exercises. Do not deploy the broken processing starter.
The history reference is a teaching baseline, not a claim of production readiness.

## Optional Snowflake Setup

Skip this section for code-generation and review practice. Running SQL incurs Snowflake usage costs.
Use an allocated, empty personal sandbox, never production or a database used by other participants.
You need a warehouse, schema/procedure/table/stage privileges, and a Snowflake edition supporting masking policies
(normally Enterprise or higher). Pytest also requires permission to clone and drop a database.
Ask the workshop administrator to provision these permissions; do not change organizational roles yourself.

1. Finish exercises 01-03 before attempting their generated SQL. Review every change.
2. In [setup/01_bootstrap.sql](setup/01_bootstrap.sql), replace COPILOT_LAB_YOURNAME with your allocated name.
   Set your authorized role and warehouse in the Snowflake extension or Snowsight, then run that script.
3. Run the three reviewed files in [ddl/agent](ddl/agent/): staging, history, processing, in that order.
4. Deploy the history reference and your **repaired** processing procedure from [procs/agent](procs/agent/).
   Generated SQL does not deploy automatically; execute the reviewed CREATE PROCEDURE statements yourself.
5. After exercise 11 or 12, deploy the generated staging procedure too. Redeploy other procedures if you changed them.
6. For exercise 13 file mode, run [setup/02_upload_files.sql](setup/02_upload_files.sql) using SnowSQL/CLI
   from this directory. Alternatively upload through Snowsight into AGENT_STAGE folders 202609 and 202610.
   Confirm LIST shows one file in each folder. Relative PUT paths may need an absolute local path for your client.
7. Every new worksheet/connection must select the same sandbox and warehouse. Object scripts intentionally
   do not contain USE DATABASE statements. Call loaders without an outer BEGIN/COMMIT.

For exercises 02-04 no file upload is needed: use the DML seeds or fixture-provided seed rows.
Do not run a staging loader after a DML seed, as that would replace the seeded staging rows.
If masking is unavailable, complete static review and mark execution as not run; do not remove the masking requirement.

## Optional Pytest Execution

Python 3.10+ is required only for test execution. In a terminal in this folder:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r tests/requirements.txt
```

After exercise 04 has created the test file, configure your own non-secret connection identifiers locally:

```powershell
$env:SNOWFLAKE_ACCOUNT = '<account identifier>'
$env:SNOWFLAKE_USER = '<user>'
$env:SNOWFLAKE_ROLE = '<authorized sandbox role>'
$env:SNOWFLAKE_WAREHOUSE = '<warehouse>'
$env:SNOWFLAKE_SOURCE_DATABASE = 'COPILOT_LAB_YOURNAME'
.\.venv\Scripts\python.exe -m pytest tests/agent/test_sp_load_prc_agent.py -v
```

Authentication uses browser SSO; never paste passwords/tokens in chat. The fixture clones the named database,
switches to the clone, then drops it in teardown. It only accepts a source named COPILOT_LAB_<name>.
Generated tests must use sf, not open a second connection or switch databases. Keep procedure SQL database-independent.
If the process is interrupted, ask your administrator to check for your leftover *_TEST_* database.
With connection variables unset, tests using sf skip. A skip is not a successful integration run.
Before exercise 04 there are no test functions, so 'no tests collected' is expected, not a passing test suite.

## Restarting Safely

Keep your completed work. For a clean retry, extract a new copy of the participant pack into a new folder.
For a fresh two-month run, have your administrator allocate another empty sandbox and update the bootstrap value.
Do not use destructive Git resets or truncate somebody else's workshop database.