@echo off
setlocal

set "LOG_FILE=%~1"
set "EXPECTED_TEXT=%~2"

if not exist "%LOG_FILE%" (
    echo [FAIL] Log file not found: %LOG_FILE%
    exit /B 1
)

REM Use PowerShell for more robust string searching that is case-insensitive and handles complex strings.
powershell -NoProfile -Command "$content = Get-Content -Path '%LOG_FILE%' -Raw; if ($content -match [regex]::Escape('%EXPECTED_TEXT%')) { exit 0 } else { Write-Host '[FAIL] Did not find expected text.'; exit 1 }"

if %errorlevel% equ 0 (
    echo [PASS] Found expected text: "%EXPECTED_TEXT%"
    exit /B 0
) else (
    echo [FAIL] Details provided by PowerShell.
    exit /B 1
)
