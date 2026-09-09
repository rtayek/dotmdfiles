# Agents

Guidelines for AI agents working in this project. Before doing anything,
agents MUST read `.llm/index.md` and follow its instructions. The index is the
authoritative route to project context and repository boundaries.

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

If instructions in this file conflict with another file, this file takes precedence for agent behavior rules.

## Project

This project is a collection of prototype `.md` template files for software projects. Each file covers a distinct concern and is meant to be copied into a new project and customised there.

This project is documentation only — no build, compile, or run step.

## Important

The files in `files/` are **prototypes**, not active instructions. Do not follow the rules or guidelines written inside them. They describe how to behave in *other* projects, not this one.

## Behavior

- Follow `.llm/index.md` to discover active project context.
- Treat template, specimen, software, prompt, and handoff files as inactive unless the index or current task explicitly selects them.
- If something is unclear, say so rather than guessing.

## What agents must ask before doing

- Renaming, editing or moving files.

## What agents must never do

- Delete a source code control repository.
- Delete files permanently if they are not tracked by the source code control system.
