---
id: DMF-PROJECT-01
lifecycle: durable
status: active
provenance: git-history
---
# dotmdfiles Project Context

## Scope Warning

The root discovery files, `CLAUDE.md` and `AGENTS.md`, and the files in
`.llm/` describe THIS repository only. They are never deployed, copied, or
reused in any other project.

`files/` and `real/` are a separate, unrelated set of files: generic
templates meant to be copied into OTHER projects by `setup-project.sh`.
Nothing said here applies to `files/` or `real/`, and nothing in `files/`
or `real/` applies here.

## Project

This repository is a collection of prototype `.md` template files for
software projects, plus the research that produced them. It is
documentation only -- no build, compile, or run step.

## Working Classification

durable knowledge / instructions and governance / reusable capabilities /
working state and records. Classify artifacts independently by semantic
role, authority, lifecycle, provenance, and loading or discovery behavior.

## Repository Boundaries

- `../files/` and `../real/` are deployable template sources, not active
  instructions for this repository.
- `../prompts/`, `../semantic/`, `../software/`, and `../templates/` are
  early ideas for reusable material -- not established conventions, not
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

## File Naming

Uppercase root filenames are retained because `CLAUDE.md` and `AGENTS.md`
are read by exact case-sensitive lookup by CLI tooling. Everything else is
lowercase.
