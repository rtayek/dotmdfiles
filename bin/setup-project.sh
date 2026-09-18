#!/usr/bin/env bash
# setup-project.sh - install the shared discovery entry points and .llm context.
# Never overwrites a file that is already present.
#
# Usage:
#   setup-project.sh [target-dir] [software-file...]
#
# software-file names are looked up in the real/ directory first and then in this
# repository's software/ directory.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REAL="$PROJECT_ROOT/real"
SOFTWARE_DIR="$PROJECT_ROOT/software"

TARGET="${1:-.}"
if [ "$#" -gt 0 ]; then shift; fi

if [ ! -d "$REAL" ]; then
  echo "No $REAL - run dotmdfiles/bin/deploy.sh first." >&2
  exit 1
fi

mkdir -p "$TARGET"
cd "$TARGET"
mkdir -p .llm

place() {
  local name="$1" src="$2"
  if [ -e "$name" ] || [ -L "$name" ]; then
    echo "  skip $name (already exists)"
    return
  fi
  cp "$src" "$name"
  echo "  copied $name"
}

echo "Setting up $(pwd):"
place "CLAUDE.md" "$REAL/CLAUDE.md"
place "AGENTS.md" "$REAL/AGENTS.md"
place ".llm/index.md" "$REAL/index.md"
place ".llm/persona.md" "$REAL/persona.md"
place ".llm/human.md" "$REAL/human.md"

missing=0
for f in "$@"; do
  if [ -f "$REAL/$f" ]; then
    place ".llm/$f" "$REAL/$f"
  elif [ -f "$SOFTWARE_DIR/$f" ]; then
    place ".llm/$f" "$SOFTWARE_DIR/$f"
  else
    echo "  warning: $f not found in $REAL or $SOFTWARE_DIR, skipped" >&2
    missing=1
  fi
done

echo "Done."
if [ "$missing" -eq 1 ]; then
  exit 1
fi