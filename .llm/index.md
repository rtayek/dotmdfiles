---
id: DMF-IDX-01
lifecycle: durable
status: active
provenance: git-history
---
# dotmdfiles Context Index

This is the authoritative discovery registry for the dotmdfiles repository.
Where this file uses MUST / MUST NOT / SHOULD / MAY, those words are used
in the RFC sense. If another file conflicts with this one, this file wins.

## Context Routing

- Agents MUST read `project-context.md` for repository-specific scope,
  boundaries, permissions, and durable instructions.
- Read other Markdown files in this directory when they are relevant to the
  current task.
- Load working context and handoffs only when they apply. Read a handoff only
  when the current task makes it relevant.

## Discovery Model

`CLAUDE.md -> AGENTS.md -> .llm/index.md -> .llm/project-context.md`

The root files are client discovery adapters. This directory holds
repository-controlled context.
