@echo off
setlocal

set "LOG_FILE=%~dp0..\..\reports\office_windows_menu.log"

echo Verifying log file: %LOG_FILE%

findstr /C:"Windows Office Main Menu" "%LOG_FILE%" >nul
if errorlevel 1 (
    echo [FAIL] Menu title not found.
    exit /b 1
)

findstr /C:"[1] Install Office Online" "%LOG_FILE%" >nul
if errorlevel 1 (
    echo [FAIL] Option 1 not found.
    exit /b 1
)

findstr /C:"[4] Convert Office Retail" "%LOG_FILE_PATH%" >nul
if errorlevel 1 (
    echo [FAIL] Option 4 not found.
    exit /b 1
)

findstr /C:"[7] Main Menu" "%LOG_FILE%" >nul
if errorlevel 1 (
    echo [FAIL] Option 7 not found.
    exit /b 1
)

echo [PASS] All expected content found in office-windows menu display.
exit /b 0
