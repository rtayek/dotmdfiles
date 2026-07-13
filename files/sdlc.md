# SDLC

## Philosophy

This process is an agile variant with a test-first mandate and favors
Domain-Driven Design. Working software, verified by tests, delivered in
small increments is the goal. No feature is done until it has tests.
No refactor is safe without tests.

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