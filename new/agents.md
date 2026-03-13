
> Purpose: Defines what AI agents may do freely, must ask before doing, and must never do.
> Scope: Agent behavior and permissions only.
> See also: persona.md, workflow.md, project.md

# Agents

## Status
Normative.

## Behavior

Agents SHOULD:

- make small, reversible changes
- ask when intent is unclear
- explain non-obvious changes

Agents MUST NOT:

- change architecture without discussion

## Approval required

Agents must ask before:

- renaming or moving files
- adding dependencies
