# Brainstorm Workflow - Complete Guide
**Created:** 2025-10-23  
**Author:** GitHub Copilot CLI (based on user feedback)  
**Version:** 1.0

---

## 🎯 **Triết Lý: Dialogue Có Chiều Sâu, Không Phải Q&A**

### **❌ Brainstorm Sai:**
```
Questioner: "Should we do X?"
Responder: "Yes."
Result: No artifacts, no learning, shallow
```

### **✅ Brainstorm Đúng:**
```
Questioner: 
  - "Should we do X?"
  - "What if we DON'T do X - what breaks?"
  - Evidence: File:line showing problem
  
Responder:
  - "AGREE but only if condition Y met"
  - Evidence: Command output supporting view
  - Reverse-check: "What if MY view is wrong?"
  - Alternative: "Have we considered Z?"

Facilitator:
  - Synthesize: "3 AGREE, 1 CONDITIONAL"
  - Artifacts: LL-XXX created, CP-XXX updated
  - Conflicts: CONF-001 escalated to human
  
Result: Tangible outcomes, documented reasoning
```

---

## 📋 **3-Round Workflow**

### **Round 1: Questioner (Opening Move)**

**Role:** Surface assumptions, identify gaps, propose solutions

**Deliverables:**
- `observations` section with evidence
- Reverse-thinking prompts for each observation
- Initial proposals (SOL-001, SOL-002, etc.)
- Critical questions (CQ-001, CQ-002, etc.)

**Example:**
```yaml
observations:
  - id: OBS-001
    topic: "Framework assumes Node.js"
    evidence: "parallel_operations.yml:22 mentions contracts/"
    
    reverse_thinking:
      prompt: "What if NO override file - how do agents adapt?"
      scenarios:
        - "Agent wastes time creating package.json"
        - "Agent confused, escalates to human"
      insight: "Override file is necessity, not nice-to-have"
    
    question_for_others: |
      How do YOU handle project type mismatches?
      Alternative solutions to override files?
```

---

### **Round 2: Responders (Counter-Move)**

**Role:** Challenge proposals, provide alternatives, vote with evidence

**Deliverables:**
- Position on each observation (AGREE/DISAGREE/CONDITIONAL)
- Evidence-based reasoning
- Reverse-thinking check on OWN position
- Alternative proposals
- Artifacts to create (LL-XXX, CP-XXX suggestions)

**Example:**
```yaml
responses:
  - responder:
      agent: "Gemini"
      timestamp: "2025-10-23T15:00:00Z"
    
    observations:
      - addresses: [OBS-001]
        position: AGREE
        
        reasoning: |
          Agree with override file (SOL-001) because:
          1. Separation of concerns - framework stays generic
          2. Precedent: Rust uses Cargo.toml, Python uses pyproject.toml
          3. Evidence: parallel_operations.yml clearly assumes Node.js
        
        evidence:
          - type: file_reference
            location: "parallel_operations.yml:22-26"
          - type: precedent
            project: "rust-lang/cargo (config overrides)"
        
        reverse_thinking_check:
          question: "What if override file is WRONG approach?"
          alternative: "Inline conditional sections in main framework"
          weakness: "Adds doc overhead - agents may skip reading"
        
        alternative_proposals:
          - proposal: "Auto-detect via file markers (.cmd, package.json)"
            vote: "WEAK_SUPPORT"
    
    artifacts_proposed:
      - type: lesson_learned
        id: "LL-021"
        content: "Multi-project frameworks need adaptation mechanism"
```

---

### **Round 3: Facilitator (Synthesis)**

**Role:** Build consensus, create artifacts, resolve conflicts

**Deliverables:**
- `decisions_made` with vote counts
- `artifacts_created` (LL/CP/DEC with commit SHAs)
- `unresolved_conflicts` with escalation paths
- `process_learnings` (meta-analysis)

**Example:**
```yaml
synthesis:
  status: "Complete"
  facilitator: "GitHub Copilot CLI"
  
  decisions_made:
    - decision_id: DEC-001
      topic: "CMD override file (SOL-001)"
      outcome: "APPROVED"
      votes: {AGREE: 3, DISAGREE: 0, CONDITIONAL: 1}
      implementation:
        status: "✅ Complete"
        commit: "1335136"
        file: ".agents/cmd_project_adaptations.yml"
  
  artifacts_created:
    - artifact_type: lesson_learned
      id: "LL-020"
      status: "✅ Merged"
      commit: "1335136"
  
  unresolved_conflicts:
    - conflict_id: CONF-001
      topic: "Merge SLA (48h vs 72h)"
      escalation:
        to: "User (tamld)"
        decision_by: "2025-10-25"
```

---

## 🔄 **Reverse-Thinking Protocol**

### **Purpose:**
Uncover hidden assumptions, prevent groupthink, force critical analysis

### **How It Works:**

**For Every Proposal:**
1. State the proposal: "We should do X"
2. Ask reverse: "What if we DON'T do X?"
3. List scenarios of what breaks
4. Extract insight: Is X necessary or nice-to-have?

**For Every Response:**
1. State your position: "I AGREE with X"
2. Ask reverse of self: "What if MY view is wrong?"
3. Identify weakness in own argument
4. Propose alternative

### **Examples:**

**Reverse on Proposals:**
```yaml
# Proposal: "Create 48h merge SLA"
reverse_thinking:
  prompt: "What if branches NEVER have deadlines?"
  scenarios:
    - "Branches stale for weeks → merge conflicts"
    - "Agent uncertainty: when is work 'done'?"
    - "Lost context when revisiting old branches"
  insight: "Some SLA needed, but 48h may be too strict"
```

**Reverse on Own Position:**
```yaml
# Your position: "AGREE with 48h SLA"
reverse_thinking_check:
  question: "What if 48h is TOO strict?"
  alternative: "72h might be more realistic"
  weakness: "I'm prioritizing velocity over human availability"
```

---

## 📊 **Evidence Requirements**

### **Acceptable Evidence:**
- ✅ File citations: `parallel_operations.yml:22-26`
- ✅ Command outputs: `ls contracts/ → No such file`
- ✅ Git evidence: `Branch age: 3 days (git log)`
- ✅ Metrics: `CI pass rate: 60% (from metrics_log.yml)`
- ✅ Test results: `CI run 18742307742 failed on step 3`
- ✅ Precedents: `Cargo.toml in Rust projects`

### **Unacceptable Evidence:**
- ❌ "I think..."
- ❌ "Best practice says..."
- ❌ "Usually..."
- ❌ "Most projects..."
- ❌ Hand-waving generalizations

---

## 🎨 **Artifact Types**

### **Lesson Learned (LL-XXX)**
**When:** Brainstorm reveals mistake or gap in practice

**Template:**
```yaml
- id: LL-XXX
  topic: "Brief topic"
  problem: "What went wrong"
  root_cause: "Why it happened"
  solution: "How to fix"
  evidence: "Proof this is real issue"
  date_identified: "YYYY-MM-DD"
```

**Example from This Brainstorm:**
- LL-019: Test validity gap
- LL-020: Framework-project mismatch

---

### **Core Principle (CP-XXX)**
**When:** Consensus on new rule or value

**Template:**
```yaml
- id: CP-XXX
  name: "Principle name"
  description: "What the rule is"
  implementation: "How to follow it"
```

**Example (Proposed):**
- CP-006: Merge Velocity Principle (48h SLA)

---

### **Decision (DEC-XXX)**
**When:** Strategic choice made or deferred

**Template:**
```yaml
- decision_id: DEC-XXX
  topic: "What was decided"
  outcome: "The decision"
  votes: {AGREE: X, DISAGREE: Y, CONDITIONAL: Z}
  rationale: "Why this decision"
  alternatives_considered: ["Alt 1", "Alt 2"]
  evidence: "Supporting data"
```

---

## ⚖️ **Conflict Resolution**

### **Conflict Types:**

| Type | Example | Resolution | Escalation |
|------|---------|------------|------------|
| **Factual** | "Test coverage is 80%" vs "20%" | Run coverage tool, measure | If data ambiguous, escalate |
| **Value** | "Speed > safety" vs "Safety > speed" | Cannot resolve with data | ALWAYS escalate to human |
| **Scope** | "Fix now" vs "Defer to Phase 2" | Check roadmap priorities | If unclear, escalate |
| **Technical** | "Approach X" vs "Approach Y" | Spike/experiment with both | If no winner, escalate |

### **Escalation Template:**
```yaml
unresolved_conflicts:
  - conflict_id: CONF-001
    type: "value_judgment | factual | scope | technical"
    
    positions:
      - agent: A
        stance: "Position A"
        evidence: "Why"
      - agent: B
        stance: "Position B"
        evidence: "Why"
    
    escalation:
      to: "human | experiment | senior_agent"
      decision_by: "YYYY-MM-DD"
      default_if_no_decision: "Conservative fallback"
```

---

## 📐 **Quality Standards**

### **Minimum Participation:**
- ≥2 agents responded (otherwise low confidence)
- ≥80% responses include evidence
- ≥50% used reverse-thinking check

### **Artifact Creation:**
- ≥1 artifact per brainstorm (otherwise, why discuss?)
- All artifacts have commit SHA (traceability)
- All artifacts reference brainstorm file

### **Closure:**
- All decisions have vote counts
- All conflicts have escalation paths
- process_learnings filled (meta-analysis)

---

## 🛠️ **Tools & Templates**

### **For Questioners (Round 1):**
```bash
# Start new brainstorm
cp .agents/templates/brainstorm_template.yml \
   .agents/brainstorm_<topic>.yml

# Fill sections:
# - metadata
# - problem_statement
# - observations (with reverse-thinking)
# - proposed_solutions
# - critical_questions
```

### **For Responders (Round 2):**
```yaml
# Copy response template from brainstorm file
# Fill with:
# - Your position (AGREE/DISAGREE/CONDITIONAL)
# - Evidence (file:line, commands, metrics)
# - Reverse-thinking check on YOUR position
# - Alternative proposals
# - Artifacts you propose
```

### **For Facilitators (Round 3):**
```bash
# Read facilitator guide
cat .agents/templates/facilitator_guide.md

# Synthesize responses
# Create artifacts
# Document conflicts
# Update brainstorm status
```

---

## 📈 **Success Metrics**

### **Process Quality:**
- Participation rate: ≥50% invited agents respond
- Evidence depth: ≥80% responses cite sources
- Reverse-thinking: ≥50% use it

### **Outcome Quality:**
- Artifacts created: ≥1 per brainstorm
- Consensus strength: ≥75% votes aligned
- Conflicts resolved: ≥80% don't escalate

### **Meta-Learning:**
- Process improvements: Document in each brainstorm
- Template evolution: Update based on learnings

---

## 🎯 **Current Status (Branch: docs/multi-agent-framework-improvements)**

### **Files Created:**
1. `.agents/brainstorm_cmd_project_constraints.yml` (refactored with workflow)
2. `.agents/templates/brainstorm_template.yml` (reusable template)
3. `.agents/templates/facilitator_guide.md` (Round 3 guide)
4. `.agents/BRAINSTORM_WORKFLOW_GUIDE.md` (this file)

### **Commits:**
- `1335136`: Initial framework docs
- `b636708`: Brainstorm workflow with reverse-thinking

### **Next Steps:**
1. ✅ Files pushed to remote
2. 🟡 Tag Gemini/Codex on PR #3
3. 🟡 Wait for Round 2 responses
4. 🟡 Facilitate Round 3 synthesis

---

## 📚 **Related Documents**

| File | Purpose |
|------|---------|
| `.agents/templates/brainstorm_template.yml` | Start new brainstorms |
| `.agents/templates/facilitator_guide.md` | Round 3 consensus guide |
| `.agents/AGENTS.md` (Section 11) | Multi-agent collaboration rules |
| `.agents/lessons_learned.yml` (LL-013) | Evidence requirements |
| `.agents/multi_agent_stability_plan.yml` | Action plan context |

---

**Created by:** GitHub Copilot CLI  
**Inspired by:** User feedback on "tư duy ngược để tạo workflow có chiều sâu"  
**Status:** Active - Round 1 complete, awaiting Round 2 responses
