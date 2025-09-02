# Agents Workspace

This repository includes a local agents workspace under `.agent/` for AI assistants and automation tools. It centralizes prompts, context, configs, and workflows used when operating on this project.

## Purpose
- Keep agent context bundled with the codebase.
- Provide clear, minimal config for tools and prompts.
- Track project-specific notes and workflows under version control.

## Structure
- `.agent/README.md`: Overview and usage.
- `.agent/config.yaml`: Minimal settings for this project.
- `.agent/prompts/`: System and helper prompts.
- `.agent/context/`: Notes, links, and scratch context.
- `.agent/workflows/`: Task flows, SOPs, and playbooks.

## Conventions
- Store private tokens or secrets outside the repo; reference them via environment variables.
- Keep prompts short and project‑specific; link to docs rather than duplicating large texts.
- Prefer small, composable workflows over monolithic scripts.

## Getting Started
1) Review `.agent/README.md` and adjust `.agent/config.yaml` as needed.
2) Add any project‑specific prompts to `.agent/prompts/`.
3) Capture working notes in `.agent/context/notes.md`.
4) Define repeatable procedures in `.agent/workflows/`.

