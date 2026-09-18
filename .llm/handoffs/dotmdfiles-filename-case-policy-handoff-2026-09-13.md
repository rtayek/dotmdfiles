# Handoff: Filename Case Policy

Date: 2026-09-13
Project: dotmdfiles (policy owner)
Affects: chatmap Active Agenda item 11, and any other downstream project
Status: Decision made. Not yet written into project files.

## Context

chatmap's working-context.md carried an open, unscoped agenda item:
"Change all filenames to lower case." No policy existed to answer it, and
the question is not chatmap-specific — it's a repository convention
question, which is dotmdfiles' job to own. Investigated and resolved in a
Claude.ai chat session on 2026-09-13.

## Decision

Filename case policy for dotmdfiles and downstream projects:

- Default: lowercase for all repository-controlled files.
- Exceptions (stay uppercase):
  - `CLAUDE.md` — Claude Code looks for this exact string. The lookup is
    case-sensitive regardless of filesystem. A lowercase `claude.md` is
    silently invisible to the tool, with no error.
  - `AGENTS.md` — same requirement, same failure mode, for agent tooling
    generally.
  - `README.md` — not required by any CLI tool. GitHub's own repo-page
    rendering is case-insensitive for README detection, but most other
    tooling (package registries, doc generators) is case-sensitive, and
    the uppercase form is near-universal convention. Keep it uppercase.
- Java source files are exempt from this policy entirely — Java requires
  the file name to match the declared public class name exactly,
  including case. This policy governs Markdown/doc/script files, not
  compiled-language source.

## Why this matters now, specifically

Ray is migrating dotfiles from Windows Git Bash to Ubuntu under WSL2.
WSL2/Linux filesystems are case-sensitive; Windows NTFS is not. A naming
mistake that was harmless on Windows (wrong-case file still found) becomes
a silent failure on WSL2 (wrong-case file simply doesn't exist as far as
the tool is concerned). This makes verifying the exceptions above, before
the WSL2 migration completes, worth doing now rather than after.

## Verification performed

- Audited the dotmdfiles repo tree directly: the only uppercase filenames
  present are `README.md`, `CLAUDE.md`, `AGENTS.md`, and their mirrors in
  `files/`. Everything else is already lowercase. No rename work is
  needed in dotmdfiles itself — it already conforms to this policy.
- Confirmed via web search that Claude Code's `CLAUDE.md` lookup is an
  exact-string match, not case-folded, and that this has caused real,
  silent failures on case-sensitive filesystems in the wild. The same
  case-sensitivity failure mode is separately documented for `SKILL.md`.
- Confirmed GitHub's own README detection is case-insensitive, but this
  is GitHub-specific and not a guarantee for other tooling.
- Checked and corrected a historical premise raised in conversation —
  that `README` was lowercase by convention on old Unix systems. It
  wasn't. The uppercase convention comes from ASCII sort order:
  uppercase letters sort before lowercase in `ls`, so an uppercase
  `README` reliably appeared first in a directory listing. That's also
  the origin of the convention this policy is keeping.

## Remaining work

1. dotmdfiles: add a short policy statement to `.llm/index.md` (or
   wherever repository conventions are recorded) so this doesn't get
   re-litigated later. Suggested text:

   > Filename case policy: lowercase for all repository-controlled
   > files. Exceptions: `CLAUDE.md`, `AGENTS.md` (case-sensitive CLI
   > tool lookup, verified 2026-09-13), `README.md` (universal
   > convention; GitHub itself is case-insensitive but most other
   > tooling is not). Java source files are out of scope — file name
   > must match the public class name.

2. chatmap: reword Active Agenda item 11 from an open decision into an
   execution task that points at the policy above instead of re-deciding
   it. Suggested text:

   > Apply the dotmdfiles filename-case policy to this repo: audit
   > remaining uppercase filenames and lowercase them, except
   > `CLAUDE.md`/`AGENTS.md`/`README.md` and Java source files (which
   > must match their public class name, case included).

3. Once dotmdfiles' policy note is in place, chatmap and any other
   downstream project can execute their own lowercase pass without
   re-deciding the underlying question.

## Not done

No files were edited or renamed in either repo as part of this handoff.
This is a decision record only. Ray applies changes himself in Eclipse
and pushes; this file exists so the next agent (Claude, Codex, or
Anti-Gravity) picking up either repo has the reasoning and the exact
text ready to use, without re-deriving it.
