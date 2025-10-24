@echo off
:: Test: test_installAio_reachable.cmd
:: Goal: Verify that the installAio function is reachable and prints its anchor.

setlocal

set "LOG_FILE=%~dp0..\reports\install_aio.log"
set "ANCHOR_TEXT=ANCHOR_installAio"

if not exist "%LOG_FILE%" (
    echo [FAILURE] Log file not found: %LOG_FILE%
    exit /b 1
)

findstr /C:"%ANCHOR_TEXT%" "%LOG_FILE%" > nul

if %errorlevel% equ 0 (
    echo [SUCCESS] installAio reachable test passed. Anchor text found in log.
    endlocal
    exit /b 0
) else (
    echo [FAILURE] installAio reachable test failed. Anchor text NOT found in log.
    endlocal
    exit /b 1
)
