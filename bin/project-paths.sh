#!/bin/sh
# Read the shared project registry and print project names or full paths.

set -eu

usage() {
    cat <<'EOF'
Usage:
  project-paths.sh [--paths]
  project-paths.sh --names

--paths  Print verified full project paths. This is the default.
--names  Print the registry entries after verifying their directories.

Environment:
  PROJECTS_FILE  Registry file. Defaults to dotmdfiles/projects.txt.
  PROJECTS_ROOT  Directory containing the projects. Defaults to the parent
                 directory of the dotmdfiles checkout.
EOF
}

mode=paths
case "${1:-}" in
    ""|--paths)
        ;;
    --names)
        mode=names
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 2
        ;;
esac

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
dotmdfiles_root=$(CDPATH= cd "$script_dir/.." && pwd)
projects_file=${PROJECTS_FILE:-$dotmdfiles_root/projects.txt}
projects_root=${PROJECTS_ROOT:-$(dirname "$dotmdfiles_root")}

if [ ! -f "$projects_file" ]; then
    echo "Project registry does not exist: $projects_file" >&2
    exit 2
fi

if [ ! -d "$projects_root" ]; then
    echo "Projects root does not exist: $projects_root" >&2
    exit 2
fi

missing=0
while IFS= read -r entry || [ -n "$entry" ]; do
    case "$entry" in
        ""|\#*)
            continue
            ;;
        /*)
            project_path=$entry
            ;;
        *)
            project_path=$projects_root/$entry
            ;;
    esac

    if [ ! -d "$project_path" ]; then
        echo "Project directory does not exist: $project_path" >&2
        missing=1
        continue
    fi

    if [ "$mode" = names ]; then
        printf '%s\n' "$entry"
    else
        (CDPATH= cd "$project_path" && pwd)
    fi
done < "$projects_file"

if [ "$missing" -ne 0 ]; then
    exit 1
fi
