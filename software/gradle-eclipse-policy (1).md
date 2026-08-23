# Gradle Projects with Eclipse

## Core model

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

Main rule:

```text
Gradle owns the build.
Eclipse owns the IDE view.
The filesystem owns the real project folder.
```

## Eclipse workspace versus project folder

Eclipse projects and Gradle projects can live anywhere on disk. They do not
have to live inside the Eclipse workspace.

The Eclipse workspace is mostly for Eclipse metadata:

```text
~/eclipse-workspace/
  .metadata/
```

Project folders can live elsewhere:

```text
~/projects/my-project/
  build.gradle
  settings.gradle
```

When importing into Eclipse, normally leave this option unchecked:

```text
Copy projects into workspace
```

Otherwise Eclipse may duplicate the project folder and create two working
copies.

## Preferred Gradle and Eclipse structure

Prefer:

```text
one Eclipse project = one Gradle project
```

Avoid Gradle multi-project builds unless there is a strong reason to use one.
Eclipse may display their subprojects as separate top-level projects, adding
clutter.

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

Older Eclipse-style layouts can still work:

```text
src/
tst/
slow/
suites/
```

Gradle must be configured explicitly for a nonstandard layout.

## Source sets versus Eclipse source folders

Gradle source sets and Eclipse source folders are similar but not identical:

```text
Gradle source set     = build/runtime/test bucket
Eclipse source folder = IDE compile/index folder
```

Gradle source sets can define compile and runtime classpaths, output
directories, dependencies, and test tasks. Eclipse source folders mainly tell
Eclipse which folders contain source code to index and compile.

For Gradle projects:

```text
Let Gradle define source sets.
Let Gradle generate the Eclipse classpath and project model.
Avoid manually maintaining Eclipse source folders unless necessary.
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

For additional test folders, start simply:

```gradle
sourceSets {
    main {
        java.srcDirs = ['src']
    }

    test {
        java.srcDirs = ['tst', 'slow', 'suites']
    }
}
```

Create separate Gradle source sets for `slow` and `suites` only if they truly
need separate tasks or classpaths.

## Eclipse working sets

Working sets are only visual organization in Eclipse. They do not affect
Gradle builds, dependencies, Java versions, tests, Git, source sets, or
classpath behavior.

Useful working sets might include:

```text
Active Java
Old Java
Python
Dotfiles / Shell
Docs / Notes
Experiments
```

Rule:

```text
Use working sets for navigation, not architecture.
```

## Eclipse metadata in Git

For Gradle-first projects, the default is not to commit:

```text
.project
.classpath
.settings/
```

Gradle is the real build model, and Eclipse metadata should be reproducible
from it. Commit Eclipse metadata only when a project is intentionally
Eclipse-first or contains stable configuration that Gradle cannot regenerate.

Suggested ignore rules:

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

## Canonical build directory

Use Gradle's standard build-output directory:

```text
build/
```

Do not redirect Gradle output to `.gradle-build/`, `.build/`, `out/`, or
`target/` unless the project has an explicit external requirement.

If an agent cannot clean `build/`, it must not solve that problem by changing
the build directory.

## Cleaning build output

Normally use Gradle's own cleanup task:

```sh
./gradlew clean
```

From Git Bash on Windows, the wrapper batch file may also be used:

```sh
./gradlew.bat clean
```

If Windows reports that files are in use:

1. Terminate running applications and tests in Eclipse.
2. Stop Gradle daemons.
3. Run the cleanup again.

```sh
./gradlew --stop
./gradlew clean
```

If the user can clean the directory from a normal shell but an agent cannot,
the likely cause is the agent's permission or safety policy rather than
Gradle. The agent should report the restriction instead of changing the build
layout.

If this remains a recurring agent problem, use the guarded project cleanup
script below. It gives agents one explicit, reviewable command and restricts
direct deletion to this project's exact `build/` directory.

## Optional cleanup script

A project may provide `scripts/clean-build.sh`:

```sh
#!/bin/sh

set -eu

projectRoot=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)

case "$projectRoot" in
    ""|/)
        echo "error: unsafe project root: $projectRoot" >&2
        exit 1
        ;;
esac

cd "$projectRoot"

if [ ! -f gradlew ] || \
   { [ ! -f build.gradle ] && [ ! -f build.gradle.kts ]; }; then
    echo "error: not a Gradle project: $projectRoot" >&2
    exit 1
fi

if ! sh ./gradlew clean; then
    echo "Gradle clean failed; stopping Gradle daemons and retrying." >&2
    sh ./gradlew --stop || true
    sh ./gradlew clean || true
fi

buildPath="$projectRoot/build"

if [ -e "$buildPath" ] || [ -L "$buildPath" ]; then
    echo "Gradle left build/ behind; removing the validated build path." >&2
    rm -rf -- "$buildPath"
fi

if [ -e "$buildPath" ] || [ -L "$buildPath" ]; then
    echo "error: could not remove $buildPath" >&2
    exit 1
fi

echo "Gradle build output cleaned."
```

Run it with:

```sh
sh scripts/clean-build.sh
```

The script uses Gradle first. Its direct-deletion fallback operates only on the
validated project root's exact `build/` path. It never changes Gradle's build
directory.

## Agent rules

Add the following policy to `AGENTS.md`, `PROJECT_RULES.md`, or the equivalent
agent-instruction file:

````markdown
## Gradle cleanup

This is a Gradle-first project. The canonical build-output directory is
`build/`.

If this project contains `scripts/clean-build.sh`, remove generated build
output with:

```sh
sh scripts/clean-build.sh
```

Otherwise run:

```sh
./gradlew clean
```

If files are in use, terminate the running application or test and then run:

```sh
./gradlew --stop
./gradlew clean
```

Do not rename or redirect the Gradle build directory.

Do not add or change:

```gradle
layout.buildDirectory = file(".gradle-build")
buildDir = ".gradle-build"
```

Do not substitute `.gradle-build/`, `.build/`, `out/`, or `target/` for
`build/`.

If Gradle cannot clean `build/`, report the exact error and stop. Do not change
the Gradle build layout. Do not improvise another recursive-deletion command;
use the guarded project script when it is available.
````

## Practical policy

```text
Use the standard Gradle layout for new projects.
Use one Gradle project per Eclipse project.
Let Gradle define source sets.
Let Gradle generate the Eclipse classpath and project model.
Do not copy projects into the Eclipse workspace.
Use Eclipse working sets only for visual grouping.
Ignore build/, .gradle/, and bin/.
Ignore .project, .classpath, and .settings/ by default.
Keep Gradle build output in build/.
Clean with ./gradlew clean or the guarded project cleanup script.
If cleanup fails, report the error instead of changing the build layout.
```

## Follow-up work

- Find Gradle projects that redirect output to a nonstandard build directory
  and restore `build/`.
- Find repeated rules across project `.gitignore` files and move appropriate
  machine-wide rules into the global Git ignore file.
- Add the cleanup and agent policies to the Gradle project template.
