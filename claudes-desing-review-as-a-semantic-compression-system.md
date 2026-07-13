# Design review: dotmdfiles as a semantic-compression system

Reviewer stance: skeptical of infrastructure; biased toward the smallest thing that works.

## 1. Product definition

A discipline, plus a small set of prompts and file conventions, for extracting durable
semantic state from transient AI chat sessions into a fixed set of Git-versioned
Markdown files, so that any fresh session (human or AI) can resume work without
replaying conversations.

It is not a note-taking system, a wiki, or a memory database. The unit of value is
the **cold start**: how fast a fresh agent becomes productive from the files alone.

Note: the repo today contains two different products:

1. Agent-behavior templates (agents.md, sdlc.md, coding-style.md, persona.md, ...).
2. The knowledge-extraction system reviewed here.

They should be separated (folders now; repos later if either grows).

## 2. What problem is actually being solved

- Chat context is transient; project knowledge is not.
- Re-explaining state to each new session is the dominant recurring cost.
- Raw transcripts are a bad memory format: chronological, redundant, unranked.
- Git already solves history, diffing, and provenance for code; this project extends
  that to decisions and intent, which Git commits capture poorly.

The problem is **compression with fidelity**, not storage or retrieval. Retrieval is
trivial at this scale (a handful of files); fidelity is the hard part.

## 3. Markdown vs structured data

**Recommendation: Markdown is canonical. Nothing else, for now.**

- Canonical means: humans edit it, Git versions it, agents read and write it directly.
- Where machine-readable fields are needed, use short inline fields on entries
  (`id`, `status`, `date`, `source`) or YAML front matter — inside the same file.
  One file, one source of truth.
- JSON/YAML sidecar files: rejected. Two representations of the same fact will drift.
- SQLite / vector DB / knowledge graph: rejected for now. At the realistic scale
  (tens of entries per project), grep and a table of contents outperform them, and
  any index can be rebuilt from the Markdown later if scale ever demands it.
  Adopt only after a demonstrated retrieval failure, not before.

## 4. Canonical semantic entities

Keep the ontology small. Five entry types:

| Entity | Meaning | Lives in |
|---|---|---|
| Decision | a choice made, with rationale | decisions.md |
| Constraint | a boundary that must hold | decisions.md (type field) |
| Question | open, unresolved | questions.md |
| Model | active conceptual model / project intent, prose | state.md |
| Task | near-term work | state.md (or the issue tracker if one exists) |

Deliberately excluded as entity types:

- **Fact** — most facts are recoverable from code, tests, or Git ("code is
  documentation"). A fact worth keeping is usually a constraint or part of a model.
- **Hypothesis** — a question with a suspected answer; represent as a Question with
  a `leaning:` note.
- **Pattern** — belongs in the templates product (design.md), not per-project state.
- **Source reference** — a field on every entry, not an entity.
- **Project state** — the file, not an entry type.

Every entry carries: `id` (short, stable), `date`, `status`
(active | superseded | uncertain), `source` (see below).

## 5. Provenance without copying conversations

- Every entry gets a one-line source pointer: date + session label + optionally the
  claim's origin, e.g. `source: 2026-07-05 chat "wsl networking", confirmed by test`.
- Do not archive transcripts by default. If a session was unusually important, save
  its extraction summary (not the raw chat) under `sources/`.
- Rule: provenance identifies **where to look if the entry is doubted**, nothing more.
- Entries an AI extracted but a human has not reviewed are marked
  `status: uncertain` until reviewed. Provenance plus review status together prevent
  silent distortion.

## 6. Conflicts, corrections, supersession, uncertainty

- **Never delete; supersede.** A replaced decision gets `status: superseded-by D-014`
  and its text is reduced to one line. Git keeps the full old text.
- New entry states what changed and why the old one lost.
- Conflicts an extractor cannot resolve become a Question, citing both entries.
- Uncertainty is explicit and cheap: `status: uncertain` plus one line on what would
  settle it. Guessing is prohibited; this mirrors persona.md's uncertainty rule.
- Files state **current truth only**, plus superseded stubs where confusion is likely.
  Chronology lives in Git, not in the files.

## 7. Avoiding stale and duplicated files

The main defense is structural: a **closed set of filenames**. Agents may add entries
to existing files; creating a new file requires explicit human instruction. This
single rule kills file proliferation.

For stale entries:

- Every extraction pass also proposes supersessions and deletions, not just additions.
  Compression is a two-way operation.
- Each entry's `date` makes staleness greppable; a periodic (manual) review of the
  oldest `active` entries is the ritual. No automation needed yet.

For duplication: before adding, the extractor must search the target file for an
existing entry on the same subject and update it instead. One subject, one entry.

## 8. Separation of knowledge

```
project.md      durable: what the system is, goals, non-goals   (slow-changing)
architecture.md durable: structure, boundaries                  (slow-changing)
decisions.md    decisions + constraints, append/supersede       (grows slowly)
state.md        current working state, models, active tasks     (rewritten freely)
questions.md    open questions                                  (shrinks and grows)
sources/        optional extraction summaries of key sessions   (rarely used)
```

- **History**: Git. Not a file.
- **Handoffs**: not stored. A handoff is *generated* from the files above at session
  end or start. If a handoff contains information the files lack, that is a bug in
  the files — fix the files. This is the key move: handoff as a view, not a document.
- **Experiments**: a section in state.md until one becomes real; then it produces a
  decision and code.

## 9. Prose vs machine-readable fields

- **Fields** (one line each): id, date, status, type, source. These exist so that
  grep, diff review, and future tooling work. Nothing else.
- **Prose**: rationale, conceptual models, intent, trade-offs — everything where
  nuance matters. Rationale compressed into fields becomes false certainty.
- Rule of thumb: fields answer "which, when, still true?"; prose answers "why."

## 10. Extraction policy for an AI

The single test: **would a fresh agent, reading only the files, act differently if
this were included?** If no, omit.

- Extract: decisions with rationale, constraints, corrections to existing entries,
  new open questions, changes to the working model.
- Omit: reasoning chains, alternatives discussed and dropped without a decision,
  anything recoverable from code/tests/Git, conversational sequence.
- Update rather than append when the subject already has an entry.
- Merge only when two entries are the same subject; otherwise link.
- When confidence is low, extract anyway but mark `uncertain` — a wrong omission is
  invisible; a wrong entry marked uncertain is reviewable.
- Output is always a **diff for human review**, never a direct commit. The human
  review step is the fidelity guarantee and stays until proven unnecessary.

## 11. Smallest useful version

1. Three files: decisions.md, state.md, questions.md (plus your existing project.md).
2. One extraction prompt: "read this session; propose diffs to these three files
   under the extraction policy."
3. One resume prompt: "read these files; state the project status and open items."
4. Human reviews the diff, commits.

No code. No schema validation. No tooling. This is testable this week on OpenClaw
or myclaw.

## 12. Premature ideas — defer

- SQLite, embeddings, vector search, knowledge graphs.
- JSON schemas and validators.
- Automated extraction pipelines / cron-driven extraction.
- Cross-project knowledge federation.
- Auto-merge or auto-supersede without human review.
- Confidence scores beyond the three-state status field.

Each is adoptable later without rework, because Markdown remains canonical.

## 13. Evaluation criteria

- **Cold-start test** (primary): start a fresh session with only the files; count
  clarifying questions the agent must ask and corrections you must make, vs. an
  ordinary notes folder. Run it on a real project, before/after.
- **Diff signal**: extraction diffs are small and mostly accepted; heavy editing of
  proposals means the policy or prompt is wrong.
- **Staleness count**: number of `active` entries you'd call obsolete at review time.
- **Duplication count**: entries per subject > 1.
- **Handoff regeneration**: a generated handoff needs no manual additions.

## 14. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Silent distortion | diffs reviewed by human; uncertain-by-default for unreviewed |
| Loss of provenance | source field mandatory on every entry |
| Excessive compression | rationale stays prose; supersede instead of delete |
| Duplicated facts | one-subject-one-entry rule; update-before-append |
| Stale conclusions | dates on entries; oldest-active review ritual |
| False certainty | three-state status; guessing prohibited |
| File proliferation | closed filename set; new files require human instruction |
| The meta-risk | building tooling before the manual workflow proves itself |

## 15. Is the project too broad?

Yes, in two ways:

1. Two products in one repo (agent templates vs. knowledge extraction). Separate them.
2. The extraction idea invites infrastructure (schemas, DBs, agents). Everything in
   section 12 is scope creep until the manual three-file workflow has survived a few
   weeks of real use. The MVP is a *practice*, not a system.

The core idea — handoffs preserve semantic state, not chronology; Git is the history
layer; Markdown is the truth layer — is sound and small. Keep it that way.

## 16. Stable design principles

1. Markdown is canonical; everything else is derived and disposable.
2. Files state current truth; Git states history.
3. Supersede, never delete.
4. Closed set of files; open set of entries.
5. Every entry has provenance and a status.
6. Extraction output is a reviewable diff, never a direct commit.
7. Omit anything recoverable from code, tests, or Git.
8. Handoffs are generated views, not stored documents.
9. Uncertainty is stated, never guessed away.
10. Add tooling only after a demonstrated manual failure.

## 17. Unresolved architectural questions

- Entry granularity: is one decisions.md per project enough, or per-module past some size?
- Does Task belong in state.md, or should it defer entirely to an issue tracker?
- Should extraction summaries in sources/ exist at all, or is the diff + commit
  message sufficient provenance?
- How do the agent-template files (agents.md etc.) reference the knowledge files —
  does agents.md instruct agents to read state.md first?
- Multi-agent writes: if two sessions extract concurrently, is Git merge sufficient?
  (Probably yes at this scale; verify.)
- When project.md and state.md disagree, which wins and who reconciles?

## 18. Staged development plan

- **Stage 0 (now):** split templates/ from knowledge/ in the repo; write the
  extraction policy (section 10) and file conventions (section 8) as one short
  spec file.
- **Stage 1 (this week):** hand-run the MVP workflow on one real project (OpenClaw
  or myclaw) for several sessions. Keep the prompts under prompts/.
- **Stage 2 (after ~2 weeks of use):** run the cold-start evaluation; fix the
  extraction policy based on what the diffs got wrong.
- **Stage 3 (only if a manual pain point is demonstrated):** minimal tooling — e.g.
  a script that lists stale/uncertain entries. Still no database.
- **Stage 4 (speculative):** structured index derived from Markdown, if retrieval
  ever actually fails.

## 19. Recommendation to hand to Codex

> Create a `knowledge/` convention in dotmdfiles consisting of: (1) a spec file
> defining five entry types (decision, constraint, question, model, task), the
> per-entry fields (id, date, status: active|superseded|uncertain, source), the
> closed file set (project.md, architecture.md, decisions.md, state.md,
> questions.md, sources/), and the supersede-never-delete rule; (2) two prompt
> files under prompts/ — an end-of-session extraction prompt that outputs proposed
> diffs to those files under the extraction policy "include only what would change
> a fresh agent's behavior; update before append; mark uncertain rather than guess,"
> and a session-resume prompt that reads the files and states current status and
> open items; (3) template versions of the five files with one worked example entry
> each. LF line endings. No code, no schemas, no databases. Do not add new files
> beyond the closed set.
