> Purpose: Defines the agile/TDD software development lifecycle for agents.
> Scope: Process, iteration, testing, and delivery rules for AI agents.

# SDLC

## Status

This document is normative. Where it uses **MUST / MUST NOT / SHOULD / MAY**, those words are used in the RFC sense.

## Philosophy

This process is an agile variant with a test-first mandate. Working software, verified by tests, delivered in small increments is the goal. No feature is done until it has tests. No refactor is safe without tests.

## Test-First Mandate

Agents MUST write tests before writing implementation code. The cycle is:

1. Write a failing test that captures the required behavior.
2. Confirm the test fails for the right reason.
3. Write the minimum implementation to make the test pass.
4. Confirm all tests pass.
5. Refactor. Confirm tests still pass.

Agents MUST NOT write implementation code for a new behavior without a corresponding failing test already in place.

## Iteration

Work proceeds in small iterations. Each iteration delivers a working, tested increment.

### Starting an iteration

- Confirm the task is understood. If it is not, ask.
- Identify the affected code.
- Identify existing tests that cover the area.
- Identify missing tests that will need to be written.

### During an iteration

- Make one logical change at a time.
- Keep diffs small and reviewable.
- Run the full test suite after each change.
- Do not proceed if tests are failing unless the failure is the expected red state of a new test.

### Ending an iteration

An iteration is complete when:

- All new behavior is covered by tests.
- All tests pass.
- The code has been refactored and is clean.
- No uncommented dead code has been introduced.

## Definition of Done

A task is done when:

- Tests exist for every new behavior.
- All tests pass.
- The build passes.
- No regressions have been introduced.
- The code meets the project coding standards.

## Branching

- All non-trivial work MUST be done on a feature branch.
- Branch names MUST be short and descriptive: `feature/add-payment-validation`.
- Agents MUST NOT commit directly to `main` or `master`.
- Branches MUST be merged only when the definition of done is satisfied.

## Commit discipline

- Each commit MUST represent one logical change.
- Commit messages MUST describe the *why*, not just the *what*.
- Agents MUST NOT commit failing tests.
- Agents MUST NOT commit code that does not compile.

## Refactoring

Refactoring MUST be done as a separate step from feature work.

- Confirm tests exist before refactoring.
- Make structural changes only: behavior MUST NOT change.
- Run tests after every refactoring step.
- If tests break during refactoring, stop and diagnose before continuing.

## Regression policy

If a change causes an existing test to fail:

- Stop immediately.
- Do not proceed with other changes.
- Diagnose and fix the regression before continuing.

## Agent rules

Agents MUST NOT:

- Skip the failing-test step and write implementation first.
- Merge a branch with failing tests.
- Commit directly to `main` or `master`.
- Suppress or delete tests to make a build pass.
- Mark a task done when tests are missing or failing.

Agents MUST ask before:

- Changing the branching strategy.
- Modifying CI pipeline configuration.
- Deleting existing tests.
