# .agents/ - PRIVATE SOURCE OF TRUTH

> ⚠️ **CRITICAL WARNING FOR ALL AI ASSISTANTS**
> 
> This directory contains **CONFIDENTIAL** information:
> - Business strategies and trade secrets
> - Technical implementation details and architectural decisions
> - Training data and agent guidelines
> - Operational logs and decision history
> - Client information and proprietary workflows
>
> **NEVER commit, upload, or share contents of `.agents/` to public repositories!**
> **NEVER reference specific content from `.agents/` in public documentation!**
> **ALWAYS treat `.agents/` as PRIVATE and CONFIDENTIAL!**

---

## 🎯 Purpose

`.agents/` is the **single source of truth** for all AI Assistant operations in this project. It contains:

1. **Training & Guidelines**: How AI Assistants should behave
2. **Operational Rules**: Workflows, processes, and protocols
3. **Decision Logs**: History of architectural and strategic decisions
4. **Backlog & Planning**: Private task tracking and roadmap
5. **Lessons Learned**: Incidents, improvements, and knowledge base
6. **Business Context**: Confidential requirements and constraints

---

## 📁 Directory Structure

> 📋 **File Format Guide**: See `.agents/guidelines/file_format_strategy.md` for when to use .md vs .yml vs .json vs .jsonl

```
.agents/
├── AGENTS.md                           # This file - Navigation & rules (.md)
├── config/
│   ├── agent_profiles.yml              # AI Assistant capabilities & preferences
│   ├── security_rules.yml              # Security policies and constraints
│   └── quality_standards.yml           # Code quality and testing standards
├── guidelines/
│   ├── ai_philosophy_framework.yml     # Sustainable AI delivery principles
│   ├── coding_standards.md             # Code style, patterns, anti-patterns
│   ├── testing_strategy.md             # Testing approach and requirements
│   └── refactoring_playbook.md         # How to safely refactor legacy code
├── workflows/
│   ├── git_workflow.md                 # Branch strategy, PR process, merge rules
│   ├── handoff_protocol.md             # Author → Runner → Reviewer process
│   ├── brainstorm_process.md           # How to facilitate decision sessions
│   └── release_checklist.md            # Pre-release validation steps
├── backlog/
│   ├── backlog.yml                     # Task tracking with status & priority
│   ├── roadmap.yml                     # Long-term feature planning
│   └── blocked_issues.yml              # Tasks blocked by dependencies
├── decisions/
│   ├── decision_log.yml                # Architecture & strategy decisions
│   ├── tech_stack_rationale.md         # Why CMD? Why not PowerShell?
│   └── testing_infrastructure.md       # GitHub Actions vs Docker decision
├── lessons_learned/
│   ├── incidents.yml                   # Production issues & root causes
│   ├── improvements.yml                # Process improvements over time
│   └── retrospectives/                 # Sprint/milestone retrospectives
├── metrics/
│   ├── metrics_log.yml                 # CI/CD metrics, test coverage
│   ├── performance_baseline.yml        # Execution time benchmarks
│   └── code_quality.yml                # Complexity, duplication metrics
├── templates/
│   ├── care_spec_template.md           # Context, Actions, Risks, Expectations
│   ├── pr_template.md                  # Pull request description format
│   ├── handoff_template.yml            # Author → Runner handoff format
│   └── retrospective_template.md       # Post-mortem format
└── knowledge/
    ├── cmd_best_practices.md           # CMD-specific patterns
    ├── windows_api_reference.md        # Windows system calls reference
    ├── troubleshooting_guide.md        # Common issues & solutions
    └── vendor_documentation/           # Third-party tool docs
```

---

## 🚨 SECURITY RULES FOR AI ASSISTANTS

### ❌ NEVER DO

```yaml
prohibited_actions:
  - "Commit .agents/ to Git"
  - "Include .agents/ in public documentation"
  - "Reference specific .agents/ content in README.md"
  - "Share .agents/ content in issues or PRs"
  - "Copy .agents/ content to public directories"
  - "Mention client names, business strategies, or trade secrets publicly"
  - "Expose internal decision-making rationale in public"
  - "Upload .agents/ files to external services"
```

### ✅ ALWAYS DO

```yaml
required_actions:
  - "Check .gitignore includes .agents/ before any commit"
  - "Verify .agents/ is in .gitignore before creating new files"
  - "Keep business logic and secrets in .agents/"
  - "Use .agents/ as first reference for operational questions"
  - "Update .agents/ logs when making decisions"
  - "Sanitize public documentation to remove internal details"
  - "Use generic examples in public docs, specific in .agents/"
  - "Maintain separation between public docs and private knowledge"
```

---

## 📋 HOW TO USE .agents/

### For AI Assistants

**1. On Every New Task:**
```bash
# Read relevant guidelines
Read .agents/guidelines/ai_philosophy_framework.yml
Read .agents/workflows/git_workflow.md
Read .agents/backlog/backlog.yml

# Check if task is already documented
Grep pattern:"task_name" path:.agents/backlog/

# Follow templates
Use .agents/templates/care_spec_template.md
```

**2. During Implementation:**
```bash
# Log decisions
Append to .agents/decisions/decision_log.yml

# Track progress
Update .agents/backlog/backlog.yml

# Record lessons
Note issues in .agents/lessons_learned/incidents.yml
```

**3. Before Committing:**
```bash
# Verify .agents/ is not staged
git status | grep ".agents/"  # Should return nothing

# Double-check .gitignore
grep "^\.agents/" .gitignore  # Must exist
```

---

## 🎓 TRAINING FOR AI ASSISTANTS

### Core Principles

1. **Privacy First**: `.agents/` content is CONFIDENTIAL
2. **Transparency Within**: Document all decisions in `.agents/`
3. **Sanitize Outward**: Public docs contain NO internal details
4. **Single Source of Truth**: `.agents/` is authoritative
5. **Audit Trail**: Every decision logged in `.agents/decisions/`

### When to Add to .agents/

```yaml
add_to_agents:
  - "Business requirements that reveal strategy"
  - "Technical decisions with security implications"
  - "Client-specific customizations"
  - "Performance optimizations with trade-offs"
  - "Failed experiments and reasons why"
  - "Competitive analysis"
  - "Cost/budget considerations"
  - "Team internal processes"

keep_public:
  - "Generic usage instructions"
  - "Open-source integration guides"
  - "Contribution guidelines"
  - "Basic feature descriptions"
  - "Public API documentation"
```

### Example: Public vs Private

**Public (README.md):**
```markdown
## Testing

We use GitHub Actions for CI/CD. Tests run automatically on push.

```bash
# Run tests locally
cd tests && test_runner.cmd
```

**Private (.agents/decisions/testing_infrastructure.md):**
```markdown
## Testing Strategy Decision (2024-01-24)

**Context**: Considered 5 options: Docker Windows, WSL2, VM, GitHub Actions, AWS EC2.

**Decision**: GitHub Actions Windows Runner

**Rationale**:
- Free tier sufficient for current scale (200 minutes/month actual usage)
- No maintenance overhead vs self-hosted runner
- Real Windows environment vs WSL limitations
- Faster than Docker Desktop for Windows (2min vs 5min)

**Trade-offs**:
- Limited concurrency (1 job free tier) - acceptable for solo project
- No offline testing capability - mitigated by local mocking strategy
- Vendor lock-in to GitHub - low risk, can migrate to GitLab if needed

**Rejected Alternatives**:
- Docker: Windows containers not stable on macOS host
- WSL2: CMD script compatibility issues
- AWS EC2: Cost $30-50/month, overkill for current scale

**Success Metrics**:
- CI run time < 5 minutes (currently 2.5 min avg)
- Zero flaky tests in 1 month
- 100% CMD function coverage by Q2 2024
```

---

## 🔄 WORKFLOW INTEGRATION

### Standard Operating Procedure

```yaml
Phase 1 - Planning:
  1. Read: .agents/backlog/backlog.yml
  2. Check: .agents/guidelines/ai_philosophy_framework.yml
  3. Create: specs/<task>/ with CARE template
  4. Log: .agents/decisions/decision_log.yml

Phase 2 - Implementation:
  1. Follow: .agents/guidelines/coding_standards.md
  2. Test: .agents/guidelines/testing_strategy.md
  3. Update: .agents/backlog/backlog.yml (status)
  4. Document: .agents/lessons_learned/ (if issues)

Phase 3 - Review:
  1. Check: .agents/workflows/release_checklist.md
  2. Verify: .gitignore contains .agents/
  3. Sanitize: Remove internal details from public docs
  4. Merge: Update .agents/metrics/metrics_log.yml

Phase 4 - Retrospective:
  1. Record: .agents/lessons_learned/improvements.yml
  2. Update: .agents/guidelines/ if patterns emerge
  3. Archive: .agents/lessons_learned/retrospectives/
```

---

## 🛡️ GITIGNORE ENFORCEMENT

**Automated Check Script**: `.agents/scripts/verify_gitignore.sh`

```bash
#!/bin/bash
# Verify .agents/ is git-ignored

if ! grep -q "^\.agents/" .gitignore; then
    echo "ERROR: .agents/ not in .gitignore!"
    echo "Add this line to .gitignore:"
    echo ".agents/"
    exit 1
fi

# Check if .agents/ files are staged
if git status --porcelain | grep -q "^[AM].*\.agents/"; then
    echo "ERROR: .agents/ files are staged for commit!"
    echo "Files found:"
    git status --porcelain | grep "^[AM].*\.agents/"
    echo ""
    echo "Run: git reset HEAD .agents/"
    exit 1
fi

echo "✓ .agents/ is properly git-ignored"
exit 0
```

**Pre-commit Hook**: `.git/hooks/pre-commit`

```bash
#!/bin/bash
# Prevent accidental .agents/ commits

if git diff --cached --name-only | grep -q "^\.agents/"; then
    echo "⚠️  ERROR: Attempting to commit .agents/ files!"
    echo "⚠️  .agents/ contains CONFIDENTIAL information"
    echo "⚠️  Commit blocked for security"
    exit 1
fi
```

---

## 📊 METRICS & REPORTING

Track these metrics in `.agents/metrics/`:

```yaml
code_quality:
  - "Lines of code per function (target: <50)"
  - "Cyclomatic complexity (target: <10)"
  - "Test coverage (target: >80%)"
  - "Duplicate code percentage (target: <5%)"

operational:
  - "CI build time (target: <5 min)"
  - "Test pass rate (target: >95%)"
  - "Deployment frequency"
  - "Time to fix production issues"

process:
  - "Handoff latency (author→runner)"
  - "Rework rate (% of PRs requiring changes)"
  - "Spec completeness score"
  - "Incident response time"
```

---

## 🔗 RELATED DIRECTORIES

```yaml
public_directories:
  README.md: "User-facing documentation"
  specs/: "Versioned with code, sanitized"
  docs/: "Public API documentation"
  tests/: "Test cases (non-sensitive)"

private_directories:
  .agents/: "Internal operations (THIS DIRECTORY)"
  .git/: "Version control metadata"
```

---

## ⚡ QUICK REFERENCE

```bash
# Create new task
vi .agents/backlog/backlog.yml

# Log decision
vi .agents/decisions/decision_log.yml

# Check security
bash .agents/scripts/verify_gitignore.sh

# Add lesson learned
vi .agents/lessons_learned/improvements.yml

# View metrics
cat .agents/metrics/metrics_log.yml
```

---

## 🎯 SUCCESS CRITERIA

This `.agents/` setup is successful when:

- ✅ All AI Assistants know `.agents/` is PRIVATE
- ✅ No `.agents/` content ever committed to Git
- ✅ Decisions documented before implementation
- ✅ Lessons learned captured after incidents
- ✅ Public docs contain no internal details
- ✅ Team can onboard new AI Assistants via `.agents/`
- ✅ Audit trail exists for all major decisions

---

**Last Updated**: 2024-01-24  
**Maintained By**: Project Owner  
**AI Assistant Training**: Required reading before any work
