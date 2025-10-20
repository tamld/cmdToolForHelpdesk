@echo off
setlocal

set "LOG_FILE=.\tests\reports\install_office_menu.log"
set "EXIT_CODE=0"

echo Verifying test: InstallOfficeMenu Display

:: List of strings to check for in the log file
set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install Office Online""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Office 365""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Office 2024 (PerpetualVL)""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Office 2019 (PerpetualVL)""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install Manually using Office Deploy Tool""

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
    echo Test PASSED: All expected menu items for InstallOfficeMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for InstallOfficeMenu were not found in the log.
)

exit /b %EXIT_CODE%
