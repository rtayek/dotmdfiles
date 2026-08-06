> Purpose: Structural rules for any project.
> Scope: Layers and dependencies.

# Architecture

- Dependencies point downward only, layer to layer. No circular dependencies.
- Core knows nothing above it.
- Cross layers with simple, preferably immutable boundary data; don't leak
  infrastructure types upward.
- Put code in the lowest layer that can own it.
