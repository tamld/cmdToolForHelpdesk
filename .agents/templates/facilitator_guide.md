# Brainstorm Facilitator Guide
# Version: 1.0
# Role: Guide for Round 3 consensus-building and artifact creation

# ========================================================================
# FACILITATOR RESPONSIBILITIES
# ========================================================================
responsibilities:
  core_duties:
    - "Read ALL Round 1 observations and Round 2 responses"
    - "Identify consensus areas and conflicts"
    - "Synthesize decisions with evidence"
    - "Create artifacts (lessons, principles, process updates)"
    - "Document unresolved conflicts with escalation path"
    - "Close brainstorm loop (archive or schedule Round 4 if needed)"
  
  not_your_job:
    - "Making unilateral decisions on contentious items"
    - "Ignoring minority opinions without analysis"
    - "Creating artifacts without responder input"
    - "Closing brainstorm before genuine discussion occurs"

# ========================================================================
# ROUND 3 WORKFLOW
# ========================================================================
workflow:
  step_1_intake:
    name: "Read and Categorize Responses"
    actions:
      - "Count responses (target: ≥2 agents for meaningful consensus)"
      - "Categorize positions: unanimous, majority, split, no consensus"
      - "Flag high-quality responses (evidence-rich, reverse-thinking used)"
      - "Identify gaps (questions not answered, shallow reasoning)"
    
    output: "Position matrix (which agent supports which proposal)"
  
  step_2_consensus_analysis:
    name: "Identify Consensus and Conflicts"
    
    consensus_criteria:
      unanimous: "All responders AGREE (easy decision)"
      strong_majority: "≥75% AGREE, no major objections (implement with notes)"
      weak_majority: "51-74% AGREE (implement with caution, monitor)"
      split: "50/50 or close (escalate or experiment)"
      no_consensus: "Wildly divergent views (escalate to human)"
    
    actions:
      - "Group proposals by consensus level"
      - "Extract common themes from CONDITIONAL responses"
      - "Identify if disagreement is factual (test) or values-based (escalate)"
    
    output: "Decisions matrix (implement/defer/escalate)"
  
  step_3_artifact_creation:
    name: "Create Tangible Deliverables"
    
    artifact_types:
      - type: "Lesson Learned (LL-XXX)"
        when: "Brainstorm reveals mistake or gap in current practice"
        template: ".agents/lessons_learned.yml"
        required_fields:
          - "problem"
          - "root_cause"
          - "solution"
          - "evidence"
        
      - type: "Core Principle (CP-XXX)"
        when: "Consensus on new rule or value"
        template: ".agents/core_principles.yml"
        required_fields:
          - "name"
          - "description"
          - "implementation"
        
      - type: "Operational Update"
        when: "Process/workflow improvement identified"
        files:
          - ".agents/operational_model.yml"
          - ".agents/project_workflow.yml"
          - ".agents/parallel_operations.yml"
        
      - type: "Decision Log Entry"
        when: "Strategic decision made or deferred"
        template: ".agents/decision_log.yml"
        required_fields:
          - "decision"
          - "rationale"
          - "alternatives_considered"
          - "evidence"
    
    quality_checklist:
      - "[ ] Artifact has unique ID (LL-XXX, CP-XXX, DEC-XXX)"
      - "[ ] Includes evidence trail (commit SHA, file refs, responder names)"
      - "[ ] Actionable (next steps clear)"
      - "[ ] Versioned (date, author recorded)"
      - "[ ] Linked to brainstorm file (cross-reference)"
  
  step_4_conflict_resolution:
    name: "Handle Unresolved Conflicts"
    
    conflict_types:
      - type: "Factual Disagreement"
        example: "Agent A says 'tests cover 80%', Agent B says '20%'"
        resolution: "Run coverage tool, measure, decide with data"
        escalation: "If data ambiguous or missing, escalate to human"
        
      - type: "Value Judgment"
        example: "Agent A prioritizes speed, Agent B prioritizes safety"
        resolution: "Cannot be resolved with data - this is risk tolerance"
        escalation: "ALWAYS escalate to human (project owner decides values)"
        
      - type: "Scope Disagreement"
        example: "Agent A wants to solve now, Agent B wants to defer"
        resolution: "Check roadmap/backlog priorities"
        escalation: "If priorities unclear, escalate to human"
        
      - type: "Technical Approach"
        example: "Agent A prefers approach X, Agent B prefers Y"
        resolution: "Spike/experiment with both, compare results"
        escalation: "If no clear winner after experiment, escalate"
    
    escalation_template: |
      unresolved_conflicts:
        - conflict_id: CONF-XXX
          topic: "Brief description"
          positions:
            - agent: "Agent A"
              stance: "Position A"
              evidence: "Why they think this"
            - agent: "Agent B"
              stance: "Position B"
              evidence: "Why they think this"
          
          analysis:
            type: "factual | value | scope | technical"
            attempted_resolution: "What we tried"
            why_stuck: "Root cause of impasse"
          
          escalation:
            to: "human | senior_agent | experiment"
            decision_by: "User (tamld) | Codex | Data"
            deadline: "YYYY-MM-DD or null"
            default_if_no_decision: "What happens if deadline passes"
  
  step_5_documentation:
    name: "Update Brainstorm File and Close Loop"
    
    updates_required:
      - section: "synthesis.decisions_made"
        content: "All consensus decisions with vote counts"
        
      - section: "synthesis.artifacts_created"
        content: "List of LL/CP/DEC created with file paths"
        
      - section: "synthesis.unresolved_conflicts"
        content: "Conflicts with escalation info"
        
      - section: "synthesis.process_learnings"
        content: "Meta-learnings about brainstorm effectiveness"
    
    closure_actions:
      - "Update brainstorm status: 'Complete' or 'Escalated'"
      - "Commit artifacts to appropriate files"
      - "Update backlog if new tasks emerged"
      - "Notify participants (PR comment or issue)"
      - "Archive brainstorm or schedule follow-up if needed"

# ========================================================================
# QUALITY STANDARDS
# ========================================================================
quality_standards:
  minimum_participation:
    threshold: "≥2 agents responded"
    if_not_met: "Extend Round 2 deadline or note low participation"
  
  evidence_depth:
    threshold: "≥80% of responses include file/command evidence"
    if_not_met: "Flag shallow responses, request elaboration"
  
  reverse_thinking_usage:
    threshold: "≥50% of responses used reverse-thinking check"
    if_not_met: "Note in process_learnings, encourage in future"
  
  artifact_creation:
    threshold: "≥1 artifact per brainstorm (otherwise, why did we discuss?)"
    if_not_met: "Question if brainstorm was premature or topic unclear"

# ========================================================================
# COMMON PITFALLS
# ========================================================================
common_pitfalls:
  - pitfall: "Declaring consensus prematurely"
    sign: "Only 1-2 responses, but marked as 'consensus'"
    prevention: "Wait for ≥2 agents, or note low participation"
    
  - pitfall: "Ignoring CONDITIONAL votes"
    sign: "CONDITIONAL responses not analyzed for common conditions"
    prevention: "Extract conditions, see if majority shares same concerns"
    
  - pitfall: "Creating artifacts without responder input"
    sign: "Facilitator writes LL-XXX without citing responders"
    prevention: "Artifacts must reference specific responses"
    
  - pitfall: "Avoiding difficult escalations"
    sign: "Conflict logged as 'unresolved' without clear next steps"
    prevention: "Always provide escalation path and decision-by date"
    
  - pitfall: "No meta-learning"
    sign: "Brainstorm closes without process_learnings section filled"
    prevention: "Always reflect on brainstorm effectiveness"

# ========================================================================
# EXAMPLE SYNTHESIS (Good Practice)
# ========================================================================
example_synthesis: |
  synthesis:
    status: "Complete"
    facilitator: "GitHub Copilot CLI"
    completed_at: "2025-10-23T16:00:00Z"
    
    decisions_made:
      - decision_id: DEC-001
        topic: "CMD project adaptations file (SOL-001)"
        outcome: "APPROVED - Create .agents/cmd_project_adaptations.yml"
        votes:
          AGREE: 3  # Copilot, Gemini, Codex
          DISAGREE: 0
          CONDITIONAL: 1  # Agent X: "Only if referenced in operational_model"
        
        implementation:
          status: "✅ Complete"
          commit: "1335136"
          file: ".agents/cmd_project_adaptations.yml"
          conditions_met: "Referenced in operational_model.yml:55"
        
        evidence:
          - "Gemini response: AGREE (cited parallel_operations.yml mismatch)"
          - "Codex response: AGREE (precedent in Rust/Cargo projects)"
          - "Agent X: CONDITIONAL (concern about doc overhead - mitigated)"
      
      - decision_id: DEC-002
        topic: "48h merge SLA (CONS-001)"
        outcome: "DEFERRED - Need human input on timeline"
        votes:
          AGREE: 2  # Copilot, Codex
          DISAGREE: 0
          CONDITIONAL: 1  # Gemini: "72h more realistic"
        
        rationale: "Value judgment - balance velocity vs human availability"
        escalation:
          to: "User (tamld)"
          question: "48h vs 72h merge SLA - what's realistic for your cadence?"
          decision_by: "2025-10-25"
          default: "72h if no response (conservative)"
    
    artifacts_created:
      - artifact_type: "lesson_learned"
        id: "LL-019"
        file: ".agents/lessons_learned.yml"
        status: "✅ Merged"
        commit: "1335136"
        topic: "Test validity gap"
        
      - artifact_type: "lesson_learned"
        id: "LL-020"
        file: ".agents/lessons_learned.yml"
        status: "✅ Merged"
        commit: "1335136"
        topic: "Framework-project type mismatch"
      
      - artifact_type: "process_update"
        file: ".agents/operational_model.yml"
        status: "✅ Merged"
        commit: "1335136"
        change: "Added project type detection to SOP step 1"
    
    unresolved_conflicts:
      - conflict_id: CONF-001
        topic: "Merge SLA timeline (48h vs 72h)"
        type: "value_judgment"
        positions:
          - agent: "Copilot"
            stance: "48h"
            reasoning: "Prevent branch drift, force small PRs"
          - agent: "Gemini"
            stance: "72h"
            reasoning: "More realistic for part-time maintainers"
        
        escalation:
          to: "human"
          decision_by: "User (tamld)"
          question: "What merge cadence matches your availability?"
          options: ["48h (strict)", "72h (balanced)", "96h (relaxed)", "No SLA"]
    
    process_learnings:
      - learning: "Reverse-thinking prompts highly effective"
        evidence: "2/3 responders caught flaws in own arguments"
        action: "Make reverse-thinking mandatory in template"
        
      - learning: "Evidence requirement prevented hand-waving"
        evidence: "100% of responses cited file:line or command output"
        action: "Continue enforcing LL-013"
        
      - learning: "Low participation (3 agents) limits consensus strength"
        evidence: "DEC-001 passed but only 3 votes"
        action: "For critical decisions, invite ≥4 agents or wait longer"

# ========================================================================
# FACILITATOR CHECKLIST
# ========================================================================
facilitator_checklist:
  before_round_3:
    - "[ ] ≥2 agents responded in Round 2"
    - "[ ] All responses follow template (evidence, reverse-thinking)"
    - "[ ] No responses are empty or placeholder"
    - "[ ] Enough time elapsed (≥48h for agents to respond)"
  
  during_synthesis:
    - "[ ] Read ALL observations and responses thoroughly"
    - "[ ] Create position matrix (which agent supports what)"
    - "[ ] Identify consensus levels (unanimous, majority, split)"
    - "[ ] Extract common themes from CONDITIONAL votes"
    - "[ ] Draft artifacts with responder citations"
    - "[ ] Document conflicts with clear escalation"
    - "[ ] Reflect on brainstorm process effectiveness"
  
  before_closing:
    - "[ ] All decisions have vote counts"
    - "[ ] All artifacts have status (drafted/merged/pending)"
    - "[ ] All conflicts have escalation paths"
    - "[ ] process_learnings section filled"
    - "[ ] Participants notified (PR comment or issue)"
    - "[ ] Brainstorm file committed and pushed"

# ========================================================================
# RELATED DOCUMENTS
# ========================================================================
related_documents:
  - file: ".agents/templates/brainstorm_template.yml"
    purpose: "Template for new brainstorms"
    
  - file: ".agents/AGENTS.md"
    section: "11. Multi-Agent Collaboration"
    purpose: "Consensus pattern guidelines"
    
  - file: ".agents/lessons_learned.yml"
    section: "LL-013"
    purpose: "Evidence requirements"
    
  - file: ".agents/core_principles.yml"
    purpose: "Where to add new CP-XXX principles"
    
  - file: ".agents/decision_log.yml"
    purpose: "Where to log strategic decisions"
