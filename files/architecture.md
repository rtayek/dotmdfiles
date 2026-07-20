> Purpose: Structural rules for any project.
> Scope: Layers and dependencies.

# Architecture

Layers, top to bottom: UI → Application → Core → Infrastructure.

- Dependencies point downward only: UI → Application → Core; Infrastructure → Core.
- Core knows nothing above it. No circular dependencies.
- Cross layers with simple, preferably immutable boundary data; don't leak
  infrastructure types upward.
- Put code in the lowest layer that can own it. No business logic in UI;
  no technical wiring in Core.
