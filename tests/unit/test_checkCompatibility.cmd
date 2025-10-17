@echo off
setlocal

:: Change to the test file's directory
cd /d "%~dp0"

:: Call the function to be tested from the main script.
:: We expect this to succeed in a CI/admin environment.
call ..\..\Helpdesk-Tools.cmd checkCompatibility

:: Use an assertion from the utils script to check the result.
:: We expect ERRORLEVEL 0 for success.
call ..\test_utils.cmd assertSuccess

:: If the assertion passes, the test is successful.
exit /b 0
