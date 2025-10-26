# Brainstorm Strategy - Public vs Private

> 📋 **TL;DR**: We use a 2-tier system:
> - **`brainstorm/`** - PUBLIC (git versioned) for technical discussions
> - **`.agents/brainstorm/`** - PRIVATE (gitignored) for business/client matters

---

## 🎯 Why Two Brainstorm Locations?

### The Problem
- ✅ Need **transparency** and **git versioning** for collaboration
- ✅ Need **privacy** for business secrets and client information
- ❌ Can't have both in the same location

### The Solution: 2-Tier System

```
cmdToolForHelpdesk/
├── brainstorm/              # PUBLIC - On GitHub
│   └── sessions/
│       ├── active/          # Current discussions
│       └── archived/        # Completed sessions
│
└── .agents/                 # PRIVATE - Gitignored
    └── brainstorm/
        ├── business/        # Strategy & positioning
        ├── client/          # Client-specific
        ├── budget/          # Financial planning
        └── security/        # Pre-disclosure issues
```

---

## 📊 Comparison Table

| Aspect | `brainstorm/` (PUBLIC) | `.agents/brainstorm/` (PRIVATE) |
|--------|----------------------|-------------------------------|
| **Git Status** | ✅ Committed & versioned | ❌ Gitignored |
| **Visibility** | 🌍 Public on GitHub | 🔒 Local only |
| **Collaboration** | ✅ Open to community | 🔒 Internal team only |
| **Content Type** | Technical, educational | Business, financial, client |
| **Examples** | Testing strategies, refactoring | Pricing, budgets, contracts |
| **Benefit** | Knowledge sharing | Protects competitive advantage |
| **Audit Trail** | Git history | Local files only |

---

## 🎓 When to Use Which?

### Use `brainstorm/` (PUBLIC) for:

```yaml
technical_decisions:
  - "Testing infrastructure choices"
  - "Refactoring approaches"
  - "Tool and library selection"
  - "Architecture patterns"
  - "Development workflows"
  
community_value:
  - "Open-source integration guides"
  - "Best practices documentation"
  - "Lessons learned (generic)"
  - "Error handling patterns"
  
educational:
  - "How we solved X problem"
  - "Why we chose Y over Z"
  - "Trade-offs and considerations"
```

**Example**:
```yaml
topic: "CMD Testing Strategy: GitHub Actions vs Docker"
location: brainstorm/sessions/active/cmd-testing-20240124.yml
rationale:
  - General technical problem
  - Benefits open-source community
  - No competitive disadvantage
  - Encourages contributions
```

---

### Use `.agents/brainstorm/` (PRIVATE) for:

```yaml
business_sensitive:
  - "Pricing strategies and revenue models"
  - "Market positioning and competition"
  - "Partnership terms"
  - "Business model decisions"
  
client_specific:
  - "Client names and requirements"
  - "Custom contracts and SLAs"
  - "NDA-covered information"
  - "Implementation specifics"
  
financial:
  - "Budget allocations"
  - "Cost structures and margins"
  - "Revenue projections"
  - "Resource planning with costs"
  
security_pre_fix:
  - "Vulnerability analysis (before patch)"
  - "Exploit techniques"
  - "Security incident details"
  - "Penetration test results"
  
competitive:
  - "Feature parity analysis"
  - "Competitive advantages"
  - "Market intelligence"
  - "Proprietary algorithms"
```

**Example**:
```yaml
topic: "Client X: Enterprise Deployment - 10K users, $50K budget"
location: .agents/brainstorm/client/clientx-20240124.yml
rationale:
  - Contains client name (confidential)
  - Reveals pricing structure
  - Exposes revenue data
  - Competitive intelligence
```

---

## 🌓 Hybrid Approach

For mixed content, use **sanitized public + full private**:

### Process

1. **Conduct full brainstorm in `.agents/brainstorm/`**
   - Include all details: client names, costs, strategies
   
2. **Extract sanitized summary to `brainstorm/`**
   - Remove: specific names, numbers, competitive details
   - Keep: general lessons, technical decisions
   
3. **Cross-reference**
   - Private version links to public
   - Public version notes "Full analysis: internal only"

### Example

**Private** (`.agents/brainstorm/client/fortune500-deployment-20240124.yml`):
```yaml
client: "Fortune 500 Company X"
requirements:
  users: 10000
  budget: "$50,000"
  timeline: "3 months"
  constraints: "On-premise, AD integration required"
  
financial_analysis:
  revenue: "$50,000"
  costs: "$12,000"
  margin: "76%"
  
competitive_edge:
  - "Volume licensing saves $15K vs competitors"
  - "Custom AD integration (6-week advantage)"
```

**Public** (`brainstorm/topics/enterprise-deployment-patterns.md`):
```markdown
# Enterprise Deployment Patterns

## Context
Large enterprise deployments (1000+ users) require specialized approaches.

## Lessons Learned
- Volume licensing significantly reduces per-seat costs
- On-premise deployments need 3+ month timeline
- AD integration improves user adoption
- Compliance requirements vary by industry

## Technical Decisions
- Windows Server Datacenter for large deployments
- SSO integration essential for enterprise
- Automated deployment reduces errors

*Full internal analysis: .agents/brainstorm/client/fortune500-deployment-20240124.yml*
```

**Benefits**:
- ✅ Community learns from generic patterns
- ✅ Client confidentiality maintained
- ✅ No competitive disadvantage
- ✅ Full audit trail in private

---

## 🔍 Classification Decision Tree

```
New brainstorm topic
│
├─ Does it mention client names/specifics?
│  ├─ YES → PRIVATE (.agents/brainstorm/client/)
│  └─ NO → Continue
│
├─ Does it contain financial numbers ($, revenue, costs)?
│  ├─ YES → PRIVATE (.agents/brainstorm/budget/)
│  └─ NO → Continue
│
├─ Would competitors benefit from this info?
│  ├─ YES → PRIVATE (.agents/brainstorm/competitive/)
│  └─ NO → Continue
│
├─ Is it a security vulnerability (unfixed)?
│  ├─ YES → PRIVATE (.agents/brainstorm/security/)
│  └─ NO → Continue
│
├─ Is it general technical discussion?
│  ├─ YES → PUBLIC (brainstorm/sessions/)
│  └─ UNCERTAIN → PRIVATE (safer default)
```

**Rule of Thumb**: When uncertain, default to PRIVATE. Better safe than leaked.

---

## ✅ Benefits of This Approach

### For `brainstorm/` (PUBLIC)
- ✅ **Git versioning**: Full history and audit trail
- ✅ **Collaboration**: Community can participate
- ✅ **Knowledge sharing**: Helps other projects
- ✅ **Transparency**: Shows decision-making process
- ✅ **Recruitment**: Demonstrates expertise
- ✅ **SEO**: Documentation benefits project visibility

### For `.agents/brainstorm/` (PRIVATE)
- ✅ **Confidentiality**: Protects business secrets
- ✅ **Competitive advantage**: Keep proprietary info private
- ✅ **Client trust**: NDA compliance
- ✅ **Risk mitigation**: No security exposure
- ✅ **Flexibility**: Discuss sensitive topics freely
- ✅ **Audit trail**: Still tracked locally

---

## 🛡️ Security Enforcement

### Automated Checks

```bash
# Before every commit
bash .agents/scripts/verify_security.sh

# Checks:
✓ .agents/ in .gitignore
✓ No .agents/ files staged
✓ No sensitive keywords in public files
✓ No accidental leaks
```

### Pre-commit Hook

Install git hook to prevent accidents:

```bash
# .git/hooks/pre-commit
#!/bin/bash
if git diff --cached --name-only | grep -q "^\.agents/"; then
    echo "ERROR: Attempting to commit .agents/ files!"
    echo "These files contain CONFIDENTIAL information."
    exit 1
fi
```

### Manual Review

Before committing public brainstorms:
1. ✓ No client names
2. ✓ No specific costs or revenue numbers
3. ✓ No competitive strategy details
4. ✓ No proprietary algorithms
5. ✓ No security vulnerabilities (unfixed)

---

## 📊 Real-World Examples

### Example 1: Testing Infrastructure ✅ PUBLIC

**Question**: "Should we use GitHub Actions or Docker for testing CMD scripts?"

**Classification**: PUBLIC (`brainstorm/sessions/active/testing-20240124.yml`)

**Rationale**:
- General technical problem many projects face
- No competitive disadvantage (standard tools)
- Benefits open-source community
- Demonstrates thought process

**Content Sample**:
```yaml
options:
  - GitHub Actions Windows Runner (free tier)
  - Docker Windows Containers
  - AWS EC2 Windows instances
  
decision: GitHub Actions
reasoning:
  - Free for open-source
  - Native Windows support
  - No maintenance overhead
  - 2-3 min build times acceptable
```

---

### Example 2: Client Deployment ❌ PRIVATE

**Question**: "How to deploy for Fortune 500 Client X with 10K users?"

**Classification**: PRIVATE (`.agents/brainstorm/client/clientx-20240124.yml`)

**Rationale**:
- Contains client name (confidential)
- Reveals pricing structure ($50K for 10K users)
- Exposes cost margins (76% profit)
- Custom requirements (competitive advantage)

**Content Sample**:
```yaml
client: "Company X (Fortune 500)"
requirements:
  users: 10000
  budget: "$50,000"
  timeline: "Q1 2024"
  
financials:
  revenue: "$50,000"
  costs: "$12,000 (licenses + integration)"
  margin: "76%"
  
competitive_notes:
  - "Competitor Y quoted $75K (we're 33% cheaper)"
  - "Our AD integration 6 weeks faster"
```

---

### Example 3: Security Vulnerability 🌓 HYBRID

**Question**: "How to fix CVE-2024-XXXX in package installer?"

**Phase 1 - PRIVATE** (`.agents/brainstorm/security/cve-2024-xxxx-20240124.yml`):
```yaml
vulnerability: "CVE-2024-XXXX"
severity: "HIGH"
exploit: "CMD injection via package parameter"
affected_versions: "v0.6.x"
poc: "curl ... | cmd /c ..."

fix_plan:
  - Sanitize user input (week 1)
  - Add parameterization (week 2)
  - Deploy patch (week 3)
  
timeline:
  discovered: "2024-01-24"
  fix_deployed: "2024-02-10"
  public_disclosure: "2024-02-17"
```

**Phase 2 - PUBLIC** (`brainstorm/topics/cmd-injection-prevention.md`):
```markdown
# CMD Injection Prevention

## Problem
CMD scripts accepting user input can be vulnerable to injection attacks.

## Solution
1. Always sanitize user input
2. Use parameterized commands
3. Validate input against whitelist
4. Escape special characters

## Best Practices
- Never use `cmd /c %USER_INPUT%`
- Use variables: `set "INPUT=%~1"` then validate
- Check for dangerous characters: `| & ; < >`

*Published: 2024-02-17 (after vulnerability patched)*
```

---

## 🔄 Migration Path

### Private → Public

When private brainstorm becomes safe to share:

```bash
# 1. Review content
vi .agents/brainstorm/business/topic.yml

# 2. Sanitize
# Remove: client names, costs, specific numbers
# Keep: general lessons, technical decisions

# 3. Create public version
cp .agents/brainstorm/business/topic.yml \
   brainstorm/sessions/archived/topic-sanitized.yml

# 4. Edit to remove sensitive info
vi brainstorm/sessions/archived/topic-sanitized.yml

# 5. Git commit (public version only)
git add brainstorm/sessions/archived/topic-sanitized.yml
git commit -m "docs: add sanitized brainstorm on topic"
```

### Public → Private

If public brainstorm becomes sensitive:

```bash
# 1. Move to private
mv brainstorm/sessions/active/topic.yml \
   .agents/brainstorm/business/

# 2. Create tombstone
cat > brainstorm/sessions/active/topic-MOVED.md << EOF
# Topic Moved to Private

This brainstorm has been moved to private storage.

Reason: Discussion evolved to include client-specific requirements
Moved: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Contact: Project owner for internal access
EOF

# 3. Git commit
git add brainstorm/sessions/active/topic-MOVED.md
git rm brainstorm/sessions/active/topic.yml
git commit -m "docs: move sensitive brainstorm to private"
```

---

## 📋 Checklist for AI Assistants

Before creating a brainstorm:

```yaml
classification_checklist:
  - [ ] Read: .agents/guidelines/brainstorm_classification.md
  - [ ] Apply decision tree
  - [ ] Default to PRIVATE if uncertain
  - [ ] Document classification rationale
  
before_commit:
  - [ ] Run: bash .agents/scripts/verify_security.sh
  - [ ] Check: git status | grep .agents (should be empty)
  - [ ] Review: No client names in public docs
  - [ ] Verify: No financial data
  - [ ] Confirm: No competitive intelligence
```

---

## 🎯 Success Metrics

This system works when:

- ✅ 100% of brainstorms correctly classified
- ✅ Zero leaks of confidential information
- ✅ Public brainstorms provide community value
- ✅ Private brainstorms protect business interests
- ✅ Clear audit trail for all decisions
- ✅ Team knows when to use which location

---

## 📚 Documentation

- **Overview**: This file (BRAINSTORM_STRATEGY.md)
- **Private Guide**: `.agents/brainstorm/README.md`
- **Public Guide**: `brainstorm/README.md`
- **Classification**: `.agents/guidelines/brainstorm_classification.md`
- **Security**: `.agents/AGENTS.md`
- **Quick Start**: `.agents/QUICKSTART.md`

---

## ⚡ Quick Reference

```bash
# Public brainstorm (technical)
vi brainstorm/sessions/active/topic-20240124.yml

# Private brainstorm (business)
vi .agents/brainstorm/business/topic-20240124.yml

# Verify security
bash .agents/scripts/verify_security.sh

# Check classification
cat .agents/guidelines/brainstorm_classification.md
```

---

**Last Updated**: 2024-01-24  
**Maintained By**: Project Owner  
**AI Assistant Training**: Required reading before brainstorming
