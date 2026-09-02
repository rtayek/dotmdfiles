# Gradle Project Policy

## Purpose

This file defines the standard structure and agent rules for Gradle projects,
including Gradle projects edited in Eclipse.

It applies only when Gradle owns the build. It does not apply to a standalone
Eclipse project that has no Gradle build files or Gradle wrapper.

## Core Model

Keep these concepts separate:

```text
filesystem folder       = where the files actually live
Eclipse workspace       = Eclipse bookkeeping area
Eclipse project         = a folder Eclipse knows about
Gradle project          = a folder Gradle builds
Gradle source set       = build/test/runtime grouping
Eclipse source folder   = IDE compile/index folder
Eclipse working set     = visual grouping/filtering in Eclipse
```

The governing rule is:

```text
Gradle owns the build.
Eclipse owns the IDE view.
The filesystem owns the real project folder.
```

The Gradle wrapper is the authoritative build interface.

## Project and Workspace Locations

Gradle projects do not have to live inside the Eclipse workspace.

The Eclipse workspace primarily contains Eclipse metadata:

```text
~/eclipse-workspace/
  .metadata/
```

The real project can live elsewhere:

```text
~/projects/my-project/
  settings.gradle
  build.gradle
```

When importing an existing project into Eclipse, normally leave this option
unchecked:

```text
Copy projects into workspace
```

Copying the project can create two working copies and cause edits or builds to
operate on the wrong copy.

## Preferred Project Structure

Prefer:

```text
one Eclipse project = one Gradle project
```

Use a Gradle multi-project build only when the software genuinely requires
separate modules. Eclipse may display Gradle subprojects as separate top-level
projects.

For new Java projects, prefer the standard Gradle layout:

```text
my-project/
  settings.gradle
  build.gradle
  gradlew
  gradlew.bat
  gradle/
  src/main/java/
  src/main/resources/
  src/test/java/
  src/test/resources/
```

Older layouts can remain in use when Gradle configures them explicitly:

```text
src/
tst/
slow/
suites/
```

Do not reorganize an established project merely to make its directory names
look like a new Gradle project.

## Source Sets and Eclipse Source Folders

A Gradle source set is not the same thing as an Eclipse source folder.

```text
Gradle source set     = build, runtime, dependency, and test grouping
Eclipse source folder = IDE compilation and indexing folder
```

Gradle source sets can define:

- Source directories
- Compile and runtime classpaths
- Dependencies
- Output directories
- Test tasks

Eclipse source folders mainly tell Eclipse what to compile and index.

For Gradle projects:

```text
Let Gradle define the source sets.
Let Eclipse consume the Gradle model or generated Eclipse classpath.
Do not make Eclipse the authoritative build definition.
```

Example for an older layout:

```gradle
sourceSets {
    main {
        java.srcDirs = ['src']
    }

    test {
        java.srcDirs = ['tst']
    }
}
```

Extra test directories can initially share the test source set:

```gradle
sourceSets {
    test {
        java.srcDirs = ['tst', 'slow', 'suites']
    }
}
```

Create separate source sets only when the directories require different tasks,
dependencies, or classpaths.

## Eclipse Working Sets

Eclipse working sets are visual organization only. They do not affect:

- Gradle builds
- Dependencies
- Java versions
- Tests
- Git
- Source sets
- Classpaths

Use working sets for navigation, not architecture.

## Eclipse Metadata

For Gradle-first projects, do not commit these files by default:

```text
.project
.classpath
.settings/
```

Gradle is the source of truth, and the Eclipse metadata should be reproducible.

Commit Eclipse metadata only when the project is intentionally Eclipse-first or
contains necessary stable configuration that cannot be regenerated.

Recommended ignore rules:

```gitignore
# Gradle
.gradle/
/build/

# Eclipse generated output
/bin/

# Eclipse metadata for Gradle-first projects
.classpath
.project
.settings/
```

## Canonical Build Directory

The canonical Gradle build-output directory is:

```text
build/
```

Do not rename or redirect it merely because a tool or agent has difficulty
removing it.

Do not introduce these substitutes:

```text
.gradle-build/
.build/
out/
target/
```

Do not add or change either of these unless the user explicitly requests a
different build layout:

```gradle
layout.buildDirectory = file(".gradle-build")
buildDir = ".gradle-build"
```

The `.gradle/` directory is Gradle's local project state. It is not a substitute
for `build/`.

## Cleaning Generated Build Output

The normal cleanup operation is Gradle's existing `clean` task.

From Git Bash, Linux, macOS, or WSL:

```sh
./gradlew clean
```

From Windows Command Prompt:

```bat
gradlew.bat clean
```

From Windows PowerShell:

```powershell
.\gradlew.bat clean
```

Here, `gradlew` or `gradlew.bat` is the Gradle wrapper launcher and `clean` is
the Gradle task passed to it.

If files appear to be locked, terminate any application or test launched from
the project. Then stop the project's Gradle daemons and try again.

Git Bash, Linux, macOS, or WSL:

```sh
./gradlew --stop
./gradlew clean
```

Windows Command Prompt:

```bat
gradlew.bat --stop
gradlew.bat clean
```

Windows PowerShell:

```powershell
.\gradlew.bat --stop
.\gradlew.bat clean
```

Do not indiscriminately terminate all Java processes. Other Java projects or
applications may be running.

## Agent Authorization and Safety

The `build/` directory directly beneath a verified Gradle project root is
generated output and may be safely deleted.

An agent is authorized to remove that directory recursively only after all of
the following are true:

1. The project root has been resolved to an explicit path.
2. The project root contains `gradlew`, `gradlew.bat`, `build.gradle`,
   `build.gradle.kts`, `settings.gradle`, or `settings.gradle.kts`.
3. The deletion target is exactly `build/` directly beneath that root.
4. The target is not the project root, repository root, home directory, or an
   unresolved variable.
5. The normal Gradle `clean` operation has already been attempted or is
   unavailable.

An agent must not:

- Rename the build directory to avoid deleting it.
- Change the Gradle build layout as a cleanup workaround.
- Delete `.gradle/` when the request concerns only build output.
- Delete an unresolved, broad, or unrelated path.
- Kill unrelated Java or Gradle processes.
- Claim cleanup succeeded without checking the result.

If permissions or tool policy prohibit deletion, the agent must report:

- The exact command attempted
- The exact error
- The exact remaining path

The agent must then stop. It must not redesign the project to work around its
own permission restriction.

## Build Verification

Use the Gradle wrapper rather than an independently installed Gradle version.

Common verification commands are:

```sh
./gradlew test
./gradlew check
./gradlew clean check
```

Use the smallest command that verifies the requested work. Do not run an
expensive or unrelated build merely because it exists.

When Eclipse and Gradle disagree, first determine whether Gradle builds the
project successfully. Gradle is authoritative for a Gradle-first project.

## Practical Policy

For Gradle projects edited in Eclipse:

```text
Use the standard Gradle layout for new projects.
Use one Gradle project per Eclipse project when practical.
Let Gradle define source sets and dependencies.
Let Eclipse consume the Gradle model.
Do not copy imported projects into the workspace.
Use Eclipse working sets only for visual grouping.
Ignore build/, .gradle/, and bin/.
Ignore .project, .classpath, and .settings/ by default.
Keep Gradle build output in build/.
Use the Gradle wrapper's clean task for normal cleanup.
Never change the build layout to evade a cleanup failure.
```

## End-of-work cleanup

After completing and verifying changes in a Gradle project:

1. Record the test or build result.
2. Stop any application or test process started during the work.
3. Run:

```sh
./gradlew clean
```

4. Confirm that the project-root `build/` directory is gone.

If cleanup fails, run:

```sh
./gradlew --stop
./gradlew clean
```

If `build/` still remains, the agent is authorized to recursively delete only the exact `build/` directory directly beneath the verified Gradle project root.

Report any remaining path and the exact deletion error.

Do not rename or redirect Gradle’s build directory.
