#!/usr/bin/env bash
# setup-project.sh — wire a project up to the real .md files in
# ~/real-md-files: one real CLAUDE.md, plus symlinks for AGENTS.md,
# persona.md, and human.md. Never overwrites a file that's already there.
#
# Usage:
#   setup-project.sh [target-dir] [software-file...]
#
#   target-dir     Defaults to the current directory. Created if missing.
#   software-file  Optional names of software/*.md files to also symlink,
#                  e.g. coding-style.md design.md architecture.md sdlc.md
#                  java.md. Looked up in ~/real-md-files first, falling
#                  back to this repo's software/ folder.
#
# Examples:
#   setup-project.sh
#   setup-project.sh ~/eclipse-workspace/my-new-thing
#   setup-project.sh ~/eclipse-workspace/my-new-thing coding-style.md design.md java.md

set -euo pipefail

REAL="$HOME/real-md-files"
SOFTWARE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/software"

TARGET="${1:-.}"
if [ "$#" -gt 0 ]; then shift; fi

if [ ! -d "$REAL" ]; then
  echo "No $REAL — run dotmdfiles/bin/deploy.sh first." >&2
  exit 1
fi

mkdir -p "$TARGET"
cd "$TARGET"

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
place "AGENTS.md" link "$REAL/agents.md"
place "persona.md" link "$REAL/persona.md"
place "human.md" link "$REAL/human.md"

for f in "$@"; do
  if [ -f "$REAL/$f" ]; then
    place "$f" link "$REAL/$f"
  elif [ -f "$SOFTWARE_DIR/$f" ]; then
    place "$f" link "$SOFTWARE_DIR/$f"
  else
    echo "  warning: $f not found in $REAL or $SOFTWARE_DIR, skipped" >&2
  fi
done

echo "Done."
