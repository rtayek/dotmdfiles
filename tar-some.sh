#!/bin/sh
set -eu

base=${PWD##*/}
out="$HOME/outgoing/$base.tar"

mkdir -p "$HOME/outgoing"

tar -cf "$out" \
    .llm/handoffs \
    *.md

echo "Wrote $out"
