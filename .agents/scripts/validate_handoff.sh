#!/usr/bin/env bash
# Handoff validation script (LL-014 enforcement)
# Usage: .agents/scripts/validate_handoff.sh <branch_name>

set -euo pipefail

BRANCH="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [[ -z "$BRANCH" ]]; then
  echo "Usage: $0 <branch_name>"
  echo "Example: $0 feature/ci-spec-check-13-gemini"
  exit 1
fi

echo "=== Handoff Validation for $BRANCH (LL-014) ==="
echo ""

# Check if branch exists
if ! git rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
  echo "❌ Branch '$BRANCH' not found"
  exit 1
fi

# Checkout branch (read-only check)
git fetch origin "$BRANCH" 2>/dev/null || true
PROGRESS_FILE=".agents/branch_progress.yml"

# Check if branch_progress.yml exists
if ! git show "$BRANCH:$PROGRESS_FILE" >/dev/null 2>&1; then
  echo "❌ Missing: $PROGRESS_FILE not found in branch"
  echo "   Action: Create using .agents/templates/branch_progress_template.yml"
  exit 1
fi

echo "✅ Found: $PROGRESS_FILE"
echo ""

# Extract and validate required fields
CONTENT=$(git show "$BRANCH:$PROGRESS_FILE")

# Required sections
SECTIONS=(
  "context:"
  "handoff_ready:"
  "handoff_checklist:"
  "milestones:"
  "verification:"
  "rollback:"
  "communication:"
  "metrics:"
  "reflection:"
  "reverse_questions:"
)

MISSING=()
for section in "${SECTIONS[@]}"; do
  if ! echo "$CONTENT" | grep -q "^${section}"; then
    MISSING+=("$section")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "❌ Missing required sections:"
  for missing in "${MISSING[@]}"; do
    echo "   - $missing"
  done
  exit 1
fi

echo "✅ All required sections present"
echo ""

# Check handoff_ready flag
HANDOFF_READY=$(echo "$CONTENT" | grep "^handoff_ready:" | awk '{print $2}')
if [[ "$HANDOFF_READY" != "true" ]]; then
  echo "⚠️  handoff_ready: $HANDOFF_READY (expected: true)"
  echo "   Action: Set handoff_ready: true when ready for next agent"
  exit 1
fi

echo "✅ handoff_ready: true"
echo ""

# Check if context sections are filled (not template defaults)
CONTEXT_WHY=$(echo "$CONTENT" | grep -A2 "why_this_approach:" | tail -1)
if echo "$CONTEXT_WHY" | grep -qi "brief explanation\|example:"; then
  echo "⚠️  context.why_this_approach appears to be template default"
  echo "   Action: Fill with actual explanation"
  exit 1
fi

echo "✅ context.why_this_approach filled"
echo ""

# Check verification section has commands
if ! echo "$CONTENT" | grep -A5 "verification:" | grep -q "command:"; then
  echo "⚠️  verification section missing test commands"
  echo "   Action: Add at least one test command with expected result"
  exit 1
fi

echo "✅ verification section has test commands"
echo ""

# Check communication section has discussions
if ! echo "$CONTENT" | grep -A5 "discussions:" | grep -q "location:"; then
  echo "⚠️  communication.discussions missing"
  echo "   Action: Add PR or brainstorm discussion references"
  exit 1
fi

echo "✅ communication.discussions present"
echo ""

# Check reflection section is filled (not template default)
if ! echo "$CONTENT" | grep -q "^reflection:"; then
  echo "⚠️  reflection section missing"
  echo "   Action: Add a brief self-assessment and risks"
  exit 1
fi

REFLECT_SELF=$(echo "$CONTENT" | awk '/^reflection:/{flag=1;next}/^[^ \t]/{flag=0}flag' | grep -A2 "self_assessment:" | tail -1)
if echo "$REFLECT_SELF" | grep -qi "Brief self-audit of the current work"; then
  echo "⚠️  reflection.self_assessment appears to be template default"
  echo "   Action: Replace with actual reflection"
  exit 1
fi

echo "✅ reflection section filled"
echo ""

# Check reverse_questions has at least one question item
if ! echo "$CONTENT" | awk '/^reverse_questions:/{flag=1;next}/^[^ \t-]/{flag=0}flag' | grep -q "^- "; then
  echo "⚠️  reverse_questions list missing"
  echo "   Action: Add 2–3 reviewer-style questions"
  exit 1
fi

if ! echo "$CONTENT" | awk '/^reverse_questions:/{flag=1;next}/^[^ \t-]/{flag=0}flag' | grep -q "?"; then
  echo "⚠️  reverse_questions do not look like questions"
  echo "   Action: Phrase as questions ending with '?'"
  exit 1
fi

echo "✅ reverse_questions present"
echo ""

# Success
echo "=========================================="
echo "✅ Handoff validation PASSED"
echo "=========================================="
echo ""
echo "Branch '$BRANCH' is ready for handoff (LL-014 compliant)"
echo ""
echo "Next steps:"
echo "1. Update .agents/backlog.yml:"
echo "   - status: 'Ready for handoff'"
echo "   - handoff_notes: 'See $PROGRESS_FILE'"
echo "2. Commit: git commit -m 'docs: prepare handoff for task #X'"
echo "3. Notify next agent in PR or brainstorm"
