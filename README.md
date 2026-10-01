# dotmdfiles

A working collection of shared agent instructions, deployment tools, reusable
software guidance, and supporting research.

## Current discovery model

Projects use two client-facing root files:

```text
CLAUDE.md -> AGENTS.md
```

`AGENTS.md` is the self-contained governing document. Its marked project-context
block names additional project documents only when they are required. The
uppercase root filenames are exceptions required by client conventions. Other
names should be lowercase when practical.

## Repository areas

- `bin/` - deployment, setup, registry, synchronization, and regression-test
  scripts
- `files/` - deployable collaboration sources: `CLAUDE.md` and `AGENTS.md`
- `real/` - reviewed copies ready for project deployment
- `software/` - optional software guidance
- `semantic/` - design research, not active project instructions
- `templates/` - reusable document scaffolding
- `prompts/` - reusable prompts
- `.llm/handoffs/` - working and historical transfer records
- `.llm/project-context.md` - retired context from the earlier split-document
  pilot, retained only as historical evidence

Root-level notes and `project-home.html` are working artifacts. They are not
part of shared project deployment.

The reusable files are source material. They are not active instructions for
dotmdfiles merely because they exist under `files/` or `real/`.

## Deployment

Edit deployable instructions in `files/`, then refresh `real/`:

```sh
bash bin/deploy.sh
```

The script copies `files/*.md` to `real/`. Review and commit the source and
deployed copies together. It does not remove a retired template from `real/`;
delete the corresponding source and deployed files explicitly when retiring
one.

Set up a project with:

```sh
bash bin/setup-project.sh /path/to/project
```

The two managed files are ordinary project-local copies. Projects do not
depend on symlinks back to the dotmdfiles checkout.

For a software project, name optional guidance files to install under `.llm/`:

```sh
bash bin/setup-project.sh /path/to/project coding-style.md design.md architecture.md sdlc.md java.md
```

The setup script never overwrites an existing file.

## Synchronizing existing projects

The System repository owns the authoritative `projects.tsv`. Its deploy command
installs an ordinary copy at `~/.config/ray/projects.tsv`, which dotmdfiles reads
without depending on the System checkout.

List verified project paths:

```sh
sh bin/project-paths.sh
```

Check every registered project without changing anything:

```sh
sh bin/sync-project-files.sh --check
```

The check exits nonzero when a managed file differs or is missing.

Synchronize the two shared root files deliberately:

```sh
sh bin/sync-project-files.sh --apply
```

Pass project paths to either command to limit the operation. Set `projectsFile`
or `projectsRoot` to override the defaults. The older `PROJECTS_FILE` and
`PROJECTS_ROOT` spellings remain temporarily accepted.

The synchronizer changes only `CLAUDE.md` and `AGENTS.md`. It preserves the
marked project-context block inside each existing `AGENTS.md` and does not
modify `.llm/` or any other project files.

## Validation

There is no application build. Validate shell syntax and the synchronizer with:

```sh
bash -n bin/deploy.sh bin/setup-project.sh
sh -n bin/project-paths.sh bin/sync-project-files.sh bin/sync-project-files-test.sh tar-some.sh
sh bin/sync-project-files-test.sh
git diff --check
```

The regression test uses temporary directories and does not modify registered
projects.

## Working taxonomy

The current broad semantic categories are durable knowledge, instructions and
governance, reusable capabilities, and working state and records. Artifacts are
also classified independently by role, authority, lifecycle, provenance, and
loading behavior.

## Placement warning

Do not put an auto-discovered `CLAUDE.md` in a directory that is an ancestor of
unrelated projects. Some clients inherit instructions from parent directories.
