> Purpose: Describe how the human thinks about software engineering so collaborators and AI assistants can work effectively with them.
> Scope: Engineering philosophy, coding preferences, and collaboration style.

# Human

## Identity

Has roughly six decades of software engineering experience across a variety of computers,
languages, and operating systems. The human has a poor memory.

## Engineering Philosophy

Prefers simple, deterministic, testable, modular software; skeptical of large
frameworks and dependency-heavy systems.

## Accessibility

- Low vision.
- Hard of hearing, even with hearing aids.
- Keep responses concise: avoid walls of text.
- Prefer short paragraphs and bullet points over long prose.
- Do not ask the human to read large blocks of output unless necessary.

## Text and File Encoding

All text intended for the user to copy—including prose, code, shell
commands, scripts, configuration, Markdown, handoffs, patches, and
generated files—must use UTF-8 encoding with LF line endings only.

- Do not include a Byte Order Mark (BOM).
- Avoid carriage returns (CR / CRLF).
- Do not use emojis.
- Avoid decorative or invisible Unicode characters, control characters, ANSI escapes, and nonbreaking spaces.
- Despite a background in prestige quality printing and an appreciation for fine typography, avoid typographic embellishments (such as em dashes, smart quotes, or special font glyphs) in copyable artifacts to ensure reliable cross-platform copying and pasting.

## Scripts

- Prefers Bourne shell scripts or JShell scripts.
- Avoids PowerShell if practical.
- Dislikes Python; avoid it entirely if possible.

## File Names, Variable Names, and Structure

- Avoid the '_' character in names; use '-' or camelCase instead.
- Prefers Unix-style directory names (e.g., config/, tmp/).
- In object-oriented classes, place fields at the bottom of the class rather than the top.

## Documentation and Comments

- The code is the documentation; the tests are the functional specification.
- Avoid comments in code and shell scripts. If a comment feels necessary, fix the naming or structure instead so the intent is self-evident.

## Software Tools and Languages

- Primary languages: Java, Groovy, C, C++.
- Primary build tools: Gradle, Make.
- Primary IDE: Eclipse.

## Development Approach and Defaults

- Employs Test-Driven Development (TDD) and Domain-Driven Design (DDD).
- Use an in-memory map of default values when starting a software project.
- Avoid properties files, configuration files, registries, environment variables, and external setup until strictly necessary.

## Accepting Artifacts

- Artifacts provided to the human must be directly placeable into the user's code project or Git repo, or be downloadable (preferring direct placement in the project/repo).
- Any handoff artifact must include '[Hh]andoff' in the filename.