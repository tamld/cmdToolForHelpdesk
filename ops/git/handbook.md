# Multi-Agent Git Workflow Handbook

This handbook describes how authors, runners, and reviewers collaborate through Git in the `cmdToolForHelpdesk` repository.

## Roles

- **Author**: prepares scope, contracts, and mock artefacts; owns problem framing.
- **Runner**: implements code, tests, and feature flags that satisfy the approved scope.
- **Reviewer**: validates correctness, standards compliance, and safe rollout.

An individual (human or agent) may play multiple roles across different tasks, but each branch must record who authored the specification and who executed it.

## Phase 0 – Intake & Planning

1. Capture or update the issue/backlog entry with:
   - `author_agent`, `runner_agent`
   - `handoff_expected_at`
   - links to specification artefacts
2. Ensure contracts (OpenAPI/JSON Schema/UI docs/events) are up to date or create change proposals in `contracts/`.
3. Author opens a branch following the convention in `ops/git/branching.md` and commits the specification artefacts under `specs/<ticket>/`.

## Phase 1 – Authoring & Handoff

1. Author completes `specs/<ticket>/plan.md` with:
   - scope & acceptance criteria
   - affected contracts/interfaces
   - rollout plan & feature flags
2. Optional supporting files: mocks, fixtures, adapter stubs.
3. Author records handoff in `.agents/decision_log.yml` (include timestamp, branch, artefact paths).
4. Runner acknowledges handoff by commenting on the issue or PR and updating `.agents/backlog.yml` status to `In Progress`.

## Phase 2 – Implementation (Runner)

1. Pull the latest branch, rebase from `main`, and run smoke tests.
2. Implement code changes, keeping commits focused and referencing the issue ID.
3. Update tests:
   - unit tests for modules touched
   - contract tests (producer/consumer) when interface changes occur
   - e2e tests (mock-backed if backend not ready)
4. Introduce feature flags via `packages/config/flags.ts` (or existing toggle mechanism) when functionality is incomplete.
5. Push changes and convert the draft PR to ready-for-review once CI matrix is green.

## Phase 3 – Review & Merge

1. Reviewer checks:
   - branch naming and metadata fields
   - contract changes validated via tests/mocks
   - flag defaults & rollback notes in PR template
   - updated specs/tests committed alongside code
2. If changes needed, reviewer requests updates; runner iterates until resolved.
3. Reviewer merges when requirements met. Post-merge:
   - close linked issues automatically (`Fixes #id`)
   - delete the branch remotely
   - update `.agents/backlog.yml` status to `Done` and capture lessons if applicable

## Supporting Automation

- **CI Matrix**: `.github/workflows/` should run lint, unit, contract, and e2e jobs in parallel.
- **Validation Scripts**: add tools under `scripts/` for enforcing branch naming and metadata checks.
- **Notification Hooks**: optional scripts (Slack/email) can read `.agents/decision_log.yml` for handoff events.

## Technology-Specific Adaptations

- **CMD Script Modules**: replace TypeScript-oriented contract references with the repo's batch script patterns. Use documented label conventions instead of `contracts/` unless a new service is introduced.
- **Feature Toggles**: when working in CMD, rely on environment variables or config files (e.g., `set FLAG_AUTH_V2=1`) rather than `packages/config/flags.ts`. The TS/JS guidance remains for future polyglot projects; note the chosen mechanism in PR templates.
- **Testing Harness**: CMD tasks should integrate with existing `.cmd` runners under `tests/` and log results to `.agents/metrics_log.yml` until automation scripts land.

## Storage Locations

- **Public policy & workflow**: `ops/git/*.md`
- **Agent-facing checklists**: `.agents/playbooks/git/*.md` (optional distilled versions).
- **Specifications**: `specs/<ticket>/` (versioned with code).
- **Operational logs**: `.agents/*.yml`.

Following this handbook keeps responsibilities explicit and preserves a clear audit trail for every change cycle.
