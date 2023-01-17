echo off
Title Script Auto install Software v0.1 Jan 16, 2023
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo  Run CMD as Administrator...
    goto goUAC
) else (
 goto goADMIN )

rem Go UAC to get Admin privileges
:goUAC
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:goADMIN
    pushd "%CD%"
    CD /D "%~dp0"
rem ========================================================================================================================================	
:main
setlocal
set "_dp=%~dp0"
set "_sys32=%windir%\system32"
call :get_OfficePath
set "_officePath=%cd%"
set "_programDATA=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
cd /d "%_dp%"
cls
title Main Menu
echo.
echo    =================================================
echo    [1] Install AIO Online                  : Press 1
echo    [2] Windows Office Utilities            : Press 2
echo    [3] Active Licenses                     : Press 3
echo    [4] Utilities                           : Press 4
echo    [5] Winget                              : Press 5
echo    [6] Update CMD                          : Press 6
echo    [7] Exit                                : Press 7
echo    =================================================
Choice /N /C 1234567 /M " Your choice is :"
if ERRORLEVEL == 7 goto end
if ERRORLEVEL == 6 goto updateCMD-Menu
if ERRORLEVEL == 5 goto winget
if ERRORLEVEL == 4 goto utilities
if ERRORLEVEL == 3 goto activeO-W
if ERRORLEVEL == 2 goto office-windows
if ERRORLEVEL == 1 goto installAIOMenu
endlocal
goto end
REM ========================================================================================================================================
rem ==============================================================================
rem Start of installAIOMenu
rem Install Software Online using Winget or Chocolately
:installAIOMenu
setlocal
cls
title Install AIO online
echo.
echo  Sub menu Install AIO online
echo.
echo        =================================================
echo        [1] Fresh Install                       : Press 1
echo        [2] From Backup                         : Press 2
echo        [3] Main Menu                           : Press 3
echo        =================================================
Choice /N /C 123 /M " Press your choice : "
if ERRORLEVEL == 3 goto main
if ERRORLEVEL == 2 goto installAIO-FromBackup
if ERRORLEVEL == 1 goto installAIO-Fresh
endlocal
REM ========================================================================================================================================
rem function install fresh Windows using Winget utilities
:installAIO-Fresh
rem call :settingWindows
rem call :installWinget
rem call :installWinget-Utilities
rem call :installWinget-Remote
rem call :installUnikey
rem call :func_CreateShortcut
rem call :settingPowerPlan
rem call :func_InstallOffice19Pro_VL
REM call :func_InstallSupportAssist
cls
echo.
echo All the steps has been running successfully
echo Logs has been generated and placed in the %temp% folder
echo Have a nice day!
PAUSE
goto :main

rem function install Windows from a backup - has been generated from Winget and reinstalled once
:installAIO-FromBackup
rem call :settingWindows
rem call :installWinget
rem call :installWinget-Utilities
rem call :installWinget-Remote
rem call :installUnikey
rem call :func_InstallOffice19Pro_VL
rem call :func_CreateShortcut
rem call :settingPowerPlan
rem call :func_InstallSupportAssist
goto :main
rem End of Install AIO Online
rem ==============================================================================



REM ========================================================================================================================================
:end
exit