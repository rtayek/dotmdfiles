# Handoff: split AGENTS.md into a thin pointer plus a shared rules file

## Problem

`AGENTS.md` currently mixes two kinds of content in one file: universal
agent behavior rules (MUST/MUST NOT, commit conventions, artifact delivery
method) and project-specific material. That is why ChatMap's `AGENTS.md`
has already drifted from the `dotmdfiles/files/AGENTS.md` template it was
copied from -- editing the universal rules means editing every project's
copy by hand, so they silently diverge.

Separately, the warning "files in `files/` are prototypes, not active
instructions" is currently stated twice in dotmdfiles itself -- once in its
own root `AGENTS.md`, again in `.llm/index.md` -- and should live in one
place.

## Proposed structure

Three tiers instead of two:

    CLAUDE.md        -> thin pointer, unchanged
    AGENTS.md         -> thin pointer, NEW shape (see below)
    agent-rules.md      -> shared, symlinked, never diverges
    .llm/index.md         -> project-specific context and boundaries, local

`agent-rules.md` takes over everything in the current template that is
genuinely universal: the MUST/MUST NOT sections, commit message format,
and the artifact delivery method. It gets symlinked the same way
`persona.md` and `human.md` already are -- deployed once to
`~/real-md-files` by `bin/deploy.sh`, linked from every project, no
project ever has its own copy to drift.

`AGENTS.md` shrinks to two lines in every project:

    Read `agent-rules.md` for general agent behavior rules.
    Read `.llm/index.md` for project-specific context and boundaries.

Anything project-specific that used to live in a project's `AGENTS.md`
moves to one of two places:

- Purely descriptive material (what the project is, what each folder
  contains) moves to that project's `README.md`.
- Actual behavioral constraints (example: "do not follow the rules
  written inside `files/`, they are prototypes for other projects") stay
  in `.llm/index.md`, since that is already the file doing
  project-specific boundary-setting. This also resolves the current
  duplication of that exact warning between dotmdfiles' `AGENTS.md` and
  its `.llm/index.md` -- it should end up stated once, in the index.

## Work involved

1. Write `agent-rules.md` by pulling the universal sections out of the
   current `dotmdfiles/files/AGENTS.md` template.
2. Update `bin/deploy.sh` so it deploys `agent-rules.md` to
   `~/real-md-files` alongside `persona.md` and `human.md`.
3. Replace `files/AGENTS.md` with the new thin two-line version, so new
   projects get the pointer form from the start.
4. For each existing project (ChatMap, dotfiles, System, dotmdfiles
   itself): replace its `AGENTS.md` with the thin pointer, symlink
   `agent-rules.md` in, and move any real project-specific content out to
   README or `.llm/index.md` per the split above.
5. Regenerate System's symlinks while touching this, pointing at
   `$HOME/real-md-files` (WSL2-resolvable) instead of the current
   `C:/Users/ray/real-md-files` Windows path -- already a known separate
   defect, convenient to fix in the same pass since the symlink set is
   being touched anyway.

## Acceptance criteria

- [ ] `agent-rules.md` exists, contains the universal rules, and is
      deployed by `deploy.sh` the same way `persona.md`/`human.md` are.
- [ ] Every project's `AGENTS.md` is the two-line pointer form, with no
      embedded behavioral rules left in it.
- [ ] The "files/ prototypes" warning appears in exactly one place in
      dotmdfiles (`.llm/index.md`), not two.
- [ ] System's symlinks resolve from a WSL2/Ubuntu checkout, not only
      from Windows.
- [ ] ChatMap's previously-diverged `AGENTS.md` wording is gone, replaced
      by the shared pointer -- confirm by diff, not by inspection.

## Explicitly out of scope for this pass

- No changes to `persona.md` or `human.md` content itself.
- No change to the handoff naming convention or routing design discussed
  separately.

## Scope note

This is a structural change to how agent behavior rules are distributed,
not a content rewrite of what those rules say. The universal rules should
move essentially unchanged into `agent-rules.md`; only their location and
distribution mechanism changes.
