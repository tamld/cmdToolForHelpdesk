@echo off
setlocal enabledelayedexpansion

echo --- Running Menu Display Loop Test ---

FOR %%m IN (
    displayMainMenu
    displayWindowsOfficeMenu
    displayUtilitiesMenu
    displayLicenseMenu
) DO (
    echo.
    echo [TEST] Calling function: %%m
    call ..\Helpdesk-Tools.cmd %%m
    if !ERRORLEVEL! NEQ 0 (
        echo [FAIL] Function %%m returned a non-zero errorlevel: !ERRORLEVEL!
        exit /b 1
    )
    echo [PASS] Function %%m ran successfully.
)

echo.
echo --- All menu display functions passed the loop test. ---
exit /b 0
