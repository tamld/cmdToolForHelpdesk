@echo off
setlocal

:: The GITHUB_WORKSPACE variable provides the absolute path to the project root.
set "PROJECT_ROOT=%GITHUB_WORKSPACE%"

echo =================================
echo         RUNNING SANITY CHECK
echo =================================

echo.
echo --- Testing: Direct call from runner with absolute path ---
echo Project Root is: %PROJECT_ROOT%
echo Script to call is: %PROJECT_ROOT%\Helpdesk-Tools.cmd

call "%PROJECT_ROOT%\Helpdesk-Tools.cmd" checkCompatibility

if %ERRORLEVEL% EQU 0 (
    echo [PASS] Absolute path call seems to work.
    echo All tests passed successfully!
    exit /b 0
) else (
    echo [FAIL] Absolute path call failed with ERRORLEVEL %ERRORLEVEL%
    exit /b 1
)
