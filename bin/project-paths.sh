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
  PROJECTS_ROOT  Base for relative paths. Defaults to the parent directory of
                 the dotmdfiles checkout.
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
while IFS= read -r registry_line || [ -n "$registry_line" ]; do
    case "$registry_line" in
        ""|\#*)
            continue
            ;;
    esac

    case "$registry_line" in
        *\|*)
            old_ifs=$IFS
            IFS='|'
            read -r project_name project_value ignored_fields <<EOF
$registry_line
EOF
            IFS=$old_ifs
            ;;
        *)
            project_name=$registry_line
            project_value=$registry_line
            ;;
    esac

    if [ -z "$project_name" ] || [ -z "$project_value" ]; then
        echo "Invalid project registry entry: $registry_line" >&2
        missing=1
        continue
    fi

    case "$project_value" in
        "~")
            project_path=$HOME
            ;;
        "~/"*)
            project_path=$HOME/${project_value#??}
            ;;
        /*)
            project_path=$project_value
            ;;
        *)
            project_path=$projects_root/$project_value
            ;;
    esac

    if [ ! -d "$project_path" ]; then
        echo "Project directory does not exist: $project_path" >&2
        missing=1
        continue
    fi

    if [ "$mode" = names ]; then
        printf '%s\n' "$project_name"
    else
        (CDPATH= cd "$project_path" && pwd)
    fi
done < "$projects_file"

if [ "$missing" -ne 0 ]; then
    exit 1
fi
