---
id: DMF-HANDOFF-2026-09-27-01
lifecycle: working
status: active
provenance: chat-handoff
---

# Handoff: Consolidated Agent Instructions and Skills Architecture

## Purpose

Continue the dotmdfiles redesign from a fresh chat. The user has approved the
direction described below, but implementation has not started.

Repository: `https://github.com/rtayek/dotmdfiles`

## Current Decision

Replace the fragile multi-file discovery chain with one self-contained,
normative `AGENTS.md` plus a thin `CLAUDE.md` adapter.

The existing deployed files are:

- `CLAUDE.md`
- `AGENTS.md`
- `.llm/index.md`
- `.llm/human.md`
- `.llm/persona.md`

The proposed deployed entry files are:

- `CLAUDE.md`: a minimal adapter that directs Claude to `AGENTS.md`.
- `AGENTS.md`: the complete governing contract, including shared instructions
  and repository-specific context.

`human.md`, `persona.md`, and `index.md` will no longer be required discovery
files. Their important content will become clearly scoped sections of
`AGENTS.md`.

## Rationale

The five-file arrangement is semantically tidy but operationally unreliable.
It assumes every LLM client will follow several file references, interpret the
authority boundaries correctly, and stop at the correct directory depth.

The new design favors reliable delivery over document purity. Important rules
must be present in the file that agents are most likely to load automatically.

## Proposed AGENTS.md Structure

```markdown
# Agent Instructions

## Normative Language
## Authority and Conflict Resolution
## Permissions and Scope
## Human Constraints and Preferences
## Agent Persona
## Skills Policy

<!-- BEGIN PROJECT CONTEXT -->

## Project Requirements
## Project Document Map

<!-- END PROJECT CONTEXT -->
```

The shared portion is standardized across repositories. The project-context
portion is owned by each repository. The synchronization mechanism should
replace only the shared block and preserve the project block.

## Normative Language

Use BCP 14, consisting of RFC 2119 as updated by RFC 8174. The recommended
convention is:

```markdown
## Normative Language

The key words `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` are
to be interpreted as described in BCP 14 (RFC 2119 and RFC 8174) when, and
only when, they appear in all capitals.

Lowercase forms have their ordinary English meanings.
```

Use normative terms only for testable requirements. Mark explanatory sections
as informative where necessary.

Suggested interpretation:

- Accessibility and safety constraints may use `MUST` or `MUST NOT`.
- Strong preferences normally use `SHOULD` or `SHOULD NOT`.
- Optional practices use `MAY`.
- Facts and explanations use ordinary declarative prose.

An earlier local edit added this BCP 14 section to `files/AGENTS.md`, but it was
not committed or pushed. At the last review, `origin/master` at commit
`fcd5200` still contained the older phrase "used in the RFC sense."

## Authority and Conflict Resolution

Define a single explicit precedence order. The working recommendation is:

1. Platform and system constraints.
2. The user's current explicit instructions.
3. `AGENTS.md` permissions and governing behavior.
4. The project-context section of `AGENTS.md`.
5. Specifically named project documents, within their declared scope.
6. Working context.
7. Historical handoffs and archives as evidence rather than authority.

The exact wording needs review before deployment.

## Project Documents and Indexing

The human-readable function of `.llm/index.md` moves into the project-context
section of `AGENTS.md`.

Do not use broad rules such as "read all relevant files." Name exact documents
and exact conditions instead:

```markdown
Agents MUST read `.llm/design.md` before changing architecture.

Agents MUST NOT read `.llm/handoffs/` unless the current user request
explicitly requires historical evidence.
```

Large project documents may remain under `.llm/`, but they are not loaded
automatically unless `AGENTS.md` names them.

## Skills

Skills remain separate and on demand. Do not concatenate them into
`AGENTS.md`.

A skill defines a capability, specialty, or workflow. The effective agent is
the combination of model, governing instructions, persona, permissions, tools,
current assignment, selected skills, and working state.

Each skill remains a directory containing:

```text
skill-name/
  SKILL.md
  scripts/       optional
  references/    optional
  assets/        optional
```

Use three skill populations:

1. A small personal active set useful across projects.
2. A small project-specific active set.
3. A large central skills library that is searchable but not automatically
   installed or exposed to every agent.

`AGENTS.md` contains only skill-selection and trust policy, for example:

```markdown
## Skills

Agents MUST use an available skill when the user explicitly names it.
Agents SHOULD use a skill when its declared purpose clearly matches the task.
Agents MUST NOT load skill resources merely because they are available.
Agents MUST NOT execute an untrusted skill before reviewing its instructions,
scripts, and other resources.
```

Current client locations differ. Codex uses `.agents/skills/`; Claude Code uses
`.claude/skills/`. Because the user prefers ordinary files rather than Windows
symlinks, deploy selected skills as copies from the central skills repository.

## Markdown, YAML, JSON, and Shell Boundaries

- Markdown contains human-readable governing rules, explanations, design,
  decisions, working context, and handoffs.
- YAML front matter describes one Markdown document or skill. Examples include
  `id`, `lifecycle`, `status`, `provenance`, skill `name`, and skill
  `description`.
- JSON is for machine-consumed manifests, schemas, configuration, or state. Do
  not create a JSON manifest until a real validator or program consumes it.
- Bourne shell belongs in executable scripts such as `bin/` or a skill's
  `scripts/` directory. Shell performs deterministic effects; it is not the
  authority for semantic policy.

Do not create a generic `json/` directory. Place JSON by semantic role, such as
`config/`, `manifests/`, `schemas/`, `data/`, or `templates/`.

## ADRs

BCP 14 expresses what is required. An Architecture Decision Record preserves
why an important decision was made.

Use this ADR structure:

1. Status
2. Context
3. Decision
4. Consequences
5. Alternatives

The consolidation decision deserves a cross-project ADR in the System
repository. Dotmdfiles owns the resulting shared template and synchronization
implementation.

## Known Problems in the Current AGENTS.md

Resolve these while consolidating:

- "Do more than the task asked for" appears under must-ask rules, while
  expanding scope also appears under never-do rules.
- Pushing appears in both must-ask and never-do sections.
- Configuration changes are categorized as never-do even though explicit user
  authorization permits them.
- "Ask when anything is unclear" conflicts with continuing safely when
  uncertainty is immaterial.
- The default permission to take any unlisted action is too broad and does not
  adequately protect untracked files or irreversible changes.
- Artifact-delivery rules are duplicated between `human.md` and `AGENTS.md`.
- The current artifact-delivery section is incomplete.
- Typography and copy-safe text rules still need a clear policy.

## Recommended Implementation Sequence

1. Write the cross-project ADR in System.
2. Draft the complete combined `files/AGENTS.md` in dotmdfiles.
3. Review every rule as normative, preferential, or informative.
4. Draft the project-context marker convention.
5. Update the synchronization script to preserve project-owned context.
6. Test on dotmdfiles itself and one complex repository, preferably ChatMap.
7. Verify exact deployed content and file modes.
8. Only then migrate the remaining repositories.

## Important Constraints

- Use lowercase filenames where practical. Retain uppercase `AGENTS.md` and
  `CLAUDE.md` because clients discover those names.
- Use UTF-8 with LF line endings.
- Prefer paste-safe Bourne shell commands.
- Avoid Windows symlinks; deploy ordinary files.
- Do not automatically load handoffs, archives, or large skill libraries.
- Keep `AGENTS.md` reasonably short even though it is self-contained.
- Do not delete substantive project knowledge while changing discovery.

## Next Chat Opening Request

Continue the dotmdfiles redesign using this handoff. First inspect the current
remote repository and compare it with this accepted direction. Draft the
cross-project ADR and the consolidated `files/AGENTS.md`, but present the draft
and unresolved policy choices before deploying it to other repositories.
