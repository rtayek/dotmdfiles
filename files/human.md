> Purpose: Describe how the human thinks about software engineering so collaborators and AI assistants can work effectively with them.
> Scope: Engineering philosophy, coding preferences, and collaboration style.

# Human

## Identity

Has roughly six decades of software engineering experience across a variety of computers,
languages, and operating systems. The human has a poor memory.

## Engineering Philosophy

Write simple, deterministic, testable, modular software. Avoid large frameworks and dependency-heavy systems.

## Accessibility

- Low vision.
- Hard of hearing, even with hearing aids.
- Keep responses concise: avoid walls of text.
- Use short paragraphs and bullet points over long prose.
- Do not ask the human to read large blocks of output unless necessary.

## Scripts

- Use Bourne shell scripts or JShell scripts.
- Avoid PowerShell if practical.
- Avoid Python if practical.

## File encoding

- Use UTF-8 with line-feeds only.

## File and Variable Names

- Prefer lowercase names where practical.
- Use lowercase with dashes for filenames, directory names, and command names.
- In shell scripts, use lower camel case for local variables and custom environment variables.
- Avoid underscores in names we control.
- Preserve established external names such as `HOME`, `PATH`, and `JAVA_HOME`, and names required by tools or compatibility interfaces.
- Apply these conventions to new and substantially edited scripts; do not mechanically rename existing code solely for style.
- Use Unix-like folder names (e.g., `config/`, `tmp/`) where reasonable.
- In object-oriented languages, place fields at the bottom of the class.

## Documentation for Software

- Treat the code as the documentation.
- Treat the tests as the functional specification.
- Avoid comments in code and shell scripts. If a comment feels necessary, fix the naming or structure instead so the intent is self-evident.

## Software Tools and Languages

- Primary languages: Java, Groovy, C, C++.
- Primary build tools: Gradle, Make.
- Primary IDE: Eclipse.

## Development Approach and Defaults for Software

- Use Test-Driven Development (TDD) and Domain-Driven Design (DDD).
- Use User Acceptance Testing (UAT) strictly to validate the human experience, usability, and business value—not to find code bugs.
- Use an in-memory map of default values when starting a software project.
- Avoid properties files, configuration files, registries, environment variables, and external setup until strictly necessary.

## Accepting Artifacts

- Artifacts provided to the human must be directly placeable into the user's code project or Git repo, or be downloadable (preferring direct placement in the project/repo).
- Any handoff artifact must include '[Hh]andoff' in the filename.
