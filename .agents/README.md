# CMD Helpdesk Agent Instructions

## Mission Snapshot
- Maintain the Windows-focused automation scripts (`Helpdesk-Tools.cmd`, `refactor.cmd`, `scripts/`) with zero regressions for IT technicians.
- Keep the experience turnkey: menu flows must stay readable in a plain console, and every download/action is justified and pinned.
- Documentation and operational hygiene mirror the discipline in `local-scripts/hash-checker`: work in small, validated increments and leave a verifiable trail.

## Guardrails & Safety
- Treat CMD syntax as fragile: quote paths with spaces, escape `(` `)` `^` and `%` appropriately, and never mix delayed and immediate expansion without explaining it.
- Preserve CRLF endings in `.cmd` files; avoid tools that silently convert line endings.
- Before introducing or updating downloads, capture the exact source URL, version, and checksum. Store scripts in `packages/` or `scripts/` only after verifying hashes locally.
- Do not add secrets, API keys, or environment-specific credentials. Anything sensitive belongs in deployment-time tooling, not the repo.
- Follow the non-overridable law from `AGENTS.md`: pause and reconfirm with the user if a requested change feels outside scope.

## Task Intake Workflow
- Read `.agent/AGENTS.md`, `.agent/policies.json`, and `.agent/context/index.json` before touching code; keep your plan synced with those expectations.
- Draft a short plan (2–4 steps) and mark progress as you go. Avoid single-step plans.
- When investigating, prefer `rg` for search and chunk file reads ≤250 lines to stay within CLI guidelines.
- Update `.agent/state/*.json` only when asked; treat them as source-of-truth for longer missions.

## Implementation Guidelines
- Modify one menu/function at a time inside `Helpdesk-Tools.cmd`; validate control-flow labels (`goto`, `call`) after every edit.
- Use helper routines instead of duplicating logic—follow the consolidation lessons in `hash-checker` to keep shared functions centralized.
- For PowerShell snippets embedded in CMD, maintain indentation and surround multi-line blocks with `PowerShell -ExecutionPolicy Bypass -Command " … "` while escaping quotes deliberately.
- Any new automation should default to `winget` or `choco` with explicit package IDs and pinned versions; include comments when falling back to direct installers.
- Record major operational updates in `docs/` (create if absent) so future agents inherit the rationale.
- Keep menu text aligned and padded with spaces; inconsistent alignment breaks the visual layout in legacy consoles.

## Validation & Testing
- Smoke-test menu paths you touch using a Windows VM or the provided `scripts/run-in-sandbox.cmd` (VirtualBox) before closing work.
- For destructive utilities (debloat, licensing), stage changes behind confirmation prompts and document manual validation steps in commit notes or docs.
- Capture hashes for any redistributed binaries with `certutil -hashfile` and store alongside the binary or in `checksums.json`.
- When editing automation around virtualization (`hyperVctl.cmd`, `virtualboxctl.sh`), validate on both Windows and macOS hosts when practical; note deviations in the PR/summary.

## Ignore & Public Hygiene
- Keep `.gitignore` updated (see root file) so local logs, VM images, IDE settings, and packaging artefacts never leak into commits.
- Never commit files from `%TEMP%`, `logs/`, `tmp/`, virtual machine export directories, or personal Editor/IDE configs.
- For screenshots or marketing assets, place them in `pictures/` with descriptive filenames and alt text references.

## Reflection & Knowledge Transfer
- Summarise what you changed, what you tested, and any open risks in your final hand-off—mirror the concise runbooks from `hash-checker/docs/OPERATIONS.md`.
- If you discover recurring issues or manual steps, log them for the next agent in `.agents/notes.md` (create if needed) and consider adding a checklist item in `.agent/state/checklist.json` after syncing with the user.
- Encourage coachability: note any CMD quirks encountered (e.g., delayed expansion pitfalls, escaping rules) so future sessions learn without repeating mistakes.
- Favor additive documentation over tribal knowledge; when in doubt, write the runbook first, then automate.

## Handoff validation (CI-first)

- Preferred: rely on CI to validate handoff artifacts (works on macOS hosts; no Windows required).

- Triggering options:
  - Add label `ready-for-handoff` to the PR (auto-runs workflow `validate-handoff`).
  - Or manually run the Action from GitHub UI ("Run workflow").

- The workflow executes `.agents/scripts/validate_handoff.sh` against the PR head SHA on `ubuntu-latest` and checks that `/.agents/branch_progress.yml` is complete, including the new `reflection` and `reverse_questions` sections.

- Local run is optional; on macOS it only validates YAML content (no Windows-only tests).
