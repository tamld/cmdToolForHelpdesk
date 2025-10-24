@echo off
setlocal

set "LOG_FILE=.\tests\reports\remove_office_key_menu.log"
set "EXIT_CODE=0"

echo Verifying test: RemoveOfficeKeyMenu Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Remove Office Key""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "One by one""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "All""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Back to Windows Office Menu""

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
    echo Test PASSED: All expected menu items for RemoveOfficeKeyMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for RemoveOfficeKeyMenu were not found in the log.
)

exit /b %EXIT_CODE%
