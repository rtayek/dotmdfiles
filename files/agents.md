> Purpose: General AI agent behavior rules for any codebase.
> Scope: What agents may do freely, must ask before, and must never do.

# Agents

Guidelines for AI agents working in any project. Before doing anything,
agents MUST read `persona.md` and `human.md` alongside this file, plus any
other `.md` files at the project root and in folders you work in.

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

## What agents may do freely

Agents may take any action not restricted by the sections below,
except deleting the source code control repository (usually `.git`).

## What agents must ask before doing

- Delete files permanently if they are not tracked by the source code control system (usually this is git).
- Renaming or moving files that are not tracked by the source code control system.
- Adding new dependencies.
- Making architectural changes (changes to module boundaries, public APIs, dependency structure, or overall design) — including introducing new abstractions, frameworks, or design patterns not present in the existing code, even if they seem like an improvement.
- Doing more than the task asked for. If a fix reveals other things worth changing, name them and stop; do not fix them in the same pass without asking.
- Pushing the Git repository.

## What agents must never do

- Modify configuration files (`.env`, secrets, CI pipelines) without explicit instruction.
- Push to a Git repository without explicit instruction.
- Leave background processes running after the task ends.
- Commit scratch, cache, or tool-generated files (e.g. `.aider*`, build output, lock files not part of the project) — add them to `.gitignore` instead.
- Expand scope beyond what was asked, even when the additional work seems clearly good.

## What agents should do

- Ask when anything is unclear.
- Explain non-obvious changes.

## Commit messages

- First line: what changed, factual, present tense.
- Message MUST NOT claim anything the change doesn't actually do.
- If a decision was made, add: `Decision: <what, and why, briefly>`.
- If something is still unresolved, add: `Open: <what>`.

## What agents may do

- Read access to the project folders and files.
- Commit to a local Git repository.


# Agent Execution and Output Protocol

## Rule: Response File Rule
Every single response provided during a session MUST also be output as a downloadable `.md` file. There are no exceptions and no judgment calls about whether a response "counts"—even a one-line answer requires a file. This functions as a general file delivery mechanism to maintain a durable, curated system-of-record local archive while treating active chats as transient scaffolding. The user decides what to do with the file, not the agent.

### 1. Interface Placement Constraint
The downloadable file element MUST always be the absolute last item rendered in the response interface. No conversational text, signatures, closing remarks, or markdown headers are permitted underneath it.

### 2. File Naming Convention (Kebab-Case)
The file must be generated with a strict kebab-case naming shape using plain text with no spaces, slashes, or colons:
`handoff-<from-project>[-to-<to-project>]-<YYYY-MM-DD-HHMM>.md`

- `<from-project>`: The active project folder identifier (e.g., `chatmap`, `hoa`). If unknown, ask exactly once at the start of the conversation. If never specified by the user, default to `misc`.
- `-to-<to-project>`: This segment MUST only be included if the user explicitly states that the active file or context is transitioning to a second project. Otherwise, omit it entirely.
- `<YYYY-MM-DD-HHMM>`: The 24-hour local timestamp tracking precisely when the response was generated.

### 3. Content Guardrails (Strict Plain ASCII Only)
To ensure reliable parsing by automated local file sorters, the internal text block content of the generated file MUST consist of plain ASCII characters only. The inclusion of the following characters constitutes a policy failure and is strictly forbidden:
- Smart quotes or curly apostrophes (`“`, `”`, `‘`, `’`)
- Em-dashes or en-dashes (`—`, `–`)
- Non-breaking spaces, advanced formatting ligatures, or rich Unicode/UTF-8 symbols.
