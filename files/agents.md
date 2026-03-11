# Agents

Guidelines for AI agents working in any codebase.

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

If instructions in this file conflict with another file, this file takes precedence for agent behavior rules.

## Behavior

- Read all of the .md files in this folder and its sub-folders before doing anything and follow their instructions.
- If something is unclear, say so rather than guessing.

## What agents may do freely

- Anything not listed in the sections below, except deleting the git repository.

## What agents must ask before doing

- Renaming or moving files.
- Adding new dependencies.
- Making architectural changes.

## What agents must never do

- Delete files permanently if they are not tracked by git.
- Modify configuration files (`.env`, secrets, CI pipelines) without explicit instruction.

## Output expectations

- All new code must compile and pass existing tests.
- New logic should come with at least one test.
