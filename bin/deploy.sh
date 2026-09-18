#!/usr/bin/env bash
# deploy.sh — copy the real .md files from this project's working copy
# (files/) to real/, the canonical source for copies installed in projects.
#
# Run this after editing anything in files/ and committing the change here,
# so the deployed copy stays in sync with what's checked into git.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$PROJECT_ROOT/files"
DEST="$PROJECT_ROOT/real"

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
