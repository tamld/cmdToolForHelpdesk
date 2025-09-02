Overview
- Helpdesk-Tools.cmd provides menu-driven automation for Windows helpdesk tasks: install software, manage Office, activation helpers, utilities, and package management via winget/chocolatey.

Structure
- Main menu: Install AIO, Windows/Office utilities, Activation, Utilities, Package Management, Self-update.
- Installers: winget/choco helpers, grouped app lists for End-users, Remote Support, Network tools, Chat apps.
- Office: Office Tool Plus deploy flow, ODT for O365, conversion and uninstall helpers.
- Utilities: performance plan, hostname change, cleanup, debloat, vendor Support Assistants, winutil integration.
- Common helpers: version checks, download/extract, schedule tasks, kill tasks, cleanup temp.

Key Design Points
- Run as admin with UAC elevation.
- Prefer winget when available, fallback to choco.
- Network calls should be version-pinned when feasible; checksums preferred.
- Windows 10/11 detection must rely on build or registry, not product name substring.
- Avoid duplicate function definitions; keep single source of truth for helpers.

Constraints
- Windows 10 (19041+) and Windows 11.
- No secrets in repo; no license keys stored.

Known Gaps (to implement)
- Active Licenses submenus call placeholders.
- AIO System-Network/Helpdesk variants incomplete.
- Some downloads use unpinned URLs and ignore checksums.
- Duplicate helpers exist in multiple sections.

References
- .agent/backlog.json for actionable tasks.
- .agent/policies.json for coding, security, and planning rules.

