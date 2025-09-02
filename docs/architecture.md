Architecture (Project‑Specific)

Runtime
- Windows 10 (19041+) and Windows 11.
- Batch (`.cmd`) as primary launcher/menu; PowerShell for complex logic and zip extraction.

Structure
- `Helpdesk-Tools.cmd`: main entry; calls modular labels for features.
- `packages/`: vendor scripts and resources (debloat, ODT, etc.).
- `scripts/`: virtualization helpers (sandbox, hyper-v, vbox).
- `.agent/`: agent configs, backlog, workflows, decisions.

Decisions
- Prefer `winget` if available; fallback to `choco` (ADR‑0002).
- Pin downloads and verify where feasible (ADR‑0003).
- Consolidate duplicate helpers; single source of truth (policy).

Observability
- Clear echo/exit code paths; avoid noisy output.

Security
- Elevate only when required; no secrets in repo; verify sources.

