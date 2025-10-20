# Agent Workflow & Conventions

This document is the Single Source of Truth (SSoT) for AI agents operating in the `cmdToolForHelpdesk` repository. All agents must adhere to these guidelines.

## 1. Workflow Protocol

- **Objective**: The primary role of an agent is to assist in software development tasks, including bug fixing, feature implementation, refactoring, and testing.
- **Core Work Loop**:
    1.  **Understand**: Analyze the user's request and the existing codebase. Use tools like `search_file_content`, `glob`, and `read_file` extensively.
    2.  **Plan**: Formulate a clear, step-by-step plan. For significant changes, present this plan to the user before execution.
    3.  **Implement**: Use tools (`replace`, `write_file`, `run_shell_command`) to execute the plan.
    4.  **Verify**: Run tests and linters to ensure changes are correct and adhere to project standards.
- **Git Operations**:
    - **Branching**: All work must be done on a descriptive branch (e.g., `feature/new-menu`, `refactor/test-coverage`).
    - **Commits**: Follow the commit message conventions (see section 5).
    - **Pull Requests**: Once a feature or fix is complete and verified, open a Pull Request to the appropriate base branch (e.g., `refactor/*` -> `main`). Do not merge without approval.
- **CI/CD Interaction**:
    - After pushing changes, monitor the CI pipeline using `gh run list`.
    - If a build fails, it is the agent's responsibility to investigate and fix it. Do not proceed with other tasks until the CI is green.

## 2. `.agents/` Directory Structure

This directory is the central hub for agent configuration and documentation.

| Path                          | Format      | Purpose                                                                 |
| ----------------------------- | ----------- | ----------------------------------------------------------------------- |
| `AGENTS.md`                   | Markdown    | This file. The primary guide for agent behavior and project conventions. |
| `*.yml`                       | YAML        | Agent-readable configuration, rules, and logs (e.g., `decision_log.yml`). |
| `*.json`                      | JSON        | Data files, state information.                                          |
| `logs/`                       | Directory   | Stores logs from agent operations or tool outputs.                      |
| `*.example`                   | Any         | Template or example files.                                              |

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
- **Content**: The commit message body (if present) should focus on the "why" behind the change, not just the "what".
- **Author**: All commits MUST be authored using the following identity: `tamld <ductam1828@gmail.com>`.

## 6. CI/CD Interaction

- **Status Checks**: After pushing a commit, use `gh run list --branch <branch-name>` to check the status of the triggered workflow.
- **Failure Analysis**: If a CI run fails, the **first step** is always to check the workflow file (`.github/workflows/*.yml`) for syntax errors. This is the most common cause of runs failing to even start.
- **Debugging**: For test failures, enhance the `test_runner.cmd` or individual test scripts with detailed `echo` statements to trace the execution flow and variable states.

## 7. Refactoring Process

- **Sensitive Variable Exclusion**: Before any automated refactoring, the agent must identify a list of variables and keywords that must not be renamed (e.g., system variables like `%errorlevel%`, magic strings like `"Enterprise"`). This list must be confirmed by the user.
- **Strategy**: Refactoring should be done in small, verifiable batches.
    1.  Identify a self-contained functional area (e.g., a single menu).
    2.  Refactor the code for that area.
    3.  Add or update tests for that area.
    4.  Commit the changes.
    5.  Verify via CI before moving to the next area.

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
- **Classification**:
    - **Strategic Plan**: Long-term vision and goals (e.g., a future `ROADMAP.md`).
    - **Tactical Plan**: Immediate tasks and short-term goals (e.g., `TODO.md`, issues, items in `decision_log.yml`). Agents should be primarily guided by the Tactical Plan for their current tasks.
