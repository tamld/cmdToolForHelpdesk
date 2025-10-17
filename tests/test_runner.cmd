@echo off
setlocal enabledelayedexpansion

:: =============================================================================
:: test_runner.cmd
:: Master test runner for the Helpdesk-Tools project.
:: It discovers and executes all test cases.
:: =============================================================================

:: Change to the script's own directory to ensure consistent paths
cd /d "%~dp0"

set "TESTS_PASSED=0"
set "TESTS_FAILED=0"

:: --- Run Unit Tests ---
echo.
echo =================================
echo         RUNNING UNIT TESTS
echo =================================

for %%f in (unit\*.cmd) do (
    echo.
    echo --- Testing: %%f ---
    call %%f
    if !ERRORLEVEL! EQU 0 (
        echo [PASS] %%f
        set /a TESTS_PASSED+=1
    ) else (
        echo [FAIL] %%f
        set /a TESTS_FAILED+=1
    )
    echo -------------------------
)

:: --- Run Integration Tests ---
echo.
echo =================================
echo      RUNNING INTEGRATION TESTS
echo =================================

for %%f in (integration\*.cmd) do (
    echo.
    echo --- Testing: %%f ---
    call %%f
    if !ERRORLEVEL! EQU 0 (
        echo [PASS] %%f
        set /a TESTS_PASSED+=1
    ) else (
        echo [FAIL] %%f
        set /a TESTS_FAILED+=1
    )
    echo -------------------------
)


:: --- Summary ---
echo.
echo =================================
echo           TEST SUMMARY
echo =================================
echo.
echo Passed: !TESTS_PASSED!
echo Failed: !TESTS_FAILED!
echo.

if !TESTS_FAILED! GTR 0 (
    echo Some tests failed.
    exit /b 1
) else (
    echo All tests passed successfully!
    exit /b 0
)