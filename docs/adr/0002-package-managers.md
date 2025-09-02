ADR-0002: Package Managers (winget vs choco)

Context
- Need reliable software installation on Windows.

Decision
- Prefer `winget` when present (Windows 10 19041+), fallback to `choco`.

Status
- Accepted.

Consequences
- Implement detection and version checks for winget; ensure choco path and self-heal logic.

