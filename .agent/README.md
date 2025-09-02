# .agent Workspace

Project-local workspace for AI agents and automation. Keep files short, token‑efficient, and machine‑readable. Longer, human‑readable specs live under `docs/`.

Contents
- `config.yaml`: Minimal agent config (portable path, limits).
- `prompts/`: Concise system/assistant prompts for this repo.
- `policies.json`: Compact operating rules for agents.
- `goals.json`: Mission, objectives, constraints, metrics.
- `backlog.json`: Technical TODOs/issues in JSON form.
- `roadmap.json`: Milestone plan referencing backlog IDs.
- `context/`: Links/short notes; avoid long texts.
- `workflows/`: Small JSON runbooks/SOPs.

Conventions
- No secrets. Use env vars or external secret stores.
- Prefer JSON for agent inputs; link to `docs/` for detail.
- Keep single files < ~32KB to reduce token cost.

See also
- `docs/` for human‑readable specs, RPM, roadmap details.
