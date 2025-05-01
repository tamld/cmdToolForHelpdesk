@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: ================== CONFIGURATION ==================
set VMNAME=Windows 10 MSIX packaging environment
:: ===================================================

:: Handle no parameter case
if "%~1"=="" call :usage & goto :eof

set ACTION=%~1
set PARAM=%~2

:: ---------------- START VM ----------------
if /i "%ACTION%"=="start" (
    powershell -Command "Start-VM -Name '%VMNAME%'"
    goto :eof
)

:: ---------------- STOP VM ----------------
if /i "%ACTION%"=="stop" (
    powershell -Command "Stop-VM -Name '%VMNAME%'"
    goto :eof
)

:: ---------------- FORCE STOP VM ----------------
if /i "%ACTION%"=="force-off" (
    powershell -Command "Stop-VM -Name '%VMNAME%' -Force"
    goto :eof
)

:: ---------------- FORCE CLOSE VM WINDOW ----------------
if /i "%ACTION%"=="force-close-hyperv" (
    taskkill /f /im vmconnect.exe >nul 2>&1
    goto :eof
)

:: ---------------- LIST VMs ----------------
if /i "%ACTION%"=="list-vms" (
    powershell -Command "Get-VM | Select-Object Name, State"
    goto :eof
)

:: ---------------- LIST SNAPSHOTS ----------------
if /i "%ACTION%"=="list-snapshots" (
    echo [^>] Snapshots for VM %VMNAME%:
    powershell -Command ^
        "$snaps = Get-VMSnapshot -VMName '%VMNAME%' | Sort-Object CreationTime;" ^
        "$i = 1; $snaps | ForEach-Object { Write-Host ($i.ToString('00'))':' $_.Name ' - ' $_.CreationTime; $i++ }"
    goto :eof
)

:: ---------------- CREATE SNAPSHOT ----------------
if /i "%ACTION%"=="snapshot" (
    call :doSnapshot %PARAM%
    goto :eof
)

:: ---------------- REVERT SNAPSHOT ----------------
if /i "%ACTION%"=="revert" (
    call :handle_revert %PARAM%
    goto :eof
)

:: ---------------- DELETE SNAPSHOT ----------------
if /i "%ACTION%"=="delete-snapshot" (
    call :handle_delete_snapshot %PARAM%
    goto :eof
)

:: ---------------- UNKNOWN ----------------
echo [!] Unknown command: %ACTION%
goto :eof

:: ================ USAGE ============================
:usage
echo.
echo === Hyper-V Orchestrator ===
echo Usage: %~nx0 ^<command^> [optional-argument]
echo.
echo Available commands:
echo   start                    - Start the virtual machine
echo   stop                     - Gracefully shut down the VM
echo   force-off                - Force power off the VM
echo   snapshot [name]          - Create a new snapshot (name optional)
echo   list-snapshots           - List all snapshots with numbered index
echo   revert [index]           - Revert VM to a specific snapshot
echo   delete-snapshot [index]  - Delete a specific snapshot (with confirm)
echo   list-vms                 - List all virtual machines
echo   force-close-hyperv       - Force close Hyper-V VM connection window
echo.
echo Example:
echo   %~nx0 snapshot 01_Baseline
echo   %~nx0 revert 2
goto :eof

:: ================ SNAPSHOT CREATION ================
:doSnapshot
set SNAPNAME=%~1

if "%SNAPNAME%"=="" (
    set /p SNAPNAME=Enter snapshot name:
)

if "%SNAPNAME%"=="" (
    echo [!] Snapshot name cannot be empty.
    goto :eof
)

echo [+] Creating snapshot "%SNAPNAME%"...
powershell -Command "Checkpoint-VM -VMName '%VMNAME%' -SnapshotName '%SNAPNAME%'"
goto :eof

:: ================ SNAPSHOT REVERT ==================
:handle_revert
set INDEX=%~1

if "%INDEX%"=="" (
    echo [^>] Available Snapshots for VM "%VMNAME%":
    powershell -Command ^
        "$snaps = Get-VMSnapshot -VMName '%VMNAME%' | Sort-Object CreationTime;" ^
        "$i = 1; $snaps | ForEach-Object { Write-Host ($i.ToString('00'))':' $_.Name ' - ' $_.CreationTime; $i++ }"
    set /p INDEX=Enter snapshot index to revert to:
)

set /a ACTUAL_INDEX=%INDEX%-1
if errorlevel 1 (
    echo [!] Invalid input. Must be a number.
    goto :eof
)
if %ACTUAL_INDEX% LSS 0 (
    echo [!] Index must be >= 1.
    goto :eof
)

echo [+] Reverting to snapshot #%INDEX%...

set PSFILE=%TEMP%\revert_vm.ps1
(
    echo $snaps = Get-VMSnapshot -VMName '%VMNAME%' ^| Sort-Object CreationTime;
    echo $target = $snaps[%ACTUAL_INDEX%];
    echo if ($null -eq $target^) { Write-Host "Invalid snapshot index!" -ForegroundColor Red; exit 1 }
    echo Restore-VMSnapshot -VMName '%VMNAME%' -Name $target.Name -Confirm:$false
) > "%PSFILE%"

powershell -ExecutionPolicy Bypass -File "%PSFILE%"
del "%PSFILE%" >nul 2>&1

goto :eof

:: ================ SNAPSHOT DELETE ==================
:handle_delete_snapshot
set INDEX=%~1

if "%INDEX%"=="" (
    echo [^>] Available Snapshots for VM "%VMNAME%":
    powershell -Command ^
        "$snaps = Get-VMSnapshot -VMName '%VMNAME%' | Sort-Object CreationTime;" ^
        "$i = 1; $snaps | ForEach-Object { Write-Host ($i.ToString('00'))':' $_.Name ' - ' $_.CreationTime; $i++ }"
    set /p INDEX=Enter snapshot index to delete:
)

set /a ACTUAL_INDEX=%INDEX%-1
if errorlevel 1 (
    echo [!] Invalid input. Must be a number.
    goto :eof
)
if %ACTUAL_INDEX% LSS 0 (
    echo [!] Index must be >= 1.
    goto :eof
)

set /p CONFIRM=Are you sure you want to delete snapshot #%INDEX%? (y/n): 
if /i not "%CONFIRM%"=="y" (
    echo [!] Deletion aborted by user.
    goto :eof
)

echo [+] Deleting snapshot #%INDEX%...

set PSFILE=%TEMP%\delete_vm.ps1
(
    echo $snaps = Get-VMSnapshot -VMName '%VMNAME%' ^| Sort-Object CreationTime;
    echo $target = $snaps[%ACTUAL_INDEX%];
    echo if ($null -eq $target^) { Write-Host "Invalid snapshot index!" -ForegroundColor Red; exit 1 }
    echo Remove-VMSnapshot -VMName '%VMNAME%' -Name $target.Name -Confirm:$false
) > "%PSFILE%"

powershell -ExecutionPolicy Bypass -File "%PSFILE%"
del "%PSFILE%" >nul 2>&1

goto :eof
