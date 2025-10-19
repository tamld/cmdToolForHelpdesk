@echo off
setlocal enabledelayedexpansion

:: Master Test Runner
:: This script executes all .cmd test files found in its subdirectories.

set "TESTS_DIR=%~dp0"
set "FAILURES=0"

:: Loop through subdirectories (unit, integration, e2e)
for /d %%d in (%TESTS_DIR%*) do (
    if exist "%%d\*.cmd" (
        echo.
        echo =======================================================================
        echo Running tests in: %%~nxd
        echo =======================================================================
        for %%f in ("%%d\*.cmd") do (
            echo.
            echo --- Running: %%~nxf ---
            call "%%f"
            
            :: Use 'if errorlevel 1' for robust failure detection. This checks if errorlevel is 1 or greater.
            if errorlevel 1 (
                echo [ERROR] Test failed: %%~nxf with errorlevel !errorlevel!
                set /a FAILURES+=1
            )
        )
    )
)

echo.
echo =======================================================================
echo Test run finished.

:: Use quotes for robust comparison to handle cases where the variable might be empty.
if "%FAILURES%"=="0" (
    echo All tests passed!
    exit /b 0
) else (
    echo %FAILURES% test(s) failed.
    exit /b 1
)

endlocal