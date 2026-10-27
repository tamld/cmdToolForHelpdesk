#!/usr/bin/env bash
#
# ci_structure_sync.sh — G2 gate (S6-1, #420, ADR-0024 Layer 1)
#
# Renders the Project Structure tree from the live filesystem (Go package
# dirs + their doc comments, plus a curated static list of non-Go dirs)
# into the README's `<!-- structure:start -->` ... `<!-- structure:end -->`
# region. Gate mode fails when the committed region drifts from a fresh
# render — hand-edits and new packages without regen are both caught.
#
# Usage:
#   ci_structure_sync.sh [--repo-root .] [--readme README.md] [--render]

set -euo pipefail

MODE="gate"
REPO_ROOT="."
README="README.md"

while [ $# -gt 0 ]; do
    case "$1" in
        --repo-root) REPO_ROOT="$2"; shift 2 ;;
        --readme) README="$2"; shift 2 ;;
        --render) MODE="render"; shift ;;
        *) echo "unknown argument: $1" >&2; exit 2 ;;
    esac
done
cd "$REPO_ROOT"
export LC_ALL=C # byte-determinism: identical string ops on every platform

START_MARKER="<!-- structure:start -->"
END_MARKER="<!-- structure:end -->"

# Static curated entries for non-Go directories (label column). Skipped
# when the directory does not exist on disk.
static_entry() {
    case "$1" in
        cmd) echo "├── cmd/g8s/                # CLI entrypoint (stdlib flag-based, no cobra)" ;;
        offer_go) echo "├── offer.go                # root package: go:embed glue for the offer/ bundle + spec-sync gate scripts" ;;
        assets) echo "├── assets/                 # Logo and release artwork" ;;
        skills) echo "├── skills/                 # Vendored agent skills (g8s-supervisor charter + manifest)" ;;
        packaging) echo "├── packaging/              # Windows NSIS/WiX, Chocolatey, winget" ;;
        docs) echo "├── docs/                   # User guide, ADRs, specs, security, history" ;;
        examples) echo "├── examples/               # Contributor brief template" ;;
        offer) echo "├── offer/                  # Pull-bundle for sibling projects (profiles, onboarding, seeds)" ;;
        plans) echo "├── plans/                  # Campaign ledgers (dated, session-type marked)" ;;
        reference) echo "├── reference/              # JIT-only Python baseline (read, never import)" ;;
        spec) echo "├── spec/openspec/          # OpenSpec deltas (DELTA-01..25)" ;;
        schemas) echo "├── schemas/                # JSON schemas (task, receipt, result)" ;;
        scripts) echo "├── scripts/                # Public installer (scripts/install.sh curl entrypoint)" ;;
        tools) echo "├── tools/                  # CI helper scripts (pre-push gates, SAST, release)" ;;
        g8s_dir) echo "├── .g8s/                   # Declarative governance registries (models, effort, lanes, trust)" ;;
        semgrep) echo "├── .semgrep/               # Offline AST security & explicit-error rules (g8s-rules.yml)" ;;
        workflows) echo "└── .github/workflows/      # CI/CD pipelines (ci, quality, codeql, govulncheck, fuzz, release)" ;;
        *) return 1 ;;
    esac
}

# doc_summary extracts the one-line package summary from the source files
# of a package directory: the first `// Package <name>` line, stripped of
# the prefix and separators, terminated at the first sentence period.
# Byte-deterministic across platforms: LC_ALL=C, POSIX [[:space:]] classes
# only (never \s — BSD and GNU sed disagree), no length-based truncation
# (the #419 CI drift was a BSD-vs-GNU \s mismatch producing an extra space).
doc_summary() {
    local dir="$1" pkg="$2"
    local line
    line=$(awk -v pkg="$pkg" '
        $0 ~ "^// Package " pkg "([^[:alnum:]]|$)" {
            in_doc = 1
            sub("^// Package " pkg "[[:space:]:—-]*", "", $0)
            buf = $0
            next
        }
        in_doc {
            if ($0 ~ "^//[[:space:]]*$") { exit }
            if ($0 ~ "^//") {
                sub("^//[[:space:]]*", "", $0)
                buf = buf " " $0
            } else {
                exit
            }
        }
        END {
            gsub(/[[:space:]]+/, " ", buf)
            if (match(buf, /\.[[:space:]]/)) {
                buf = substr(buf, 1, RSTART - 1)
            } else {
                sub(/\.[[:space:]]*$/, "", buf)
            }
            print buf
        }
    ' "$dir"/*.go 2>/dev/null || true)
    [ -n "$(printf '%s' "$line" | tr -d '[:space:]')" ] && printf '%s\n' "$line" || echo "(no package doc — add one)"
}

render() {
    echo '```'
    echo "g8s/"
    echo "├── cmd/g8s/                # CLI entrypoint (stdlib flag-based, no cobra)"
    echo "├── internal/               # All packages (private, not importable)"
    for dir in $(go list ./... 2>/dev/null | grep '/internal/' | sed 's|.*/internal/||; s|/.*||' | sort -u); do
        summary=$(doc_summary "internal/$dir" "$dir")
        echo "│   ├── $dir/ — $summary"
    done
    echo "│   └── ...                 # supporting packages"
    static_entry offer_go
    for entry in assets offer docs examples packaging plans reference schemas scripts skills spec tools g8s_dir semgrep workflows; do
        case "$entry" in
            g8s_dir) [ -d ".g8s" ] && static_entry g8s_dir ;;
            semgrep) [ -d ".semgrep" ] && static_entry semgrep ;;
            workflows) [ -d ".github/workflows" ] && static_entry workflows ;;
            *) [ -d "$entry" ] && static_entry "$entry" ;;
        esac
    done
    echo '```'
}

if [ "$MODE" = "render" ]; then
    if ! grep -q "$START_MARKER" "$README" || ! grep -q "$END_MARKER" "$README"; then
        echo "::error::structure sync: $README is missing the $START_MARKER / $END_MARKER markers" >&2
        exit 1
    fi
    body=$(render)
    export STRUCTURE_BODY="$body"
    awk -v start="$START_MARKER" -v end="$END_MARKER" '
        BEGIN { body = ENVIRON["STRUCTURE_BODY"] }
        $0 == start { print; print body; printing = 1; next }
        $0 == end { printing = 0 }
        printing != 1 { print }
    ' "$README" > "$README.new"
    mv "$README.new" "$README"
    echo "STRUCTURE SYNC: rendered fresh tree into $README."
    exit 0
fi

# --- gate mode -------------------------------------------------------------
if [ ! -f "go.mod" ]; then
    missing=0
    checked_any=0
    if [ -f "docs/README.md" ]; then
        checked_any=1
        for d in docs/*/; do
            [ -d "$d" ] || continue
            sub=$(basename "$d")
            if ! grep -qF "$sub" "docs/README.md"; then
                echo "::error::structure sync: docs/$sub/ is not documented in docs/README.md (#420 G2)"
                missing=$((missing + 1))
            fi
        done
    fi
    if [ -d "src" ] || [ -d "rust" ]; then
        if [ -f "package.json" ] || [ -f "Cargo.toml" ] || [ -f "dist-workspace.toml" ]; then
            if [ -d "src" ]; then
                for d in src/*/; do
                    [ -d "$d" ] || continue
                    sub=$(basename "$d")
                    checked_any=1
                    found=0
                    for doc in "$README" "AGENTS.md" "docs/README.md"; do
                        if [ -f "$doc" ] && grep -qF "$sub" "$doc"; then
                            found=1
                            break
                        fi
                    done
                    if [ "$found" -eq 0 ]; then
                        echo "::error::structure sync: src/$sub/ is not documented in $README or AGENTS.md (#420 G2)"
                        missing=$((missing + 1))
                    fi
                done
            fi
            if [ -d "rust" ]; then
                for d in rust/*/; do
                    [ -d "$d" ] || continue
                    sub=$(basename "$d")
                    checked_any=1
                    found=0
                    for doc in "$README" "AGENTS.md" "docs/README.md"; do
                        if [ -f "$doc" ] && grep -qF "$sub" "$doc"; then
                            found=1
                            break
                        fi
                    done
                    if [ "$found" -eq 0 ]; then
                        echo "::error::structure sync: rust/$sub/ is not documented in $README or AGENTS.md (#420 G2)"
                        missing=$((missing + 1))
                    fi
                done
            fi
        fi
    fi
    if [ "$missing" -gt 0 ]; then
        echo "STRUCTURE SYNC GATE: $missing undocumented subdirectory(ies)."
        exit 1
    fi
    if [ "$checked_any" -eq 1 ]; then
        echo "STRUCTURE SYNC GATE: OK — polyglot structure verified."
        exit 0
    fi
    echo "STRUCTURE SYNC GATE: SKIP — no go.mod found (Go-project structure gate)."
    exit 0
fi
if ! grep -q "$START_MARKER" "$README" || ! grep -q "$END_MARKER" "$README"; then
    echo "::error::structure sync: $README is missing the $START_MARKER / $END_MARKER markers (#420 G2)"
    exit 1
fi

current=$(awk -v start="$START_MARKER" -v end="$END_MARKER" '
    $0 == start { printing = 1; next }
    $0 == end { printing = 0 }
    printing == 1 { print }
' "$README")
fresh=$(render)

if [ "$current" != "$fresh" ]; then
    echo "::error::structure sync: README Project Structure drifted from the live filesystem (#420 G2) — run: tools/ci_structure_sync.sh --render"
    echo "--- committed region ---"
    echo "$current"
    echo "--- fresh render ---"
    echo "$fresh"
    exit 1
fi
echo "STRUCTURE SYNC GATE: OK — README tree matches the filesystem."
