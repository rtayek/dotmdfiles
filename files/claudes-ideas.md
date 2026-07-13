That's the right instinct. Agents already know GoF, Fowler, SOLID, etc. — you don't need to teach them, just state your preferences. Here's my read:

**Cut almost entirely**
- **patterns.md (18KB)** — it's a textbook index. Replace with a few lines in design.md: "Prefer named patterns over ad hoc solutions. Apply the literature: GoF, Fowler (Refactoring, PoEAA), Evans, Meszaros, Nygard. Treat code smells as refactoring signals."

**Condense heavily**
- **design.md** — the SOLID/FP/DDD/security sections are definitions the agent already knows. Keep only: your goals, your principles list (simple over clever, immutability, fail loudly...), and one line saying "apply SOLID, DDD, xUnit patterns by default." Could go from 6KB to ~1.5KB.
- **coding-style.md** — the tests section overlaps sdlc.md. Keep naming/layout/comments (those are *your* opinions, agents won't guess them); move test rules to sdlc.md.

**Doesn't belong / questionable**
- **architecture.md** — layered-architecture rules are generic; arguably belongs as a per-project file, not a universal template. Or fold a short version into design.md.
- **c.md** — 4 bullets; could merge into coding-style.md as a language subsection alongside java.md.
- **accessibility.md** — fine, but only for UI projects; it's already scoped that way, so OK as opt-in.

**Keep mostly as-is**
- agents.md, sdlc.md, persona.md, human.md, project.md — these are your actual rules and preferences, and they're already fairly tight.

Rough result: ~14 files / ~40KB down to ~8 files / ~15KB.

Does that match your thinking? If so, I can draft the condensed design.md first — it's the one where "mention the preference, skip the detail" applies most — and you can react to that before I touch anything else.