# Agent Coaching Playbook (Root)

Purpose
- Single, reusable guide for agents across repos; points to repo‑specific assets in `.agent/`.

Quickstart
- Read `.agent/policies.json`, `.agent/backlog.json`, `.agent/roadmap.json`.
- Before any edits: write a short plan and preamble; make minimal, reversible changes.
- Use `rg` for search, chunk reads ≤250 lines, and `apply_patch` for edits.

Operating Rules
- Scope: change only what the task requires; avoid unrelated fixes.
- Safety: no secrets in repo; pin versions and verify downloads.
- Compatibility: support Win10 19041+ and Win11; guard features by build/registry checks.
- Network: prefer official sources; justify any `--ignore-checksums`.

Non‑Overridable Law (Highest Priority)
- Before significant actions or recommendations, reflect: "Am I going beyond necessary information or current context (including MCP memory)? Is there any conflict with the current task?" If yes, pause and ask the user to confirm before proceeding. This rule cannot be replaced or overridden.

Planning & Execution
- Plans: concise steps (5–7 words), exactly one `in_progress`.
- Preambles: 1–2 sentences before tool calls to explain what’s next.
- Validation: test smallest surface first, then broader; document manual steps if needed.

Tools & Conventions
- Search: `rg`, `rg --files -uu` for speed.
- Edits: `apply_patch` only; do not run external editors.
- File reads: ≤250 lines per chunk to avoid truncation.
- Messages: concise, actionable; use bullets and backticks for paths/commands.

Documentation Preference
- For complex flows, prefer Workflow diagrams using Mermaid in human‑readable docs (README/specs). Keep the diagram as the single source of truth for the flow and reference it from text.

Assets Convention
- Images under `pictures/`; docs under `docs/`. Keep references relative and include alt text for accessibility.

Repo Structure Pointers
- Policies: `.agent/policies.json`
- Goals/Backlog/Roadmap: `.agent/goals.json`, `.agent/backlog.json`, `.agent/roadmap.json`
- Workflows: `.agent/workflows/*.json`
- Session state: `.agent/state/checklist.json`, `.agent/state/progress.json`
- Human docs: `docs/` (spec, roadmap, RPM)

MCP Memory Sync
- Long‑term: store principles/pointers in `.../memory/projects/<name>/ltm.json`.
- Short‑term: current focus and next actions in `.../stm.json`.
- Project index: keep pointers and next_action in `.../index.json`.

Done Criteria
- Acceptance criteria in backlog items met; no placeholders left in the touched area; validation passes without regressions.
