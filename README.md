# dotmdfiles

A working collection of operational Markdown for LLM and agent projects. ChatMap is the current pilot for discovery, project context, metadata, and loading behavior.

## Current discovery model

Projects use two client-mandated root entry files and one repository-controlled dispatcher:

```text
CLAUDE.md -> AGENTS.md -> .llm/index.md
```

The uppercase root filenames are exceptions required by client conventions. Other names should be lowercase when practical.

## Repository areas

- `files/` - deployable collaboration sources: `CLAUDE.md`, `AGENTS.md`, `index.md`, `human.md`, and `persona.md`
- `software/` - optional coding, design, architecture, SDLC, accessibility, and language guidance
- `templates/` - reusable document scaffolding
- `prompts/` - reusable prompts
- `.llm/handoffs/` - working and historical transfer records
- `.llm/` - active context and discovery routing for this repository itself

The reusable files are source material. They are not active instructions for the dotmdfiles repository unless `.llm/index.md` or the current task selects them.

## Deployment

Deploy the shared sources after reviewing and committing changes:

```bash
bash bin/deploy.sh
```

This copies `files/*.md` to `real/`.

Set up a project with:

```bash
bash bin/setup-project.sh /path/to/project
```

The setup script creates:

```text
CLAUDE.md
AGENTS.md
.llm/
├── index.md
├── human.md
└── persona.md
```

All five files are ordinary project-local copies. Projects remain self-contained
and do not depend on symlinks back to the dotmdfiles checkout.

For a software project, name the optional guidance files to install under `.llm/`:

```bash
bash bin/setup-project.sh /path/to/project coding-style.md design.md architecture.md sdlc.md java.md
```

The setup script never overwrites an existing file.

## Synchronizing existing projects

`projects.txt` is the shared project registry. Each entry uses `name|path`, with
paths normally starting at the home directory:

```text
chatmap|~/eclipse-workspace/chatmap
```

Blank lines and lines beginning with `#` are ignored. Additional pipe-delimited
fields are reserved for later project metadata such as ports, colors, and launch
settings; the current reader ignores them. Older name-only entries remain
supported and resolve relative to `PROJECTS_ROOT`.

List the verified project paths:

```bash
sh bin/project-paths.sh
```

Check every registered project without changing anything:

```bash
sh bin/sync-project-files.sh --check
```

Check only selected projects by giving their paths explicitly:

```bash
sh bin/sync-project-files.sh --check /path/to/project [/path/to/another-project ...]
```

Copy and verify the shared files deliberately:

```bash
sh bin/sync-project-files.sh --apply /path/to/project [/path/to/another-project ...]
```

Omit the paths with `--apply` to update every registered project. Set
`PROJECTS_FILE` or `PROJECTS_ROOT` to override the registry or workspace
location.

The synchronizer changes only `CLAUDE.md`, `AGENTS.md`, `.llm/index.md`,
`.llm/human.md`, and `.llm/persona.md`. It does not recursively copy `.llm/`
and does not modify or remove any other project files. Skill-package
synchronization, if added later, will be a separate operation.

## Working taxonomy

The current broad semantic categories are:

- durable knowledge
- instructions and governance
- reusable capabilities
- working state and records

Artifacts are also classified independently by semantic role, authority, lifecycle, provenance, and loading or discovery behavior. This remains a working model to be revised from real project evidence.

## Placement warning

Do not put an auto-discovered `CLAUDE.md` in a directory that is an ancestor of unrelated projects. Some clients inherit instructions from parent directories.
