@echo off
setlocal

:: Master Test Runner - File Reporting Version

set "FAILURES=0"
set "RESULT_FILE=%~dp0reports\test_result.txt"

if not exist "%~dp0reports" mkdir "%~dp0reports"

for /d %%d in (%~dp0*) do (
    if exist "%%d\*.cmd" (
        echo.
        echo =======================================================================
        echo Verifying outcomes in: %%~nxd
        echo =======================================================================
        for %%f in ("%%d\*.cmd") do (
            echo.
            echo --- Verifying: %%~nxf ---
            call "%%f"
            if errorlevel 1 (
                echo [ERROR] Verification failed: %%~nxf
                set /a FAILURES+=1
            )
        )
    )
)

echo.
echo =======================================================================
echo Verification run finished.

if %FAILURES% GEQ 1 (
    echo %FAILURES% verification(s) failed.
    echo 1 > %RESULT_FILE%
) else (
    echo All verifications passed!
    echo 0 > %RESULT_FILE%
)

endlocal
goto :EOF
