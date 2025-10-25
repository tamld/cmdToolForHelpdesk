@echo off
setlocal

set "LOG_FILE=.\tests\reports\package_management_menu.log"
set "EXIT_CODE=0"

echo Verifying test: PackageManagerMenu Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install Package Management""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install End Users Applications""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install Remote Applications""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install Network Applications""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Install Chat Applications""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Upgrade All Software Online""

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
    echo Test PASSED: All expected menu items for PackageManagerMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for PackageManagerMenu were not found in the log.
)

exit /b %EXIT_CODE%
