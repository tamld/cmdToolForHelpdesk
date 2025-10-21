@echo off
setlocal

set "LOG_FILE=.\tests\reports\utilities_menu.log"
set "EXIT_CODE=0"

echo Verifying test: UtilitiesMenu Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Set High Performance""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Change hostname""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Clean up system""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "ChrisTitusTech/winutil""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install Support Assistance""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Active IDM""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Windows Debloat""

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
    echo Test PASSED: All expected menu items for UtilitiesMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for UtilitiesMenu were not found in the log.
)

exit /b %EXIT_CODE%
