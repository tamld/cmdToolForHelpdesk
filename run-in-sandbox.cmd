@echo off
setlocal EnableDelayedExpansion

:: Define the target .cmd file to copy into Windows Sandbox
set "CMD_FILE=Helpdesk-Tools.cmd"

:: Check if the target file exists
if not exist "%CMD_FILE%" (
    echo [ERROR] %CMD_FILE% not found in current directory.
    exit /b 1
)

:: Check if Windows Sandbox feature is enabled
echo [*] Checking if Windows Sandbox is enabled...
dism /online /Get-FeatureInfo /FeatureName:Containers-DisposableClientVM | findstr /i "State : Enabled" >nul
if errorlevel 1 (
    echo.
    echo [!] Windows Sandbox is currently disabled.
    echo     It is required for this script to work.
    echo.
    echo.
       echo Do you want to enable Windows Sandbox now? [Y/N]
       choice /c YN /n
       if errorlevel 2 (
    echo [*] Sandbox setup cancelled by user.
    exit /b 0
)


    echo [*] Enabling Windows Sandbox feature...
    dism /online /Enable-Feature /FeatureName:Containers-DisposableClientVM /All

    echo.
    echo [*] Windows Sandbox has been enabled.
    echo     A system restart is required for it to take effect.
    echo     Please reboot and run this script again.
    pause
    exit /b 0
)

:: Get absolute path of current directory
set "CURRENT_DIR=%~dp0"
set "CURRENT_DIR=%CURRENT_DIR:~0,-1%"

:: Define the temporary .wsb file path
set "WSB_FILE=%temp%\_sandbox_runner.wsb"

:: Generate Windows Sandbox configuration file (.wsb)
> "%WSB_FILE%" (
    echo ^<Configuration^>
    echo   ^<MappedFolders^>
    echo     ^<MappedFolder^>
    echo       ^<HostFolder^>%CURRENT_DIR%^</HostFolder^>
    echo       ^<ReadOnly^>false^</ReadOnly^>
    echo     ^</MappedFolder^>
    echo   ^</MappedFolders^>
    echo
    echo   ^<LogonCommand^>
    echo     ^<Command^>
    echo       cmd /c copy "C:\Users\WDAGUtilityAccount\Documents\%CMD_FILE%" "%%UserProfile%%\Desktop\%CMD_FILE%"
    echo     ^</Command^>
    echo   ^</LogonCommand^>
    echo ^</Configuration^>
)

:: Launch Windows Sandbox
echo.
echo [*] Launching Windows Sandbox with %CMD_FILE%...
start "" "%WSB_FILE%"

:: Wait for sandbox to exit
echo [*] Waiting for Sandbox to close...
:waitSandbox
tasklist | find /i "WindowsSandbox.exe" >nul
if not errorlevel 1 (
    timeout /t 2 /nobreak >nul
    goto :waitSandbox
)

:: Clean up
echo [*] Cleaning up temporary file: %WSB_FILE%
del /f /q "%WSB_FILE%"

echo [*] Done.
endlocal
exit /b 0
