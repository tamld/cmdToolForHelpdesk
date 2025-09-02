ADR-0001: Language and Shell

Context
- Targets Windows 10+/11. Needs ubiquitous runtime and simple distribution.

Decision
- Use Batch (`.cmd`) for menus/launchers and simple orchestration.
- Use PowerShell for complex logic (downloads, zip extraction, registry ops).

Status
- Accepted.

Consequences
- Keep batch labels small; delegate to PowerShell when logic grows.
- Ensure PowerShell execution policy handled where needed.

