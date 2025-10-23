# Sustainable AI Delivery Philosophy

- **Spec Foundations for Every Project**: Whether greenfield or legacy, begin by translating goals into CARE specs and test charters before coding.
- **Human Governance, AI Compliance**: Humans set strategy, guardrails, and approvals; AI agents execute, audit, and surface deviations.
- **Context Before Action**: Capture objectives, constraints, environment state, and success metrics in `specs/` packages before delegating to Codex.
- **Dual Path Onboarding**: New projects bootstrap with the philosophy from day zero; existing projects add protective layers (contracts, tests, flags) before major AI-driven changes.
- **Parallel with Safeguards**: Multi-agent work uses named branches, handoff logs, and CI matrices to maintain stability while scaling throughput.
- **Continuous Verification**: Codex enforces checklists, regenerates tests, and reports metrics (handoff latency, rework) so humans can steer using data.
- **Learning Loop**: Feed incidents and improvements into `.agents/lessons_learned.yml` and evolve the framework without breaking prior commitments.

Detailed operational rules for agents: `.agents/ai_philosophy_framework.yml`.
