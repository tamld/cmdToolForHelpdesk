#!/usr/bin/env bash
#
# ci_spec_code_sync.sh — G1 gate (S6-1, #420, ADR-0024 Layer 1)
#
# Every scenario in an APPLIED/ACCEPTED OpenSpec delta that carries a
# `<!-- tests: Name1, Name2 -->` pin must map to existing Go tests
# (`func Name(` somewhere under --go-root). `process-enforced` pins are
# exempt (the promise is a process, not a test). Unpinned scenarios in
# CHANGED enforced files fail the gate; unpinned scenarios in untouched
# files are grandfathered with a warning (ratchet: completeness tightens
# as deltas are touched).
#
# Usage:
#   ci_spec_code_sync.sh [--spec-root spec/openspec] [--go-root .]
#                        [--changed-files <newline-list-file>]
#
# CHANGED_FILES env: newline-separated file list; defaults to
# `git diff --name-only <merge-base>...HEAD` when run in a git repo.

set -euo pipefail

SPEC_ROOT="spec/openspec"
GO_ROOT="."
CHANGED_FILES="${CHANGED_FILES:-}"

while [ $# -gt 0 ]; do
    case "$1" in
        --spec-root) SPEC_ROOT="$2"; shift 2 ;;
        --go-root) GO_ROOT="$2"; shift 2 ;;
        --changed-files) CHANGED_FILES="$2"; shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 2 ;;
    esac
done

if [ -z "$CHANGED_FILES" ] && git rev-parse --git-dir >/dev/null 2>&1; then
    BASE=$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main 2>/dev/null || echo "")
    if [ -n "$BASE" ]; then
        CHANGED_FILES=$(git diff --name-only "$BASE" 2>/dev/null || true)
    fi
fi

if [ "$SPEC_ROOT" = "spec/openspec" ] && [ ! -d "$SPEC_ROOT" ] && [ -d "$GO_ROOT/docs/openspec/specs" ]; then
    SPEC_ROOT="$GO_ROOT/docs/openspec/specs"
fi

FAIL=0
WARN=0

for spec in "$SPEC_ROOT"/*.md "$SPEC_ROOT"/*/*.md "$GO_ROOT/spec/domains"/*/*.md; do
    [ -e "$spec" ] || continue
    status=$(grep -m1 -E '^(\* )?\*\*Status\*\*:' "$spec" || true)
    enforced=0
    case "$status" in
        *APPLIED*|*ACCEPTED*|*Applied*|*Accepted*) enforced=1 ;;
    esac
    case "$spec" in
        */spec/domains/*/*.md) enforced=1 ;;
    esac

    # Boundary 1 (#679): Verify domain_href bidirectional anchor lineage (E_BROKEN_SPEC_LINEAGE).
    domain_href=$(grep -m1 -E '^[-*] \*\*domain_href\*\*:' "$spec" | sed -E 's/.*`([^`]+)`.*/\1/' || true)
    spec_id=$(grep -m1 -E '^[-*] \*\*Specification ID\*\*:' "$spec" | sed -E 's/.*`([^`]+)`.*/\1/' || true)
    if [ -n "$domain_href" ]; then
        target_file="${domain_href%%#*}"
        target_anchor="${domain_href#*#}"
        if [ ! -f "$GO_ROOT/$target_file" ]; then
            echo "::error::E_BROKEN_SPEC_LINEAGE: $spec references missing domain spec '$target_file'"
            FAIL=$((FAIL + 1))
        elif [ "$target_anchor" != "$domain_href" ] && ! grep -qF "{#$target_anchor}" "$GO_ROOT/$target_file"; then
            echo "::error::E_BROKEN_SPEC_LINEAGE: $spec references missing anchor '#$target_anchor' in '$target_file'"
            FAIL=$((FAIL + 1))
        elif [ "$enforced" -eq 1 ] && [ -n "$spec_id" ] && ! grep -qE "inherited-from:.*$spec_id" "$GO_ROOT/$target_file"; then
            echo "::error::E_BROKEN_SPEC_LINEAGE: $target_file is missing reciprocal 'inherited-from: ... $spec_id' for enforced delta $spec"
            FAIL=$((FAIL + 1))
        fi
    fi

    changed=0
    if [ -n "$CHANGED_FILES" ] && printf '%s\n' "$CHANGED_FILES" | grep -qxF "$spec"; then
        changed=1
    fi

    # Emit one record per scenario: start-line ::: title ::: pin
    records=$(awk '
        /^#### Scenario:/ {
            if (title != "") print start ":::" title ":::" pin
            sub(/^#### Scenario: */, "")
            title = $0; pin = ""; start = NR
            next
        }
        title != "" && /<!-- *tests *:/ && pin == "" {
            line = $0
            sub(/.*<!-- *tests *:/, "", line)
            sub(/-->.*$/, "", line)
            gsub(/^[ \t]+|[ \t]+$/, "", line)
            pin = line
        }
        END { if (title != "") print start ":::" title ":::" pin }
    ' "$spec")

    [ -n "$records" ] || continue

    while IFS= read -r record; do
        [ -n "$record" ] || continue
        line_no=$(printf '%s' "$record" | cut -d: -f1)
        title=$(printf '%s' "$record" | cut -d: -f2- | sed 's/:::[^:]*$//')
        pin=$(printf '%s' "$record" | awk -F':::' '{print $NF}')

        if [ -z "$pin" ]; then
            # Pinning is required only for enforced deltas; a Proposed delta
            # with an unpinned scenario is a draft, not a broken promise.
            if [ "$enforced" -eq 1 ] && [ "$changed" -eq 1 ]; then
                echo "::error::spec-code sync: $spec:$line_no scenario \"$title\" is not pinned — add '<!-- tests: TestX -->' or '<!-- tests: process-enforced -->' (#420 G1)"
                FAIL=$((FAIL + 1))
            else
                echo "  [grandfathered] $spec:$line_no scenario \"$title\" unpinned (will be required when the delta is enforced + touched)"
                WARN=$((WARN + 1))
            fi
            continue
        fi

        [ "$pin" = "process-enforced" ] && continue

        IFS=',' read -r -a names <<< "$pin"
        for name in ${names[@]}; do
            name=$(echo "$name" | tr -d ' ')
            [ -n "$name" ] || continue
            pin_found=0
            if [ -x "./bin/g8s" ] && ./bin/g8s search -q -F "func ${name}(" -g '*.go' "$GO_ROOT" 2>/dev/null; then
                pin_found=1
            elif command -v rg >/dev/null 2>&1; then
                if rg -q -F "func ${name}(" -g '*.go' "$GO_ROOT" 2>/dev/null; then
                    pin_found=1
                elif rg -q -E "(fn ${name}\\s*\\(|def ${name}\\s*\\(|(test|it|describe)\\s*\\(['\"]${name}['\"]|${name}\\s*\\(\\s*\\))" "$GO_ROOT" 2>/dev/null; then
                    pin_found=1
                elif [ -f "$GO_ROOT/$name" ] || [ -f "$GO_ROOT/tests/$name" ]; then
                    pin_found=1
                elif [ -d "$GO_ROOT/tests" ] && rg --files -g "**/$name" -g "$name" "$GO_ROOT/tests" 2>/dev/null | grep -q .; then
                    pin_found=1
                fi
            else
                if grep -rqF "func ${name}(" "$GO_ROOT" --include='*.go' 2>/dev/null; then
                    pin_found=1
                elif grep -rqE "(fn ${name}[[:space:]]*\\(|def ${name}[[:space:]]*\\(|(test|it|describe)[[:space:]]*\\(['\"]${name}['\"]|${name}[[:space:]]*\\(\\))" "$GO_ROOT" 2>/dev/null; then
                    pin_found=1
                elif [ -f "$GO_ROOT/$name" ] || [ -f "$GO_ROOT/tests/$name" ]; then
                    pin_found=1
                elif [ -d "$GO_ROOT/tests" ] && find "$GO_ROOT/tests" -name "$name" 2>/dev/null | grep -q .; then
                    pin_found=1
                fi
            fi
            if [ "$pin_found" -eq 0 ]; then
                echo "::error::spec-code sync: $spec:$line_no scenario \"$title\" pins test \"$name\" which does not exist under $GO_ROOT (#420 G1)"
                FAIL=$((FAIL + 1))
            fi
        done
    done <<< "$records"
done

if [ "$FAIL" -gt 0 ]; then
    echo ""
    echo "SPEC-CODE SYNC GATE: $FAIL violation(s), $WARN grandfathered warning(s)."
    exit 1
fi
echo "SPEC-CODE SYNC GATE: OK ($WARN grandfathered warning(s))."
