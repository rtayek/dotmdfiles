#!/bin/sh
set -eu

base=${PWD##*/}
out="$HOME/outgoing/$base.tar"

tar -cf "$out" \
    handoffs \
    *.md

echo "Wrote $out"
