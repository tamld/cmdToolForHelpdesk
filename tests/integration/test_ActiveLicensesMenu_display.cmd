@echo off
setlocal

set "LOG_FILE=.\tests\reports\active_licenses_menu.log"
set "EXIT_CODE=0"

echo Verifying test: ActiveLicensesMenu Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Online""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "By Phone""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Check Licenses""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Backup Licenses""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Restore License""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "MAS (Microsoft Activation Scripts)""

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
    echo Test PASSED: All expected menu items for ActiveLicensesMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for ActiveLicensesMenu were not found in the log.
)

exit /b %EXIT_CODE%
