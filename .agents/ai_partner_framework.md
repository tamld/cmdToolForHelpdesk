# AI Partner Framework

Version: 1.0  
Last Updated: 2025-10-22  
Author: Codex agent

This document operationalises the "human leads, AI executes" model for production-grade work in `cmdToolForHelpdesk`. It expands on the headlines in `ops/ai/partner-headlines.md` and is binding for all agents.

---

## 1. Core Principles

1. **Spec-First, Not Code-First**  
   - Every production task requires a written specification before code generation.  
   - Specifications must follow the CARE structure (Context, Action/Requirements, Result, Evaluation) and live in `specs/<ticket>/plan.md`.
2. **Human Makes Decisions, AI Executes**  
   - Architectural choices, business logic trade-offs, and merge approvals remain human-owned.  
   - Agents implement, refactor, test, and report back.
3. **Context Engineering Over Prompt Tweaks**  
   - Provide curated inputs: `AGENTS.md`, relevant file snippets, design notes, error logs.  
   - Avoid dumping entire repositories into prompts.
4. **TDD & Red–Green–Refactor**  
   - Tests are written (or updated) before implementation.  
   - AI drafts minimal passing code; humans review and request refactors.
5. **Sequential PR Iteration**  
   - Use `@codex` comments for one task at a time on the same branch to avoid conflicts.  
   - After each iteration, inspect diffs and update backlog entries.
6. **Mandatory Quality Gates**  
   - CI matrix (lint, unit, contract, e2e) must pass.  
   - Security/performance-sensitive items require human approval even if Codex signs off.
7. **Measure, Learn, Adjust**  
   - Track metrics (handoff latency, CI pass rate, AI iteration count, human rework).  
   - Feed lessons into `.agents/lessons_learned.yml` and update this framework when needed.

---

## 2. Phase Breakdown

### Phase A – Ideation & Planning
- **Human**: Validate problem statements, define KPIs, prioritise features (MoSCoW).  
- **AI**: Provide market scans, persona templates, analogous solutions.  
- **Output**: Problem brief stored in `specs/<ticket>/notes.md` or linked doc.

### Phase B – Design & Specification
- Produce architecture sketches, component breakdowns, contracts.  
- Populate `AGENTS.md` with conventions if missing.  
- Draft CARE-compliant spec and attach to ticket folder.  
- Write initial test stubs (unit/integration) describing acceptance criteria.

### Phase C – Implementation Loop
1. Prepare context package (spec extracts, relevant files, tests).  
2. Request code skeleton from Codex (function signatures, placeholder logic).  
3. Iterate via Red–Green–Refactor with sequential `@codex` comments.  
4. Maintain feature flags and update `specs/<ticket>/handoff.md` after each iteration.

### Phase D – Validation & Review
- Run full CI matrix.  
- Perform human-led review using checklist (security, performance, code quality).  
- Ensure tests cover requirements and logs are clean.  
- Document outcomes in `.agents/decision_log.yml` if strategy shifts.

### Phase E – Refinement & Release
- Optimise performance after correctness is proven.  
- Clean up scaffolding, consolidate code, update docs.  
- Record lessons (`LL-***`) for future agents.  
- Coordinate feature-flag rollout and post-release monitoring.

---

## 3. Specification Requirements

Each spec in `specs/<ticket>/plan.md` must include:
- **Context**: Architecture, dependencies, relevant contracts.  
- **Requirements**: Functional + non-functional items, edge cases.  
- **Results**: Example inputs/outputs, success criteria.  
- **Evaluation**: Performance/security thresholds, tests to run.  
- **Testing Plan**: Unit/integration/e2e coverage expectations.  
- **Risks & Flags**: Feature flag names, rollout plan, rollback plan.

Templates: reuse or adapt from `specs/template-plan.md` (create if absent).

---

## 4. Context Engineering Checklist

Before delegating to Codex:
1. Confirm `AGENTS.md` and relevant guidelines are up to date.  
2. Collect only the necessary files (e.g., similar modules, schema definitions).  
3. Provide error logs or test failures if iterating on a bug.  
4. Summarise spec sections to fit context length; link to full plan.  
5. Clarify desired artefacts (files to edit, tests to update, expected output format).  
6. Note environmental constraints (sandbox mode, network access, scripts allowed).  
7. Update `.agents/backlog.yml` with context summary for other agents.

---

## 5. Test & Quality Expectations

- **Unit Tests**: 60% of suite; AI drafts, human reviews.  
- **Integration Tests**: 30%; ensure module boundaries.  
- **E2E Tests**: 10%; critical flows only.  
- **Coverage Target**: ≥80% overall; highlight gaps in PR.  
- **Static Analysis**: Lint and security scans must pass.  
- **Manual QA**: Provide checklist when automated coverage is insufficient.

Human reviewers must confirm: no secrets/logging leaks, performance budgets met, type safety preserved, and comments explain complex logic.

---

## 6. Skeleton & Infrastructure Checklist

Before full implementation, ensure the following scaffolding exists (update spec if missing):
- CI/CD pipeline config.  
- Environment variable templates (`.env.example`) with validation.  
- Error handling/logging utilities.  
- Type definitions (TypeScript or equivalent).  
- Modular file structure and API contracts.  
- Database schema/migrations if applicable.  
- Authentication/authorisation skeleton.  
- Testing framework, linting, pre-commit hooks.  
- Observability hooks (logging, monitoring placeholders).  
- Security middleware (input validation, rate limiting, CORS).  
- Documentation stubs (README, AGENTS.md, ADRs, contributing guide).

If gaps exist, add tasks to backlog before implementation proceeds.

---

## 7. Metrics & Monitoring

Track the following (update `.agents/parallel_operations.yml` metrics if tooling changes):
- `handoff_latency_hours`: time from spec handoff to runner acknowledgement.  
- `ci_pass_rate`: percent of first-attempt success in CI.  
- `codex_iteration_count`: number of `@codex` cycles per PR.  
- `human_rework_ratio`: percentage of lines adjusted manually after AI output.  
- `spec_completeness_score`: audit measure (e.g., 0-1 scale) from spec checklist.

Review metrics weekly; open issues for persistent regressions.

---

## 8. Red Flags & Escalation

Pause work and escalate (issue + decision log entry) when:
- AI output repeatedly fails the same tests (likely spec/context gap).  
- Manual rework exceeds 30% of diff.  
- Security/performance violations appear.  
- Productivity drops despite AI assistance.  
- Tech debt accumulates faster than features ship.

Escalation protocol: update `.agents/decision_log.yml` with context, tag human owner, adjust spec or workflow before resuming.

---

## 9. Related References

- `ops/ai/parallel-headlines.md` — public summary.  
- `.agents/parallel_operations.yml` — parallel branch/role SOP.  
- `.agents/documentation_playbook.yml` — doc ownership rules.  
- `.agents/lessons_learned.yml` — ensure LL-011/LL-012 considered.  
- `AGENTS.md` — quick-start agent conventions.

Maintain this file as the definitive guide for AI collaboration. Update version and changelog upon modification.
