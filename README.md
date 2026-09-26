# dotmdfiles

A working collection of operational Markdown for LLM and agent projects.
ChatMap is the current pilot for discovery, project context, metadata, and
loading behavior.

## Current discovery model

Projects use two client-mandated root entry files and one repository-controlled
dispatcher:

```text
CLAUDE.md -> AGENTS.md -> .llm/index.md
```

The uppercase root filenames are exceptions required by client conventions.
Other names should be lowercase when practical.

## Repository areas

- `files/` - deployable collaboration sources: `CLAUDE.md`, `AGENTS.md`,
  `index.md`, `human.md`, and `persona.md`
- `real/` - reviewed copies ready for project deployment
- `software/` - optional software guidance
- `templates/` - reusable document scaffolding
- `prompts/` - reusable prompts
- `.llm/handoffs/` - working and historical transfer records
- `.llm/` - active context for this repository itself

The reusable files are source material. They are not active instructions for
dotmdfiles unless `.llm/index.md` or the current task selects them.

## Deployment

Deploy the shared sources after reviewing and committing changes:

```sh
sh bin/deploy.sh
```

This copies `files/*.md` to `real/`.

Set up a project with:

```sh
sh bin/setup-project.sh /path/to/project
```

The five managed files are ordinary project-local copies. Projects do not
depend on symlinks back to the dotmdfiles checkout.

For a software project, name optional guidance files to install under `.llm/`:

```sh
sh bin/setup-project.sh /path/to/project coding-style.md design.md architecture.md sdlc.md java.md
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

Copy and verify the five shared files deliberately:

```sh
sh bin/sync-project-files.sh --apply
```

Pass project paths to either command to limit the operation. Set `projectsFile`
or `projectsRoot` to override the defaults. The older `PROJECTS_FILE` and
`PROJECTS_ROOT` spellings remain temporarily accepted.

The synchronizer changes only `CLAUDE.md`, `AGENTS.md`, `.llm/index.md`,
`.llm/human.md`, and `.llm/persona.md`. It does not recursively copy `.llm/`
or modify any other project files.

## Working taxonomy

The current broad semantic categories are durable knowledge, instructions and
governance, reusable capabilities, and working state and records. Artifacts are
also classified independently by role, authority, lifecycle, provenance, and
loading behavior.

## Placement warning

Do not put an auto-discovered `CLAUDE.md` in a directory that is an ancestor of
unrelated projects. Some clients inherit instructions from parent directories.
