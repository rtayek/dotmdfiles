#!/usr/bin/env bash
# deploy.sh — copy the real .md files from this project's working copy
# (files/) to ~/real-md-files, the canonical location that other projects'
# CLAUDE.md imports and AGENTS.md/persona.md/human.md symlinks point at.
#
# Run this after editing anything in files/ and committing the change here,
# so the deployed copy stays in sync with what's checked into git.

set -euo pipefail

SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/files"
DEST="$HOME/real-md-files"

if [ ! -d "$SOURCE" ]; then
  echo "No source directory at $SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST"

shopt -s nullglob
files=("$SOURCE"/*.md)

if [ ${#files[@]} -eq 0 ]; then
  echo "No .md files found in $SOURCE." >&2
  exit 0
fi

for f in "${files[@]}"; do
  name=$(basename "$f")
  echo "Deploying $name -> $DEST/$name"
  cp "$f" "$DEST/$name"
done

echo "Done."
