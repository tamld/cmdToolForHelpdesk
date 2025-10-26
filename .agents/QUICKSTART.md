# .agents/ Quick Start Guide

## 🎯 30-Second Overview

```yaml
What: Private operational hub for AI Assistants
Why: Store confidential business/technical info safely
How: Gitignored directory, never committed

Structure:
  .agents/          # PRIVATE (gitignored)
  brainstorm/       # PUBLIC (git versioned)
```

---

## 🚀 Quick Setup (5 minutes)

### Step 1: Verify Security

```bash
# Run security check
bash .agents/scripts/verify_security.sh

# Should see: ✓ All checks passed!
```

### Step 2: Understand the System

```
2-Tier Brainstorm System:

PUBLIC (brainstorm/)          PRIVATE (.agents/)
├─ Technical decisions        ├─ Business strategy
├─ Testing strategies         ├─ Client requirements
├─ Open-source choices        ├─ Budget planning
├─ Git versioned              ├─ Financial data
└─ Visible on GitHub          └─ Gitignored
```

### Step 3: Classification Rule

```yaml
Ask: "Would competitors benefit from this?"
  YES → .agents/ (private)
  NO  → brainstorm/ (public)

Ask: "Does it contain client/financial info?"
  YES → .agents/ (private)
  NO  → brainstorm/ (public)

When uncertain: Default to .agents/ (safer)
```

---

## 📋 Common Tasks

### Create New Brainstorm

```bash
# Technical/public topic
vi brainstorm/sessions/active/topic-20240124.yml

# Business/private topic
vi .agents/brainstorm/business/topic-20240124.yml
```

### Log a Decision

```bash
# Add to decision log
vi .agents/decisions/decision_log.yml

# Format:
# - date: 2024-01-24
#   decision: "Use GitHub Actions for CI"
#   rationale: "Free tier, native Windows support"
#   alternatives: ["Docker", "AWS EC2"]
```

### Track Progress

```bash
# Update backlog
vi .agents/backlog/backlog.yml

# Update status: pending → in_progress → completed
```

### Record Lesson

```bash
# After incident or improvement
vi .agents/lessons_learned/improvements.yml

# Document: what happened, why, how to prevent
```

---

## 🔒 Security Checklist

Before every commit:

```bash
✓ Run: bash .agents/scripts/verify_security.sh
✓ Check: git status | grep .agents  # Should be empty
✓ Verify: .gitignore contains .agents/
✓ Review: No client names in public docs
✓ Confirm: No financial data in commit
```

---

## 📁 Key Files (Read First)

```yaml
Start here:
  1. .agents/AGENTS.md
     - Complete overview and rules
     
  2. .agents/guidelines/brainstorm_classification.md
     - Public vs Private decision tree
     
  3. .agents/workflows/git_workflow.md
     - How to work with Git safely

Reference:
  - .agents/config/agent_profiles.yml
  - .agents/guidelines/coding_standards.md
  - .agents/templates/ (all templates)
```

---

## 🎓 Examples

### Example 1: Public Brainstorm ✅

**Topic**: "Should we use GitHub Actions or Docker for testing?"

**Location**: `brainstorm/sessions/active/testing-infrastructure-20240124.yml`

**Why Public?**
- General technical problem
- Benefits open-source community
- No competitive disadvantage
- Encourages contributions

---

### Example 2: Private Brainstorm 🔒

**Topic**: "Client X deployment: 10K users, $50K budget"

**Location**: `.agents/brainstorm/client/clientx-deployment-20240124.yml`

**Why Private?**
- Contains client name
- Reveals pricing structure
- Exposes revenue data
- Competitive intelligence

---

### Example 3: Hybrid Approach 🌓

**Topic**: "Security vulnerability in package installer"

**During Fix**: `.agents/brainstorm/security/cve-2024-xxxx.yml` (private)

**After Fix**: `brainstorm/topics/cmd-injection-prevention.md` (public)

**Why Hybrid?**
- Vulnerability details must stay private until fixed
- Prevention lessons benefit community
- Educate without exposing exploit

---

## ⚡ Quick Commands

```bash
# Verify security
bash .agents/scripts/verify_security.sh

# Check classification
cat .agents/guidelines/brainstorm_classification.md

# View backlog
cat .agents/backlog/backlog.yml

# View decisions
cat .agents/decisions/decision_log.yml

# View metrics
cat .agents/metrics/metrics_log.yml
```

---

## 🆘 Troubleshooting

### Problem: .agents/ files staged for commit

```bash
# Unstage all .agents/ files
git reset HEAD .agents/

# Verify
git status | grep .agents  # Should return nothing
```

### Problem: .agents/ already committed

```bash
# Remove from git (keep local files)
git rm -r --cached .agents/

# Update .gitignore
echo ".agents/" >> .gitignore

# Commit the fix
git add .gitignore
git commit -m "chore: gitignore .agents/ directory"

# Optional: Clean history (advanced)
git filter-branch --tree-filter 'rm -rf .agents' HEAD
```

### Problem: Uncertain about classification

```bash
# Default to PRIVATE (safer)
vi .agents/brainstorm/business/topic.yml

# Can migrate to public later if safe
```

---

## ✅ Success Indicators

You're using .agents/ correctly when:

- ✅ `git status` never shows .agents/ files
- ✅ Security check always passes
- ✅ No client info in public docs
- ✅ All decisions logged in .agents/
- ✅ Clear separation public/private
- ✅ Team knows when to use which

---

## 📚 Next Steps

1. **Read full documentation**: `.agents/AGENTS.md`
2. **Set up pre-commit hook**: Prevent accidental commits
3. **Review guidelines**: `.agents/guidelines/`
4. **Practice classification**: Use decision tree
5. **Update backlog**: Track your tasks

---

## 🎯 Remember

```
Golden Rules:
  1. When uncertain → Default to PRIVATE
  2. Before commit → Run security check
  3. Client info → Always PRIVATE
  4. Technical → Usually PUBLIC
  5. Financial → Always PRIVATE
```

---

**Help**: Read `.agents/AGENTS.md` for complete documentation  
**Security**: Run `.agents/scripts/verify_security.sh` before every commit  
**Questions**: Ask project owner or default to PRIVATE
