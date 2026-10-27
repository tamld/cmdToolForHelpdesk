#!/usr/bin/env bash
#
# Test suite for tools/ci_spec_code_sync.sh (S6-1 / #420 G1)
# Validates the spec↔code sync gate: every scenario in an APPLIED/ACCEPTED
# delta that carries a tests-comment must map to existing Go tests; changed
# deltas must pin every scenario; process-enforced scenarios are exempt.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE_SCRIPT="${SCRIPT_DIR}/ci_spec_code_sync.sh"

if [ ! -f "$GATE_SCRIPT" ]; then
    echo "ERROR: spec-code-sync gate script not found at $GATE_SCRIPT"
    exit 1
fi

echo "==> Running Spec-Code Sync Gate Test Suite..."

FAILURES=0

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

# --- fixture: a fake spec tree -------------------------------------------

FIXTURE_ROOT="$(mktemp -d)"
trap 'rm -rf "$FIXTURE_ROOT"' EXIT
SPEC_DIR="$FIXTURE_ROOT/spec/openspec"
mkdir -p "$SPEC_DIR/internal"

# Enforced delta, scenario pinned to an existing test.
cat > "$SPEC_DIR/09-worker-supervisor-spec.md" <<'EOF'
---
**Status**: `APPLIED`

#### Scenario: pinned happy path
<!-- tests: TestSweepAttemptGroupCleanExitNoop -->
- the pinned scenario body.

#### Scenario: pinned with two tests
<!-- tests: TestSweepAttemptGroupKillsSameGroupGrandchild, TestSweepAttemptGroupCleanExitNoop -->
- two-test pinning body.

#### Scenario: process enforced only
<!-- tests: process-enforced -->
- doctrine changes go through ADR amendments.
EOF

# Enforced delta whose scenario is NOT pinned — fails only when the file is
# in the changed set.
cat > "$SPEC_DIR/22-brief-dor-floor-spec.md" <<'EOF'
---
**Status**: `APPLIED`

#### Scenario: unpinned scenario in changed file
- nobody declared the tests for this one.
EOF

# Non-enforced delta (Proposed) — never fails the gate.
cat > "$SPEC_DIR/99-draft-spec.md" <<'EOF'
---
**Status**: `Proposed`

#### Scenario: draft scenario without pinning
- proposals are not promises yet.
EOF

# A real test the fixtures can point at (in the repo the script greps *.go).
TEST_ANCHOR="$FIXTURE_ROOT/internal/sweep_test.go"
mkdir -p "$(dirname "$TEST_ANCHOR")"
cat > "$TEST_ANCHOR" <<'EOF'
package internal

import "testing"

func TestSweepAttemptGroupCleanExitNoop(t *testing.T) {}

func TestSweepAttemptGroupKillsSameGroupGrandchild(t *testing.T) {}
EOF

# --- tests -----------------------------------------------------------------

# 1. All files grandfathered (not changed): unpinned scenario warns only.
run_test "grandfathered unpinned scenario passes" pass \
    "$GATE_SCRIPT" --spec-root "$SPEC_DIR" --go-root "$FIXTURE_ROOT"

# 2. Changed enforced file with an unpinned scenario → fail.
run_test "changed unpinned scenario fails" fail \
    "$GATE_SCRIPT" --spec-root "$SPEC_DIR" --go-root "$FIXTURE_ROOT" \
    --changed-files "$SPEC_DIR/22-brief-dor-floor-spec.md"

# 3. Pinned scenario whose test does not exist → fail (regardless of change).
cat > "$SPEC_DIR/22-brief-dor-floor-spec.md" <<'EOF'
---
**Status**: `APPLIED`

#### Scenario: pinned to a ghost test
<!-- tests: TestThisTestDoesNotExistAnywhere -->
- phantom pinning.
EOF
run_test "ghost test pin fails" fail \
    "$GATE_SCRIPT" --spec-root "$SPEC_DIR" --go-root "$FIXTURE_ROOT"

# 4. Pinned scenario with a bad tests comment (no comment at all in changed file) → covered by (2).
# 5. process-enforced is exempt from existence check.
cat > "$SPEC_DIR/22-brief-dor-floor-spec.md" <<'EOF'
---
**Status**: `APPLIED`

#### Scenario: doctrine only
<!-- tests: process-enforced -->
- no Go test exists for this and that is fine.
EOF
run_test "process-enforced exempt passes" pass \
    "$GATE_SCRIPT" --spec-root "$SPEC_DIR" --go-root "$FIXTURE_ROOT" \
    --changed-files "$SPEC_DIR/22-brief-dor-floor-spec.md"

# 6. Proposed deltas never fail even when changed and unpinned.
cat > "$SPEC_DIR/99-draft-spec.md" <<'EOF'
---
**Status**: `Proposed`

#### Scenario: draft unpinned
- drafts are drafts.
EOF
run_test "proposed delta exempt passes" pass \
    "$GATE_SCRIPT" --spec-root "$SPEC_DIR" --go-root "$FIXTURE_ROOT" \
    --changed-files "$SPEC_DIR/99-draft-spec.md"

# 7. A pinned scenario in a PROPOSED delta with a ghost test still fails
#    (pinning is a promise the moment you write it).
cat > "$SPEC_DIR/99-draft-spec.md" <<'EOF'
---
**Status**: `Proposed`

#### Scenario: draft with ghost pin
<!-- tests: TestGhostPinNope -->
- pinning a draft is still a promise.
EOF
run_test "ghost pin in proposed delta fails" fail \
    "$GATE_SCRIPT" --spec-root "$SPEC_DIR" --go-root "$FIXTURE_ROOT" \
    --changed-files "$SPEC_DIR/99-draft-spec.md"

# 8. Polyglot test-file pin (e.g. tests/api.test.js) resolves cleanly.
mkdir -p "$FIXTURE_ROOT/tests"
echo "// js test" > "$FIXTURE_ROOT/tests/api.test.js"
cat > "$SPEC_DIR/99-draft-spec.md" <<'EOF'
---
**Status**: `APPLIED`

#### Scenario: polyglot js test file pin
<!-- tests: api.test.js -->
- resolves to tests/api.test.js on disk.
EOF
run_test "polyglot test-file pin passes" pass \
    "$GATE_SCRIPT" --spec-root "$SPEC_DIR" --go-root "$FIXTURE_ROOT" \
    --changed-files "$SPEC_DIR/99-draft-spec.md"

if [ "$FAILURES" -gt 0 ]; then
    echo ""
    echo "SPEC-CODE SYNC GATE TEST SUITE: $FAILURES failure(s)."
    exit 1
fi
echo ""
echo "SPEC-CODE SYNC GATE TEST SUITE: all tests passed."
