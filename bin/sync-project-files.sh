#!/bin/sh
# Keep the five shared collaboration files identical in one or more projects.
# All other project files, including other .llm content, are left unchanged.

set -eu

usage() {
    cat <<'EOF'
Usage:
  sync-project-files.sh [--check] [PROJECT...]
  sync-project-files.sh --apply [PROJECT...]

--check  Report differences without changing anything. This is the default.
--apply  Copy the five shared files into each project, then verify them.

When no PROJECT is supplied, projects are read from projects.txt through
project-paths.sh.
EOF
}

mode=check
case "${1:-}" in
    --check)
        shift
        ;;
    --apply)
        mode=apply
        shift
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    --*)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 2
        ;;
esac

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
project_root=$(CDPATH= cd "$script_dir/.." && pwd)
source_dir=$project_root/real

for source_name in CLAUDE.md AGENTS.md index.md human.md persona.md; do
    if [ ! -f "$source_dir/$source_name" ]; then
        echo "Missing shared source: $source_dir/$source_name" >&2
        exit 2
    fi
done

differences=0

sync_file() {
    source_file=$1
    target_file=$2
    display_name=$3

    if [ ! -L "$target_file" ] && [ -f "$target_file" ] && cmp -s "$source_file" "$target_file"; then
        echo "  same: $display_name"
        return
    fi

    differences=1
    if [ "$mode" = check ]; then
        if [ -L "$target_file" ]; then
            echo "  symlink: $display_name"
        elif [ -e "$target_file" ]; then
            echo "  differs: $display_name"
        else
            echo "  missing: $display_name"
        fi
        return
    fi

    if [ -d "$target_file" ]; then
        echo "Managed file path is a directory: $target_file" >&2
        exit 1
    fi
    if [ -L "$target_file" ]; then
        rm "$target_file"
    fi
    cp "$source_file" "$target_file"
    if ! cmp -s "$source_file" "$target_file"; then
        echo "Verification failed: $target_file" >&2
        exit 1
    fi
    echo "  copied: $display_name"
}

sync_project() {
    target_dir=$1
    if [ ! -d "$target_dir" ]; then
        echo "Project directory does not exist: $target_dir" >&2
        exit 2
    fi

    echo "Project: $target_dir"

    if [ "$mode" = apply ]; then
        mkdir -p "$target_dir/.llm"
    fi

    sync_file "$source_dir/CLAUDE.md" "$target_dir/CLAUDE.md" "CLAUDE.md"
    sync_file "$source_dir/AGENTS.md" "$target_dir/AGENTS.md" "AGENTS.md"
    sync_file "$source_dir/index.md" "$target_dir/.llm/index.md" ".llm/index.md"
    sync_file "$source_dir/human.md" "$target_dir/.llm/human.md" ".llm/human.md"
    sync_file "$source_dir/persona.md" "$target_dir/.llm/persona.md" ".llm/persona.md"
}

if [ "$#" -gt 0 ]; then
    for target_dir do
        sync_project "$target_dir"
    done
else
    registry_list=$(mktemp "${TMPDIR:-/tmp}/sync-project-files.XXXXXX")
    cleanup() {
        rm -f "$registry_list"
    }
    trap cleanup 0 1 2 15

    if ! sh "$script_dir/project-paths.sh" > "$registry_list"; then
        exit 2
    fi

    while IFS= read -r target_dir || [ -n "$target_dir" ]; do
        sync_project "$target_dir"
    done < "$registry_list"
fi

if [ "$mode" = check ] && [ "$differences" -ne 0 ]; then
    exit 1
fi
