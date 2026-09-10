# Handoff: dotmdfiles Discovery and Taxonomy

**Date:** 2026-09-09  
**Project:** dotmdfiles  
**Status:** Clean checkpoint after adopting the ChatMap discovery pattern  
**Latest implementation commit before this handoff:** `4ed7751`

## Purpose

The project studies operational artifacts used by LLM and agent systems, with special attention to Markdown. Its practical goal is to determine how instructions, project knowledge, skills, workflows, and working state should be stored, discovered, loaded, and reused.

The project is no longer restricted to classifying file extensions. A skill may be a package containing Markdown, YAML or JSON metadata, scripts, templates, examples, and references. Markdown remains central because it usually carries the human-readable and LLM-readable meaning.

## Current Working Taxonomy

Use four broad semantic categories as a provisional working model:

1. **Durable knowledge**
   - architecture
   - design
   - first principles
   - patterns
   - durable decisions
   - domain knowledge

2. **Instructions and governance**
   - human collaboration preferences
   - persona
   - coding rules
   - SDLC guidance
   - policies and constraints

3. **Reusable capabilities**
   - skills
   - workflows
   - commands
   - templates
   - supporting scripts

4. **Working state and records**
   - working context
   - plans
   - handoffs
   - preliminary designs
   - historical reviews
   - research imports

Classify artifacts independently along five additional dimensions:

- semantic role
- authority
- lifecycle
- provenance
- loading or discovery behavior

These are working categories, not a settled universal taxonomy. Revise them from real specimens and project experience.

## Lesson From the Earlier ChatMap Classification

The ChatMap Markdown pilot found five different states mixed together inside `handoffs/`:

- active handoff
- working context
- preliminary design
- historical review
- research import

Those were not five universal kinds of Markdown. They were lifecycle and provenance distinctions that revealed that `handoffs/` had become a miscellaneous container.

A handoff should primarily transfer active state between sessions or workers. Historical review and research material may eventually need separate homes.

## Representation Layers

Operational material commonly has three representation layers:

1. **Human and LLM meaning**
   - Markdown and plain text

2. **Declarative control**
   - YAML front matter
   - JSON manifests
   - TOML commands
   - schemas and configuration

3. **Execution and resources**
   - scripts
   - programs
   - templates
   - tests
   - datasets
   - reference files

The file format is not the semantic category.

## ChatMap Pilot Result

ChatMap is the active real-world pilot. Its tested discovery path is:

```text
CLAUDE.md -> AGENTS.md -> .llm/index.md
```

This arrangement produced substantive agreement across Codex, Claude Code, and Anti-Gravity. Although flat fan-out was considered, the existing relay remains reasonable because `AGENTS.md` contains shared normative behavior before routing to project-specific context.

Use lowercase names whenever practical. The uppercase names `CLAUDE.md` and `AGENTS.md` are retained because external clients require or conventionally discover them.

## Changes Made to dotmdfiles

Commit `4ed7751` adopted the ChatMap discovery layout.

Changes included:

- renamed root `agents.md` to `AGENTS.md`
- reduced root `CLAUDE.md` to the client entry point
- added root `.llm/index.md`
- renamed deployable `files/agents.md` to `files/AGENTS.md`
- reduced deployable `files/CLAUDE.md` to the client entry point
- added deployable `files/index.md`
- updated `bin/setup-project.sh` to create `.llm/`
- changed setup so human, persona, and optional software guidance are placed under `.llm/`
- updated `README.md` to describe the new layout and working taxonomy
- normalized the deployable `AGENTS.md` to LF line endings

The setup script now creates approximately:

```text
CLAUDE.md
AGENTS.md
.llm/
├── index.md
├── human.md
├── persona.md
└── optional project guidance
```

The script does not overwrite existing files.

## Current Dogfooding Status

The repository now dogfoods the discovery architecture:

```text
CLAUDE.md -> AGENTS.md -> .llm/index.md
```

It does not yet dogfood the complete ChatMap project-memory system.

Not currently present or proven in dotmdfiles:

- `.llm/human.md`
- `.llm/persona.md`
- `.llm/working-context.md`
- a JSON manifest
- installation of its active files through `setup-project.sh`
- a fresh-agent discovery test comparable to ChatMap's test
- protection against drift between active and deployable copies of `AGENTS.md`

Partial dogfooding is intentional. Do not expand it merely for structural purity.

## Important Repository Boundary

The reusable source areas are not automatically active instructions for this repository:

- `files/`
- `software/`
- `templates/`
- `prompts/`
- historical or unrelated files under `handoffs/`

The active `.llm/index.md` controls discovery. Research specimens must remain outside directories where clients could mistake them for active instructions.

## Encoding Direction

The strict ASCII proposal was relaxed.

The current direction is:

- UTF-8
- no BOM
- LF line endings
- avoid problematic invisible control characters
- use ASCII for machine-sensitive text where practical
- do not impose the operational-file rule on imported transcripts or external research specimens

## Scope Decisions

- The separate Markdown macroprocessor project is outside dotmdfiles scope.
- Do not design a macro language here.
- ChatMap owns and tests its own project-memory implementation.
- dotmdfiles should observe ChatMap and generalize only practices that prove useful.
- Do not force ChatMap's exact internal organization onto every project.
- Avoid broad repository reorganization while the taxonomy remains provisional.

## Recommended Next Step

Use the new discovery layout for a while before changing it again.

The smallest useful next experiment is a fresh-agent read-only discovery test in dotmdfiles:

1. Start an agent at the repository root.
2. Ask it to explain the project purpose, active taxonomy, repository boundaries, and which files are active instructions.
3. Record which entry files it reports reading.
4. Compare the substantive result with `.llm/index.md`.
5. Change the layout only if the test exposes a concrete failure.

After that, decide whether the repository needs `.llm/working-context.md`. Do not add a manifest or full project-memory machinery without demonstrated need.

## Suggested Restart Prompt

> Continue the dotmdfiles project. Read `AGENTS.md` and `.llm/index.md`, then inspect commits `4ed7751` and the latest handoff. The repository now dogfoods the ChatMap discovery pattern but not the complete deployment and project-memory workflow. First perform or design a fresh-agent read-only discovery test. Recommend the smallest useful next step before editing anything.
