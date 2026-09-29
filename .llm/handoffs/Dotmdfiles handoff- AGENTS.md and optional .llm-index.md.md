# Handoff: dotmdfiles agent-document architecture

## Current direction

The project has moved away from a multi-file automatic discovery chain and toward a simpler governing model.

The old model was effectively:

```text
CLAUDE.md
  -> AGENTS.md
       -> .llm/index.md
            -> human.md
            -> persona.md
            -> other project documents
```

That model proved too fragile and depended too heavily on secondary files being discovered and read correctly.

The new governing model is:

```text
CLAUDE.md
  -> AGENTS.md
```

`AGENTS.md` is self-contained and contains:

- shared governing instructions,
- human constraints and engineering preferences,
- persona/communication guidance,
- authority and conflict-resolution rules,
- skills policy,
- project-document discovery rules,
- a repository-owned project-context block.

The project-context block is delimited by:

```text
<!-- BEGIN PROJECT CONTEXT -->
...
<!-- END PROJECT CONTEXT -->
```

Synchronization tooling updates the shared portions of `AGENTS.md` while preserving the project-owned contents inside those markers.

`CLAUDE.md` remains a thin client adapter that directs Claude to `AGENTS.md`.

## Normative model

The current authority model is approximately:

```text
platform/system/tool constraints
current explicit user instructions
shared AGENTS.md rules
project-context section of AGENTS.md
specifically named project documents
working context
historical handoffs/archive
```

BCP 14 / RFC 2119 and RFC 8174 uppercase terms such as `MUST`, `SHOULD`, and `MAY` are used only for testable normative requirements.

Critical instructions MUST NOT depend on discovering `human.md`, `persona.md`, `index.md`, or historical handoffs.

## human.md and persona.md

The durable shared content formerly stored in `human.md` and `persona.md` has been consolidated into `AGENTS.md`.

For migrated projects, these files are no longer part of active instruction discovery.

Legacy copies are being removed where they are merely duplicated shared instructions.

Historical or experimental snapshots should not be rewritten merely to remove these files. Those remain evidence.

## Project migration status

The System registry currently includes approximately:

```text
chatmap
dotmdfiles
five-rules
system
clipboard
money
openworker
dotfiles
bin
util
```

The first several projects have been migrated to the consolidated `AGENTS.md` model.

The synchronization script now manages only:

```text
AGENTS.md
CLAUDE.md
```

It preserves the project-context block in `AGENTS.md`.

The old automatic synchronization of:

```text
.llm/index.md
.llm/human.md
.llm/persona.md
```

has been removed.

The migration has also exposed some old tracked symlinks and legacy duplicate files, particularly on Windows. Those are being converted to ordinary files as encountered.

## New question: bring back .llm/index.md?

The current conclusion is **yes, probably**, but with a completely different role.

The old `index.md` was an instruction router and part of automatic discovery.

That should NOT return.

The proposed new role is:

```text
AGENTS.md
  = governing instructions
  + project-specific document rules

.llm/index.md
  = optional navigation/catalog file
    for deeper project knowledge
```

The important distinction is:

```text
AGENTS.md          normative governing authority
specific docs      authoritative within their declared subject
working-context    current project/work state
index.md           navigation only
handoffs/archive   historical evidence
```

## Proposed contract for .llm/index.md

A repository MAY provide `.llm/index.md`.

Its purpose is to help humans and agents locate deeper project knowledge.

It MUST NOT:

- be part of the automatic instruction-discovery chain,
- contain critical governing instructions that are unavailable elsewhere,
- override `AGENTS.md`,
- cause agents to recursively read all `.llm` content.

Agents SHOULD consult `.llm/index.md` when:

- the task requires locating project knowledge,
- the needed document is not already named directly in `AGENTS.md`,
- the `.llm` tree has become large enough that navigation is useful.

The index should describe what documents or collections exist and when they are useful.

A typical structure might be:

```markdown
# Project Knowledge Index

This file is a navigation aid.

It is not governing authority and is not part of the automatic instruction-discovery chain.

Read only the documents relevant to the current task.

## Architecture
- `design.md` - current architectural boundaries and ownership
- `first-principles.md` - durable principles
- `evo.md` - important design evolution

## Current Work
- `working-context.md` - current state, open work, next evidence
- `implementation-notes.md` - implementation details worth preserving

## Decisions
- `decisions/` - ADRs and durable decisions

## Historical Evidence
- `handoffs/` - continuity records
- `archive/` - superseded or historical material
```

## Relationship between AGENTS.md and index.md

`AGENTS.md` should continue to name important project documents directly when there is a clear trigger.

Example:

```markdown
## Project Document Map

- Agents MUST read `.llm/design.md` before changing architecture.
- Agents MUST read `.llm/working-context.md` when continuing unfinished work.
- Agents SHOULD read `.llm/index.md` when they need to discover deeper project documentation not already named here.
- Agents MUST NOT read `.llm/handoffs/` unless the current task requires historical evidence.
```

This means `AGENTS.md` answers:

> What must or should be read, and when?

while `.llm/index.md` answers:

> What knowledge exists here, and where is it?

That separation appears to solve both the reliability problem and the scaling problem.

## ChatMap relevance

ChatMap is likely the strongest test case for the new `index.md` role because its `.llm` knowledge set already contains or has contained documents such as:

```text
design.md
first-principles.md
evo.md
working-context.md
implementation-notes.md
decisions/
handoffs/
archive/
```

As the number of durable semantic documents grows, requiring `AGENTS.md` to enumerate everything directly would become unwieldy.

An optional navigation-only `.llm/index.md` fits ChatMap's broader goal of durable semantic-content capture and provenance.

## dotmdfiles changes to consider next

The next chat should review and probably implement the following:

1. Update the canonical `AGENTS.md` wording to explicitly permit optional `.llm/index.md` as a navigation aid.
2. Define the exact authority and discovery contract for `index.md`.
3. Decide whether dotmdfiles should ship a generic `index.md` template or merely document the convention.
4. Decide whether `setup-project.sh` should optionally create one.
5. Ensure `sync-project-files.sh` does NOT automatically overwrite project-owned `.llm/index.md`.
6. Add tests proving that:
   - `AGENTS.md` remains the governing authority,
   - `index.md` is optional,
   - synchronization ignores/preserves it,
   - no critical instruction depends on it.
7. Consider reintroducing `.llm/index.md` first in ChatMap as a pilot.
8. Review existing `.llm` documentation for stale references to the retired discovery chain.
9. After the pilot, decide whether other projects actually need indexes or should remain simple.

## Design principle

The emerging principle is:

> Keep governing instructions small and deterministic.  
> Let deeper knowledge grow independently behind an explicit navigation layer.

Or more compactly:

```text
AGENTS.md tells the agent how to behave.
index.md tells the agent where knowledge lives.
```

That is the current architectural direction.