#!/bin/sh

set -eu

beginMarker='<!-- BEGIN PROJECT CONTEXT -->'
endMarker='<!-- END PROJECT CONTEXT -->'

scriptDir=$(CDPATH= cd "$(dirname "$0")" && pwd)
projectRoot=$(CDPATH= cd "$scriptDir/.." && pwd)
tempRoot=$(mktemp -d "${TMPDIR:-/tmp}/sync-project-files-test.XXXXXX")
trap 'rm -rf "$tempRoot"' 0 1 2 15

testRepo=$tempRoot/repo
testProject=$tempRoot/project
mkdir -p "$testRepo/bin" "$testRepo/real" "$testProject/.llm"
cp "$scriptDir/sync-project-files.sh" "$testRepo/bin/"
cp "$projectRoot/real/AGENTS.md" "$testRepo/real/AGENTS.md"
cp "$projectRoot/real/CLAUDE.md" "$testRepo/real/CLAUDE.md"
canonicalBackup=$tempRoot/canonical-AGENTS.md
cp "$testRepo/real/AGENTS.md" "$canonicalBackup"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

resetProject() {
    rm -rf "$testProject"
    mkdir -p "$testProject/.llm"
    cp "$testRepo/real/CLAUDE.md" "$testProject/CLAUDE.md"
    printf 'legacy-index\n' > "$testProject/.llm/index.md"
    printf 'legacy-human\n' > "$testProject/.llm/human.md"
    printf 'legacy-persona\n' > "$testProject/.llm/persona.md"
}

assertLegacyUntouched() {
    [ "$(cat "$testProject/.llm/index.md")" = legacy-index ] || fail 'index.md was modified'
    [ "$(cat "$testProject/.llm/human.md")" = legacy-human ] || fail 'human.md was modified'
    [ "$(cat "$testProject/.llm/persona.md")" = legacy-persona ] || fail 'persona.md was modified'
}

writeCustomAgents() {
    sourceFile=$1
    outputFile=$2
    awk -v beginMarker="$beginMarker" -v endMarker="$endMarker" '
        $0 == beginMarker {
            print
            print ""
            print "## Project Requirements"
            print ""
            print "CUSTOM-PROJECT-CONTEXT"
            inside=1
            next
        }
        $0 == endMarker {
            inside=0
            print
            next
        }
        !inside { print }
    ' "$sourceFile" > "$outputFile"
}

expectFailureUnchanged() {
    label=$1
    beforeFile=$2
    if sh "$testRepo/bin/sync-project-files.sh" --apply "$testProject" >/dev/null 2>&1; then
        fail "$label unexpectedly succeeded"
    fi
    cmp -s "$beforeFile" "$testProject/AGENTS.md" || fail "$label changed AGENTS.md after validation failure"
    assertLegacyUntouched
    echo "PASS: $label"
}

cp "$canonicalBackup" "$testRepo/real/AGENTS.md"
resetProject
writeCustomAgents "$canonicalBackup" "$testProject/AGENTS.md"
{
    echo 'STALE-SHARED-CONTENT'
    cat "$testProject/AGENTS.md"
} > "$tempRoot/stale"
mv "$tempRoot/stale" "$testProject/AGENTS.md"
sh "$testRepo/bin/sync-project-files.sh" --apply "$testProject" >/dev/null
grep -Fx 'CUSTOM-PROJECT-CONTEXT' "$testProject/AGENTS.md" >/dev/null || fail 'project context was not preserved'
firstLine=$(sed -n '1p' "$testProject/AGENTS.md")
[ "$firstLine" = '# Agent Instructions' ] || fail 'shared content was not replaced'
assertLegacyUntouched
sh "$testRepo/bin/sync-project-files.sh" --check "$testProject" >/dev/null || fail 'check failed after successful synchronization'
echo 'PASS: valid synchronization preserves project context and ignores legacy .llm files'

resetProject
grep -Fvx "$beginMarker" "$canonicalBackup" > "$testProject/AGENTS.md"
cp "$testProject/AGENTS.md" "$tempRoot/before"
expectFailureUnchanged 'missing begin marker' "$tempRoot/before"

resetProject
awk -v marker="$beginMarker" '{ print; if ($0 == marker) print }' "$canonicalBackup" > "$testProject/AGENTS.md"
cp "$testProject/AGENTS.md" "$tempRoot/before"
expectFailureUnchanged 'duplicate begin marker' "$tempRoot/before"

resetProject
awk -v marker="$endMarker" '{ print; if ($0 == marker) print }' "$canonicalBackup" > "$testProject/AGENTS.md"
cp "$testProject/AGENTS.md" "$tempRoot/before"
expectFailureUnchanged 'duplicate end marker' "$tempRoot/before"

resetProject
cat > "$testProject/AGENTS.md" <<EOF
# Invalid Agent Instructions

$endMarker
project context
$beginMarker
EOF
cp "$testProject/AGENTS.md" "$tempRoot/before"
expectFailureUnchanged 'reversed markers' "$tempRoot/before"

cp "$canonicalBackup" "$testRepo/real/AGENTS.md"
resetProject
writeCustomAgents "$canonicalBackup" "$testProject/AGENTS.md"
cp "$testProject/AGENTS.md" "$tempRoot/before"
grep -Fvx "$endMarker" "$canonicalBackup" > "$testRepo/real/AGENTS.md"
expectFailureUnchanged 'invalid canonical markers' "$tempRoot/before"

echo 'PASS: all sync-project-files tests'
