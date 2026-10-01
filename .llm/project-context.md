---
id: DMF-PROJECT-01
lifecycle: durable
status: retired
provenance: git-history
---
# Retired dotmdfiles Project Context

This file was the project-context source during the split-document discovery
pilot. Its governing content was consolidated into the root `AGENTS.md`.

It is retained as historical evidence and is not an active instruction file.
Read the root `CLAUDE.md` and `AGENTS.md` for current repository instructions.

## Current structure snapshot

- `files/` contains the working shared templates.
- `real/` contains reviewed deployment copies.
- `bin/` contains deployment and synchronization tools.
- `software/` contains optional guidance that `setup-project.sh` can install.
- `prompts/`, `semantic/`, and `templates/` contain reusable or research
  material that is not automatically active.
- `.llm/handoffs/` contains historical and working transfer records.

The repository has no application build. Its executable behavior is limited to
the shell tools and their regression test described in `README.md`.
