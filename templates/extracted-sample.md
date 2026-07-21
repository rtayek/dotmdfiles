# Chat Extraction

## Source

* Chat title: miniReader extraction-template workflow
* Date: 2026-05-06
* Project: miniReader / project-memory workflow
* Extracted by: ChatGPT

---

# Active Semantic State

## Stable Decisions

Decisions likely to remain valid.

* Use `extract-chat-template.md` as the canonical structure for durable chat extraction.
* Extract semantic project state, not conversation history.
* Prefer aggressive compression and omission over preserving marginal information.
* Separate handoff state from suggested canonical `.md` updates.
* For programming projects, use `architecture.md`, `design.md`, `patterns.md`, and `working-context.md` as the default canonical update targets.

## Constraints

Architectural, workflow, tooling, semantic, compatibility, or style constraints.

* Extraction output must use the exact uploaded template structure.
* Do not add extra sections.
* Do not preserve chronology, conversational filler, repeated reasoning, implementation trivia, temporary exploration, or information reconstructable from Git.
* Preserve only durable semantic state likely to matter in future work.
* When uncertain, exclude the information.
* `working-context.md` is for temporary but still useful state, not durable architecture.

## Active Model

Current conceptual model being used.

* `Active Semantic State` is the compact handoff for a future chat or coding agent.
* `Suggested Canonical Updates` maps extracted knowledge into long-lived project memory files.
* Durable semantic state includes stable decisions, constraints, conceptual models, reusable patterns, unresolved questions, and project intent.

## Reusable Patterns

Patterns, idioms, workflows, or decision rules worth reusing.

* Use one extraction prompt plus one uploaded template file to process old chats consistently.
* Keep extraction prompts self-contained unless the template file is explicitly uploaded and available.
* For non-programming domains, replace programming canonical files with domain-specific files while preserving the same semantic split.
* Treat Git as the source for detailed history; extraction should preserve intent and constraints Git cannot easily reconstruct.

## Open Questions

Still unresolved.

* Whether each project/domain should maintain the same canonical file names or use domain-specific variants.
* How much temporary state belongs in `working-context.md` before it becomes noise.

## Rejected / Deferred

Intentionally rejected, postponed, or explicitly out of scope.

* Do not use chat extraction as a full transcript summary.
* Do not preserve debugging chronology or implementation churn.
* Do not rely on an external template reference unless the template file is uploaded or otherwise available.

---

# Suggested Canonical Updates

## architecture.md

Durable structural decisions, layer boundaries, dependency rules, major abstractions.

* No architecture updates identified.

## design.md

Current design intent, UX behavior, object responsibilities, interaction flows.

* Chat extraction workflow should produce a compact semantic handoff plus suggested updates to canonical memory files.

## patterns.md

Reusable implementation or reasoning patterns.

* Extraction pattern: preserve durable semantics; omit chronology, repeated reasoning, and Git-reconstructable facts.
* Use the uploaded `extract-chat-template.md` as the exact output skeleton for chat compression.
* Separate extracted project state from filing recommendations.

## working-context.md

Temporary but still useful project state: current direction, next likely work, recent unresolved issues.

* The extraction prompt is now ready for use on old chats.
* The template file has been uploaded and can be referenced directly in future extraction requests.

---

# Compression Guidance

Prefer:

* semantic compression
* durable intent
* reusable structure

Avoid:

* chronology
* repeated reasoning
* implementation trivia
* conversational filler
* information already reconstructable from Git

When uncertain, prefer omission over preservation.
