#!/usr/bin/env bash
# setup-project.sh - install the shared discovery entry points and .llm context.
# Never overwrites a file that is already present.
#
# Usage:
#   setup-project.sh [target-dir] [software-file...]
#
# software-file names are looked up in ~/real-md-files first and then in this
# repository's software/ directory.

set -euo pipefail

REAL="$HOME/real-md-files"
SOFTWARE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/software"

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
  local name="$1" mode="$2" src="$3"
  if [ -e "$name" ] || [ -L "$name" ]; then
    echo "  skip $name (already exists)"
    return
  fi
  if [ "$mode" = copy ]; then
    cp "$src" "$name"
    echo "  copied $name"
  else
    ln -s "$src" "$name"
    echo "  linked $name -> $src"
  fi
}

echo "Setting up $(pwd):"
place "CLAUDE.md" copy "$REAL/CLAUDE.md"
place "AGENTS.md" link "$REAL/AGENTS.md"
place ".llm/index.md" copy "$REAL/index.md"
place ".llm/persona.md" link "$REAL/persona.md"
place ".llm/human.md" link "$REAL/human.md"

for f in "$@"; do
  if [ -f "$REAL/$f" ]; then
    place ".llm/$f" link "$REAL/$f"
  elif [ -f "$SOFTWARE_DIR/$f" ]; then
    place ".llm/$f" link "$SOFTWARE_DIR/$f"
  else
    echo "  warning: $f not found in $REAL or $SOFTWARE_DIR, skipped" >&2
  fi
done

echo "Done."
