# Coding Standards (Batch/Powershell)

Comments
- Use English for all code comments and docstrings.
- Prefer `::` over `REM` for comments in batch files.
- Keep explanations short, focused, and near the logic they describe.

Labels (Batch)
- Naming: lowerCamelCase without hyphens. Avoid spaces and special characters.
- Verbs first: `installAio`, `installAioO2019`, `checkCompatibility`, `packageManagementMenu`.
- Menu labels end with `Menu`; actions start with a verb; helpers use clear nouns.
- Avoid duplicate labels; group logically by prefix (e.g., `install*`, `package*`, `office*`).

Variables
- Environment variables: UPPER_CASE where practical; local script vars: lower_snake_case or descriptive names.
- Be consistent within a file; avoid one-letter names except in loops.

Structure
- One purpose per label/function; keep labels small and composable.
- Centralize shared helpers (installSoft_ByWinget/Choco, extractZip, downloadFile) to a single definition.
- Guard OS/version-specific logic (Windows 10/11) with explicit checks.

PowerShell
- Use PowerShell for complex logic (downloads, archive, registry); batch for menus/launchers.
- Prefer explicit error handling and clear exit codes.

Examples
- Label: `:installAioO2019` (verb + target + version)
- Comment: `:: Extract OTP to temp and run deployment`

