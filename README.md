# dotmdfiles

A working copy of the `.md` files that get deployed into every project — Claude Code, and any other agent that reads `AGENTS.md`.

## Structure

- `files/` — the real, always-needed collaboration files: `CLAUDE.md`, `agents.md`, `persona.md`, `human.md`. These describe the collaboration itself (who you're working with, how the agent should behave and communicate) and don't depend on what a given project is.
- `software/` — conditional rules that only apply if a project involves writing code: `coding-style.md`, `design.md`, `architecture.md`, `sdlc.md`, plus language-specific files (`java.md`, `c.md`) and `accessibility.md` (only relevant if there's a UI). Pick the ones that apply per project; don't include the rest.
- `templates/` — blank scaffolding (`README.md`, `project.md`) still to be filled in per project, plus a chat-extraction subsystem whose long-term home is still undecided.

## Deployment model

`files/` here is the working copy — edit it, review it, commit it. The actual source of truth that other projects point at is `~/real-md-files/`, a plain (non-git) folder in the home directory. After changing anything in `files/`, run:

```
bash bin/deploy.sh
```

This copies `files/*.md` into `~/real-md-files/`. Nothing outside this repo reads `files/` directly — they all read `~/real-md-files/`.

## Setting up a new project

Each project needs exactly one real file and three symlinks, all pointing back at `~/real-md-files/`:

```
cp ~/real-md-files/CLAUDE.md ./CLAUDE.md
ln -s ~/real-md-files/agents.md ./AGENTS.md
ln -s ~/real-md-files/persona.md ./persona.md
ln -s ~/real-md-files/human.md ./human.md
```

`CLAUDE.md` is a real file, not a symlink — it's tiny (just `@import` lines) and specific to Claude Code. `AGENTS.md`, `persona.md`, and `human.md` are symlinks because every other agent tool (Codex, Cursor, Copilot, Gemini CLI) has no import mechanism of its own — it just reads whatever `.md` files are physically present, so the file needs to actually be there, even if only via symlink. Copies would work too but drift out of sync the moment the source changes; symlinks don't.

Why not just point `CLAUDE.md` at `~/real-md-files/CLAUDE.md` directly and skip the local file entirely? You can, for Claude Code specifically — its `@import` supports absolute paths. The one-line local `CLAUDE.md` shown above is only needed because every other tool requires *something* with the right filename physically present in the project.

If the project involves writing code, also symlink whichever `software/*.md` files apply (skip the rest):

```
ln -s ~/real-md-files/coding-style.md ./coding-style.md
ln -s ~/real-md-files/design.md ./design.md
ln -s ~/real-md-files/architecture.md ./architecture.md
ln -s ~/real-md-files/sdlc.md ./sdlc.md
ln -s ~/real-md-files/java.md ./java.md    # or c.md, or neither
```

(`software/*.md` files aren't deployed by `deploy.sh` yet — for now, symlink them straight from this repo's `software/` folder, or copy them into `~/real-md-files/` yourself if you want them centralized too.)

## A caution on placement

Don't put a real, auto-discovered `CLAUDE.md` at a directory that's an ancestor of more than one project (e.g. a shared parent folder like `~/eclipse-workspace/`). Claude Code walks up every parent directory to the filesystem root looking for `CLAUDE.md` files and merges what it finds — a file placed too high up gets silently inherited by everything nested underneath, including projects that aren't really yours (a cloned repo you're just reading, for instance). Keep real files either in `~/real-md-files/` (not an ancestor of anything) or inside one specific project you deliberately opted in.

## Customization tips

- Fill in any `## Structure` sections and resolve `## To be decided` items early.
- Adjust `persona.md` and `human.md` to match your actual working style — these are personal, not generic.
- Tighten or loosen the agent permission lists in `agents.md` based on how much autonomy you want to grant.
