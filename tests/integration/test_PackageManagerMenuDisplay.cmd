@echo off
setlocal

:: Call the display function from the main script.
call ..\..\Helpdesk-Tools.cmd displayPackageManagerMenu

:: The test_runner.cmd is expected to capture stdout and compare it.
:: This call just ensures the script itself ran without a critical error.
call ..\test_utils.cmd assertSuccess

exit /b 0