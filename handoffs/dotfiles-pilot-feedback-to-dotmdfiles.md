# Handoff: Lessons from the Dotfiles Markdown Pilot

## Purpose

This handoff feeds results from the `dotfiles` repository pilot back into the `.MD Files` project.

The pilot was useful because it tested the proposed Markdown/LLM organization in a real, active repository rather than refining the convention only in the abstract.

The main conclusion is:

> **Standardize discovery, not organization.**

The original `.MD Files` proposal was directionally useful, but it prescribed more of the internal Markdown layout than the pilot showed was necessary.

---

## What the pilot tested

The dotfiles repository adopted several ideas from the `.MD Files` project:

- root bootstrap files for coding/LLM tools
- an `.llm/` area for LLM-oriented material
- a current working-context file
- a handoff directory
- separation between ordinary project documentation and LLM-operational material
- attempts to share HUMAN and PERSONA material across projects

During the pilot, the repository accumulated enough real usage to expose which parts were valuable and which parts were unnecessary structure.

---

## Main result

The useful invariant turned out to be the discovery chain:

```text
CLAUDE.md
   ↓
AGENTS.md
   ↓
.llm/index.md
```

The first two files are compatibility entry points for tools that expect conventional filenames.

`.llm/index.md` is the project-controlled dispatcher.

It tells an agent which context matters for that particular repository.

Everything behind `.llm/index.md` may evolve independently.

That means the convention should guarantee **how an agent discovers project context**, but should not require every project to use the same internal directory tree.

---

## Recommended bootstrap

A minimal `CLAUDE.md` can be:

```md
Read `AGENTS.md` and follow its instructions.
```

A minimal `AGENTS.md` can be:

```md
Read `.llm/index.md` and follow its instructions.
```

Then `.llm/index.md` can say whatever the project actually needs, for example:

```md
# LLM context

Start with `.llm/working-context.md` for the current project state and next work.

Consult `.llm/handoffs/` when prior work or a specific handoff is relevant.

Read `README.md`, `docs/`, tests, and other project files as needed for the task.

The exact organization of project documentation may evolve. This file is the
stable LLM entry point for deciding what context matters in this repository.
```

The precise contents of `.llm/index.md` are project-specific.

---

## What changed from the earlier proposal

### HUMAN and PERSONA should not be mandatory project files

The pilot initially put shared `human.md` and `persona.md` links in the dotfiles repository.

They added indirection and portability problems without improving project discovery.

They have now been removed.

If a project genuinely needs human-preference or persona material, `.llm/index.md` can point to it wherever it lives.

The convention does not need to reserve HUMAN or PERSONA filenames or locations.

### Do not prescribe the whole `.llm/` tree

The earlier proposal suggested a standard structure such as:

```text
.llm/
    HUMAN.md
    PERSONA.md
    working-context.md
    handoffs/
    skills/
    prompts/
```

The pilot suggests that this is too prescriptive as a universal standard.

`working-context.md`, handoffs, skills, and prompts can all be useful, but they should exist because a project needs them, not because the convention requires them.

Do not create empty ceremonial directories.

### README remains the human entry point

`README.md` remains ordinary project documentation.

It does not need to participate in the tool bootstrap chain, although `.llm/index.md` may direct agents to it when relevant.

### `working-context.md` remains useful, but not mandatory

The rolling-current-state idea worked well conceptually:

> Where are we now, and what should happen next?

It should remain a recommended pattern for active projects, not a required part of the standard.

### Handoffs remain useful

Handoffs proved useful for transferring compressed semantic state between chats, tools, and phases of work.

Their exact location should not be over-standardized.

`.llm/handoffs/` is a sensible convention when a project uses `.llm/`, but discovery through `.llm/index.md` matters more than the path itself.

---

## Final principle

The `.MD Files` project should distinguish between:

### Stable convention

```text
tool-specific entry point
        ↓
AGENTS.md
        ↓
project-controlled context index
```

For the tested tools and project, that became:

```text
CLAUDE.md -> AGENTS.md -> .llm/index.md
```

### Project-specific organization

Everything after `.llm/index.md`.

A project may have:

```text
.llm/working-context.md
.llm/handoffs/
docs/
architecture.md
design.md
skills/
prompts/
```

or a different structure entirely.

The index tells the agent where to look.

---

## Why this is better

This approach gives us:

- a predictable entry point for agents
- compatibility with tools that require conventional filenames
- a clean repository root
- freedom for project documentation to evolve
- no requirement to move functioning documentation merely to satisfy a taxonomy
- fewer symlinks and fewer machine-specific paths
- no empty standard directories
- less duplication between provider-specific files
- a convention small enough to remember without consulting its own documentation

Most importantly, it lets real projects determine their own structure while keeping agent discovery reliable.

---

## Recommended changes to the `.MD Files` project

The next pass on `.MD Files` should:

1. Make **“standardize discovery, not organization”** the central principle.
2. Define the minimal bootstrap chain:
   ```text
   CLAUDE.md -> AGENTS.md -> .llm/index.md
   ```
   while allowing equivalent provider-specific entry files when tools require them.
3. Treat `.llm/index.md` as the stable project-controlled dispatcher.
4. Remove HUMAN and PERSONA from the required/recommended default tree.
5. Recast `working-context.md`, `handoffs/`, `skills/`, and `prompts/` as optional patterns rather than required locations.
6. Keep `README.md` and durable project documentation in their normal human-facing roles.
7. Continue the rule against empty ceremonial directories and unnecessary metadata.
8. Update templates only after they reflect this tested, smaller convention.

---

## Dotfiles pilot status

The dotfiles repository has completed the relevant pilot cleanup.

Its current documented model is:

```text
CLAUDE.md -> AGENTS.md -> .llm/index.md
```

The obsolete root `human.md` and `persona.md` links were removed.

The README now states that `.llm/index.md` is the project-controlled dispatcher and that the organization behind it may vary by project.

The earlier dotfiles Markdown pilot handoff is being retained for now as historical context and may be archived later.

---

## Suggested next step

Use this handoff to revise the `.MD Files` project itself.

Do not immediately impose the resulting convention on every repository.

First make `.MD Files` accurately describe the smaller convention proven by the dotfiles pilot, then try that convention on additional real projects and adjust only when repeated use demonstrates a need.
