> Purpose: General AI agent behavior rules for any codebase.
> Scope: What agents may do freely, must ask before, and must never do.

# Agents

Guidelines for AI agents working in any code base.

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

This file defines the baseline agent behavior rules. Other files in the project MAY define additional agent rules scoped to their domain; those rules extend this baseline and do not conflict with it.

## Behavior

- Read all of the .md files in this project and its sub-folders before doing anything and follow their instructions.

## What agents may do freely

- Anything not listed in the sections below, except deleting the source code control repository (usually this is .git).

## What agents must ask before doing

- Delete files permanently if they are not tracked by the source code control system (usually this is git).
- Renaming or moving files that are not tracked by the source code control system.
- Adding new dependencies.
- Making architectural changes.

## What agents must never do

- Modify configuration files (`.env`, secrets, CI pipelines) without explicit instruction.

## Agents should

- Always ask when anything is unclear
- Always explain non-obvious changes
