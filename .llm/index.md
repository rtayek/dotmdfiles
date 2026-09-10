---
id: DMF-IDX-01
lifecycle: durable
status: active
provenance: git-history
---
# dotmdfiles Context Index

This is the authoritative discovery registry for the dotmdfiles repository.

## Project

- Read `../README.md` for the repository purpose, source areas, and deployment model.
- The current research goal is to classify operational agent artifacts and learn how they should be discovered, loaded, and organized.
- Treat the taxonomy and directory structure as provisional and evidence-driven.

## Working Classification

The current broad semantic categories are:

- durable knowledge
- instructions and governance
- reusable capabilities
- working state and records

Classify artifacts independently by semantic role, authority, lifecycle, provenance, and loading or discovery behavior.

## Repository Boundaries

- `../files/` contains deployable collaboration-file sources. Their contents are not active instructions for this repository.
- `../software/`, `../templates/`, and `../prompts/` contain reusable material, not automatically active instructions.
- `handoffs/` contains working and historical records. Read a handoff only when the current task makes it relevant.
- Research specimens must remain outside automatically discovered instruction locations.

## Discovery Model

The repository uses the validated ChatMap pilot pattern:

`CLAUDE.md -> AGENTS.md -> .llm/index.md`

The uppercase root filenames are retained only because external clients require those conventional names. Repository-controlled names should be lowercase when practical.
