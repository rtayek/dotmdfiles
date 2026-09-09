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
- `handoffs/` - working and historical transfer records
- `.llm/` - active context for this repository itself

The reusable files are source material. They are not active instructions for the dotmdfiles repository unless `.llm/index.md` or the current task selects them.

## Deployment

Deploy the shared sources after reviewing and committing changes:

```bash
bash bin/deploy.sh
```

This copies `files/*.md` to `~/real-md-files/`.

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

`CLAUDE.md` and `.llm/index.md` are project-local copies. `AGENTS.md`, `.llm/human.md`, and `.llm/persona.md` link to the shared deployed sources.

For a software project, name the optional guidance files to install under `.llm/`:

```bash
bash bin/setup-project.sh /path/to/project coding-style.md design.md architecture.md sdlc.md java.md
```

The setup script never overwrites an existing file.

## Working taxonomy

The current broad semantic categories are:

- durable knowledge
- instructions and governance
- reusable capabilities
- working state and records

Artifacts are also classified independently by semantic role, authority, lifecycle, provenance, and loading or discovery behavior. This remains a working model to be revised from real project evidence.

## Placement warning

Do not put an auto-discovered `CLAUDE.md` in a directory that is an ancestor of unrelated projects. Some clients inherit instructions from parent directories.
