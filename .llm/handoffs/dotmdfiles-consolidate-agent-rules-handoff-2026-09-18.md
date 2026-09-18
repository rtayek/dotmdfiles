# Handoff: Consolidate agent rules into .llm/index.md

Date: 2026-09-18
Project: dotmdfiles
Status: Ready to apply

## Context

AGENTS.md currently carries its own substantive content (status, project
description, behavior rules, ask-before/never-do rules) in addition to
pointing at .llm/index.md, which duplicates and overlaps with what
.llm/index.md already says. Separately, .llm/index.md points onward to
README.md for the repository's purpose — an undocumented fourth hop in
what's meant to be a three-file discovery chain
(CLAUDE.md -> AGENTS.md -> .llm/index.md).

Decision: make AGENTS.md a pure pointer, matching CLAUDE.md. Move every
rule currently unique to AGENTS.md into .llm/index.md, and make
.llm/index.md fully self-contained — no onward pointer to README.md
required to understand the repository's rules. README.md keeps existing
as the human-facing GitHub landing page, but is no longer part of the
required agent discovery chain.

This also adds a new, explicitly requested "Scope Warning" section to
.llm/index.md: the root files (CLAUDE.md, AGENTS.md, .llm/index.md)
describe this repository only and are never deployed or reused anywhere
else. This distinction — root files vs. files/ and real/ — caused real
confusion earlier in the session that produced this handoff, so it needs
to be unmissable.

## Change 1: replace AGENTS.md entirely

Full new content:

```
# Agents

Read `.llm/index.md` and follow its instructions.
```

## Change 2: replace .llm/index.md entirely

Full new content:

```
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

## Scope Warning

The files at this repository's root — `CLAUDE.md`, `AGENTS.md`, and this
file — describe THIS repository only. They are never deployed, copied, or
reused in any other project.

`files/` and `real/` are a separate, unrelated set of files: generic
templates meant to be copied into OTHER projects by `setup-project.sh`.
Nothing said here applies to `files/` or `real/`, and nothing in `files/`
or `real/` applies here.

## Project

This repository is a collection of prototype `.md` template files for
software projects, plus the research that produced them. It is
documentation only — no build, compile, or run step.

## Working Classification

durable knowledge / instructions and governance / reusable capabilities /
working state and records. Classify artifacts independently by semantic
role, authority, lifecycle, provenance, and loading or discovery behavior.

## Repository Boundaries

- `../files/` and `../real/` are deployable template sources, not active
  instructions for this repository.
- `../prompts/`, `../semantic/`, `../software/`, and `../templates/` are
  early ideas for reusable material — not established conventions, not
  enforced, not active instructions. Read only when the current task
  requires it.
- `.llm/handoffs/` contains working and historical records, plus anything
  else without a clearer home yet. Read a handoff only when the current
  task makes it relevant.

## What agents must ask before doing

- Renaming, editing, or moving files.

## What agents must never do

- Delete a source code control repository.
- Delete files permanently if they are not tracked by the source code
  control system.

## Discovery Model

`CLAUDE.md -> AGENTS.md -> .llm/index.md`

Uppercase root filenames are retained because CLAUDE.md and AGENTS.md are
read by exact case-sensitive lookup by CLI tooling. Everything else is
lowercase.
```

## Not done

README.md was not edited. It still describes the discovery model and
repository areas for human readers on GitHub; it's just no longer a
required read for an agent to understand the repository's active rules.
Reconcile README.md's content against this file later if it drifts,
but that's a separate task — do not edit README.md as part of this
handoff.

files/ and real/ were not touched. They continue to drift from each
other intentionally, per Ray's earlier instruction, while changes are
staged and tested one at a time.
