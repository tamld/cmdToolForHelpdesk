@echo off
setlocal EnableDelayedExpansion
REM ==============================================
REM Helpdesk-Tools.refactored.cmd - All-in-One Script
REM ==============================================

REM --- Set script directory ---
set "SCRIPT_DIR=%~dp0"
set "APP_VERSION=v0.6.80-refactored"

REM --- Elevate privileges if not admin ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    call :request_admin
    exit /b
)

REM === Entry Point ===
call :main_menu
exit /b

REM ==========================================================
REM                         MAIN MENU                         
REM ==========================================================
:main_menu
cls
title Helpdesk Toolkit - Main Menu

echo    ========================================================
echo    [1] Essential Network Tools                   : Press 1
echo    [2] System Cleanup ^& Maintenance              : Press 2
echo    [3] Software ^& Package Management             : Press 3
echo    [4] System Shell Tools                        : Press 4
echo    [5] Update Helpdesk Script                    : Press 5
echo    [6] Exit                                      : Press 6
echo    [7] Dev-Functions                             : Press 7
echo    ========================================================

set "menu[1]=menu_network"
set "menu[2]=menu_maintenance"
set "menu[3]=menu_package"
set "menu[4]=menu_shell_tools"
set "menu[5]=update_script"
set "menu[6]=exit_script"
set "menu[7]=dev_functions"

set /p "USER_CHOICE=Press your choice number and hit ENTER: "

call :handle_main_menu !USER_CHOICE!
goto :main_menu

:handle_main_menu
set "sel=%~1"
if defined menu[%sel%] (
    goto :!menu[%sel%]!
) else (
    echo Invalid option. Try again.
    timeout /t 1 >nul
)
goto :eof

REM ==========================================================
REM                 [MENU] SOFTWARE & PACKAGE MANAGEMENT      
REM ==========================================================
:menu_package
cls
echo    ========================================================
echo    [1] Install Common Software (Choco/Winget)    : Press 1
echo    [2] All-in-One Setup (Essential Stack)        : Press 2
echo    [3] List Installed Packages                   : Press 3
echo    [0] Back to Main Menu                         : Press 0
echo    ========================================================
set /p "PKG_CHOICE=Press your choice number and hit ENTER: "


if "%PKG_CHOICE%"=="1" call :pkg_install_common
if "%PKG_CHOICE%"=="2" call :pkg_all_in_one
if "%PKG_CHOICE%"=="3" call :pkg_list_installed
if "%PKG_CHOICE%"=="0" goto :main_menu

goto :menu_package

:pkg_install_common
call :notify_under_construction
goto :menu_package

:pkg_all_in_one
call :notify_under_construction
goto :menu_package

:pkg_list_installed
call :notify_under_construction
goto :menu_package

REM ==========================================================
REM                 [MENU] NETWORK TOOLS                      
REM ==========================================================
:menu_network
cls
echo    ========================================================
echo    [1] Ping Gateway                              : Press 1
echo    [2] Show IP and Gateway                       : Press 2
echo    [3] Flush DNS and Reset Adapter               : Press 3
echo    [0] Back to Main Menu                         : Press 0
echo    ========================================================
set /p "NET_CHOICE=Press your choice number and hit ENTER: "


if "%NET_CHOICE%"=="1" call :net_ping_gateway
if "%NET_CHOICE%"=="2" call :net_show_ip
if "%NET_CHOICE%"=="3" call :net_flush_dns
if "%NET_CHOICE%"=="0" goto :main_menu

goto :menu_network

:net_ping_gateway
call :notify_under_construction
goto :menu_network

:net_show_ip
call :notify_under_construction
goto :menu_network

:net_flush_dns
call :notify_under_construction
goto :menu_network

REM ==========================================================
REM              [MENU] SYSTEM SHELL TOOLS (PAGE 1)          
REM ==========================================================
:menu_shell_tools
goto :menu_shell_page1

:menu_shell_page1
cls
echo    ========================================================
echo    SYSTEM SHELL TOOLS - Page 1/2
echo    [1] Show System Info
echo    [2] List Running Processes
echo    [3] List Services
echo    [4] Export User ^& Group List
echo    [5] View System Event Logs
echo    [6] Enable PowerShell Scripts (Unrestricted)
echo    [7] Open PowerShell as Admin
echo    [N] Next Page
echo    [0] Back to Main Menu
echo    ========================================================
set /p "SHELL_CHOICE=Press your choice number and hit ENTER: "

if "%SHELL_CHOICE%"=="1" call :shell_sysinfo
if "%SHELL_CHOICE%"=="2" call :shell_list_process
if "%SHELL_CHOICE%"=="3" call :shell_list_services
if "%SHELL_CHOICE%"=="4" call :shell_export_users
if "%SHELL_CHOICE%"=="5" call :shell_eventlog_recent
if "%SHELL_CHOICE%"=="6" call :shell_enable_execpolicy
if "%SHELL_CHOICE%"=="7" call :shell_run_ps_admin
if /i "%SHELL_CHOICE%"=="N" goto :menu_shell_page2
if "%SHELL_CHOICE%"=="0" goto :main_menu

goto :menu_shell_page1

:menu_shell_page2
cls
echo    ========================================================
echo    SYSTEM SHELL TOOLS - Page 2/2
echo    [P] Previous Page
echo    [0] Back to Main Menu
echo    ========================================================
set /p "SHELL_P2=Press your choice number and hit ENTER: "

if /i "%SHELL_P2%"=="P" goto :menu_shell_page1
if "%SHELL_P2%"=="0" goto :main_menu

goto :menu_shell_page2

:shell_sysinfo
call :notify_under_construction
goto :menu_shell_page1

:shell_list_process
call :notify_under_construction
goto :menu_shell_page1

:shell_list_services
call :notify_under_construction
goto :menu_shell_page1

:shell_export_users
call :notify_under_construction
goto :menu_shell_page1

:shell_eventlog_recent
call :notify_under_construction
goto :menu_shell_page1

:shell_enable_execpolicy
call :notify_under_construction
goto :menu_shell_page1

:shell_run_ps_admin
call :notify_under_construction
goto :menu_shell_page1

REM ==========================================================
REM                     EXIT / ADMIN SECTION                 
REM ==========================================================
:update_script
call :notify_under_construction
goto :main_menu

:exit_script
cls
echo Exiting Helpdesk Tools. Goodbye!
PAUSE
exit

:request_admin
set "vbsFile=%temp%\getadmin.vbs"
>"%vbsFile%" echo Set UAC = CreateObject("Shell.Application")
set "params=%*"
set "params=%params:"=\"%"
>>"%vbsFile%" echo UAC.ShellExecute "cmd.exe", "/c \"%~s0\" %params%", "", "runas", 1
cscript //nologo "%vbsFile%"
del "%vbsFile%"
exit /b

REM ==========================================================
REM                 [MENU] DEVELOP FUNCTOINS      
REM ==========================================================
:dev_functions
cls
echo    ========================================================
echo    [1] Unikey                                    : Press 1
echo    [2] 7zip                                      : Press 2
echo    [3] Chocolatey                                : Press 3
echo    [4] Winget                                    : Press 4
echo    [5] Fix powershell                            : Press 5
echo    [0] Back to Main Menu                         : Press 0
echo    ========================================================
set /p "DEV_CHOICE=Press your choice number and hit ENTER: "
if "%DEV_CHOICE%"=="1" call :install_unikey
if "%DEV_CHOICE%"=="2" call :install_7zip
if "%DEV_CHOICE%"=="3" call :install_chocolatey
if "%DEV_CHOICE%"=="4" call :install_winget
if "%DEV_CHOICE%"=="5" call :fix_dotnet_for_powershell
if "%DEV_CHOICE%"=="0" goto :main_menu

REM ==========================================================
REM            [SYSTEM CORE UTILITIES / SERVICES]            
REM ==========================================================
:init_environment
REM Initialize variables, temp paths, etc.
goto :eof

:check_requirements
REM Check required tools, packages, network, admin rights...
goto :eof

:get_windows_version
REM Get and store Windows version metadata
goto :eof

:get_hostname
REM Get and store system hostname
goto :eof

:notify_under_construction
REM -- Notify user that the selected function is under construction
echo [NOTICE] ----------------------------------------------------
echo [NOTICE] This function is currently under development.
echo [NOTICE] Please check back later or contribute your ideas.
echo [NOTICE] Visit the project homepage to support or submit PRs.
echo [NOTICE] ----------------------------------------------------
pause
goto :eof

REM ==========================================================
REM                       :extract_zip                       
REM Extract a ZIP file to a given destination using PowerShell
REM Usage: call :extract_zip "file.zip" "dest\\path"
REM ==========================================================
:extract_zip
REM -- Extract a ZIP file to a given destination using PowerShell
REM -- Usage: call :extract_zip "C:\path\to\file.zip" "C:\destination"

if "%~1"=="" (
echo [ERROR] Missing source ZIP file path.
exit /b 1
)

if "%~2"=="" (
echo [ERROR] Missing destination folder path.
exit /b 1
)

set "ZIP_FILE=%~1"
set "DEST_FOLDER=%~2"

if not exist "%ZIP_FILE%" (
echo [ERROR] ZIP file not found: "%ZIP_FILE%"
exit /b 1
)

if not exist "%DEST_FOLDER%" (
echo [INFO] Destination folder not found. Creating: "%DEST_FOLDER%"
mkdir "%DEST_FOLDER%"
)

echo [INFO] Extracting "%ZIP_FILE%" to "%DEST_FOLDER%"...
powershell -NoProfile -Command "try { Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%DEST_FOLDER%' -Force } catch { Write-Error $_; exit 1 }"

if errorlevel 1 (
echo [ERROR] ZIP extraction failed.
exit /b 1
)

echo [SUCCESS] Extraction completed successfully.
goto :eof

REM ==========================================================
REM                       :download_file                     
REM Download file using aria2c / curl / PowerShell fallback
REM Usage: call :download_file "url" "dest\\file"
REM ==========================================================
:download_file
REM -- Download a file using aria2c, curl, or PowerShell as fallback
REM -- Usage: call :download_file "https://url/to/file" "C:\output\file.zip"

setlocal
set "downloadUrl=%~1"
set "outputFile=%~2"

if "%downloadUrl%"=="" (
    echo [ERROR] Missing download URL.
    endlocal & exit /b 1
)

if "%outputFile%"=="" (
    echo [ERROR] Missing output file path.
    endlocal & exit /b 1
)

REM -- Check if aria2c is available
where aria2c >nul 2>&1
if %errorlevel%==0 (
    echo [INFO] Using aria2c to download...
    aria2c -x 16 -s 16 -j 5 -o "%outputFile%" "%downloadUrl%"
    if %errorlevel%==0 endlocal & exit /b 0
)

REM -- Check if curl is available
where curl >nul 2>&1
if %errorlevel%==0 (
    echo [INFO] Using curl to download...
    curl -L -o "%outputFile%" "%downloadUrl%"
    if %errorlevel%==0 endlocal & exit /b 0
)

REM -- Use PowerShell as a fallback
echo [INFO] Using PowerShell to download...
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri '%downloadUrl%' -OutFile '%outputFile%' -UseBasicParsing } catch { Write-Error $_; exit 1 }"
if %errorlevel%==0 endlocal & exit /b 0

echo [ERROR] Download failed using all available methods.
endlocal
exit /b 1

REM ==========================================================
REM                          :kill_tasks                     
REM Terminates known application processes safely            
REM Usage: call :kill_tasks                                  
REM ==========================================================
:kill_tasks
cls
setlocal EnableDelayedExpansion

echo [INFO] Terminating known application processes...

set "appList=notepad++.exe chrome.exe firefox.exe FoxitPDFReader.exe vlc.exe ShareX.exe Everything.exe IObitUnlocker.exe FxSound.exe Telegram.exe Skype.exe Zoom.exe Viber.exe Messenger.exe MobaXterm.exe WinSCP.exe putty.exe VirtualBox.exe rclone.exe RcloneBrowser.exe Advanced_IP_Scanner.exe JDownloader2.exe Code.exe sshfs-win.exe NetworkManager.exe TeamViewer.exe UltraViewer_Desktop.exe AnyDesk.exe UnikeyNT.exe xpipe.exe LocalSend.exe TeraCopy.exe WindowsTerminal.exe LockHunter.exe PDFgear.exe CopyQ.exe HiBitUninstaller.exe Zalo.exe FreeTube.exe VirtualBox-7.1.6-167084-W.exe TeamViewer_Service.exe UltraViewer_Service.exe TeraCopyService.exe msedge.exe "YouTube Music.exe" "PDFLauncher.exe""

set "excludeList=explorer.exe svchost.exe taskmgr.exe cmd.exe conhost.exe winlogon.exe csrss.exe lsass.exe services.exe wininit.exe smss.exe"

for %%a in (%appList%) do (
    set "proc=%%~a"
    echo [CHECK] !proc!...

    echo !excludeList! | find /i "!proc!" >nul
    if !errorlevel! equ 0 (
        echo [SKIP] Essential process: !proc!
    ) else (
        tasklist /fi "imagename eq !proc!" | find /i "!proc!" >nul
        if !errorlevel! equ 0 (
            echo [KILL] Attempting to terminate: !proc!
            taskkill /F /IM "!proc!" >nul 2>&1
            if !errorlevel! equ 0 (
                echo [DONE] Terminated: !proc!
            ) else (
                echo [FAIL] Could not terminate: !proc!
            )
        ) else (
            echo [MISS] Process not running: !proc!
        )
    )
)

echo [INFO] Task killing completed.
endlocal
ping -n 2 localhost >nul
goto :eof

REM ==========================================================
REM                        :clean_temp                       
REM Clean the %TEMP% directory (no log exclusion)            
REM Usage: call :clean_temp                                  
REM ==========================================================
:clean_temp
cls
setlocal EnableDelayedExpansion

echo [INFO] Cleaning temporary files in %TEMP%...

for /F "delims=" %%f in ('dir /B /A:D "%temp%"') do (
    rd /S /Q "%temp%\%%f" >nul 2>&1
)
for %%f in (%temp%\*.*) do (
    del /F /Q "%%f" >nul 2>&1
)

echo [SUCCESS] Temporary files in %TEMP% deleted.
ping -n 3 localhost >nul
endlocal
goto :eof

REM ==========================================================
REM                        :install_unikey                    
REM Extract and shortcut Unikey from pre-downloaded ZIP      
REM Usage: call :install_unikey                              
REM ==========================================================
REM ==========================================================
REM                        :install_unikey                    
REM Download, extract and shortcut Unikey standalone         
REM Usage: call :install_unikey                              
REM ==========================================================
:install_unikey
cls
setlocal

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

REM -- Extract ZIP using PowerShell
powershell -NoProfile -Command "try { Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%TARGET_DIR%' -Force } catch { Write-Error $_; exit 1 }"
if errorlevel 1 (
    echo [ERROR] Failed to extract Unikey ZIP.
    popd & endlocal & exit /b 1
)

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

REM ==========================================================
REM               :fix_dotnet_for_powershell                 
REM Automatically fix missing .NET v4.0.30319 for PowerShell 
REM Usage: call :fix_dotnet_for_powershell                  
REM ==========================================================
:fix_dotnet_for_powershell
setlocal

set "DOTNET_URL=https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe"
set "DOTNET_FILE=%TEMP%\dotnetfx481.exe"

echo [INFO] Downloading .NET Framework 4.8.1 offline installer...
call :download_file "%DOTNET_URL%" "%DOTNET_FILE%"
if errorlevel 1 (
    echo [ERROR] Failed to download .NET Framework installer.
    endlocal & exit /b 1
)

echo [INFO] Installing .NET Framework 4.8.1 silently...
"%DOTNET_FILE%" /quiet /norestart
if errorlevel 1 (
    echo [ERROR] Installation failed.
    del /f /q "%DOTNET_FILE%" >nul 2>&1
    endlocal & exit /b 1
)

echo [SUCCESS] .NET Framework installed successfully.
del /f /q "%DOTNET_FILE%" >nul 2>&1
endlocal
goto :eof

REM ==========================================================
REM                    :add_schedule_upgrade                 
REM Add scheduled tasks to auto-upgrade via winget & choco   
REM Usage: call :add_schedule_upgrade                       
REM ==========================================================
:add_schedule_upgrade
cls
setlocal

echo [INFO] Choose when to schedule the upgrade tasks:
echo [1] At user logon
echo [2] At system startup
echo [3] Daily at 10:00 AM
set /p "SCHEDULE_CHOICE=Select an option (1-3): "

if "%SCHEDULE_CHOICE%"=="1" (
    set "SCHEDULE_TYPE=onlogon"
    set "TIME_PARAM="
) else if "%SCHEDULE_CHOICE%"=="2" (
    set "SCHEDULE_TYPE=onstart"
    set "TIME_PARAM="
) else if "%SCHEDULE_CHOICE%"=="3" (
    set "SCHEDULE_TYPE=daily"
    set "TIME_PARAM=/st 10:00"
) else (
    echo [ERROR] Invalid selection.
    endlocal & exit /b 1
)

REM -- Check if winget exists
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Winget not found. Cannot schedule upgrade.
) else (
    echo [INFO] Creating scheduled task: Winget Upgrade...
    schtasks /create ^
        /tn "Winget Upgrade" ^
        /tr "winget upgrade -h --all" ^
        /sc %SCHEDULE_TYPE% %TIME_PARAM% ^
        /ru %USERNAME% ^
        /f >nul 2>&1

    if %errorlevel%==0 (
        echo [SUCCESS] Winget upgrade task created.
    ) else (
        echo [ERROR] Failed to create Winget upgrade task.
    )
)

REM -- Check if choco exists
where choco >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Chocolatey not found. Cannot schedule upgrade.
) else (
    echo [INFO] Creating scheduled task: Choco Upgrade...
    schtasks /create ^
        /tn "Choco Upgrade" ^
        /tr "choco upgrade all -y" ^
        /sc %SCHEDULE_TYPE% %TIME_PARAM% ^
        /ru %USERNAME% ^
        /f >nul 2>&1

    if %errorlevel%==0 (
        echo [SUCCESS] Choco upgrade task created.
    ) else (
        echo [ERROR] Failed to create Choco upgrade task.
    )
)

endlocal
goto :eof

REM ==========================================================
REM                    :choco_install_package                 
REM Install a given software package via Chocolatey          
REM Usage: call :choco_install_package <package_name>        
REM ==========================================================
:choco_install_package
cls
setlocal

set "software=%~1"

if "%software%"=="" (
    echo [ERROR] No software package specified.
    endlocal & exit /b 1
)

REM -- Check if Chocolatey exists
where choco >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Chocolatey is not available on this system.
    endlocal & exit /b 1
)

REM -- Check if package is already installed
choco list --local-only "%software%" | findstr /i "^%software%" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Installing %software%...
    choco install "%software%" -y >nul 2>&1
    if errorlevel 0 (
        echo [SUCCESS] %software% installed successfully.
    ) else (
        echo [ERROR] Failed to install %software%.
        endlocal & exit /b 1
    )
) else (
    echo [INFO] %software% is already installed.
)

endlocal
goto :eof

REM ==========================================================
REM                   :winget_install_package                
REM Install a given software package via Winget              
REM Usage: call :winget_install_package <package_name>       
REM ==========================================================
:winget_install_package
cls
setlocal

set "software=%~1"

if "%software%"=="" (
    echo [ERROR] No software package specified.
    endlocal & exit /b 1
)

REM -- Check if Winget exists
where winget >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Winget is not available on this system.
    endlocal & exit /b 1
)

REM -- Check if package is already installed
winget list --exact --name "%software%" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Installing %software%...
    winget install --exact --accept-source-agreements --accept-package-agreements -h --name "%software%" >nul 2>&1
    if errorlevel 0 (
        echo [SUCCESS] %software% installed successfully.
    ) else (
        echo [ERROR] Failed to install %software%.
        endlocal & exit /b 1
    )
) else (
    echo [INFO] %software% is already installed.
)

endlocal
goto :eof
