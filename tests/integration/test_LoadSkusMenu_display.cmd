@echo off
setlocal

set "LOG_FILE=.\tests\reports\load_skus_menu.log"
set "EXIT_CODE=0"

echo Verifying test: LoadSkusMenu Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Load Windows Eddition""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Professional""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "ProfessionalWorkstation""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Enterprise""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "LTSC 2019""

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
    echo Test PASSED: All expected menu items for LoadSkusMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for LoadSkusMenu were not found in the log.
)

exit /b %EXIT_CODE%
