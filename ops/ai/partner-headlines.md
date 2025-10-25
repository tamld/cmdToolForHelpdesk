# Human–AI Partnership Headlines

- **Spec-First Delivery**: Production work starts from written CARE-style specs and tests; no vibe coding goes straight to main.
- **Human Leads, AI Executes**: Humans own architecture, business rules, and approvals; agents implement, refactor, and test against the spec.
- **Context Engineering**: Provide AGENTS.md, spec extracts, relevant code, and error logs as curated context before delegating to Codex.
- **TDD Loop**: Red–Green–Refactor remains mandatory; AI draft tests and minimal code, humans review and tighten.
- **Sequential PR Iterations**: Use `@codex` comments to run tasks one at a time on the same branch; review diffs between iterations.
- **Quality Gates**: Human review required for security/performance; CI matrix must pass before merge even if Codex approves.
- **Measure & Adjust**: Track handoff latency, CI pass rate, AI iteration count, and human rework to tune the workflow.

Full procedural detail for agents lives in `.agents/ai_partner_framework.md`.
