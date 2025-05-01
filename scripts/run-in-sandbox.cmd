REM ==========================================================
REM                        :install_unikey                    
REM Download, extract and shortcut Unikey standalone         
REM Usage: call :install_unikey                              
REM ==========================================================
:install_unikey
cls
setlocal
@echo off
set "UNIZIP=unikey46RC2-230919-win64.zip"
set "UNIURL=https://www.unikey.org/assets/release/%UNIZIP%"
set "TARGET_DIR=C:\Program Files\Unikey"
set "ZIP_PATH=%TEMP%\%UNIZIP%"

pushd %TEMP%

REM -- Download ZIP with curl
curl -L -# -o "%ZIP_PATH%" "%UNIURL%"
if errorlevel 1 (
    echo [ERROR] Failed to download Unikey ZIP.
    popd & endlocal & exit /b 1
)
PAUSE
REM -- Extract ZIP using PowerShell
start powershell -NoProfile -Command "try { Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%TARGET_DIR%' -Force } catch { Write-Error $_; exit 1 }"
if errorlevel 1 (
    echo [ERROR] Failed to extract Unikey ZIP.
    popd & endlocal & exit /b 1
)
PAUSE
REM -- Create startup shortcut
if defined startProgram (
    echo [INFO] Creating shortcut in Startup folder...
    mklink "%startProgram%\StartUp\UniKeyNT.lnk" "%TARGET_DIR%\UniKeyNT.exe" >nul 2>&1
)

REM -- Create desktop shortcut
if defined public (
    echo [INFO] Creating desktop shortcut...
    mklink "%public%\Desktop\UniKeyNT.exe" "%TARGET_DIR%\UniKeyNT.exe" >nul 2>&1
)

popd
endlocal
echo [SUCCESS] Unikey installed successfully.
goto :eof