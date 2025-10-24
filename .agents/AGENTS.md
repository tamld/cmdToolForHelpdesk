# Agent Workflow & Conventions

This document is the Single Source of Truth (SSoT) for AI agents operating in the `cmdToolForHelpdesk` repository. All agents must adhere to these guidelines.

Agent scope and non-override etiquette

- This SSoT applies to all agents (GitHub Copilot, Gemini CLI, etc.) when working in this repository.
- Agent-specific instruction files (e.g., `GEMINI_INSTRUCTIONS.md` for Gemini CLI) may exist for runtime behavior, but they must not override this repo-level workflow, quality gates, or handoff protocols.
- If an agent-specific rule appears to conflict with this document, follow this document and raise a clarification in `.agents/brainstorm_*.yml` or the PR.

## 1. Workflow Protocol

- **Objective**: The primary role of an agent is to assist in software development tasks, including bug fixing, feature implementation, refactoring, and testing.
- **Core Work Loop**:
  1. **Understand**: Analyze the user's request and the existing codebase. Use tools like `search_file_content`, `glob`, and `read_file` extensively.
  2. **Plan**: Formulate a clear, step-by-step plan. For significant changes, present this plan to the user before execution.
  3. **Implement**: Use tools (`replace`, `write_file`, `run_shell_command`) to execute the plan.
  4. **Verify**: Run tests and linters to ensure changes are correct and adhere to project standards.
  5. **Document**: Before handoff or completion, create/update `.agents/branch_progress.yml` with complete context (see LL-014).
- **Git Operations**:
  - **Branching**: All work must be done on a descriptive branch following naming conventions:
    - Solo work: `feature/<domain>-<ticket>` (e.g., `feature/ci-spec-check-13`)
    - Multi-agent: `feature/<domain>-<ticket>-<aAuthor>-<rRunner>` (e.g., `feature/ci-spec-check-13-agemini-rcodex`)
  - **Marker Commits**: When starting a task, push a marker commit: `chore: claim task #X` for transparency.
  - **Commits**: Follow the commit message conventions (see section 5).
  - **Draft PRs**: Open draft PR immediately after first push for visibility to other agents.
  - **Handoff Ritual** (LL-014):
    - Before handoff OUT: `git commit -m "docs: prepare handoff for task #X"` with `handoff_ready: true` in branch_progress.yml
    - After handoff IN: `git commit -m "docs: acknowledge handoff from @agent"` with new owner recorded
  - **Codex Merge Delegation** (LL-015): After `@codex review`, leave a follow-up instruction (e.g., "@codex once CI is green ... merge") so Codex merges and deletes the branch automatically when checks pass; log the event in branch_progress milestones and metrics log.
  - **Pull Requests**: Once a feature or fix is complete and verified, open a Pull Request to the appropriate base branch (e.g., `refactor/*` -> `main`). Do not merge without approval.
  - **Workflow Reference**: See `ops/git/handbook.md` and `ops/git/branching.md` for multi-agent role definitions, branch naming, and handoff expectations.
  - **Parallel Operations Spec**: Follow `.agents/parallel_operations.yml` for detailed rules on multi-agent planning, Codex usage, and compliance.
  - **Human–AI Partnership**: Consult `.agents/ai_partner_framework.md` before delegating production tasks; it defines spec-first expectations, context engineering, and quality gates.
  - **Sustainable Philosophy**: Adhere to `ops/ai/philosophy-headlines.md` and `.agents/ai_philosophy_framework.yml` when bootstrapping new projects or upgrading legacy systems.
- **CI/CD Interaction**:
  - After pushing changes, monitor the CI pipeline using `gh run list`.
  - If a build fails, it is the agent's responsibility to investigate and fix it. Do not proceed with other tasks until the CI is green.

## 2. `.agents/` Directory Structure

This directory is the central hub for agent configuration and documentation.

| Path                          | Format      | Purpose                                                                 |
| ----------------------------- | ----------- | ----------------------------------------------------------------------- |
| `AGENTS.md`                   | Markdown    | This file. The primary guide for agent behavior and project conventions. |
| `lessons_learned.yml`         | YAML        | Structured log of lessons (LL-001 to LL-014) preventing repeated mistakes. |
| `backlog.yml`                 | YAML        | Tactical task tracking with status, owner, branch, dates. |
| `decision_log.yml`            | YAML        | Major strategic decisions, experiments, and outcomes. |
| `metrics_log.yml`             | YAML        | Manual tracking of multi-agent workflow metrics (handoff latency, CI pass rate). |
| `brainstorm_*.yml`            | YAML        | Multi-agent consensus files with observations + responder blocks. |
| `branch_progress.yml`         | YAML        | (In feature branches only) Comprehensive handoff documentation (LL-014). |
| `templates/`                  | Directory   | Templates for branch_progress.yml and other artifacts. |
| `scripts/`                    | Directory   | Automation scripts (e.g., validate_handoff.sh for LL-014 enforcement). |
| `logs/`                       | Directory   | Stores logs from agent operations or tool outputs. |
| `parallel_operations.yml`     | YAML        | Specification for multi-agent workflows and Codex interaction. |
| `documentation_playbook.yml`  | YAML        | Rules for splitting public vs agent-facing documentation. |
| `operational_model.yml`       | YAML        | SSoT entry point with 6-step SOP (read → plan → spec → code → test → reflect). |
| `ai_partner_framework.md`     | Markdown    | Comprehensive guide for human-led, AI-executed development. |
| `ai_philosophy_framework.yml` | YAML        | Sustainable philosophy for new/legacy projects and guardrail audits. |

## 3. Memory Rules

- **`save_memory` Tool**: This tool should ONLY be used to remember user-specific preferences or facts that persist across sessions (e.g., "My preferred language is Python", "Remember my alias is 'tamld'").
- **Project Context**: DO NOT use `save_memory` to store general project information, code snippets, or temporary context. The project files themselves are the source of truth for project context.

## 4. Error Handling & Feedback

- **Proactive Clarification**: If a user's request is ambiguous or conflicts with established rules, the agent MUST pause and ask for clarification before proceeding.
- **Action Confirmation**: For critical or destructive actions (e.g., deleting branches, overwriting files), the agent must explain the action and its potential impact, then ask for user confirmation before executing.

## 5. Commit Message Conventions

- **Format**: All commit messages MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.
  - Example: `feat(testing): add test for office-windows menu`
  - Example: `fix(ci): correct path in test runner`
  - Handoff commits: `docs: prepare handoff for task #X` or `docs: acknowledge handoff from @agent`
  - Marker commits: `chore: claim task #X` (first commit when starting work)
- **Content**: The commit message body (if present) should focus on the "why" behind the change, not just the "what".
- **Author**: All commits MUST be authored using the following identity: `tamld <ductam1828@gmail.com>`.

## 6. CI/CD Interaction

- **Status Checks**: After pushing a commit, use `gh run list --branch <branch-name>` to check the status of the triggered workflow.
- **Failure Analysis**: If a CI run fails, the **first step** is always to check the workflow file (`.github/workflows/*.yml`) for syntax errors. This is the most common cause of runs failing to even start.
- **Debugging**: For test failures, enhance the `test_runner.cmd` or individual test scripts with detailed `echo` statements to trace the execution flow and variable states.

## 7. Refactoring Process

- **Sensitive Variable Exclusion**: Before any automated refactoring, the agent must identify a list of variables and keywords that must not be renamed (e.g., system variables like `%errorlevel%`, magic strings like `"Enterprise"`). This list must be confirmed by the user.
- **Strategy**: Refactoring should be done in small, verifiable batches.
  1. Identify a self-contained functional area (e.g., a single menu).
  2. Refactor the code for that area.
  3. Add or update tests for that area.
  4. Commit the changes.
  5. Verify via CI before moving to the next area.

## 8. Decision Log

- A file named `.agents/decision_log.yml` MUST be maintained.
- It is used to log all major strategic decisions, experiments, and outcomes.
- **Structure**:

  ```yaml
  - branch: name-of-branch
    objective: "What was being attempted."
    strategic_review:
      timestamp: YYYY-MM-DD
      decision: "The decision that was made (e.g., pivot, proceed, abandon)."
      new_strategy: "Description of the new path forward."
    experiments:
      - id: number
        name: "Description of the experiment."
        outcome: "Success/Failure"
        conclusion: "What was learned."
  ```

## 9. Branching Strategy

This project follows a `strict`-like mode.

- All new work (features, fixes, refactors) must be done in a dedicated branch: `feature/*`, `fix/*`, or `refactor/*`.
- Direct commits to `main` are forbidden.
- Changes are integrated into `main` via Pull Requests, which must pass all CI checks.

## 10. Single Source of Truth (SSoT)

- **Primacy**: Documents within the `.agents/` and `.github/` directories are the primary SSoT for project status, strategy, and agent conventions.
- **3-Layer Architecture** (from highest to lowest priority):
  - **META Layer**: Immutable laws (e.g., LAW-REFLECT-001, LAW-CONTEXT-001) requiring human approval to change.
  - **HARD Layer**: Stable policies (e.g., GUIDELINE-PLAN-001) requiring multi-agent consensus and high bar to modify.
  - **SOFT Layer**: Adaptive practices in `lessons_learned.yml` (LL-001 to LL-014) that evolve through evidence-driven iteration.
- **Classification**:
  - **Strategic Plan**: Long-term vision and goals (`roadmap.yml`).
  - **Tactical Plan**: Immediate tasks and short-term goals (`backlog.yml`, issues, `decision_log.yml`). Agents should be primarily guided by the Tactical Plan for their current tasks.

## 11. Multi-Agent Collaboration

- **Consensus Pattern**: Use `.agents/brainstorm_<topic>.yml` for lightweight multi-agent discussions:
  - Append-only responder blocks (never edit others' observations)
  - Evidence-based responses: cite file:line, commit SHA, or backlog refs
  - Use AGREE/DISAGREE/CONDITIONAL with explicit reasoning
  - Attribution required: agent name + timestamp
- **Evidence Requirements** (LL-013):
  - All claims must be verifiable (file:line citations, command outputs)
  - Challenge incorrect evidence politely but firmly
  - Do not rubber-stamp responses without verification
- **Handoff Completeness** (LL-014):
  - Before marking task "Ready for handoff", create complete `.agents/branch_progress.yml` in feature branch
  - 7 mandatory sections: context, handoff checklist, progress/milestones, verification, rollback, communication, metrics
  - Run `.agents/scripts/validate_handoff.sh <branch>` to verify completeness
  - Use handoff ritual commits for traceability
- **Conflict Resolution**:
  - Never self-resolve conflicts between Global MCP and repo instructions
  - Escalate to user with: evidence of conflict, proposed resolution, impact assessment
  - Document resolution in `decision_log.yml`
