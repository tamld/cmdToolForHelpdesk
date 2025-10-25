@echo off
setlocal

set "LOG_FILE=.\tests\reports\select_office_app.log"
set "EXIT_CODE=0"

echo Verifying test: SelectOfficeApp Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% List of components to install Office"
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% Microsoft Office Word"
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% Microsoft Office Excel"
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% Microsoft Office PowerPoint"
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% Microsoft Office Outlook"

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
    echo Test PASSED: All expected menu items for SelectOfficeApp are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for SelectOfficeApp were not found in the log.
)

exit /b %EXIT_CODE%
