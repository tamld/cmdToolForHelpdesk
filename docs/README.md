This folder contains human-readable documentation for cmdToolForHelpdesk.

Contents
- spec-cmdtool.md: Feature spec, structure, and behavior.
- roadmap.md: Narrative milestones and priorities.
- rpm.md: Roles, Process, Metrics (how we operate).
- backlog.md: A readable mirror of .agent/backlog.json (high-level).

Visualization
- Prefer Mermaid workflow diagrams for complex procedures and multi-step flows. Keep diagrams canonical and reference them within the surrounding text.

Markdown Conventions (icons, images, matrices, anchors)
- Icons/Badges: use emojis (e.g., 🚀) and Shields badges. Example: `![Status](https://img.shields.io/badge/status-active-brightgreen)`.
- Images: store under `pictures/` or `docs/img/` and reference with relative paths. Always include alt text. For sizing, use HTML if needed: `<img src="pictures/1.png" alt="Main menu" width="480" />`.
- Tables/Matrices: prefer GitHub Markdown tables to present comparisons or matrices.
  Example:
  
  | Feature | Windows 10 | Windows 11 |
  |:--|:--:|:--:|
  | Winget | ✅ | ✅ |
  | ODT    | ✅ | ✅ |

- Custom Anchors for Index: headings auto-generate anchors on GitHub (link with `[text](#heading-text)`). For custom ids, add an HTML anchor before a section: `<a id="troubleshooting"></a>` then link with `[Troubleshooting](#troubleshooting)`.
- Index/TOC: add a short manual TOC at the top linking to key sections; keep 5–8 items for scanability. Tools like Doctoc are optional; prefer manual for control.
- Callouts/Details: use blockquotes for callouts (`> Note:`) and `<details><summary>...</summary>...</details>` for collapsible sections when content is long.

Assets Layout
- Images: place under `pictures/` at repo root; reference with relative paths in docs (e.g., `![Main menu](pictures/1.png)`).
- Documents: place human‑readable specs and guides under `docs/`; keep agent‑facing JSON/TXT under `.agent/`.
- Keep assets lightweight; prefer linking to large binaries rather than committing them.

Note: Agents should use the compact JSON sources in .agent/ and refer here for details and rationale.
