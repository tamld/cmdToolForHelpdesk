@echo off
setlocal enabledelayedexpansion

:: =============================================================================
:: test_runner.cmd
:: Master test runner for the Helpdesk-Tools project.
:: It discovers and executes all test cases based on category.
:: =============================================================================

:: Change to the script's own directory to ensure consistent paths
cd /d "%~dp0"

set "TESTS_PASSED=0"
set "TESTS_FAILED=0"

set "TEST_CATEGORY=%~1"

if /i "%TEST_CATEGORY%"=="" (
    echo Running ALL tests.
    set "TEST_CATEGORY=all"
) else (
    echo Running tests for category: %TEST_CATEGORY%
)

:: --- Run Unit Tests ---
if /i "%TEST_CATEGORY%"=="all" (
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
) else if /i "%TEST_CATEGORY%"=="unit" (
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
)

:: --- Run Integration Tests ---
if /i "%TEST_CATEGORY%"=="all" (
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
) else if /i "%TEST_CATEGORY%"=="integration" (
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