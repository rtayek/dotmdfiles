> Purpose: Defines the development process for agents.
> Scope: Testing, build, and delivery rules.

# SDLC

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

## Philosophy

This process is an agile variant with a test-first mandate and favors
Domain-Driven Design. Working software, verified by tests, delivered in
small increments is the goal. No feature is done until it has tests.
No refactor is safe without tests.

## Tests

Tests are the functional spec: behavioral documentation MUST live in tests, not in prose comments.

Use xUnit Test Patterns liberally.

- If behavior changes, tests MUST change.
- One assertion concept per test.
- Tests must be deterministic: no random data without a fixed seed, no wall-clock time, no network, no environment-specific paths, no reliance on test order.
- Cover the happy path, boundary conditions, and expected error cases.
- If tests write files, write into an isolated temp directory and clean up afterward.
- All new code must compile and pass existing tests.


## Build

- The build tool is the source of truth for build configuration.
- IDE configuration MUST be derived from the build tool, not hand-maintained.
- The project MUST build and test from the command line in a clean environment.

## Rules

- Agents MUST NOT commit directly to main or master.
- Agents MUST NOT suppress or delete tests to make a build pass.
- Agents MUST ask before deleting existing tests.
- If a change breaks an existing test, stop and fix the regression
  before continuing.