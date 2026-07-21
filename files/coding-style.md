> Purpose: Code style conventions that apply to all languages.
> Scope: Naming, formatting, layout, visibility, and utilities.

# Coding Style

Applies to all languages unless a language-specific section says otherwise.

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

## General

- Optimize for the reader: code is read far more than it is written.
- Small functions.
- Meaningful names; no single-letter variables outside loop counters unless they are in common use in mathematics, computer science, physics or engineering.

## Comments policy

Code is the documentation; comments MUST be minimal. Allowed only for:

- non-obvious invariants
- tricky algorithm reasoning
- format/protocol explanations
- references to external specs

## Naming

Examples use Java and C syntax; adapt conventions to your language.

| Thing | Style |
|-------|-------|
| Classes / types / interfaces / records | `PascalCase` |
| Methods / functions / locals / parameters | `camelCase` |
| Enum values | `camelCase` (not `ALL_CAPS`) |
| Constants (`int const i=42;`) | `camelCase` (not `ALL_CAPS`) |
| Files | match the primary class/type they contain |
| Test classes | name must end with `TestCase` |
| Test methods | describe the scenario and should start with test: `testPlaceStone_reducesEnemyLiberties` |

Names should reflect intent: `test...`, `mapper`, `applier`, `codec`, `adapter`, `plugin`, `renderer`.

## Formatting

- Max line length: 100 characters.
- Opening brace on the same line as the declaration.
- Compress vertical white space as much as possible.
- Compress horizontal white space as much as is reasonable.
- Fit code onto one line if it is reasonable.

## Class layout

Every class MUST follow this ordering:

1. constructors
2. public methods
3. protected methods
4. package-private methods
5. private methods
6. main method
7. instance fields (at the bottom)
8. static fields (at the bottom)

Place static methods after instance methods, before `main`. `main` is the last method before the fields.

Fields at the top are not allowed. The file should read top-down like an execution narrative.

## Visibility

- Use the default visibility for classes, methods, and fields.
- Public/protected is a commitment: treat it as a deliberate external API decision.
- Fields SHOULD NOT be public unless they are final.

## Spec violations

If you violate this spec, you MUST do one of:

- Fix the code to comply, or
- Add a short "Exception" note near the code explaining why compliance is worse, and ideally add a test that proves the exception is justified.

Recurring exceptions indicate the spec needs updating.

## Dead code

- Agents SHOULD remove unreachable, unused, or commented-out code when clearly safe.
- Retaining apparently-unused code requires a short documented reason (for
  example: public API compatibility, planned work, debugging scaffolding).

## Agent rules

Agents MUST ask before:

- refactoring
- changing public APIs or interfaces
- widening the access modifier of internal methods or classes

Agents MUST NOT:

- delete code without explaining why

## Utilities

- Utilities must be dependency-light and general-purpose.
- Project-specific logic must NOT be placed in util packages.
- If a utility depends on model/parser/UI types, it is not a utility.
