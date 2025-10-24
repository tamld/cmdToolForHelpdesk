@echo off
:: Test: test_InstallMenu_display.cmd
:: Goal: Verify that the InstallMenu log file contains the anchor text.

setlocal

set "LOG_FILE=%~dp0..\reports\install_menu.log"
set "ANCHOR_TEXT=ANCHOR_InstallMenu"

if not exist "%LOG_FILE%" (
    echo [FAILURE] Log file not found: %LOG_FILE%
    exit /b 1
)

findstr /C:"%ANCHOR_TEXT%" "%LOG_FILE%" > nul

if %errorlevel% equ 0 (
    echo [SUCCESS] InstallMenu display test passed. Anchor text found in log.
    endlocal
    exit /b 0
) else (
    echo [FAILURE] InstallMenu display test failed. Anchor text NOT found in log.
    endlocal
    exit /b 1
)
