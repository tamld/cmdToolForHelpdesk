@echo off
setlocal

:: Change to the script's own directory to ensure consistent paths
cd /d "%~dp0"

echo =================================
echo         RUNNING SANITY CHECK
echo =================================

echo.
echo --- Testing: Direct call from runner ---

call ..\Helpdesk-Tools.cmd checkCompatibility

if %ERRORLEVEL% EQU 0 (
    echo [PASS] Direct call seems to work.
    echo All tests passed successfully!
    exit /b 0
) else (
    echo [FAIL] Direct call failed with ERRORLEVEL %ERRORLEVEL%
    exit /b 1
)
