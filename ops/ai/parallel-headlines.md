# Parallel AI Workflow Headlines

This note summarises the principles the team follows when multiple AI agents collaborate in the repository. Detailed specifications live under `.agents/`.

- **Contracts First**: Freeze interfaces (OpenAPI/JSON Schema/UI docs) before parallel implementation work begins.
- **Distinct Branches**: Each agent works on a branch named per `ops/git/branching.md`, recording author and runner roles.
- **Specs in Repo**: Every task carries a `specs/<ticket>/` package (plan, mocks, fixtures) so runners can act without blocking others.
- **Daily Sync**: Rebase with `main` at least once every 24 hours; log hand-offs in `.agents/backlog.yml` and `.agents/decision_log.yml`.
- **CI Matrix**: Lint, unit, contract, and e2e jobs run in parallel; contract tests must stay green before merging.
- **Feature Flags**: Incomplete features ship behind toggles; merge only when rollout and rollback notes exist.
- **@codex Workflow**: Use GitHub mentions (`@codex review`, `@codex fix comments`, `@codex <task>`) for cloud execution, then manually review diffs before merge.
- **Human Checkpoint**: Sensitive changes (security, data handling, architecture) require human approval even if Codex signs off.

For execution-level guidance, see `.agents/parallel_operations.yml` and related playbooks.
