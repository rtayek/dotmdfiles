# Handoff: Filename Case Policy

Date: 2026-09-13
Revised: 2026-09-18
Project: dotmdfiles (policy owner)
Affects: dotmdfiles and downstream projects that adopt this convention
Status: Existing convention clarified. Index wording still to be updated.

## Context

The original discussion on 2026-09-13 was prompted by a reported chatmap
working-context.md agenda item: "Change all filenames to lower case."
That downstream agenda has not been rechecked as part of this revision.

dotmdfiles already says in `.llm/index.md` that repository-controlled
names should be lowercase when practical. This handoff clarifies that
convention rather than introducing a new one.

On 2026-09-18, Ray clarified the intent: avoid ALL-CAPS filenames such as
`WORKING-CONTEXT.md`, preferring `working-context.md`. Mixed-case names
are acceptable; every filename need not contain only lowercase letters.

## Decision

> Prefer lowercase filenames for documentation and scripts. Avoid
> ALL-CAPS names unless required by tooling or retained by convention,
> such as `CLAUDE.md`, `AGENTS.md`, `SKILL.md`, and `README.md`.
> Mixed-case names are acceptable.

These examples are not an exhaustive exception list. Preserve exact names
required by tools, languages, or external interfaces. Source files follow
their language and project conventions.

## Rationale

Use documented filename spelling for tool-discovered files and keep
references consistent with the actual filenames. This supports portability
without assuming identical lookup behavior across tools and filesystems.
`README.md` is retained by convention.

## Verification performed on 2026-09-18

- Read the current `.llm/index.md` and `README.md`; both already express
  a lowercase preference.
- Checked tracked filenames with `git ls-files`. ALL-CAPS basenames are
  limited to `AGENTS.md`, `CLAUDE.md`, and `README.md` in the root and
  applicable copies under `files/`, `real/`, and `templates/`.
- Two tracked handoffs have mixed-case names:
  `2026-09-12-DMF-agent-rules-split-handoff.md` and
  `retire .md Workflow Strategy.md`. They are acceptable under the
  clarified convention.
- No tracked filename renames are indicated by this audit. This does not
  establish compliance for untracked files or downstream repositories.

## Remaining work

1. Update the existing convention in `.llm/index.md` with the wording
   under Decision and its general exception for required names.
2. When a downstream project adopts the convention, audit ALL-CAPS
   documentation and script filenames first. Check tool requirements,
   scripts, links, and other references before proposing specific renames.
   Mixed-case names and historical records do not need a cosmetic
   normalization pass.
3. Follow that project's current instructions and task authorization
   before executing any proposed renames.

## Not done

This revision updates only this decision record. The index and downstream
projects have not been changed, and no files have been renamed.

This handoff authorizes no edits, renames, commits, or pushes; follow the
current task and repository instructions.
