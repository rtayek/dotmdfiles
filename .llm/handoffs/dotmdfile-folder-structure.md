# Handoff: `.MD Files` Project

## Purpose

This project is about establishing a **simple, durable convention for Markdown files used by humans, LLMs, coding agents, and project handoffs**.

The immediate problem is that modern LLM-assisted projects are accumulating large numbers of `.md` files in repository roots:

* agent instructions
* provider-specific instructions
* personas
* human preferences
* working context
* handoffs
* skills
* prompts
* design notes
* architecture documents
* temporary session material

Some of these are genuine project documentation. Others exist mainly to help LLMs work on the project. Treating all of them alike creates clutter and makes it unclear what an agent should actually read.

The goal is **not** to create an elaborate documentation framework. The goal is to establish a small convention that scales across projects.

---

# Core distinction

Separate Markdown primarily by **purpose**, not merely by file extension.

## Human/project documentation

Files that a human maintainer would reasonably read to understand the project belong in normal project documentation.

Examples:

```text
README.md

docs/
    architecture.md
    design.md
    user-guide.md
```

These documents may be written or maintained with LLM assistance, but that does not make them “LLM files.”

## LLM-operational material

Files whose primary purpose is to help an LLM resume, understand, or perform work belong together under:

```text
.llm/
```

This keeps the repository root reasonably clean while preserving useful project memory in Git.

---

# Current proposed project structure

```text
project/
├── README.md
├── AGENTS.md
├── CLAUDE.md
│
├── docs/
│   ├── architecture.md
│   ├── design.md
│   └── other durable project documentation
│
└── .llm/
    ├── HUMAN.md
    ├── PERSONA.md
    ├── working-context.md
    │
    ├── handoffs/
    │   └── ...
    │
    ├── skills/
    │   └── ...
    │
    └── prompts/
        └── ...
```

`prompts/` should exist only when a project actually accumulates reusable prompts.

Do not create empty ceremonial directory trees merely because a convention permits them.

---

# Root bootstrap files

Some agent systems automatically look for particular files in the repository hierarchy.

Therefore the current recommendation is to retain conventional visible entry-point files such as:

```text
AGENTS.md
CLAUDE.md
```

Do **not** rename them to hidden forms such as:

```text
.AGENTS.md
.CLAUDE.md
```

unless the relevant tools explicitly support those names.

Compatibility is more useful than hiding two tiny files.

## `AGENTS.md`

This should become the main general-purpose entry point.

Its job is to tell an agent **which context to read**, rather than telling it to read every Markdown file it can find.

Conceptually:

```markdown
Read HUMAN and PERSONA context.

Read .llm/working-context.md if present.

Use relevant material from .llm/skills/.

Consult .llm/handoffs/ when prior work is needed.
```

This is effectively a **context manifest**.

That is preferable to:

```text
Read all .md files in the root directory.
```

because repositories inevitably accumulate unrelated Markdown and historical debris.

## `CLAUDE.md`

Keep this as Claude's provider-specific bootstrap.

Ideally it is very small and mostly directs Claude to the common instructions in `AGENTS.md`.

Only genuinely Claude-specific behavior should live there.

Other providers can receive similar tiny bootstrap files if their tools require them.

---

# HUMAN and PERSONA files

The user currently commonly has files corresponding to:

* Human
* Persona
* Agent instructions
* Claude instructions

Many are links to shared files and are largely static.

The user's HUMAN and PERSONA information is expected to remain fairly stable across projects.

Because these files are generally symlinks or shared material, duplication/drift is not presently a major problem.

Current preference:

```text
.llm/HUMAN.md
.llm/PERSONA.md
```

However, moving existing working symlinks out of the repository root is **not urgent**. There is little value in reorganizing functioning files merely to satisfy a prettier taxonomy.

The more important architectural decision is that `AGENTS.md` should explicitly identify the context that matters.

---

# `working-context.md`

This is likely to become one of the most useful standard files across active projects.

Purpose:

> Answer “Where are we now, and what should happen next?”

Suggested structure:

```markdown
# Working Context

## Current state

Short description of where the project stands.

## Next

- ...

## Open questions

- ...

## Deferred

- ...
```

A valid state is:

```markdown
## Next

Nothing currently planned.
```

Do not invent work simply to populate the file.

## Size

Keep it deliberately small.

Typical target:

```text
~200–800 words
```

Roughly half a page to two pages.

It should be **rolling state**, not an append-only journal.

Delete completed material that is no longer useful for resuming work.

Move durable information elsewhere:

```text
architecture decisions -> docs/architecture.md
design decisions       -> docs/design.md
reusable patterns      -> patterns/design documentation
past session state     -> .llm/handoffs/ or archive
```

The guiding idea is:

> `working-context.md` is the resumption point, not the history of civilization.

---

# Handoffs

Use:

```text
.llm/handoffs/
```

for handoff documents.

Handoffs are useful when:

* a chat becomes large
* work moves to another LLM or agent
* a focused subproject is delegated
* a project changes phases
* durable semantic state needs to survive session boundaries

A good handoff contains compressed semantic information, not a transcript.

Useful contents include:

* goal
* current state
* important decisions
* files/components involved
* tools/environment
* constraints
* definition of done
* immediate next work
* unresolved questions

## Git policy

Do **not** automatically `.gitignore` handoffs.

Useful handoffs often contain real project history and important decisions.

Track good handoffs and prune/archive obsolete ones.

Truly temporary execution logs and disposable session artifacts can remain untracked.

---

# Skills

Reusable instructions for LLMs or coding agents belong under:

```text
.llm/skills/
```

Example:

```text
.llm/
    skills/
        code-review/
            SKILL.md

        release-check/
            SKILL.md
```

Create a skill only when the procedure is:

* repeatable
* reasonably stable
* useful more than once
* specific enough to justify maintaining

A one-time instruction should remain a prompt or handoff rather than being promoted into a sacred `SKILL.md`.

The emerging proliferation of skill files is partly a taxonomy problem. Giving them one defined habitat makes them easier to manage.

---

# Prompts

Optional location:

```text
.llm/prompts/
```

Use only for reusable prompts that genuinely benefit from being maintained as project assets.

Do not turn every successful chat instruction into a permanent prompt file.

---

# Documentation already used in projects

A prior `.MD files` convention had converged around files such as:

```text
architecture.md
design.md
patterns.md
working-context.md
```

That remains conceptually useful.

The refinement now is to distinguish:

```text
durable software/project knowledge
        vs.
LLM-operational working state
```

So a likely mapping is:

```text
docs/architecture.md
docs/design.md
docs/patterns.md

.llm/working-context.md
```

Not every project needs every document.

Prefer omission over boilerplate.

---

# Principles

The convention should remain:

* small
* comprehensible
* easy to adopt incrementally
* provider-neutral where possible
* compatible with provider conventions where necessary
* Git-friendly
* friendly to both humans and LLMs
* resistant to repository-root clutter

A file should have a clear reason to exist.

Do not add YAML front matter, indexing metadata, elaborate schemas, or orchestration machinery until there is an actual tool that consumes it.

Metadata can always be added later. Decorative infrastructure has an unfortunate tendency to achieve immortality.

---

# Current working rule

A useful classification test is:

> **If a human maintainer would reasonably read it to understand the project, it belongs in ordinary project documentation.**

> **If it primarily exists so an LLM can resume or perform work, it belongs under `.llm/`.**

Provider-required bootstrap files such as `AGENTS.md` and `CLAUDE.md` are the intentional exception and remain at the repository root.

---

# Likely next work

1. Decide whether `.llm/` is definitely the canonical directory name.
2. Define a small standard `AGENTS.md` bootstrap/context-manifest template.
3. Define the minimal `working-context.md` template.
4. Decide how existing HUMAN/PERSONA symlinks should migrate, if at all.
5. Decide whether old handoffs need an archive convention such as:

```text
.llm/handoffs/archive/
```

6. Try the structure on one or two active repositories before imposing it everywhere.
7. Once proven useful, consider a small audit/migration script that reports existing Markdown files and recommends where they belong.

The key is to **standardize only what has demonstrated value**. The purpose is to reduce context clutter, not move the clutter into a beautifully organized hidden folder.
