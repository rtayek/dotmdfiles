> Purpose: Code style conventions that apply to all languages.
> Scope: Naming, formatting, layout, visibility, and utilities.

# Coding Style

Applies to all languages unless a language-specific section says otherwise.

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

## Naming

- Enum values and constants: `camelCase`, not `ALL_CAPS`.
- Test classes end with `TestCase`; test methods read as a scenario: `testPlaceStone_reducesEnemyLiberties`.
- No single-letter variables outside loop counters, unless conventional in math, CS, physics, or engineering.

## Formatting

- Max line length: 100 characters.
- Opening brace on the same line as the declaration.

## Class layout

Top to bottom: constructors, public/protected/package-private/private methods, `main`, then instance fields, then static fields. No fields at the top.

## Visibility

Default visibility unless there's a deliberate reason to widen it. Public/protected fields must be final.

## Comments

Minimal — only for non-obvious invariants, tricky algorithm reasoning, format/protocol notes, or references to external specs.

## Spec violations

Fix the code, or add a short "Exception" note explaining why compliance is worse. Recurring exceptions mean the spec needs updating.

## Agents

Ask before refactoring, changing public APIs, or widening access. Remove dead code when clearly safe; don't delete code without saying why.

## Utilities

Dependency-light and general-purpose only — no project-specific logic.
