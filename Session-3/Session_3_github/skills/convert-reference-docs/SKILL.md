---
name: convert-reference-docs
description: 'Convert supporting reference documents into agent-readable text. Use when: an Excel workbook (.xlsx/.xls) contains database, schema, table, column, data dictionary, or mapping details that must be split into one CSV per sheet; a Word document (.docx) such as requirements, specs, or design notes must be converted to Markdown (.md) for reference while planning or refining Jira tickets.'
argument-hint: 'Path to an Excel/Word file or a docs folder (default: docs/)'
---

# Convert Reference Docs

Turns source documents into plain-text formats the agent can read and cite:

| Input | Script | Output |
|-------|--------|--------|
| `.xlsx` / `.xls` (schema, tables, columns, mappings) | [excel_to_csv.py](./scripts/excel_to_csv.py) | `output/<workbook_name>/<sheet_name>.csv` — one CSV per sheet |
| `.docx` | [word_to_md.py](./scripts/word_to_md.py) | `output/<doc_name>.md` + `output/<doc_name>_images/` |

## When to Use
- A new or updated data dictionary / schema workbook is added to `docs/`
- Supporting `.docx` specs need to be referenced while writing or refining backlog stories
- CSV/Markdown in `output/` is missing or older than its source document

## Procedure

1. **Discover inputs.** List files in the target (default `docs/`). Skip `docs/Archive/` unless the user asks for it, and skip Office lock files starting with `~$`.
2. **Check dependencies.** Run once per environment:
   ```powershell
   py -3 -m pip install -r .github/skills/convert-reference-docs/scripts/requirements.txt
   ```
   On Windows use the `py -3` launcher; `python`/`python3` may resolve to the Microsoft Store alias and fail. On macOS/Linux use `python3`.
3. **Convert Excel workbooks.** Run from the workspace root for each `.xlsx`/`.xls`:
   ```powershell
   py -3 .github/skills/convert-reference-docs/scripts/excel_to_csv.py "docs/<file>.xlsx" output
   ```
   All cells are read as text, so IDs and codes keep leading zeros. Duplicate or invalid sheet names are sanitized.
4. **Convert Word documents.** For each `.docx`:
   ```powershell
   py -3 .github/skills/convert-reference-docs/scripts/word_to_md.py "docs/<file>.docx" output
   ```
   Legacy `.doc` files are not supported; ask the user to re-save them as `.docx`.
5. **Verify.** Confirm each script printed `Done.` and exit code was 0. List the generated files and spot-check:
   - Overview / table-level sheets have the expected headers (e.g., table name, column name, data type, description)
   - Markdown headings, lists, and tables render correctly
6. **Report.** Summarize generated files as workspace-relative links and note any failures or skipped files.

## Using the Output
- Treat CSVs as the source of truth for table and column names when writing acceptance criteria — cite them, don't invent fields.
- Re-run conversion whenever the source workbook/document version changes (e.g., `PLADSv1.0` → `PLADSv1.1`); each version gets its own output folder.

## Troubleshooting
| Symptom | Fix |
|---------|-----|
| `can't open file ...excel_to_csv.py` | Use the full script path from step 3, not `.\excel_to_csv.py` |
| `ModuleNotFoundError` | Run the install command in step 2 |
| `PermissionError` on the workbook | Close the file in Excel and retry |
| `Python was not found` | Use `py -3` instead of `python`/`python3` |
| `.xls` read error | `py -3 -m pip install xlrd` |
