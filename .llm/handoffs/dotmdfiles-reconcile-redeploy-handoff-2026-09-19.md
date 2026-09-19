# Handoff: Reconcile files/real drift and redeploy to all projects

Date: 2026-09-19
Project: dotmdfiles (source of truth), affects dotfiles, chatmap, bin
Status: Ready to apply, in order

## Context

files/ and real/ in dotmdfiles were allowed to drift intentionally while
changes were staged. Ray has now decided to close that gap and redeploy
everywhere. Investigation found:

- files/human.md is a clean improvement over real/human.md: fixes several
  typos (sofyware, registrys, environmeny, downldable, Power Shell), adds
  a genuinely new preference (hard of hearing), and is stricter/clearer on
  the plain-ASCII copyable-text rule. Nothing in real/human.md is worth
  keeping. files/ wins outright.

- files/AGENTS.md and real/AGENTS.md differ in two places that both need
  attention before files/ can be treated as canonical:
  1. The never-do rule: files/'s version is actually safer — it prohibits
     overwriting untracked files, which real/'s version never mentions.
     Keep files/'s wording.
  2. The Artifact Delivery section: real/'s version has substantially more
     detail (four numbered fallback steps, a standing-permission clause,
     a note about where handoffs belong) that files/ had condensed away.
     That detail needs to be restored into files/ before syncing.

- Separately, dotfiles and chatmap each have their own independent copies
  of AGENTS.md (root) and human.md (.llm/) that were deployed at some past
  point and never refreshed. Both are stale relative to even the OLD
  real/ content — they predate this reconciliation entirely and need a
  fresh copy once files/ and real/ agree.

- bin uses live symlinks for AGENTS.md, human.md, and persona.md, pointing
  at dotmdfiles/real/ using a hardcoded Windows path
  (C:/Users/ray/eclipse-workspace/dotmdfiles/real/...). This is fragile —
  it won't resolve from WSL2/Linux — and inconsistent with dotmdfiles' own
  decision to stop using symlinks for deployment. Convert these to plain
  copies, matching how setup-project.sh now works for new projects.

- dotfiles/CLAUDE.md is one line with no header, unlike the three-line
  `# CLAUDE.md` / `Read @AGENTS.md...` form used everywhere else. Minor,
  fixed here for consistency since this handoff is already touching
  every project's root files.

persona.md is already identical across dotmdfiles/files, dotmdfiles/real,
dotfiles, and chatmap. No action needed on persona.md anywhere.

## Step 1: Reconcile files/AGENTS.md in dotmdfiles

In `files/AGENTS.md`, replace the "What agents must never do" bullet:

Before:
```
- Delete, overwrite, rename, or move files permanently if they are not tracked by the source code control system.
```
(No change — this line is already correct. Confirm it matches exactly;
if it doesn't, use this wording.)

Replace the "Artifact Delivery" section entirely:

Before:
```
## Artifact Delivery

Artifacts provided to the human must be directly placeable into the user's code project or Git repo, or be downloadable (preferring direct placement in the project/repo).

- If writing to the project and downloads are both unsupported by the interface, provide the artifact in a fenced block.
- Any handoff artifact MUST include '[Hh]andoff' in the filename.
```

After:
```
## Artifact Delivery

Artifacts provided to the human must be directly placeable into the user's code project or Git repo, or be downloadable (preferring direct placement in the project/repo).

Deliver each qualifying artifact using the first available method:

1. Attach it as a downloadable file when the interface supports attachments or
   download buttons.

2. If downloads are unavailable but the agent can write files, write the
   artifact to the first suitable writable location:

   - a delivery directory explicitly selected by the user;
   - an existing project `incoming/` directory;
   - the user's `Downloads` directory;
   - the agent's current working directory.

3. After writing the file, report its exact pathname clearly.

4. If neither downloading nor filesystem writing is available, provide the
   artifact in a fenced block as a last resort.

This rule grants standing permission to create new artifact files in these
delivery locations. It does not grant permission to overwrite an existing file.
Use a timestamp or numeric suffix to prevent collisions.

Actual handoffs may be placed in an existing project `.llm/handoffs/`
directory. Other artifacts should not be placed there merely because no
better location exists. Any handoff artifact MUST include '[Hh]andoff' in
the filename.

When practical, make the download link, attachment, or written pathname the
last item in the response so it is easy to find.
```

Commit this change in dotmdfiles before continuing.

## Step 2: Sync real/ from files/

```bash
cd dotmdfiles
bin/deploy.sh
```

This copies every file in `files/` over `real/`, including the now-
reconciled AGENTS.md and the already-better human.md. Commit the result.

## Step 3: Redeploy into dotfiles and chatmap

For each of `dotfiles` and `chatmap`:

```bash
cp dotmdfiles/real/AGENTS.md <project>/AGENTS.md
cp dotmdfiles/real/human.md <project>/.llm/human.md
```

Do not touch persona.md in either project — already in sync.

Commit the result in dotfiles and in chatmap, separately, with a message
noting this is a redeploy from dotmdfiles/real/.

## Step 4: Convert bin's symlinks to plain copies

`bin/AGENTS.md`, `bin/.llm/human.md`, and `bin/.llm/persona.md` are
currently symlinks:

```bash
cd bin
rm AGENTS.md .llm/human.md .llm/persona.md
cp ../dotmdfiles/real/AGENTS.md AGENTS.md
cp ../dotmdfiles/real/human.md .llm/human.md
cp ../dotmdfiles/real/persona.md .llm/persona.md
```

(Adjust the relative path to dotmdfiles if bin and dotmdfiles aren't
checked out as siblings.) Commit in bin.

## Step 5: Fix dotfiles/CLAUDE.md formatting

Before:
```
Read `AGENTS.md` and follow its instructions.
```

After:
```
# CLAUDE.md

Read @AGENTS.md and follow its instructions.
```

Commit in dotfiles, can be combined with the Step 3 commit for dotfiles.

## Verification

After all steps, these should all be true:
- `diff dotmdfiles/files/AGENTS.md dotmdfiles/real/AGENTS.md` — no output
- `diff dotmdfiles/files/human.md dotmdfiles/real/human.md` — no output
- `diff dotmdfiles/real/AGENTS.md dotfiles/AGENTS.md` — no output
- `diff dotmdfiles/real/AGENTS.md chatmap/AGENTS.md` — no output
- `diff dotmdfiles/real/human.md dotfiles/.llm/human.md` — no output
- `diff dotmdfiles/real/human.md chatmap/.llm/human.md` — no output
- `bin/AGENTS.md`, `bin/.llm/human.md`, `bin/.llm/persona.md` are regular
  files, not symlinks (`ls -la` should not show `->`)

## Not done

`five-rules` (mentioned in launch-webterms.sh as a project) was not
checked or touched — out of scope unless it also carries copies of these
files. Worth a quick look separately if it does.
