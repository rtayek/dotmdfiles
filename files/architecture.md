# ARCHITECTURE.md

## Purpose

This file defines the structural rules of the system.

These rules are language-agnostic and apply regardless of implementation details.

---

## Layers

Top to bottom:

UI → Application → Core → Infrastructure

---

## Layer Responsibilities

### UI
- rendering
- input handling
- displaying results
- no business rules

### Application
- use-case orchestration
- coordinates work between layers
- translates user intent into domain actions

### Core
- domain logic
- rules
- state transitions
- no UI concerns
- no direct infrastructure concerns

### Infrastructure
- filesystem
- network
- database
- external services
- adapters for technical concerns

---

## Dependency Rules

Allowed:

- UI → Application
- Application → Core
- Infrastructure → Core

Forbidden:

- Core → UI
- Core → Application
- circular dependencies

Avoid UI → Infrastructure unless explicitly justified.

If a dependency direction seems wrong, prefer introducing an interface or boundary data rather than crossing layers directly.

---

## Data Flow

- UI sends intent to Application
- Application invokes Core logic
- Core produces results
- UI renders the result

---

## Boundary Data

Cross-layer communication should prefer simple boundary data.

- boundary data should be simple and preferably immutable
- UI should not depend on mutable domain internals
- infrastructure-specific types should not leak upward unless explicitly intended

---

## Code Organization

Code organization should reflect architectural boundaries where practical.

Avoid structures that hide or blur layer boundaries.

---

## General Rule

Put code in the lowest layer that can own it without violating dependency rules.

Do not put business logic in UI code.
Do not put technical wiring in Core code.