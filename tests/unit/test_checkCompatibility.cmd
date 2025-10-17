@echo on
setlocal

echo [DEBUG] Current directory: %cd%
echo [DEBUG] Changing directory to: %~dp0
cd /d "%~dp0"
echo [DEBUG] New directory: %cd%

echo [DEBUG] --- START TEST ---

echo [DEBUG] Calling Helpdesk-Tools.cmd...
call ..\..\Helpdesk-Tools.cmd checkCompatibility
echo [DEBUG] ERRORLEVEL after Helpdesk-Tools.cmd: %ERRORLEVEL%

echo [DEBUG] Calling test_utils.cmd...
call ..\test_utils.cmd assertSuccess
echo [DEBUG] ERRORLEVEL after test_utils.cmd: %ERRORLEVEL%

echo [DEBUG] --- TEST FINISHED ---

exit /b 0
