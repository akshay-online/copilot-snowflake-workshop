---
description: "Refine a backlog Jira story against converted reference docs (schema CSVs, spec Markdown). Use to validate table/column names and complete acceptance criteria, DoR, and DoD."
argument-hint: "Story file (default: backlog/story.md)"
agent: "agent"
---
Refine the Jira story in the given file (default [backlog/story.md](../../backlog/story.md)).

1. Make sure reference docs are current: if any `.xlsx`/`.xls`/`.docx` in `docs/` (excluding `docs/Archive/` and `~$*` files) has no matching output in `output/`, run the `convert-reference-docs` skill first.
2. Read the story and the relevant files in `output/` (start with `Overview.csv`, `Change Log.csv`, and `Questions.csv` when present, then the per-table CSVs referenced by the story).
3. Cross-check every schema, table, and column named in the story against the CSVs:
   - Keep names exactly as they appear in the reference.
   - Flag names in the story that are missing from the reference, or that differ in spelling/case.
   - Add in-scope tables/fields that the story implies but omits only when the reference makes it unambiguous.
4. Rewrite the story to follow [Jira Ticket Standards](../instructions/jira-ticket-standards.instructions.md). Do not invent requirements; record gaps under `Open Questions` with the reference file that raised them.
5. Edit the story file in place, then reply with a short list of what changed and the open questions.
