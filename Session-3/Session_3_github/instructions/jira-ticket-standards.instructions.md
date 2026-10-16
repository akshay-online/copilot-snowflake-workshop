---
name: Jira Ticket Standards
description: "Use when writing or refining Jira tickets, backlog stories, requirements, or acceptance criteria in Markdown. Enforces clear summaries, descriptions, acceptance criteria, Definition of Ready, and Definition of Done."
applyTo: "backlog/**/*.md"
---

# Jira Ticket Standards

Use this structure for every Jira story or ticket:

```markdown
# <Concise Summary>

## Description

<What needs to change, why it is needed, and the systems, users, or data affected.>

## Scope and Requirements

- <Functional requirement>
- <Data, integration, timing, or operational requirement>
- <Out-of-scope item, when useful>

## Acceptance Criteria

- [ ] <Observable, testable behavior>
- [ ] <Expected data, integration, or operational result>
- [ ] <Error or edge-case behavior, when applicable>
- [ ] Should be specific to the scope and requirements outlined above.
- [ ] Should be clear and unambiguous, avoiding vague terms like "etc." or "and so on."
- [ ] Should avoid implementation details unless necessary for understanding the requirement.

## Definition of Ready

- [ ] Business objective and problem are understood.
- [ ] In-scope systems, tables, fields, or interfaces are identified.
- [ ] Dependencies, assumptions, and external references are documented.
- [ ] Acceptance criteria are specific, testable, and agreed upon.
- [ ] Required test data, access, and environments are available or identified.

## Definition of Done

- [ ] Implementation is complete and reviewed.
- [ ] Automated and/or documented validation covers the acceptance criteria.
- [ ] Required data quality, security, and operational checks pass.
- [ ] Documentation, configuration, and monitoring are updated as needed.
- [ ] Deployment or handoff is complete, and stakeholders are notified.
```

## Writing Rules

- Write the Summary as a concise outcome, not a task fragment. Include the affected domain or system when it adds clarity.
- In the Description, explain the current need, desired outcome, scope, and relevant constraints. Preserve technical names exactly as provided.
- Make every acceptance criterion independently verifiable. Prefer observable outcomes over implementation steps.
- Use tables for structured lists of schemas, tables, fields, interfaces, or environments.
- Put SQL, code, paths, and configuration values in fenced code blocks or inline code formatting.
- Record timing, schedule, ownership, notifications, dependencies, and source-of-truth references when they affect delivery.
- Do not invent missing requirements, table names, business rules, or test evidence. Mark unknowns as `TBD` or add an explicit `Open Questions` section.
- When source material contains conflicting names, counts, or requirements, preserve the supplied facts and add a clearly labeled scope check or open question.
- Keep the ticket focused on one deliverable. Separate unrelated follow-up work into linked tasks.
- Use consistent terminology throughout the ticket, especially for system, schema, table, environment, and date definitions.
