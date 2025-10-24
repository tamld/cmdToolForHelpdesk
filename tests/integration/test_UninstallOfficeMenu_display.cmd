@echo off
setlocal

set "LOG_FILE=.\tests\reports\uninstall_office_menu.log"
set "EXIT_CODE=0"

echo Verifying test: UninstallOfficeMenu Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Uninstall Office all versions""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Using SaraCMD (silent)""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Using Office Tool Plus""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Using BCUninstaller""

for %%s in (%EXPECTED_STRINGS%) do (
    findstr /C:%%s "%LOG_FILE%" > nul
    if !errorlevel! neq 0 (
        echo [FAIL] Expected string not found: %%s
        set "EXIT_CODE=1"
    ) else (
        echo [PASS] Found expected string: %%s
    )
)

if %EXIT_CODE% equ 0 (
    echo.
    echo Test PASSED: All expected menu items for UninstallOfficeMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for UninstallOfficeMenu were not found in the log.
)

exit /b %EXIT_CODE%
