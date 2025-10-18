@echo off

:: TEST UTILS DISPATCHER
if /i "%~1"=="assertSuccess" goto :assertSuccess
if /i "%~1"=="assertEqual" goto :assertEqual
if /i "%~1"=="assertFileContains" goto :assertFileContains
goto :eof

setlocal

::
:: test_utils.cmd
:: Core assertion library for the testing framework.
::

:: =============================================================================
:: :assertSuccess
:: Checks if the last command executed successfully (ERRORLEVEL is 0).
:: If not, it echoes a failure message and exits with error code 1.
::
:: Usage:
::   call :myFunction
::   call :assertSuccess
:: =============================================================================
:assertSuccess
    if %ERRORLEVEL% EQU 0 (
        exit /b 0
    ) else (
        echo [FAIL] Assertion failed: Expected ERRORLEVEL 0, but got %ERRORLEVEL%.
        exit /b 1
    )
    goto :eof

:: =============================================================================
:: :assertEqual
:: Checks if two strings are equal.
::
:: Usage:
::   call :assertEqual "%variable%" "expected_value"
:: =============================================================================
:assertEqual
    if "%~1" == "%~2" (
        exit /b 0
    ) else (
        echo [FAIL] Assertion failed: Expected \"%~2\", but got \"%~1\".
        exit /b 1
    )
    goto :eof

:: =============================================================================
:: :assertFileContains
:: Checks if a file contains a specific string.
::
:: Usage:
::   call :assertFileContains "path/to/file.log" "string to find"
:: =============================================================================
:assertFileContains
    findstr /c:"%~2" "%~1" >nul
    if %errorlevel% equ 0 (
        exit /b 0
    ) else (
        echo [FAIL] Assertion failed: Expected to find \"%~2\" in \"%~1\".
        exit /b 1
    )
    goto :eof

