# GitHub Copilot for Snowflake: Participant Workshop

A step-by-step path from inline suggestions to a reusable Copilot development kit.
One original AGENT scenario, one specification, and one set of standards are used throughout.

## Start Here

1. Extract the entire folder to a writable location and keep a clean original for retries.
2. Use VS Code with GitHub Copilot access and sign in. Confirm inline suggestions and Chat work.
   Organization policy may restrict Agent mode, custom agents, or skills; ask your administrator if needed.
3. Open [workspace](workspace/) as the **VS Code folder**, not this pack root or the parent containing other demos.
   This ensures the `.github/` files you create belong to the active workspace.
4. Read [workspace/README.md](workspace/README.md), then start [exercise 01](workspace/exercises/exercise-01/README.md).
  Open lessons from the workspace's exercises folder alongside your code in the same VS Code window.
  Follow the exercises in order; the workspace README includes the lesson index and version notes.
5. Review Copilot's proposed changes before keeping them. Do not authorize deployment, commits, or unrelated edits.

**Required:** VS Code, GitHub Copilot, basic SQL familiarity. JavaScript knowledge helps but is not required.
**Optional:** Python 3.10+ for generated tests; an approved Snowflake sandbox for SQL execution.
Code-only participation still uses the Copilot service; it means no database access, not offline AI.

## Learning Path

Each exercise has one or two prompt examples. Times are practice estimates, not demo timings.

| Exercise | Feature and outcome | Minutes |
|---|---|---:|
| [01](workspace/exercises/exercise-01/README.md) | Inline suggestions: complete staging DDL from the spec | 10 |
| [02](workspace/exercises/exercise-02/README.md) | /explain: understand SCD2 and transaction flow | 10 |
| [03](workspace/exercises/exercise-03/README.md) | /fix: repair a deliberately broken processing loader | 15 |
| [04](workspace/exercises/exercise-04/README.md) | /tests: generate clone-isolated integration tests | 20 |
| [05](workspace/exercises/exercise-05/README.md) | /compact: retain decisions in a long thread | 5 |
| [06](workspace/exercises/exercise-06/README.md) | Repository instructions: define persistent project rules | 10 |
| [07](workspace/exercises/exercise-07/README.md) | Path instructions: scope SQL, procedure and view rules | 15 |
| [08](workspace/exercises/exercise-08/README.md) | Table skill: package a repeatable workflow and templates | 15 |
| [09](workspace/exercises/exercise-09/README.md) | Procedure skill: package three load patterns | 20 |
| [10](workspace/exercises/exercise-10/README.md) | Custom agent: define a reviewable end-to-end workflow | 10 |
| [11](workspace/exercises/exercise-11/README.md) | Use skills directly to generate/review the AGENT pipeline | 15 |
| [12](workspace/exercises/exercise-12/README.md) | Use the custom agent and test its missing-spec guardrail | 15 |
| [13](workspace/exercises/exercise-13/README.md) | Validate two monthly loads, reruns, logs and failure behavior | 20 |

Allow 180 minutes (3 hours) plus optional environment setup. Exercises 02-05 use the **same chat thread**.
Start a fresh chat for exercise 06. All files remain in the same workspace.

## How the Pieces Fit

Staging holds the incoming file. History keeps changed versions using SCD Type 2.
Processing keeps one snapshot per valuation month. September has three agents; October changes one,
adds one, and omits one without deleting it from history.

Instructions define rules; skills describe repeatable workflows and provide templates.
Use skills directly in Chat; the custom agent sequences them with confirmation checkpoints.
These guide AI behavior, but are not enforcement or a substitute for review and tests.

The later exercises revisit your earlier files deliberately: you compare one-off generation with a reusable kit.
Keep correct behavior and append change history instead of blindly replacing working code.
The kit itself is an exercise output, so no prebuilt `.github/` directory or complete answer key is shipped.

## Prompt and Version Notes

- Paste only the fenced prompt, not the entire lesson. Replace `<your name>` before sending.
- Attach each `#file:` reference with Chat's file picker if pasted text does not become an attachment.
  Open tabs can help, but explicitly attached files are the intended source of truth.
- For /explain, /fix and /tests, select the command from the slash menu when available. If absent, remove
  the slash command and keep the natural-language request. Ask mode explains; Agent mode edits files.
- /compact availability varies. If absent, use the built-in context-summary control if offered;
  otherwise record a manual summary and reattach the named files. Mark the command itself as not practiced.
- For customizations, use the installed VS Code version's Chat customization UI and diagnostics to check discovery.
  Setting names and tool identifiers can change. Do not blindly copy old setting IDs.
- Request snowflake-tables and snowflake-loaders directly by name in Chat. If discovery fails, attach the
  corresponding SKILL.md explicitly. Skills may also appear in the slash menu in current VS Code versions.

## Completion Evidence

For each exercise, keep the generated artifact or chat result and check its acceptance list.
Record live checks as PASS, FAIL, SKIPPED or NOT RUN. Code review and skipped tests never count as database validation.
Exercise 13 includes both a code-only route and an optional live route.

Scope is limited to the demonstrated core features. No live Jira integration, reconciliation procedure,
month-end orchestrator, policy timeline, or additional business domain is introduced.
Only synthetic records and example.com addresses are supplied. Never substitute production data or credentials.