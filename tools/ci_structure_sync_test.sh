#!/usr/bin/env bash
#
# Test suite for tools/ci_structure_sync.sh (S6-1 / #420 G2)
# Validates the structure regen gate: the generator renders the Project
# Structure tree from the live filesystem (Go packages + curated top-level
# dirs) and the gate fails when the README's marked region drifts.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYNC_SCRIPT="${SCRIPT_DIR}/ci_structure_sync.sh"

if [ ! -f "$SYNC_SCRIPT" ]; then
    echo "ERROR: structure sync script not found at $SYNC_SCRIPT"
    exit 1
fi

echo "==> Running Structure Sync Gate Test Suite..."

FAILURES=0
REPO="$SCRIPT_DIR/.."

run_test() {
    local desc="$1"
    local expect="$2" # pass | fail
    shift 2
    echo "Testing: $desc"
    local output=""
    local exit_code=0
    output=$("$@" 2>&1) || exit_code=$?
    if [ "$expect" = "pass" ] && [ "$exit_code" -ne 0 ]; then
        echo "  FAIL: expected pass, got exit $exit_code"
        echo "$output" | sed 's/^/    /'
        FAILURES=$((FAILURES + 1))
    elif [ "$expect" = "fail" ] && [ "$exit_code" -eq 0 ]; then
        echo "  FAIL: expected fail, got success"
        FAILURES=$((FAILURES + 1))
    else
        echo "  ok"
    fi
}

# --- fixture: a tiny fake module -----------------------------------------

FIXTURE_ROOT="$(mktemp -d)"
trap 'rm -rf "$FIXTURE_ROOT"' EXIT

mkdir -p "$FIXTURE_ROOT/internal/alpha" "$FIXTURE_ROOT/internal/beta" "$FIXTURE_ROOT/cmd/tool"
cat > "$FIXTURE_ROOT/go.mod" <<'EOF'
module example.com/fake

go 1.26
EOF
cat > "$FIXTURE_ROOT/internal/alpha/alpha.go" <<'EOF'
// Package alpha does the alpha thing.
package alpha
EOF
cat > "$FIXTURE_ROOT/internal/beta/beta.go" <<'EOF'
// Package beta: the beta worker.
package beta
EOF
cat > "$FIXTURE_ROOT/cmd/tool/main.go" <<'EOF'
package main

func main() {}
EOF

# A README with the markers, currently containing a stale tree.
render_readme() {
    local body="$1"
    cat > "$FIXTURE_ROOT/README.md" <<EOF
# Fake Repo

Some intro.

<!-- structure:start -->
$body
<!-- structure:end -->

Footer.
EOF
}

# --- tests ----------------------------------------------------------------

# 1. Clean render: a freshly generated region + no drift → gate passes.
render_readme "stale content that will be replaced"
"$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md" --render > /dev/null
render_readme "$(awk '/<!-- structure:start -->/{f=1;next}/<!-- structure:end -->/{f=0;next}f' "$FIXTURE_ROOT/README.md")"
run_desc="regen-idempotent region passes"
if output=$("$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md" 2>&1); then
    echo "Testing: $run_desc — ok"
else
    echo "Testing: $run_desc — FAIL"
    echo "$output" | sed 's/^/    /'
    FAILURES=$((FAILURES + 1))
fi

# 2. Hand-edited tree → drift → gate fails.
sed -i '' 's/does the alpha thing/DOES SOMETHING COMPLETELY DIFFERENT/' "$FIXTURE_ROOT/README.md"
run_test "hand-edited tree fails the regen-diff" fail \
    "$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md"

# 3. New package appears on disk → README (even pristine) is stale → fails
#    until regenerated.
render_readme "pristine regenerated region"
mkdir -p "$FIXTURE_ROOT/internal/gamma"
cat > "$FIXTURE_ROOT/internal/gamma/gamma.go" <<'EOF'
// Package gamma arrived after the last render.
package gamma
EOF
run_test "new package without regen fails" fail \
    "$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md"

# 4. Regenerating absorbs the new package → passes again.
"$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md" --render > /dev/null
run_test "regen absorbs new package" pass \
    "$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md"

# 5. Missing markers → gate fails with an actionable error.
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Fake Repo

No markers here at all.
EOF
run_test "missing markers fails" fail \
    "$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md"

# 6. Generated region carries the package doc summaries.
render_readme "placeholder replaced by --render"
"$SYNC_SCRIPT" --repo-root "$FIXTURE_ROOT" --readme "$FIXTURE_ROOT/README.md" --render > /dev/null
if grep -q "does the alpha thing" "$FIXTURE_ROOT/README.md" &&
   grep -q "the beta worker" "$FIXTURE_ROOT/README.md"; then
    echo "Testing: doc summaries rendered — ok"
else
    echo "Testing: doc summaries rendered — FAIL"
    FAILURES=$((FAILURES + 1))
fi

# 7. Non-Go repository (no go.mod) skips gracefully in gate mode.
NON_GO_ROOT="$(mktemp -d)"
cat > "$NON_GO_ROOT/README.md" <<'EOF'
# Non-Go Repo
EOF
run_test "non-Go repo without go.mod skips gracefully" pass \
    "$SYNC_SCRIPT" --repo-root "$NON_GO_ROOT" --readme "$NON_GO_ROOT/README.md"

# 8. Non-Go repository with docs/README.md enforces first-level docs/ taxonomy.
mkdir -p "$NON_GO_ROOT/docs/adr" "$NON_GO_ROOT/docs/openspec"
cat > "$NON_GO_ROOT/docs/README.md" <<'EOF'
# Docs Index
- `adr/` — Architecture decisions
- `openspec/` — Living capability specs
EOF
run_test "non-Go repo with complete docs/README.md passes" pass \
    "$SYNC_SCRIPT" --repo-root "$NON_GO_ROOT" --readme "$NON_GO_ROOT/README.md"

mkdir -p "$NON_GO_ROOT/docs/undocumented_lane"
run_test "non-Go repo with undocumented docs/ subdir fails" fail \
    "$SYNC_SCRIPT" --repo-root "$NON_GO_ROOT" --readme "$NON_GO_ROOT/README.md"
rm -rf "$NON_GO_ROOT"

# 9. Non-Go polyglot repo with package.json + src/ subdirs passes when README.md documents them.
POLYGLOT_ROOT="$(mktemp -d)"
mkdir -p "$POLYGLOT_ROOT/src/engine" "$POLYGLOT_ROOT/src/security"
cat > "$POLYGLOT_ROOT/package.json" <<'EOF'
{
  "name": "fake-polyglot",
  "version": "1.0.0"
}
EOF
cat > "$POLYGLOT_ROOT/README.md" <<'EOF'
# Polyglot Repo

Modules:
- `engine`: core runtime
- `security`: boundaries and checks
EOF
run_test "polyglot repo with documented src/ subdirs passes" pass \
    "$SYNC_SCRIPT" --repo-root "$POLYGLOT_ROOT" --readme "$POLYGLOT_ROOT/README.md"

# 10. Non-Go polyglot repo fails when an undocumented src/ directory is added.
mkdir -p "$POLYGLOT_ROOT/src/undocumented_mod"
run_test "polyglot repo with undocumented src/ subdir fails" fail \
    "$SYNC_SCRIPT" --repo-root "$POLYGLOT_ROOT" --readme "$POLYGLOT_ROOT/README.md"
rm -rf "$POLYGLOT_ROOT"

if [ "$FAILURES" -gt 0 ]; then
    echo ""
    echo "STRUCTURE SYNC GATE TEST SUITE: $FAILURES failure(s)."
    exit 1
fi
echo ""
echo "STRUCTURE SYNC GATE TEST SUITE: all tests passed."

