@echo off
setlocal

:: Change to the test file's directory
cd /d "%~dp0"

:: Call the function to be tested from the main script.
call ..\..\Helpdesk-Tools.cmd checkCompatibility

:: Use an assertion from the utils script to check the result.
call ..\test_utils.cmd assertSuccess

:: If the assertion passes, the test is successful.
exit /b 0
