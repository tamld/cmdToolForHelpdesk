@echo off
setlocal
set "MAIN_SCRIPT_PATH=../../Helpdesk-Tools.cmd"
set "UTILS_PATH=../test_utils.cmd"
set "REPORTS_DIR=../reports"
set "LOG_FILE=%REPORTS_DIR%/test_InstallMenuDisplay.log"

if not exist "%REPORTS_DIR%" mkdir "%REPORTS_DIR%"

call %MAIN_SCRIPT_PATH% InstallMenu

:: The test_runner.cmd is expected to capture stdout and compare it.
:: This call just ensures the script itself ran without a critical error.
call %UTILS_PATH% assertSuccess

exit /b 0
