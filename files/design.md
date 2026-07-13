> Purpose: Software design principles and goals.
> Scope: Design defaults for all projects.

# Design

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**,
those words are used in the RFC sense.

## Goals

Optimize for:

- **Correctness**: verified by tests
- **Readability**: code reads like prose
- **Determinism**: tests and builds behave the same everywhere
- **Low coupling** and **clear boundaries**
- **Long-term maintainability** over short-term cleverness

## Principles

- **Simple over clever**: prefer the straightforward solution.
- **Immutability by default**: mutable only with a clear reason.
- **Small surfaces**: keep public APIs minimal; easier to add than remove.
- **Fail loudly**: validate inputs at boundaries; throw descriptive exceptions early.
- **Separation of concerns**: data, business logic, and I/O in separate layers.
- **Lossless first**: never drop information at format boundaries.

Apply the standard literature by default: SOLID, DDD (Evans), design patterns
(GoF, Fowler), test patterns (Meszaros), resilience patterns (Nygard).
Prefer named patterns over ad hoc solutions. Treat code smells as
refactoring signals. Deviation MUST be accompanied by a brief justification.

## Dependencies

Prefer small, well-scoped libraries. Avoid heavy frameworks and deep
transitive dependency graphs. A new dependency MUST be justified by a clear
need and a net reduction in complexity.

## Error handling

- Exceptions (or Result types) for conditions the caller must handle.
- Assertions for invariants that should never be violated.
- Never swallow exceptions silently.

## Concurrency

- Prefer immutable, shared-nothing designs.
- Document every class that is or is not thread-safe.