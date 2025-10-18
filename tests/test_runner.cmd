@echo off
setlocal enabledelayedexpansion

set "TESTS_DIR=%~dp0"
set "REPORTS_DIR=%TESTS_DIR%reports"
set "UNIT_TESTS_DIR=%TESTS_DIR%unit"
set "INTEGRATION_TESTS_DIR=%TESTS_DIR%integration"

set "FAILURES=0"

if not exist "%REPORTS_DIR%" mkdir "%REPORTS_DIR%"

echo =================================================================
echo Running Unit Tests...
echo =================================================================
for %%f in ("%UNIT_TESTS_DIR%\test_*.cmd") do (
    echo Running %%~nxf...
    call "%%f" > "%REPORTS_DIR%\%%~nxf.log" 2>&1
    if !errorlevel! neq 0 (
        echo   [FAIL] %%~nxf
        set /a FAILURES+=1
    ) else (
        echo   [PASS] %%~nxf
    )
)

echo.

echo =================================================================
echo Running Integration Tests...
echo =================================================================
for %%f in ("%INTEGRATION_TESTS_DIR%\test_*.cmd") do (
    echo Running %%~nxf...
    call "%%f" > "%REPORTS_DIR%\%%~nxf.log" 2>&1
    if !errorlevel! neq 0 (
        echo   [FAIL] %%~nxf
        set /a FAILURES+=1
    ) else (
        echo   [PASS] %%~nxf
    )
)

echo.

echo =================================================================
echo Test run finished.
if %FAILURES% gtr 0 (
    echo %FAILURES% test(s) failed.
    exit /b 1
) else (
    echo All tests passed.
    exit /b 0
)
