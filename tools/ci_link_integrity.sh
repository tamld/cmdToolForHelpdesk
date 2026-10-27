#!/usr/bin/env bash
#
# ci_link_integrity.sh — G3 gate (S6-2, #420, ADR-0024 Layer 1, #435)
#
# Scans configured content roots (default: README.md + docs/**/*.md)
# for markdown links `[text](target)`.
# ONLY relative targets are checked (resolved against the markdown file's own directory).
# External links (http/https), mailto:, and #anchor-only links are skipped.
# Any dead target causes an exit code 1 listing every dead link (file:line).
# Clean runs exit 0.
#
# Usage:
#   ci_link_integrity.sh [--root <dir>] [--content-root <path>...]
#
# Environment variables:
#   LINK_INTEGRITY_ROOTS  Colon-separated list of directories/files relative to $ROOT_DIR.
#

set -euo pipefail

ROOT_DIR="."
CLI_ROOTS=()
ROOT_FLAG_ARGS=()
HAS_EXPLICIT_ROOT_DIR=0
HAS_CLI_CONTENT_ROOTS=0

while [ $# -gt 0 ]; do
    case "$1" in
        --root-dir|--repo)
            if [ $# -lt 2 ]; then
                echo "error: $1 requires a directory argument" >&2
                exit 2
            fi
            ROOT_DIR="$2"
            HAS_EXPLICIT_ROOT_DIR=1
            shift 2
            ;;
        --content-root|--scan-root)
            if [ $# -lt 2 ]; then
                echo "error: $1 requires an argument" >&2
                exit 2
            fi
            CLI_ROOTS+=("$2")
            HAS_CLI_CONTENT_ROOTS=1
            shift 2
            ;;
        --root)
            if [ $# -lt 2 ]; then
                echo "error: --root requires a directory argument" >&2
                exit 2
            fi
            ROOT_FLAG_ARGS+=("$2")
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--root <dir>] [--content-root <path>]"
            exit 0
            ;;
        *)
            echo "unknown argument: $1" >&2
            exit 2
            ;;
    esac
done

if [ "$HAS_EXPLICIT_ROOT_DIR" -eq 1 ]; then
    for r in ${ROOT_FLAG_ARGS[@]+"${ROOT_FLAG_ARGS[@]}"}; do
        CLI_ROOTS+=("$r")
        HAS_CLI_CONTENT_ROOTS=1
    done
elif [ "$HAS_CLI_CONTENT_ROOTS" -eq 1 ]; then
    if [ ${#ROOT_FLAG_ARGS[@]} -gt 0 ]; then
        ROOT_DIR="${ROOT_FLAG_ARGS[0]}"
        for r in "${ROOT_FLAG_ARGS[@]:1}"; do
            CLI_ROOTS+=("$r")
        done
    fi
else
    if [ ${#ROOT_FLAG_ARGS[@]} -eq 1 ]; then
        ROOT_DIR="${ROOT_FLAG_ARGS[0]}"
    elif [ ${#ROOT_FLAG_ARGS[@]} -gt 1 ]; then
        first="${ROOT_FLAG_ARGS[0]}"
        if [[ "$first" = /* ]] || [ -f "$first/README.md" ] || [ -d "$first/docs" ]; then
            ROOT_DIR="$first"
            for r in "${ROOT_FLAG_ARGS[@]:1}"; do
                CLI_ROOTS+=("$r")
                HAS_CLI_CONTENT_ROOTS=1
            done
        else
            for r in ${ROOT_FLAG_ARGS[@]+"${ROOT_FLAG_ARGS[@]}"}; do
                CLI_ROOTS+=("$r")
                HAS_CLI_CONTENT_ROOTS=1
            done
        fi
    fi
fi

ROOT_LIST=()
ROOTS_EXPLICIT=0

if [ "$HAS_CLI_CONTENT_ROOTS" -eq 1 ]; then
    ROOT_LIST=("${CLI_ROOTS[@]}")
    ROOTS_EXPLICIT=1
elif [ -n "${LINK_INTEGRITY_ROOTS:-}" ]; then
    IFS=':' read -ra raw_roots <<< "$LINK_INTEGRITY_ROOTS"
    for r in ${raw_roots[@]+"${raw_roots[@]}"}; do
        [ -n "$r" ] && ROOT_LIST+=("$r")
    done
    ROOTS_EXPLICIT=1
else
    ROOT_LIST=("README.md" "docs")
    ROOTS_EXPLICIT=0
fi

export LC_ALL=C
ROOT_DIR="${ROOT_DIR%/}"
[ -z "$ROOT_DIR" ] && ROOT_DIR="."

format_roots() {
    local out=""
    for r in "$@"; do
        if [ -z "$out" ]; then
            out="$r"
        else
            out="$out, $r"
        fi
    done
    echo "$out"
}

FILES=()

if [ "$ROOTS_EXPLICIT" -eq 0 ]; then
    if [ -f "$ROOT_DIR/README.md" ]; then
        FILES+=("$ROOT_DIR/README.md")
    fi
    if [ -d "$ROOT_DIR/docs" ]; then
        while IFS= read -r f; do
            [ -n "$f" ] && FILES+=("$f")
        done < <(find "$ROOT_DIR/docs" -type f -name "*.md" | sort)
    fi

    if [ ${#FILES[@]} -eq 0 ]; then
        echo "LINK INTEGRITY GATE: No markdown files found under $ROOT_DIR."
        exit 0
    fi
else
    DISCOVERED=()
    for r in "${ROOT_LIST[@]}"; do
        if [[ "$r" = /* ]]; then
            target="$r"
        else
            target="$ROOT_DIR/$r"
        fi

        if [ -f "$target" ]; then
            DISCOVERED+=("$target")
        elif [ -d "$target" ]; then
            while IFS= read -r f; do
                [ -n "$f" ] && DISCOVERED+=("$f")
            done < <(find "$target" -type f -name "*.md" | sort)
        fi
    done

    if [ ${#DISCOVERED[@]} -gt 0 ]; then
        while IFS= read -r f; do
            [ -n "$f" ] && FILES+=("$f")
        done < <(printf '%s\n' "${DISCOVERED[@]}" | sort -u)
    fi

    if [ ${#FILES[@]} -eq 0 ]; then
        ROOTS_DISPLAY="$(format_roots "${ROOT_LIST[@]}")"
        echo "LINK INTEGRITY GATE: NOT EVALUATED: no markdown files found under configured root(s): $ROOTS_DISPLAY"
        exit 2
    fi
fi

FAIL=0
CHECKED=0

while IFS=$'\t' read -r file line_no raw_target path_part; do
    [ -n "$file" ] || continue
    CHECKED=$((CHECKED + 1))

    # Resolve target path
    case "$path_part" in
        /*)
            resolved="$ROOT_DIR/${path_part#/}"
            ;;
        *)
            file_dir="$(dirname "$file")"
            resolved="$file_dir/$path_part"
            ;;
    esac

    if [ ! -e "$resolved" ]; then
        echo "::error::link integrity: $file:$line_no dead relative link -> '$raw_target' (resolved: $resolved)"
        FAIL=$((FAIL + 1))
    fi
done < <(awk '
FNR == 1 {
    in_code_block = 0
}
{
    line = $0

    # Handle fenced code blocks (``` or ~~~)
    if (line ~ /^[[:space:]]*(```|~~~)/) {
        in_code_block = !in_code_block
        next
    }
    if (in_code_block) {
        next
    }

    # Strip inline code spans to avoid false positives inside backticks
    gsub(/`[^`]+`/, "", line)

    while (match(line, /\]\([^)]+\)/)) {
        m = substr(line, RSTART, RLENGTH)
        line = substr(line, RSTART + RLENGTH)

        # Strip leading ]( and trailing )
        sub(/^\]\(/, "", m)
        sub(/\)$/, "", m)

        # Trim leading and trailing whitespace
        sub(/^[[:space:]]+/, "", m)
        sub(/[[:space:]]+$/, "", m)

        # Strip optional title (e.g. "title" or '\''title'\'')
        sub(/[[:space:]]+["'\''].*$/, "", m)

        # Strip enclosing < >
        if (m ~ /^<.*>$/) {
            sub(/^</, "", m)
            sub(/>$/, "", m)
        }

        # Skip empty, http(s)://, mailto:, #anchor-only, or URI schemes
        if (m == "" || m ~ /^(https?:\/\/|mailto:|#|[a-zA-Z][a-zA-Z0-9+.-]*:\/\/)/) {
            continue
        }

        # Extract file path part (strip fragment and query parameters)
        path_part = m
        sub(/#.*$/, "", path_part)
        sub(/\?.*$/, "", path_part)

        if (path_part == "") {
            continue
        }

        # Decode URL-encoded spaces (%20)
        gsub(/%20/, " ", path_part)

        printf "%s\t%d\t%s\t%s\n", FILENAME, FNR, m, path_part
    }
}
' "${FILES[@]}")

ROOTS_DISPLAY="$(format_roots "${ROOT_LIST[@]}")"

if [ "$FAIL" -gt 0 ]; then
    echo ""
    echo "LINK INTEGRITY GATE: $FAIL dead link(s) found across ${#FILES[@]} file(s) ($CHECKED relative link(s) examined; roots: $ROOTS_DISPLAY)."
    exit 1
fi

echo "LINK INTEGRITY GATE: OK ($CHECKED relative link(s) verified across ${#FILES[@]} file(s); roots: $ROOTS_DISPLAY)."
exit 0
