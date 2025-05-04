@echo off
setlocal EnableDelayedExpansion

:: Define parent directory (project root)
set "PROJECT_ROOT=%~dp0.."

:: Get absolute path of project root directory
pushd "%PROJECT_ROOT%"
set "PROJECT_DIR=%CD%"
popd

:: Check if Windows Sandbox feature is enabled
echo [*] Checking if Windows Sandbox is enabled...
dism /online /Get-FeatureInfo /FeatureName:Containers-DisposableClientVM | findstr /i "State : Enabled" >nul
if errorlevel 1 (
    echo.
    echo [!] Windows Sandbox is currently disabled.
    echo     It is required for this script to work.
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

:: Define the temporary .wsb file path
set "WSB_FILE=%temp%\_sandbox_runner.wsb"

:: Check if Sandbox is already running and force-close it
echo [*] Checking if Sandbox is already running...
tasklist | find /i "WindowsSandbox.exe" >nul
if not errorlevel 1 (
    echo [*] Sandbox is currently running. Closing it...
    taskkill /f /im WindowsSandbox.exe >nul 2>&1
    taskkill /f /im WindowsSandboxClient.exe >nul 2>&1
    timeout /t 2 /nobreak >nul
)

:: Generate Windows Sandbox configuration file (.wsb)
> "%WSB_FILE%" (
    echo ^<Configuration^>
    echo   ^<MappedFolders^>
    echo     ^<MappedFolder^>
    echo       ^<HostFolder^>%PROJECT_DIR%^</HostFolder^>
    echo       ^<ReadOnly^>false^</ReadOnly^>
    echo     ^</MappedFolder^>
    echo   ^</MappedFolders^>
    echo
    echo   ^<LogonCommand^>
    echo     ^<Command^>
    echo       cmd /c "mkdir %%UserProfile%%\Desktop\HelpdeskTools 2>nul & for /f %%i in ('dir /b "C:\Users\WDAGUtilityAccount\Documents\*.cmd"') do copy "C:\Users\WDAGUtilityAccount\Documents\%%i" "%%UserProfile%%\Desktop\HelpdeskTools\%%i" >nul & echo Copied: %%i"
    echo       start cmd /c "%%UserProfile%%\Desktop\HelpdeskTools\Helpdesk-Tools.cmd"
    echo     ^</Command^>
    echo   ^</LogonCommand^>
    echo ^</Configuration^>
)

:: Launch Windows Sandbox
echo.
echo [*] Launching Windows Sandbox with all CMD files...
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