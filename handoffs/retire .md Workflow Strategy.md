# HANDOFF.md

## Project

`dotmdfiles`

## Purpose

Develop a general-purpose taxonomy, template set, and workflow for `.md` files used by humans, LLMs, coding agents, and software projects.

The current emphasis is no longer merely “documentation templates.” The project is trying to understand:

- what kinds of `.md` files exist in current LLM/coding-agent ecosystems;
- what semantic role each kind performs;
- which roles are general-purpose rather than vendor-specific;
- how those files should be organized;
- how project-specific semantic state can be extracted from long chats and used to restart fresh chats with much smaller context.

Do not assume the current repository hierarchy is correct. The next phase should derive organization from the taxonomy rather than fit the taxonomy to the current directory structure.

---

# Major Current Insight

Most generic software-engineering knowledge does not belong in these `.md` files because competent LLMs already know it.

Canonical project `.md` files should primarily contain information the LLM cannot reliably infer from:

- general programming knowledge;
- source code;
- repository structure;
- tests;
- Git history.

Useful `.md` content therefore tends to be:

- project-specific decisions;
- architectural invariants;
- boundaries;
- constraints;
- unusual conventions;
- intent;
- unresolved state that matters to continuing work.

A useful conceptual split is:

```text
General engineering knowledge
    → already in the LLM

Project-specific semantic state
    → .md files

Current operational state
    → working-context.md

Chronology/history
    → Git
```

Markdown is currently the preferred semantic representation because it is human-readable, Git-friendly, and readily consumed by LLMs.

JSON may later be useful for machine-readable routing, orchestration, schemas, workflow definitions, and validation, but this should not be formalized prematurely.

---

# Chat Extraction Experiment

A concrete workflow was developed for retiring large chats.

## Goal

Extract durable semantic state from an old chat, then use that state to start a fresh lower-level operational chat.

## Current Minimal Workflow

```text
old chat
→ upload extract-chat-template.md
→ run short extraction prompt
→ produce extract-chat.md
→ semantic triage
→ update canonical .md files if warranted
→ create/update working-context.md
→ start fresh chat
```

The old chat performs its own extraction because it already contains the relevant conversational context.

---

# Extraction Prompt

Use this with an old chat after uploading `extract-chat-template.md`:

```text
Use the uploaded extract-chat-template.md to extract durable semantic state from this chat.

Goals:
- preserve stable semantic information
- compress meaning aggressively
- avoid preserving chronology
- keep output small and focused
- preserve semantic state, not conversation history
- prefer omission over preservation

Preserve:
- stable decisions
- constraints
- active conceptual models
- reusable patterns
- unresolved questions
- important project intent

Avoid:
- repeated reasoning
- conversational filler
- implementation trivia
- chronology
- temporary exploration
- information reconstructable from Git

Return only the completed template.
```

---

# Extraction Template

Current Version 1:

```markdown
# Chat Extraction

## Source
- Chat title:
- Date:
- Project:
- Extracted by:

---

# Active Semantic State

## Stable Decisions
Decisions likely to remain valid.

-

## Constraints
Architectural, workflow, tooling, semantic, compatibility, or style constraints.

-

## Active Model
Current conceptual model being used.

-

## Reusable Patterns
Patterns, idioms, workflows, or decision rules worth reusing.

-

## Open Questions
Still unresolved.

-

## Rejected / Deferred
Intentionally rejected, postponed, or explicitly out of scope.

-

---

# Suggested Canonical Updates

## architecture.md
Durable structural decisions, layer boundaries, dependency rules, major abstractions.

-

## design.md
Current design intent, UX behavior, object responsibilities, interaction flows.

-

## patterns.md
Reusable implementation or reasoning patterns.

-

## working-context.md
Temporary but still useful project state: current direction, next likely work, recent unresolved issues.

-

---

# Compression Guidance

Prefer:
- semantic compression
- durable intent
- reusable structure

Avoid:
- chronology
- repeated reasoning
- implementation trivia
- conversational filler
- information already reconstructable from Git

When uncertain, prefer omission over preservation.
```

Important distinction:

```text
Active Semantic State
    = handoff/restart payload

Suggested Canonical Updates
    = filing/canonicalization recommendations
```

Extraction and canonicalization are separate operations.

---

# Semantic Lifecycle Model

The project is converging on this lifecycle:

```text
chat
→ extraction
→ semantic triage
→ canonicalization
→ working context
→ fresh operational chat
```

Each stage should generally become smaller, cleaner, and more focused.

`extract-chat.md` is a harvest buffer, not permanent canonical memory.

Most extracted material does not necessarily deserve promotion into long-lived `.md` files.

A useful triage question is:

> Would future work become meaningfully worse if this information disappeared?

If not, omit it.

---

# miniReader Experiment

The extraction workflow was tested on a real miniReader architecture/design chat.

This produced meaningful durable project state, including:

## Architecture

- library-first architecture;
- Swing UI acts as a client of the core;
- `CoreFacade` is the sole public core entry point;
- public API exposes DTOs and IDs;
- no leakage of Lucene, filesystem paths, HTTP/parser internals, or storage internals;
- pipeline-oriented ingestion model;
- expected external failures use typed outcomes;
- internal/system failures use exceptions.

## Design

- UI clears display before fetch;
- copyable error dialogs;
- explicit blank-URL and failure feedback;
- JS-shell pages are detected, saved, and currently not indexed;
- persistent library lives under `~/.miniReader`;
- UI reflects persistent rather than session-only document state.

## Working Context

- core architecture appears stable;
- remaining work is primarily semantic refinement rather than restructuring;
- XHTML handling validated;
- failure separation mostly complete;
- possible future work includes real usage testing, optional CLI client, and possible remote client/protocol pressure.

The experiment demonstrated that a long architecture chat can be compressed into durable semantic state without preserving the conversation itself.

It also demonstrated that extraction quality depends strongly on the semantic content of the source chat. Architecture-heavy chats produce architecture; meta-workflow chats produce workflow patterns; debugging chats may produce little durable state.

---

# Current Understanding of Canonical Files

Current candidate semantic roles:

## `architecture.md`

Stable structural facts only:

- boundaries;
- dependency rules;
- major abstractions;
- architectural invariants;
- important architectural non-goals.

It should not become a general software architecture textbook.

## `design.md`

Project-specific design intent:

- behavior;
- policies;
- interaction flows;
- object responsibilities;
- UX choices;
- tradeoffs that are not structural invariants.

## `patterns.md`

Project-specific reusable idioms and decision patterns.

Avoid documenting generic textbook patterns merely because LLMs know their names.

Prefer:

> All UI/core communication passes through `CoreFacade` using DTOs.

over:

> Use the Facade pattern.

## `working-context.md`

Small, current operational state:

- current goal;
- active direction;
- unresolved issues;
- next likely work.

It should change aggressively and should not contain session-local mechanics such as “the template was uploaded.”

---

# Larger Taxonomy Question

The next major research phase is to examine actual open-source `.md` ecosystems before finalizing a taxonomy.

Do not start by forcing known files into the current repository hierarchy.

Instead:

1. survey real open-source conventions;
2. identify semantic roles;
3. compare equivalent concepts across vendors/tools;
4. derive a taxonomy;
5. then determine an organization for `dotmdfiles`.

---

# Preliminary Taxonomy Hypothesis

This is provisional and should be tested against real repositories.

## 1. Agent Instructions

Persistent repository or workspace guidance.

Examples:

- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`
- Copilot instruction files

Semantic role:

> Tell the agent how to behave in this repository or context.

---

## 2. Scoped Rules

Instructions that apply only to certain paths, languages, files, or tasks.

Examples:

- nested `AGENTS.md`
- `*.instructions.md`
- Cursor project rules

Semantic role:

> Instruction + applicability scope.

---

## 3. Skills

Reusable task capabilities.

Typical form:

```text
skill/
    SKILL.md
    scripts/
    references/
    templates/
```

Semantic role:

> Tell an agent how to perform a particular class of job.

---

## 4. Prompts / Commands

Explicit reusable invocations.

Examples:

- `*.prompt.md`
- custom/slash command files

Semantic role:

> Reusable request or operation entry point.

---

## 5. Workflows / Procedures

Multi-step operating processes, possibly involving multiple prompts, skills, tools, or human checkpoints.

Examples:

- release workflow;
- review workflow;
- old-chat extraction workflow;
- project restart workflow.

Semantic role:

> Coordinate a sequence of actions.

---

## 6. Project Semantic State

Durable information specific to the project.

Examples:

- `architecture.md`
- `design.md`
- `patterns.md`
- `vision.md`
- constraints or intent files.

Semantic role:

> Preserve what future humans/agents cannot reliably reconstruct elsewhere.

---

## 7. Handoffs / Transient State

Short-lived transfer artifacts.

Examples:

- `HANDOFF.md`
- `working-context.md`
- `extract-chat.md`
- implementation plans;
- research notes.

Semantic role:

> Transfer current work/state rather than preserve permanent history.

---

# Important Open Questions

The next chat should investigate, rather than assume, answers to these:

- What other recurring `.md` semantic roles exist in open-source agent ecosystems?
- Are skills and workflows genuinely distinct in practice?
- Where do plans/specs/tasks fit?
- How are prompts, commands, rules, and instructions differentiated across tools?
- Which conventions are becoming vendor-neutral?
- Which file formats rely on Markdown bodies plus YAML frontmatter?
- What patterns exist for progressive disclosure?
- What patterns exist for file discovery and loading?
- Which open-source projects have mature agent/skill libraries worth studying?
- What organizational schemes recur across repositories?
- Which categories are semantic categories versus merely vendor naming conventions?
- Which content should remain `.md`, and which eventually belongs in JSON or executable scripts?

---

# Immediate Next Task

Perform a broad survey of open-source skill, instruction, prompt, workflow, rule, handoff, context, plan, spec, and related `.md` files.

Priority should be given to actual repositories/specifications from ecosystems such as:

- OpenAI Codex
- Anthropic Claude Code
- Agent Skills / `SKILL.md`
- `AGENTS.md`
- Gemini CLI
- GitHub Copilot
- Cursor
- Windsurf
- Aider
- other mature open-source agent harnesses and coding-agent repositories

For each discovered type, record:

- filename/convention;
- ecosystem;
- semantic role;
- discovery/loading mechanism;
- scope;
- persistence;
- whether it is automatically loaded or explicitly invoked;
- whether it supports frontmatter/metadata;
- whether it can reference scripts/resources;
- whether it is general-purpose or vendor-specific.

Then derive the taxonomy from evidence.

Do **not** organize the findings around the existing `dotmdfiles` directory hierarchy.

---

# Design Biases Going Forward

- Lean and mean first.
- Prefer omission over preservation.
- Do not teach LLMs generic knowledge they already possess.
- Prefer project-specific semantic state.
- Let Git preserve chronology and archaeology.
- Keep canonical docs small.
- Separate extraction from canonicalization.
- Separate durable state from working state.
- Formalize JSON/orchestration only after repeated workflows reveal where structure is genuinely useful.
- Derive taxonomy from actual ecosystem evidence rather than from filenames already present in this repository.