> Purpose: Software design principles and goals.
> Scope: Design defaults for all projects.

# Design

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**,
those words are used in the RFC sense.

## Principles

Apply the standard literature by default: SOLID, TDD, DDD (Evans), design patterns
(GoF, Fowler), test patterns (Meszaros), resilience patterns (Nygard).
Prefer named patterns over ad hoc solutions. Deviation MUST be accompanied by
a brief justification.

- **Immutability by default**: mutable only with a clear reason.
- **Lossless first**: never drop information at format boundaries.

## Dependencies

Prefer small, well-scoped libraries. Avoid heavy frameworks and deep
transitive dependency graphs. A new dependency MUST be justified by a clear
need and a net reduction in complexity.

## Concurrency

Prefer immutable, shared-nothing designs. Document every class that is or is
not thread-safe.
