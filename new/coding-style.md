> Purpose: Defines code conventions.
> Scope: Naming, layout, formatting.
> See also: design.md, workflow.md

# Coding Style

## Principles

- clarity over cleverness
- small functions
- meaningful names

## Naming

| Element | Style |
|--------|------|
| Types | PascalCase |
| Methods | camelCase |
| Variables | camelCase |
| Enum values | camelCase |

## Comments

Comments must add information not obvious from code.

Dead code should be deleted rather than commented out.

## Agent rules

Agents must ask before:

- refactoring
- changing public APIs or interfaces
- widening the access modifier of internal methods or classes

Agents MUST NOT:

- delete code without explaining why
