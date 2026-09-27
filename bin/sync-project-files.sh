#!/bin/sh
# Keep shared collaboration files synchronized across projects.
# AGENTS.md preserves each project's marked project-context block.
# All other project files, including other .llm content, are left unchanged.

set -eu

beginMarker='<!-- BEGIN PROJECT CONTEXT -->'
endMarker='<!-- END PROJECT CONTEXT -->'

usage() {
    cat <<'EOF'
Usage:
  sync-project-files.sh [--check] [PROJECT...]
  sync-project-files.sh --apply [PROJECT...]

--check  Report differences without changing anything. This is the default.
--apply  Synchronize the shared files into each project, then verify them.

AGENTS.md is synchronized specially: the shared portions come from the
canonical file while the target project's marked project-context block is
preserved exactly.

When no PROJECT is supplied, projects are read from the deployed System
registry through project-paths.sh.
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

scriptDir=$(CDPATH= cd "$(dirname "$0")" && pwd)
projectRoot=$(CDPATH= cd "$scriptDir/.." && pwd)
sourceDir=$projectRoot/real

for sourceName in CLAUDE.md AGENTS.md index.md human.md persona.md; do
    if [ ! -f "$sourceDir/$sourceName" ]; then
        echo "Missing shared source: $sourceDir/$sourceName" >&2
        exit 2
    fi
done

differences=0
tempFiles=''

cleanup() {
    oldIfs=$IFS
    IFS='
'
    for tempFile in $tempFiles; do
        [ -n "$tempFile" ] && rm -f "$tempFile"
    done
    IFS=$oldIfs
}
trap cleanup 0 1 2 15

newTempFile() {
    template=$1
    newTemp=$(mktemp "$template")
    if [ -n "$tempFiles" ]; then
        tempFiles="$tempFiles
$newTemp"
    else
        tempFiles=$newTemp
    fi
}

markerLine() {
    file=$1
    marker=$2
    awk -v marker="$marker" '$0 == marker { print NR }' "$file"
}

validateMarkers() {
    file=$1
    displayName=$2

    beginLines=$(markerLine "$file" "$beginMarker")
    endLines=$(markerLine "$file" "$endMarker")
    beginCount=$(printf '%s\n' "$beginLines" | awk 'NF { count++ } END { print count+0 }')
    endCount=$(printf '%s\n' "$endLines" | awk 'NF { count++ } END { print count+0 }')

    if [ "$beginCount" -ne 1 ] || [ "$endCount" -ne 1 ]; then
        echo "Invalid project-context markers in $displayName: expected exactly one begin marker and one end marker" >&2
        return 1
    fi

    beginLine=$beginLines
    endLine=$endLines
    if [ "$beginLine" -ge "$endLine" ]; then
        echo "Invalid project-context markers in $displayName: begin marker must precede end marker" >&2
        return 1
    fi
}

renderAgents() {
    sourceFile=$1
    targetFile=$2
    outputFile=$3

    validateMarkers "$sourceFile" "$sourceFile" || return 1
    validateMarkers "$targetFile" "$targetFile" || return 1

    awk -v beginMarker="$beginMarker" '
        { print }
        $0 == beginMarker { exit }
    ' "$sourceFile" > "$outputFile"

    awk -v beginMarker="$beginMarker" -v endMarker="$endMarker" '
        $0 == beginMarker { inside=1; next }
        $0 == endMarker { inside=0; exit }
        inside { print }
    ' "$targetFile" >> "$outputFile"

    awk -v endMarker="$endMarker" '
        $0 == endMarker { after=1 }
        after { print }
    ' "$sourceFile" >> "$outputFile"
}

syncFile() {
    sourceFile=$1
    targetFile=$2
    displayName=$3

    if [ ! -L "$targetFile" ] && [ -f "$targetFile" ] && cmp -s "$sourceFile" "$targetFile"; then
        echo "  same: $displayName"
        return
    fi

    differences=1
    if [ "$mode" = check ]; then
        if [ -L "$targetFile" ]; then
            echo "  symlink: $displayName"
        elif [ -e "$targetFile" ]; then
            echo "  differs: $displayName"
        else
            echo "  missing: $displayName"
        fi
        return
    fi

    if [ -d "$targetFile" ]; then
        echo "Managed file path is a directory: $targetFile" >&2
        exit 1
    fi
    if [ -L "$targetFile" ]; then
        rm "$targetFile"
    fi
    cp "$sourceFile" "$targetFile"
    if ! cmp -s "$sourceFile" "$targetFile"; then
        echo "Verification failed: $targetFile" >&2
        exit 1
    fi
    echo "  copied: $displayName"
}

syncAgents() {
    sourceFile=$1
    targetFile=$2
    displayName=$3

    validateMarkers "$sourceFile" "$sourceFile" || exit 2

    if [ ! -e "$targetFile" ] && [ ! -L "$targetFile" ]; then
        differences=1
        if [ "$mode" = check ]; then
            echo "  missing: $displayName"
            return
        fi
        cp "$sourceFile" "$targetFile"
        echo "  copied: $displayName"
        return
    fi

    if [ -d "$targetFile" ]; then
        echo "Managed file path is a directory: $targetFile" >&2
        exit 1
    fi
    if [ -L "$targetFile" ]; then
        echo "AGENTS.md must be an ordinary file before project context can be preserved: $targetFile" >&2
        exit 1
    fi

    validateMarkers "$targetFile" "$targetFile" || exit 1

    newTempFile "${TMPDIR:-/tmp}/sync-project-files.rendered.XXXXXX"
    renderedFile=$newTemp
    renderAgents "$sourceFile" "$targetFile" "$renderedFile" || exit 1

    if cmp -s "$renderedFile" "$targetFile"; then
        echo "  same: $displayName"
        return
    fi

    differences=1
    if [ "$mode" = check ]; then
        echo "  differs: $displayName"
        return
    fi

    newTempFile "$targetFile.tmp.XXXXXX"
    replacementFile=$newTemp
    cp -p "$targetFile" "$replacementFile"
    cat "$renderedFile" > "$replacementFile"

    validateMarkers "$replacementFile" "$replacementFile" || exit 1
    mv "$replacementFile" "$targetFile"

    if ! cmp -s "$renderedFile" "$targetFile"; then
        echo "Verification failed: $targetFile" >&2
        exit 1
    fi
    echo "  merged: $displayName"
}

preflightProject() {
    targetDir=$1
    targetAgents=$targetDir/AGENTS.md

    validateMarkers "$sourceDir/AGENTS.md" "$sourceDir/AGENTS.md" || exit 2

    if [ -e "$targetAgents" ] || [ -L "$targetAgents" ]; then
        if [ -L "$targetAgents" ]; then
            echo "AGENTS.md must be an ordinary file before project context can be preserved: $targetAgents" >&2
            exit 1
        fi
        if [ -d "$targetAgents" ]; then
            echo "Managed file path is a directory: $targetAgents" >&2
            exit 1
        fi
        validateMarkers "$targetAgents" "$targetAgents" || exit 1
    fi
}

syncProject() {
    targetDir=$1
    if [ ! -d "$targetDir" ]; then
        echo "Project directory does not exist: $targetDir" >&2
        exit 2
    fi

    preflightProject "$targetDir"

    echo "Project: $targetDir"

    if [ "$mode" = apply ]; then
        mkdir -p "$targetDir/.llm"
    fi

    syncAgents "$sourceDir/AGENTS.md" "$targetDir/AGENTS.md" "AGENTS.md"
    syncFile "$sourceDir/CLAUDE.md" "$targetDir/CLAUDE.md" "CLAUDE.md"
    syncFile "$sourceDir/index.md" "$targetDir/.llm/index.md" ".llm/index.md"
    syncFile "$sourceDir/human.md" "$targetDir/.llm/human.md" ".llm/human.md"
    syncFile "$sourceDir/persona.md" "$targetDir/.llm/persona.md" ".llm/persona.md"
}

if [ "$#" -gt 0 ]; then
    for targetDir do
        syncProject "$targetDir"
    done
else
    newTempFile "${TMPDIR:-/tmp}/sync-project-files.registry.XXXXXX"
    registryList=$newTemp

    if ! sh "$scriptDir/project-paths.sh" > "$registryList"; then
        exit 2
    fi

    while IFS= read -r targetDir || [ -n "$targetDir" ]; do
        syncProject "$targetDir"
    done < "$registryList"
fi

if [ "$mode" = check ] && [ "$differences" -ne 0 ]; then
    exit 1
fi
