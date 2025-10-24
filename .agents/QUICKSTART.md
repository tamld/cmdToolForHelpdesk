# AI Agent Quickstart — cmdToolForHelpdesk

## Purpose

Enable any AI Agent to quickly understand project state, active work, and next steps when entering this repository.

## 3-Step Onboarding Protocol

### Step 1: Load Context

```bash
# Check branch and working tree
git branch --show-current
git status --short

# Read SSoT and active tasks
cat .agents/AGENTS.md | head -50
cat .agents/backlog.yml | grep -A10 "In Progress\|Ready for handoff"

# Check for feature branch context
[ -f .agents/branch_progress.yml ] && echo "Active feature work" || echo "No active feature"
```

**Key information to extract:**

- Current branch name (main / refactor / feature)
- Modified files (uncommitted work?)
- Active tasks from backlog (In Progress / Ready for handoff)
- Feature context (branch_progress.yml exists?)

### Step 2: Identify Work State

**If `branch_progress.yml` exists:**

```bash
grep "workflow_state:" .agents/branch_progress.yml
grep "owner_current:" .agents/branch_progress.yml
grep "handoff_ready:" .agents/branch_progress.yml
sed -n '/^next_steps:/,/^[^ ]/p' .agents/branch_progress.yml | head -10
```

**Workflow state mapping:**

- `authored` → Spec complete, awaiting runner to implement
- `ready_for_runner` → Ready for another agent to implement
- `in_progress` → Active implementation, continue work
- `blocked` → Blocked, needs escalation
- `review` → Awaiting review, prepare for merge
- `done` → Task complete, close

**If `branch_progress.yml` does NOT exist:**

```bash
# Check for unstarted tasks
cat .agents/backlog.yml | grep -B2 "status: \"To Do\""

# Check CI status
GH_PAGER=cat gh run list --branch $(git branch --show-current) --limit 1 --json status,conclusion
```

### Step 3: Clarify with User

**Standard clarification template:**

```text
I see:
- Branch: <branch_name>
- Backlog: Task #X is <status>
- [If branch_progress exists]: workflow_state = <state>, next_steps = <list>

What would you like me to do:
1. Continue current task (Task #X)?
2. Review/wrap-up and switch to new task?
3. Something else?
```

## User Prompt Templates

### Template 1: Cold Start (New Session)

```text
I just CD'd into /path/to/cmdToolForHelpdesk.

Please:
1. Read .agents/AGENTS.md, .agents/backlog.yml, and git status
2. Summarize briefly:
   - Current branch and CI status
   - Which tasks are In Progress or Ready for handoff
   - Does branch_progress.yml exist (if yes, what is workflow_state)
3. Suggest what I should do next

Reply in Vietnamese, max 10 lines.
```

**Expected agent response format:**

```text
✅ Branch: <name> (CI: <green/red>)
📋 Backlog: Task #X "<status>" (<brief description>)
📁 branch_progress.yml: <exists/not exists>

Suggestions:
- Option A: <action>
- Option B: <action>
- Option C: <action>

What would you like to do?
```

### Template 2: Warm Resume (Continue Work)

```text
I'm on branch <branch_name>.

Please:
1. Read .agents/branch_progress.yml (if exists)
2. Check next_steps and blockers
3. Summarize:
   - Task ID, workflow_state, owner
   - What's been done (milestones)
   - What remains (next_steps)
   - Any blockers
4. If handoff_ready=true, guide me on completing handoff

Reply in Vietnamese, max 15 lines.
```

**Expected agent response format:**

```text
📋 Task #X: <description>
👤 Owner: <name>
🔄 State: <workflow_state>

✅ Done:
- <milestone 1>
- <milestone 2>

⏭️ Remaining:
- <next step 1>
- <next step 2>

🚫 Blockers: <none / list>
```

### Template 3: Review Before Merge/Handoff

```text
I want to wrap-up task on branch <branch_name> and prepare for merge/handoff.

Please:
1. Check CI status (must be green)
2. Review branch_progress.yml completeness (per LL-014 and LL-018):
   - All required sections present?
   - reflection and reverse_questions filled?
   - handoff_ready=true?
3. Check backlog.yml (status must be "Ready for handoff" or "Done")
4. List files needing commit if any uncommitted changes
5. Suggest final checklist before handoff/merge

Reply in Vietnamese, checklist format.
```

**Expected agent response format:**

```text
🔍 Review Checklist:

CI Status: ✅ / ❌
branch_progress.yml: ✅ / ⚠️ (details)
backlog.yml: ✅ / ⚠️ (details)
Uncommitted: <count> files

Final Steps:
1. <step>
2. <step>
...
```

### Template 4: Escalate When Blocked

```text
I'm blocked on task <task_id> on branch <branch_name>.

Block reason: <short description>

Please:
1. Update branch_progress.yml:
   - workflow_state: "blocked"
   - Add blocker entry with waiting_for and mitigation
2. Update backlog.yml: status: "Blocked"
3. Commit with message "docs: mark task as blocked - <reason>"
4. Suggest escalation path (user, brainstorm, or pivot to other task)

Reply in Vietnamese.
```

## Utility Commands (Cheat Sheet)

```bash
# Check SSoT hierarchy
head -100 .agents/AGENTS.md

# Find active work
yq '.tasks[] | select(.status == "In Progress" or .status == "Ready for handoff") | {id, description, status, owner, branch}' .agents/backlog.yml

# Check CI health
GH_PAGER=cat gh run list --branch $(git branch --show-current) --limit 3 --json status,conclusion,displayTitle,createdAt | jq -c '.[]'

# Validate handoff readiness (CI-first on macOS)
# Label PR with "ready-for-handoff" to trigger workflow
# Manual check: verify branch_progress.yml sections
grep -E "^(context|handoff_ready|verification|reflection|reverse_questions):" .agents/branch_progress.yml

# Quick branch switch
git branch -a | grep feature/
git checkout <branch> && cat .agents/branch_progress.yml | head -30
```

## Key Files (Priority Order)

1. **`.agents/AGENTS.md`** — SSoT, workflow, ritual, guardrails (📌 READ FIRST)
2. **`.agents/backlog.yml`** — Active tasks, status, handoff notes
3. **`.agents/branch_progress.yml`** — Feature branch context (if exists)
4. **`specs/<task_id>/plan.md`** — Task requirements, CARE structure
5. **`.agents/lessons_learned.yml`** — Past mistakes, solutions, enforcement
6. **`.agents/decision_log.yml`** — Major decisions, approval, execution

## Decision Tree

```text
CD into project
│
├─ Step 1: Load context (git status, backlog, branch_progress.yml)
│
├─ Step 2: Identify state
│   ├─ Has branch_progress.yml?
│   │   ├─ Yes → Read workflow_state, next_steps, blockers
│   │   │   ├─ State = "authored" → Ask: implement or handoff?
│   │   │   ├─ State = "in_progress" → Continue next_steps
│   │   │   ├─ State = "blocked" → Escalate or pivot
│   │   │   └─ State = "review" → Check CI, prepare merge
│   │   └─ No → Check backlog for "To Do" or "In Progress" tasks
│
├─ Step 3: Clarify with user (use prompt templates above)
│   ├─ User confirms → Proceed
│   └─ User redirects → Update context, follow new directive
│
└─ Step 4: Execute with ritual (marker → spec → progress → CI → handoff)
```

## Red Flags (Stop and Ask)

- ❌ No `.agents/AGENTS.md` in repo → Wrong directory or need SSoT init
- ❌ `git status` shows 50+ modified files → Stale working tree, needs cleanup
- ❌ CI failing on current branch → Fix CI before new work
- ❌ `branch_progress.yml` says `handoff_ready: true` but told to continue → Clarify ownership

## Green Lights (Safe to Proceed)

- ✅ Branch name matches backlog task ID (e.g., `feature/ci-care-lint-13-*`)
- ✅ CI green on parent branch
- ✅ `next_steps` in `branch_progress.yml` is clear and actionable
- ✅ No merge conflicts with main

## Example Session Flow

**User:** "I just CD'd into cmdToolForHelpdesk. What's the situation?"

**Agent (internally runs):**

```bash
git branch --show-current  # → refactor/structure-and-naming
git status --short         # → clean
cat .agents/backlog.yml | grep -A8 "Ready for handoff"
GH_PAGER=cat gh run list --branch refactor/structure-and-naming --limit 1 --json conclusion
```

**Agent (responds in Vietnamese):**

```text
✅ Branch: refactor/structure-and-naming (CI: green)
📋 Backlog:
   - Task #13: "Ready for handoff" (CARE spec CI lint)
   - Branch: feature/ci-care-lint-13-agemini

Situation:
- Refactor branch clean, CI green, can merge to main
- Task #13 has spec + handoff context, awaiting runner

Options:
1. Merge refactor → main first?
2. Checkout Task #13 branch to implement?
3. Start new task?
```

**User:** "Checkout Task #13 to continue"

**Agent:**

```bash
git checkout feature/ci-care-lint-13-agemini
cat .agents/branch_progress.yml | head -50
cat specs/13/plan.md
```

**Agent (responds):**

```text
✅ Checked out feature/ci-care-lint-13-agemini

📋 Task #13: CARE spec CI lint
🔄 State: authored (spec complete, awaiting runner)

Next steps (from branch_progress.yml):
1. Implement scripts/lint_care_spec.sh
2. Add .github/workflows/lint_care_spec.yml
3. Test with sample specs
4. Update README.md
5. Set handoff_ready=true

Full spec: specs/13/plan.md (CARE structure)

Start implementation now? (Y/n)
```

## References

- **LL-014:** Handoff completeness (branch_progress.yml required sections)
- **LL-018:** Reflection + reverse-thinking prompts
- **LAW-REFLECT-001:** Pause and confirm before significant actions
- **Workflow rituals:** Marker commit → spec → progress → CI → handoff

---

**Last Updated:** 2025-10-23  
**Maintained by:** GitHub Copilot (agemini mode)  
**Feedback:** Update this file when discovering new patterns or pain points
