# Branch Naming & Lifecycle

This guide standardises branch usage for multi-agent development in `cmdToolForHelpdesk`.

## Naming Convention

```
<kind>/<domain>-<ticket>-a<author>-r<runner>
```

- `kind`: `feature`, `fix`, `refactor`, or `chore`.
- `domain`: short module or capability label (e.g. `auth`, `menus`, `dispatcher`).
- `ticket`: GitHub issue number or short slug.
- `author`: agent (or human) that prepares the specification.
- `runner`: agent that delivers the implementation.

Example: `feature/menus-142-aatlas-rcodex`.

Use lowercase letters, numbers, and hyphens only. Keep the branch name under 60 characters when possible.

**Solo exception**: when a single human or agent handles both authoring and running, the suffix may be shortened to `<kind>/<domain>-<ticket>`. Record the acting agent in `.agents/backlog.yml` to preserve attribution.

## Lifecycle Overview

1. **Author creates branch** from `main` (or agreed base) and pushes specification artefacts.
2. **Runner rebases daily** on `main` and implements the change set.
3. **Reviewer(s)** enforce branch hygiene via pull request checks.
4. **Merge** happens only after all required checks succeed and feature flags guard incomplete work.

## Branch Hygiene Rules

- Never commit directly to `main`.
- Keep branches focused on a single checklist/issue.
- Rebase (or merge) from `main` every 24 hours to minimise drift.
- Delete remote branches once a pull request is merged.

## Labels & Tracking

- Each branch must reference a GitHub issue (`Fixes #<id>` in the PR description).
- Update `.agents/backlog.yml` with `branch`, `author_agent`, and `runner_agent` fields when the branch is created.
- Log hand-offs in `.agents/decision_log.yml` including timestamps and links to artefacts.

## Specification Artefacts

Place specifications under `specs/<ticket>/`:

- `plan.md`: outline, acceptance criteria, contract changes.
- `mocks/` or `fixtures/`: optional supporting files.
- `handoff.md`: short summary for the runner when the spec is ready.

These artefacts stay in the repo for transparency and review.

## Pull Request Requirements

- Draft PRs are encouraged as soon as the branch is created.
- Use `.github/PULL_REQUEST_TEMPLATE.md` to report author/runner names, contract impact, and feature flags.
- Ensure CI matrix (lint/unit/contract/e2e) is green before requesting final review.

Adhering to this branching convention keeps multi-agent work traceable and conflict-free.
