@echo off
setlocal

set "LOG_FILE=.\tests\reports\backup_licenses_menu.log"
set "EXIT_CODE=0"

echo Verifying test: BackupLicensesMenu Display

set "EXPECTED_STRINGS="
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "Backup License Windows & Office""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "BACKUP To Local""
set "EXPECTED_STRINGS=%EXPECTED_STRINGS% "BACKUP To NAS STORAGE""

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
    echo Test PASSED: All expected menu items for BackupLicensesMenu are present.
) else (
    echo.
    echo Test FAILED: Some expected menu items for BackupLicensesMenu were not found in the log.
)

exit /b %EXIT_CODE%
