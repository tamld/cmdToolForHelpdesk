@echo off
setlocal

:: Call the function to be tested from the main script.
call ..\Helpdesk-Tools.cmd checkCompatibility

:: Use an assertion from the utils script to check the result.
call ..\test_utils.cmd assertSuccess

exit /b 0
