ADR-0004: Versioning and Release

Context
- Need predictable releases and rollback.

Decision
- Use SemVer style `vMAJOR.MINOR.PATCH` + date in header.
- Maintain changelog in docs/roadmap.md and SOP in .agent/workflows/release.json.

Status
- Accepted.

Consequences
- Tag releases in VCS; smoke test post-cut; document rollback.

