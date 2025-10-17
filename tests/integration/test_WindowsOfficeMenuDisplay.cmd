@echo off
setlocal

:: Call the display function from the main script.
call ..\Helpdesk-Tools.cmd displayWindowsOfficeMenu

:: Use an assertion from the utils script to check the result.
call test_utils.cmd assertSuccess

exit /b 0
