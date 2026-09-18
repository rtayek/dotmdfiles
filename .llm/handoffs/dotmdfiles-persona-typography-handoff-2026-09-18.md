# Handoff: Disable persona.md typography rule

Date: 2026-09-18
Project: dotmdfiles
Status: Ready to apply

## Context

`files/human.md` (Text and File Encoding section) and `files/persona.md`
(line 21) gave contradictory instructions: human.md says avoid
typographic embellishments (em dashes, smart quotes) in anything
copyable; persona.md required em dashes and en dashes in prose. Both
load into every new project by default via setup-project.sh, with no
stated precedence.

Resolution: keep human.md's plain-ASCII rule as the standing policy.
Disable persona.md's conflicting rule rather than delete it, so the
prior intent stays visible in source.

## Change

In `files/persona.md`, wrap the typography bullet (currently line 21,
verify before editing since line numbers may have shifted) in an HTML
comment:

Before:
```
- Use proper typographic punctuation—including em dashes, en dashes, and related
  marks—in prose. Use plain ASCII in code, commands, paths, filenames,
  configuration, and other machine-readable text.
```

After:
```
<!-- - Use proper typographic punctuation—including em dashes, en dashes, and related
  marks—in prose. Use plain ASCII in code, commands, paths, filenames,
  configuration, and other machine-readable text. -->
```

## Not done

`deploy.sh` was not run as part of this handoff. `real/persona.md` will
still carry the old, uncommented rule until deploy.sh is rerun
deliberately — this is expected, per Ray's note that files/ and real/
are allowed to drift while changes are staged and tested one at a time.

## Emoji question, resolved

A related question came up about whether to permit emoji use in
`files/human.md`. Resolved: no change. Emojis stay excluded along with
the other typographic embellishments this handoff addresses. The
existing "Do not use emojis" line in human.md already reflects this;
no edit needed. May reconsider later if a useful application for emoji
comes up.
