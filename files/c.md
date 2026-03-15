> Purpose: C and C++ coding style rules.
> Scope: C and C++ conventions.

# C / C++

- `camelCase` for functions and variables.
- `static` on all functions not part of a public API.
- Explicit `void` parameter list in C: `int foo(void)`.
- Inline assembly only where strictly necessary; isolate it in small helpers.
- No global mutable state.
