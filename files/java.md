> Purpose: Java-specific coding style rules.
> Scope: Java 25+ features and idioms.

# Java

- Take full advantage of Java 25 features.
- Prefer **records** for immutable value types.
- Use **sealed hierarchies** for closed sets of types; avoid inheritance when modeling a tagged union: prefer a sealed interface + records.
- Use **switch expressions** (not switch statements) for exhaustive dispatch.
- Use `var` for local variables when the type is obvious from context.
- Return `Optional<T>` instead of `null` from public methods.
- Keep mutation methods package-private when they are only for internal use.
- No raw types; always parameterize generics.
