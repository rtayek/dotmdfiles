#!/bin/sh

set -eu

usage() {
    cat <<'EOF'
Usage:
  project-paths.sh [--paths]
  project-paths.sh --names

--paths  Print verified full project paths. This is the default.
--names  Print project names after verifying their directories.

Environment:
  projectsFile  Registry file. Defaults to ~/.config/ray/projects.tsv.
  projectsRoot  Base for relative paths. Defaults to ~/eclipse-workspace.
  PROJECTS_FILE and PROJECTS_ROOT are accepted during migration.
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

projectsFile=${projectsFile:-${PROJECTS_FILE:-"$HOME/.config/ray/projects.tsv"}}
projectsRoot=${projectsRoot:-${PROJECTS_ROOT:-"$HOME/eclipse-workspace"}}

[ -f "$projectsFile" ] || {
    echo "Project registry does not exist: $projectsFile" >&2
    exit 2
}

[ -d "$projectsRoot" ] || {
    echo "Projects root does not exist: $projectsRoot" >&2
    exit 2
}

tab=$(printf '\t')
awk -F "$tab" 'NR > 1 { print $1 "|" $2 }' "$projectsFile" |
(
    missing=0
    while IFS='|' read -r projectName projectValue; do
        if [ -z "$projectName" ] || [ -z "$projectValue" ]; then
            echo "Invalid project registry entry: $projectName|$projectValue" >&2
            missing=1
            continue
        fi

        case "$projectValue" in
            "~")
                projectPath=$HOME
                ;;
            "~/"*)
                projectPath=$HOME/${projectValue#??}
                ;;
            /*)
                projectPath=$projectValue
                ;;
            *)
                projectPath=$projectsRoot/$projectValue
                ;;
        esac

        if [ ! -d "$projectPath" ]; then
            echo "Project directory does not exist: $projectPath" >&2
            missing=1
            continue
        fi

        if [ "$mode" = names ]; then
            printf '%s\n' "$projectName"
        else
            (CDPATH= cd "$projectPath" && pwd)
        fi
    done
    exit "$missing"
)
