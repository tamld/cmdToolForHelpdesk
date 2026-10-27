#!/usr/bin/env bash
#
# Test suite for tools/ci_link_integrity.sh (S6-2 / #420 G3 / #435)
# Validates markdown link-integrity gate and content root configuration:
#   1. Pillar vault with dead link inside configured root -> exit 1, dead link found
#   2. Same pillar vault without configured roots (default) -> exit 0, default behavior
#   3. README.md + docs/guide.md dead link, default roots -> exit 1 (regression guard)
#   4. Clean relative links, default roots -> exit 0, report mentions examined links
#   5. Roots configured pointing at empty directory -> exit 2 with NOT EVALUATED line
#   6. Report line always contains examined file and link counts (pass and fail)
#   Plus regression guards for code fences, external URLs, anchors, mailto, etc.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATE_SCRIPT="${SCRIPT_DIR}/ci_link_integrity.sh"

if [ ! -f "$GATE_SCRIPT" ]; then
    echo "ERROR: link-integrity gate script not found at $GATE_SCRIPT"
    exit 1
fi

echo "==> Running Link Integrity Gate Test Suite..."

FAILURES=0

run_test() {
    local desc="$1"
    local expect_code="$2"
    shift 2
    echo "Testing: $desc"
    local output=""
    local exit_code=0
    output=$("$@" 2>&1) || exit_code=$?
    if [ "$exit_code" -ne "$expect_code" ]; then
        echo "  FAIL: expected exit code $expect_code, got $exit_code"
        echo "$output" | sed 's/^/    /'
        FAILURES=$((FAILURES + 1))
    else
        echo "  ok (exit $exit_code)"
    fi
}

run_test_with_output() {
    local desc="$1"
    local expect_code="$2"
    local pattern="$3"
    shift 3
    echo "Testing: $desc"
    local output=""
    local exit_code=0
    output=$("$@" 2>&1) || exit_code=$?
    if [ "$exit_code" -ne "$expect_code" ]; then
        echo "  FAIL: expected exit code $expect_code, got $exit_code"
        echo "$output" | sed 's/^/    /'
        FAILURES=$((FAILURES + 1))
    elif ! echo "$output" | grep -qE "$pattern"; then
        echo "  FAIL: output did not match pattern '$pattern'"
        echo "$output" | sed 's/^/    /'
        FAILURES=$((FAILURES + 1))
    else
        echo "  ok (exit $exit_code, pattern matched: '$pattern')"
    fi
}

# --- fixture: temporary test workspace ------------------------------------

FIXTURE_ROOT="$(mktemp -d)"
trap 'rm -rf "$FIXTURE_ROOT"' EXIT

reset_fixture() {
    rm -rf "${FIXTURE_ROOT:?}"/*
}

# ==========================================================================
# Cases from brief-435 (#435)
# ==========================================================================

# 1. Clean README.md; 1-Knowledge/note.md with [Dead Link](missing.md);
#    roots configured to include 1-Knowledge -> exit 1, one dead link.
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Clean Readme
This is a clean readme with no links.
EOF
mkdir -p "$FIXTURE_ROOT/1-Knowledge"
cat > "$FIXTURE_ROOT/1-Knowledge/note.md" <<'EOF'
# Knowledge Note
Here is a [Dead Link](missing.md).
EOF

run_test_with_output \
    "(1a) configured root via env var LINK_INTEGRITY_ROOTS finds dead link -> exit 1" 1 \
    "1 dead link\(s\) found" \
    env LINK_INTEGRITY_ROOTS="1-Knowledge" "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

run_test_with_output \
    "(1b) configured root via --content-root flag finds dead link -> exit 1" 1 \
    "1 dead link\(s\) found" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT" --content-root "1-Knowledge"

# 2. Same fixture, roots NOT configured (default) -> exit 0 with current
#    default behavior preserved (README/docs only).
run_test_with_output \
    "(2) same fixture without configured roots preserves default behavior -> exit 0" 0 \
    "OK \(0 relative link\(s\) verified across 1 file\(s\)" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 3. README.md + docs/guide.md dead link, default roots -> exit 1
#    (regression guard for today's working case).
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Readme
Check [Guide](docs/guide.md).
EOF
mkdir -p "$FIXTURE_ROOT/docs"
cat > "$FIXTURE_ROOT/docs/guide.md" <<'EOF'
# Guide
Dead link here: [Missing](missing_target.md).
EOF

run_test_with_output \
    "(3) docs/guide.md dead link with default roots -> exit 1" 1 \
    "1 dead link\(s\) found across 2 file\(s\)" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 4. README links existing docs/guide.md, guide links back, default roots ->
#    exit 0, report mentions 2 examined links.
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Readme
Check [Guide](docs/guide.md).
EOF
mkdir -p "$FIXTURE_ROOT/docs"
cat > "$FIXTURE_ROOT/docs/guide.md" <<'EOF'
# Guide
Link back to [Home](../README.md).
EOF

run_test_with_output \
    "(4) README links guide and guide links back -> exit 0 with 2 examined links" 0 \
    "OK \(2 relative link\(s\) verified across 2 file\(s\)" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 5. Roots configured pointing at an empty directory -> exit 2 with the
#    NOT EVALUATED line (no blanket OK).
reset_fixture
mkdir -p "$FIXTURE_ROOT/empty_dir"

run_test_with_output \
    "(5a) empty directory configured via env var -> exit 2 with NOT EVALUATED" 2 \
    "NOT EVALUATED: no markdown files found under configured root\(s\): empty_dir" \
    env LINK_INTEGRITY_ROOTS="empty_dir" "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

run_test_with_output \
    "(5b) empty directory configured via --content-root flag -> exit 2 with NOT EVALUATED" 2 \
    "NOT EVALUATED: no markdown files found under configured root\(s\): empty_dir" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT" --content-root "empty_dir"

# 6. Report line always contains examined file and link counts (pass and fail).
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Readme
[Dead](nowhere.md)
EOF
run_test_with_output \
    "(6a) failure report line contains examined file and link counts" 1 \
    "across 1 file\(s\) \([0-9]+ relative link\(s\) examined" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Readme
No links.
EOF
run_test_with_output \
    "(6b) success report line contains examined file and link counts" 0 \
    "0 relative link\(s\) verified across 1 file\(s\)" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# ==========================================================================
# Regression tests from #420
# ==========================================================================

# 7. Valid relative links pass (exit 0)
reset_fixture
mkdir -p "$FIXTURE_ROOT/docs/sub" "$FIXTURE_ROOT/docs/deep/nested" "$FIXTURE_ROOT/assets"
touch "$FIXTURE_ROOT/docs/guide.md"
touch "$FIXTURE_ROOT/docs/sub/topic.md"
touch "$FIXTURE_ROOT/docs/deep/nested/page.md"
touch "$FIXTURE_ROOT/assets/logo.png"

cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Fixture Project

Check out the [Guide](docs/guide.md) or the [Topic](docs/sub/topic.md).
See image: ![Logo](assets/logo.png)
EOF

cat > "$FIXTURE_ROOT/docs/guide.md" <<'EOF'
# Guide

Go back to [Home](../README.md) or see [Sub Topic](sub/topic.md).
EOF

cat > "$FIXTURE_ROOT/docs/sub/topic.md" <<'EOF'
# Topic

Deep link to [Nested Page](../deep/nested/page.md).
EOF

run_test "valid relative links pass" 0 \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 8. Dead relative link fails (exit 1) and lists file:line
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Title

Line 3 has a [Broken Link](docs/nonexistent.md).
Line 4 is ok.
EOF

run_test_with_output \
    "dead relative link fails with file:line" 1 \
    "(README\.md:3|README\.md:[[:space:]]*3)" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 9. HTTP and HTTPS external links are ignored
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# External Links

Check [Google](https://google.com/search?q=test) or [HTTP Site](http://example.com/index.html).
Also [Badge](https://img.shields.io/badge/test-badge.svg).
EOF
run_test "http and https links ignored" 0 \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 10. #anchor-only links are ignored
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Anchors

Jump to [Overview](#overview) or [FAQ](#faq-section).

## Overview
Content.

## FAQ Section
Content.
EOF
run_test "anchor-only links ignored" 0 \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 11. Mailto links are ignored
reset_fixture
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Contact

Send email to [Maintainers](mailto:team@example.com).
EOF
run_test "mailto links ignored" 0 \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 12. Nested docs/ subdirectory links resolved relative to md file's directory
reset_fixture
mkdir -p "$FIXTURE_ROOT/docs/sub" "$FIXTURE_ROOT/docs/deep/nested"
touch "$FIXTURE_ROOT/docs/guide.md"
touch "$FIXTURE_ROOT/docs/deep/nested/page.md"
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Main
[Topic](docs/sub/topic.md)
EOF

cat > "$FIXTURE_ROOT/docs/sub/topic.md" <<'EOF'
# Topic
[Sibling](../guide.md)
[Deep](../deep/nested/page.md)
[Dead Relative](../deep/missing.md)
EOF

run_test_with_output \
    "nested subdirectory dead link resolved relative to md file" 1 \
    "(docs/sub/topic\.md:4|topic\.md:4)" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 13. Relative links with anchor fragments
reset_fixture
mkdir -p "$FIXTURE_ROOT/docs"
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Anchored Targets
Valid link with anchor: [Guide Install](docs/guide.md#installation)
Dead link with anchor: [Missing Install](docs/missing.md#installation)
EOF
cat > "$FIXTURE_ROOT/docs/guide.md" <<'EOF'
# Installation Guide
EOF

run_test_with_output \
    "relative link with anchor target checked properly" 1 \
    "(README\.md:3|README\.md:[[:space:]]*3)" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 14. Multiple links on the same line
reset_fixture
mkdir -p "$FIXTURE_ROOT/docs"
touch "$FIXTURE_ROOT/docs/guide.md"
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Multiple links on one line
[Valid](docs/guide.md) and [Dead One](docs/dead1.md) and [Dead Two](docs/dead2.md)
EOF

output=""
exit_code=0
output=$("$GATE_SCRIPT" --root "$FIXTURE_ROOT" 2>&1) || exit_code=$?
echo "Testing: multiple links on single line detected"
if [ "$exit_code" -ne 1 ]; then
    echo "  FAIL: expected exit 1, got $exit_code"
    FAILURES=$((FAILURES + 1))
elif ! echo "$output" | grep -q "dead1.md" || ! echo "$output" | grep -q "dead2.md"; then
    echo "  FAIL: expected output to list both dead links"
    echo "$output" | sed 's/^/    /'
    FAILURES=$((FAILURES + 1))
else
    echo "  ok (exit $exit_code)"
fi

# 15. Fenced code blocks with link-like text are ignored
reset_fixture
mkdir -p "$FIXTURE_ROOT/docs"
touch "$FIXTURE_ROOT/docs/guide.md"
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Code Blocks

```bash
# This is a sample command, not a link
arr[0](not_a_real_file.md)
[fake](docs/nonexistent.md)
```

~~~python
# Another code fence
call[0](other_fake.md)
~~~

Valid outside fence: [Guide](docs/guide.md)
EOF

run_test "fenced code blocks ignored" 0 \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 16. Links with optional titles and angle brackets
reset_fixture
mkdir -p "$FIXTURE_ROOT/docs"
touch "$FIXTURE_ROOT/docs/guide.md"
cat > "$FIXTURE_ROOT/README.md" <<'EOF'
# Titles and Brackets

[With Title](docs/guide.md "Awesome Guide")
[With Angle Brackets](<docs/guide.md>)
[Dead With Title](docs/missing.md "Title")
EOF

run_test_with_output \
    "titled link failure reported" 1 \
    "docs/missing\.md" \
    "$GATE_SCRIPT" --root "$FIXTURE_ROOT"

# 17. Unknown CLI argument fails with code 2
run_test "unknown argument exits with code 2" 2 \
    "$GATE_SCRIPT" --unknown-flag

# 18. --root-dir without --roots must not crash on stock bash 3.2 (#466):
# empty-array expansion under set -u raised "unbound variable" before the
# ${arr[@]+...} guards; the gate must complete with a normal exit.
OUT=$("$GATE_SCRIPT" --root-dir . 2>&1)
RC=$?
if [ "$RC" -ne 0 ]; then
    echo "FAIL (18): --root-dir . exited $RC (want 0)"
    echo "$OUT" | tail -3
    FAILURES=$((FAILURES + 1))
elif echo "$OUT" | grep -q "unbound variable"; then
    echo "FAIL (18): unbound variable leaked into output (bash 3.2 regression)"
    FAILURES=$((FAILURES + 1))
else
    echo "  ok (18) --root-dir . completes without bash 3.2 crash"
fi

if [ "$FAILURES" -gt 0 ]; then
    echo ""
    echo "LINK INTEGRITY GATE TEST SUITE: $FAILURES failure(s)."
    exit 1
fi
echo ""
echo "LINK INTEGRITY GATE TEST SUITE: all tests passed."
exit 0
