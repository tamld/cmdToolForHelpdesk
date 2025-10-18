@echo off
setlocal
set "MAIN_SCRIPT_PATH=../../Helpdesk-Tools.cmd"
set "UTILS_PATH=../test_utils.cmd"
set "REPORTS_DIR=../reports"
set "LOG_FILE=%REPORTS_DIR%/test_InstallMenuDisplay.log"

if not exist "%REPORTS_DIR%" mkdir "%REPORTS_DIR%"

call %MAIN_SCRIPT_PATH% InstallMenu > %LOG_FILE% 2>&1
call %UTILS_PATH% assertFileContains "%LOG_FILE%" "Install All In One"
if %errorlevel% neq 0 (
    echo Test failed: Menu title not found.
    exit /b 1
)

echo Test passed.
exit /b 0
