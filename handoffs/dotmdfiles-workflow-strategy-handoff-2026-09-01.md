# Handoff: `.md` Workflow Strategy

**Date:** 2026-09-01  
**Project:** `dotmdfiles` / operational Markdown organization  
**Status:** Paused at a clean decision point  
**Next likely work:** Finish the `mdmacro` scaffold, define its minimal language, then resume the taxonomy

## Purpose of the project

The primary goal is to examine real open-source operational Markdown used by LLMs and agents, then derive a useful taxonomy and organization system.

The project is not merely about arranging the files already present in `dotmdfiles`. The intended sequence is:

1. Examine open-source skills, workflows, instructions, context files, handoffs, templates, and related operational Markdown.
2. Classify files by what they do, how they are discovered, when they are loaded, and what authority they carry.
3. Develop a taxonomy from that evidence.
4. Use the taxonomy to decide how the files should be organized and retrieved.

Do not assume that the repository's current hierarchy is correct. Taxonomy comes before directory structure.

## Important standards distinction

The Agent Skills specification defines:

- A skill as a directory containing `SKILL.md`.
- The internal skill format and optional supporting resources.
- Progressive disclosure: discover metadata, activate instructions, and then load additional resources as needed.

It does **not** define:

- `AGENT.md`.
- `AGENTS.md`.
- A universal skill-discovery directory.
- Configuration of a skill directory through an agent instruction file.

Keep these concepts separate:

| Concept | Example | Authority |
|---|---|---|
| Portable skill package | `foo/SKILL.md` | Agent Skills specification |
| Skill-discovery location | `.agents/skills/` | Individual client implementation |
| Project instruction entry point | `AGENTS.md`, `CLAUDE.md` | Individual client |
| Project-controlled agent documentation | `.agents/llm/`, workflows, context | Repository convention |

`.agents/` may be a useful project convention, but it is not itself a universal part of the Agent Skills standard.

## Current `.agents/` direction

Ray is comfortable placing most canonical, agent-facing operational Markdown under `.agents/` and having required client entry files point into it.

The working principles are:

- Canonical agent-facing material may live under `.agents/`.
- Root or client-mandated files remain where their clients require them.
- `CLAUDE.md`, `AGENTS.md`, or similar files should be thin entry points rather than duplicated stores of policy.
- `.agents/skills/` is special because some clients may automatically discover and activate material there.
- Research specimens and downloaded examples must not be placed where clients may mistake them for active instructions. A corpus belongs under a clearly inactive location such as `corpus/`, `catalog/`, or `examples/`.
- A large number of files is acceptable if discovery is selective. Loading everything indiscriminately is not.

The exact internal `.agents/` layout is still provisional. Earlier possibilities included:

```text
.agents/
├── index.md
├── llm/
├── skills/
├── workflows/
├── instructions/
├── context/
├── handoffs/
├── templates/
└── references/
```

This is a candidate structure, not an established taxonomy.

## ChatMap pilot

ChatMap was selected as the better pilot because it contains substantial operational Markdown with real jobs to perform. The work used branch `feature/agents-markdown-pilot`; the pilot was later merged into ChatMap `master`.

The pilot examined a proposed discovery chain:

```text
CLAUDE.md → AGENTS.md → .agents/llm/index.md
```

Its strongest finding was that this particular linear chain adds unnecessary indirection. ChatMap's existing flat fan-out already worked. If a shared `.agents` index is introduced, client entry points should normally reference it directly instead of relaying through one another.

In other words, central storage under `.agents/` remains viable, but avoid dispatcher-after-dispatcher chains.

The pilot also found:

- `AGENTS.md`, `persona.md`, and `human.md` were tracked as absolute symlinks into Ray's local Markdown repository.
- `core.symlinks=false` can make those links appear as plain path files on a fresh Windows clone.
- There was a case mismatch between `AGENTS.md` and a reference to `@agents.md`.
- Ray chose to retain the symlinks for now because this is a personal repository and avoiding duplicate content is useful.

These are practical pilot findings, not universal rules.

## Why `mdmacro` was proposed

Centralizing canonical Markdown still leaves many small client-specific entry files, generated variants, paths, and repeated fragments. A small macroprocessor could generate those files from templates instead of maintaining copies manually.

`m4` was considered, but it is not readily available in Ray's Windows environment. Ray prefers Java and does not want Python for this job. The macroprocessor therefore became a small standalone Java project, tentatively named `mdmacro`.

It should be its own project rather than living inside ChatMap. ChatMap was briefly considered as a temporary home because it is already a Java project, but templates, invocation, and reuse make a separate project cleaner.

## Decided `mdmacro` build conventions

Use ChatMap's Gradle/Eclipse configuration as the model, stripped of ChatMap-specific machinery.

Required conventions:

- Java 25.
- Gradle wrapper 9.1.0.
- Kotlin Gradle build file.
- One root Gradle project; no generated `app/` subproject.
- Production Java in `src/`.
- Test Java in `tst/`.
- `application` and `eclipse` plugins.
- JUnit Jupiter.
- Gradle CLI is authoritative.
- Plain Eclipse/JDT project; do not use Buildship.
- Retain ChatMap's `copyLibs` approach and Eclipse classpath customization.
- Generate and commit the appropriate `.project`, `.classpath`, and selected `.settings` files.
- Keep the project minimal: no JavaFX, SQLite, logging framework, Checkstyle, PMD, SpotBugs, or JaCoCo initially.

`copyLibs` copies Gradle-managed dependency JARs into `lib/`. The generated Eclipse `.classpath` then points to those JARs, allowing Eclipse to resolve dependencies without Buildship.

Expected verification command:

```bash
./gradlew clean test eclipse
```

A prompt containing these requirements was prepared for Claude. This handoff does not contain confirmation that Claude completed the setup or that the command passed. Inspect the actual `mdmacro` repository before assuming the scaffold is finished.

## `mdmacro` design still open

No macro language has been finalized. The next design pass should decide the smallest useful behavior before substantial implementation begins:

- Template location and naming.
- Variable syntax and substitution rules.
- Whether includes or reusable fragments are needed in the first version.
- Input and output path rules.
- Overwrite and stale-output behavior.
- Error reporting for missing variables or files.
- Command-line invocation.
- How `dotmdfiles`, `dotfiles`, and ChatMap locate or invoke the processor.
- Which generated files are committed and which are regenerated locally.

Keep the first version intentionally small and test-driven.

## `bin/` versus `scripts/`

Both `dotfiles` and `dotmdfiles` currently have `bin/` directories. There was discussion of using `scripts/` for non-Java repositories and possibly retaining `bin` as a compatibility link.

The abbreviation `scr/` was considered but not adopted. It may be confused with `src/`, and the modest saving in name length is probably not worth that ambiguity.

This remains an open naming and migration decision. Do not reorganize these directories merely to finish the macroprocessor scaffold.

## Open work

### Immediate

1. Inspect the actual `mdmacro` repository and Claude's changes, if any.
2. Confirm that it is one root project using `src/` and `tst/`.
3. Run `./gradlew clean test eclipse`.
4. Correct only the scaffold and Eclipse integration needed to establish a clean baseline.
5. Design the minimal macro language before writing the processor.

### After the macroprocessor baseline

1. Select one small, real generation case for the first test.
2. Pilot the generated entry-point approach in ChatMap without creating a long relay chain.
3. Decide the stable relationship among client entry files, `.agents/index.md`, `.agents/llm/`, and `.agents/skills/`.
4. Resume the open-source operational Markdown survey.
5. Derive the semantic taxonomy and loading model from evidence.
6. Only then settle the long-term `dotmdfiles` repository hierarchy.

## Guidance for the next assistant

- Treat this handoff as the current project context, but verify repository state before making claims about completed implementation.
- Preserve the distinction among format, discovery mechanism, loading behavior, instruction authority, and storage location.
- Do not present `.agents/` as part of the Agent Skills standard.
- Do not confuse `AGENT.md` with `AGENTS.md`.
- Avoid broad directory rewrites while testing a narrow convention.
- Keep active agent instructions separate from research specimens.
- Prefer semantic classification and metadata over assuming a rigid folder hierarchy.
- Work in small, verifiable steps.
- Ray prefers Java, `src/` and `tst/`, one Gradle project per Eclipse project, Gradle CLI authority, and no Buildship.

## Clean restart prompt

The next chat can begin with:

> Read the latest `.md Workflow Strategy` handoff. First inspect the current `mdmacro` repository and report whether the agreed Gradle/Eclipse scaffold is complete. Do not implement the macro language yet. Verify the baseline and identify the smallest next design decision.

