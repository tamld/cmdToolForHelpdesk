# Refactoring Plan: Structure and Naming

**Branch:** `refactor/structure-and-naming`

## Goals
1.  **Restructure Functions:** Organize functions into a menu/submenu layout.
2.  **Standardize Function Names:** Apply a consistent naming convention to all functions.
3.  **Standardize Variable Names:** Apply a consistent naming convention to all variables.

## Todo List & Checklist

### Phase 1: Analyze Current Codebase
- [x] Identify all functions in `Helpdesk-Tools.cmd`.
- [x] Analyze the current function call structure.
- [x] Document the current naming conventions (or lack thereof) for functions and variables.

### Phase 2: Plan the New Structure and Conventions
- [x] Propose a new menu/submenu structure for the functions.
- [x] Define a clear naming convention for functions.
- [x] Define a clear naming convention for variables.

### Phase 3: Implementation
- [x] **Restructure:**
    - [x] Create the main menu function (`MainMenu`).
    - [x] Create submenu functions (`WindowsOfficeMenu`, `LicenseMenu`, `UtilitiesMenu`, `PackageManagerMenu`).
    - [ ] Create `InstallMenu` submenu.
    - [ ] Move existing functions into the new structure.
- [ ] **Rename Functions:**
    - [ ] Rename all functions according to the new convention.
    - [ ] Update all function calls to reflect the new names.
- [ ] **Rename Variables:**
    - [ ] Rename all variables according to the new convention.

### Phase 4: Verification
- [x] Test the script to ensure all functionality works as expected after refactoring. (Partial: Menu display tests exist)
- [ ] Review the code to ensure it adheres to the new structure and naming conventions.

---

## Proposed Naming Conventions

### Functions/Labels
*   **`PascalCase`**: For main menu and sub-menu entry points.
    *   *Example:* `:InstallMenu`, `:OfficeUtilsMenu`
    *   *Reason:* Helps distinguish between navigation labels and callable utility functions.
*   **`camelCase`**: For helper/utility functions that perform a specific task.
    *   *Example:* `:downloadFile`, `:checkCompatibility`
    *   *Reason:* Standard practice for callable functions.

### Variables
*   **`camelCase`**: For all local and global variables.
    *   *Example:* `officePath`, `appVersion`
    *   *Reason:* A common, readable convention.

### Constants
*   **`UPPER_SNAKE_CASE`**: For variables whose values are not intended to change.
    *   *Example:* `GITHUB_API_URL`
    *   *Reason:* Clearly marks the variable as a constant.

---

## Proposed Menu Structure

*   `MainMenu`
    *   `InstallMenu` (replaces `installAIOMenu`)
        *   `InstallFresh`
        *   `InstallWithOffice2024`
        *   `InstallWithOffice2021`
        *   `InstallWithOffice2019`
    *   `WindowsOfficeMenu` (replaces `office-windows`)
        *   `InstallOfficeMenu`
        *   `UninstallOfficeMenu`
        *   `RemoveOfficeKeyMenu`
        *   `ConvertOfficeEditionMenu`
        *   `FixNonCoreWindows`
        *   `LoadWindowsSkusMenu`
    *   `LicenseMenu` (replaces `activeLicenses`)
        *   `ActivateOnline`
        *   `ActivateByPhone`
        *   `CheckLicenseStatus`
        *   `BackupLicense`
        *   `RestoreLicense`
        *   `RunMicrosoftActivationScripts`
    *   `UtilitiesMenu` (replaces `utilities`)
        *   `SetHighPerformance`
        *   `ChangeHostname`
        *   `CleanupSystem`
        *   `RunWinUtil`
        *   `InstallSupportAssist`
        *   `ActivateIdm`
        *   `DebloatWindows`
    *   `PackageManagerMenu` (replaces `packageManagementMenu`)
        *   `InstallPackageManagers`
        *   `InstallEndUserApps`
        *   `InstallRemoteApps`
        *   `InstallNetworkApps`
        *   `InstallChatApps`
        *   `UpgradeAllPackages`
    *   `UpdateScript` (replaces `updateCMD`)
    *   `Exit`
