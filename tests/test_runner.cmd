@echo off
setlocal

:: Master Test Runner - Robust Version 2

set "FAILURES=0"
set "RESULT_FILE=%~dp0reports\test_result.txt"

:: Ensure reports directory exists
if not exist "%~dp0reports" mkdir "%~dp0reports"

for /d %%d in (%~dp0*) do (
    if exist "%%d\*.cmd" (
        echo.
        echo =======================================================================
        echo Running tests in: %%~nxd
        echo =======================================================================
        for %%f in ("%%d\*.cmd") do (
            echo.
            echo --- Running: %%~nxf ---
            call "%%f"
            if errorlevel 1 (
                echo [ERROR] Test failed: %%~nxf
                set /a FAILURES+=1
            )
        )
    )
)

echo.
echo =======================================================================
echo Test run finished.

if %FAILURES% GEQ 1 (
    echo %FAILURES% test(s) failed.
    echo 1 > %RESULT_FILE%
) else (
    echo All tests passed!
    echo 0 > %RESULT_FILE%
)

endlocal
goto :EOF