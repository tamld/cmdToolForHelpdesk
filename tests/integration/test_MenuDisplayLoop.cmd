@echo off
:: Menu Stability Loop Test (Initial Version - Expected to Fail)

setlocal enabledelayedexpansion

set "FAILURES=0"

:: List of all current, mixed-concern menu labels to test
set "MENU_LIST=^
    main ^
    installAIOMenu ^
    DisplayOfficeWindowsMenu ^
    DisplayInstallOfficeMenu ^
    DisplayLoadSkusMenu ^
    DisplayRemoveOfficeKeyMenu ^
    DisplayUninstallOfficeMenu ^
    DisplayActiveLicensesMenu ^
    DisplayBackupLicensesMenu ^
    utilities ^
    packageManagementMenu
"

echo =================================================================
echo Starting Menu Stability Loop Test (Expected to Hang/Fail)...
echo =================================================================

for %%m in (%MENU_LIST%) do (
    echo Testing menu label: :%%m...
    call Helpdesk-Tools.cmd :%%m > nul 2>&1
    if !errorlevel! neq 0 (
        echo   [FAIL] Failed to call :%%m
        set /a FAILURES+=1
    ) else (
        echo   [PASS] Successfully called :%%m (Note: This may be a false positive if the call hung and was killed)
    )
)

echo.
echo =================================================================
echo Menu Stability Loop Test finished.

if %FAILURES% gtr 0 (
    echo !FAILURES! menu(s) failed to be called.
    exit /b 1
) else (
    echo All menus were called (or hung).
    exit /b 0
)
