@echo off
setlocal enabledelayedexpansion

:: Master Test Runner - Final Robust Version

set "FAILURES=0"

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
            if !errorlevel! neq 0 (
                echo [ERROR] Test failed: %%~nxf
                set /a FAILURES+=1
            )
        )
    )
)

echo.
echo =======================================================================
echo Test run finished.

if !FAILURES! gtr 0 (
    echo !FAILURES! test(s) failed.
    exit /b 1
) else (
    echo All tests passed!
    exit /b 0
)

endlocal