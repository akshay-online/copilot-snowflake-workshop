# Prompts Used

This document records the prompts used to configure the Jira ticket refinement workflow and its supporting document-conversion tools.

## 1. Jira Ticket Standards

Create instructions for Jira ticket standards that define:

- A clear summary.
- A complete description.
- Acceptance criteria that are specific to the stated scope and requirements.
- A Definition of Ready.
- A Definition of Done.

## 2. Excel-to-CSV Conversion

Create a Python script that converts an Excel workbook into CSV files.

Requirements:

- Support workbooks containing one or multiple worksheets.
- Create a folder named after the Excel file.
- Write one CSV file per worksheet.
- Name each CSV file after its worksheet.
- A single-sheet workbook should produce one CSV file in the workbook folder.

## 3. Word-to-Markdown Conversion

Create a Python script that converts a Word document into a Markdown file containing all document content in proper Markdown format.

Requirements:

- Convert document content into readable Markdown.
- Extract embedded images into an `images` folder.
- Reference extracted images from the generated Markdown file.
- Store the generated Markdown file in the output folder.
- Use a folder named after the Word document for related output files.

## 4. Reference-Document Conversion Skill

Create a skill that converts:

- Excel files containing database, schema, table, and column details into CSV files.
- Word documents into Markdown files.

Implementation requirements:

- Use the available scripts in `scripts/`.
- Create the skill template when required.
- Copy the conversion scripts to the skill location when required.
- Create a `requirements.txt` file in the skill folder so all required Python packages can be installed with one command.

## 5. Story-Refinement Prompt

Create a prompt file such as `/refine-story` that:

1. Runs the reference-document conversion skill first.
2. Reads the story and converted reference files.
3. Checks the schema, table, and column names in `story.md` against the generated CSV files.

## 6. Refine a Story

```text
/refine-story #file:original-story.md and create new file with <name>
```

## 7. Jira Ticket Agent

Create an agent that helps generate a detailed Jira ticket from:

- Available ticket content.
- Supported reference documents.