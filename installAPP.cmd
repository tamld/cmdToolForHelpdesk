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
set "_dp=%~dp0"
set "_sys32=%windir%\system32"
call :get_OfficePath
set "_officePath=%cd%"
set "_programDATA=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
cd /d "%_dp%"
setlocal
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
if ERRORLEVEL == 6 goto updateCMD
if ERRORLEVEL == 5 goto winget
if ERRORLEVEL == 4 goto utilities
if ERRORLEVEL == 3 goto activeLicenses
if ERRORLEVEL == 2 goto office-windows
if ERRORLEVEL == 1 goto installAIOMenu
endlocal
goto end
REM ========================================================================================================================================
rem ==============================================================================
rem Start of installAIOMenu
rem Install Software Online using Winget or Chocolately
REM #installAIOMenu
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
echo All the steps has been running successfully
echo Logs has been generated and placed in the %temp% folder
echo Have a nice day!
PAUSE
goto :main
rem End of Install AIO Online
REM ========================================================================================================================================
rem ==============================================================================
rem Start of Windows Office Utilities Menu
:office-windows
setlocal
cd /d %_dp%
cls
title Office Main Menu
echo.
echo  Sub menu Office
echo.
echo        =================================================
echo        [1] Install Office Online               : Press 1
echo        [2] Uninstall Office                    : Press 2
echo        [3] Remove Office Key                   : Press 3
echo        [4] Convert Office Retail ^<==^> VL       : Press 4
echo        [5] Fix Noncore Windows                 : Press 5
echo        [6] Load SKUS Windows                   : Press 6
echo        [7] Main Menu                           : Press 7
echo        =================================================
Choice /N /C 12345678 /M " Press your choice : "
if ERRORLEVEL == 7 goto :main
if ERRORLEVEL == 6 goto :loadSkus
if ERRORLEVEL == 5 goto :fixNonCore
if ERRORLEVEL == 4 goto :convertOfficeEddition
if ERRORLEVEL == 3 goto :removeOfficeKey
if ERRORLEVEL == 2 goto :uninstallOffice
if ERRORLEVEL == 1 goto :installOffice
endlocal
rem ==============================================================================
rem Start of Windows Office Utilities functions
:loadSkus
cls
::put actions here
goto :office-windows

:fixNonCore
cls
::put actions here
goto :office-windows

:convertOfficeEddition
cls
::put actions here
goto :office-windows

:removeOfficeKey
cls
::put actions here
goto :office-windows

:uninstallOffice
cls
::put actions here
goto :office-windows

:installOffice
cls
::put actions here
goto :office-windows
rem End of Windows Office Utilities functions
REM ========================================================================================================================================
:activeLicenses
rem Start of Active Licenses Menu
setlocal
Title Active Licenses Menu
cls
echo.
echo  Sub menu Active Licenses
echo.
echo        =================================================
echo        [1] Online                              : Press 1
echo        [2] By Phone                            : Press 2
echo        [3] Check Licenses                      : Press 3
echo        [4] Backup Licenses                     : Press 4
echo        [5] Restore License                     : Press 5
echo        [6] MAS                                 : Press 6
echo        [7] Back to Main Menu                   : Press 7
echo        =================================================
Choice /N /C 1234567 /M " Press your choice : "
if ERRORLEVEL == 7 goto :main
if ERRORLEVEL == 6 goto :MAS
if ERRORLEVEL == 5 goto :restoreLicenses
if ERRORLEVEL == 4 goto :backupLicenses
if ERRORLEVEL == 3 goto :checkLicense
if ERRORLEVEL == 2 goto :activeByPhone
if ERRORLEVEL == 1 goto :activeOnline
goto main
endlocal
rem End of Active Licenses Menu
rem ==============================================================================
rem Start of Active Lienses functions
:MAS
    cls
    ::put actions here
    goto :activeLicenses

:restoreLicenses
    cls
    ::put actions here
    goto :activeLicenses

:backupLicenses
    cls
    ::put actions here
    goto :activeLicenses

:checkLicense
    cls
    ::put actions here
    goto :activeLicenses

:activeByPhone
    cls
    ::put actions here
    goto :activeLicenses

:activeOnline
    cls
    ::put actions here
    goto :activeLicenses
rem End of Active Lienses functions
REM ========================================================================================================================================
:utilities
setlocal
rem Start of Utilities Menu
cls
title Utilities Main Menu
echo.
echo  Sub menu Utilities
echo.
echo        =================================================
echo        [1] Set High Performance                : Press 1
echo        [2] Change hostname                     : Press 2
echo        [3] Clean up system                     : Press 3
echo        [4] Upgrade online al                   : Press 4
echo        [5] Join domain                         : Press 5
echo        [6] Install SupportAssistInstaller      : Press 6
echo        [7] Restart Windows                     : Press 7
echo        [8] Add user local admin                : Press 8
echo        [9] Back to Main Menu                   : Press 9
echo        =================================================
Choice /N /C 123456789 /M " Press your choice : "
if ERRORLEVEL == 9 goto :main
if ERRORLEVEL == 8 goto :addLocalUser
if ERRORLEVEL == 7 goto :restartPC
if ERRORLEVEL == 6 goto :installSupportAssist
if ERRORLEVEL == 5 goto :joinDomain
if ERRORLEVEL == 4 goto :updateWinget-All
if ERRORLEVEL == 3 goto :cleanUpSystem
if ERRORLEVEL == 2 goto :changeHostName
if ERRORLEVEL == 1 goto :setHighPerformance
endlocal
rem End of Utilities Menu
rem ==============================================================================
rem Start of Utilities functions
:addLocalUser
    cls
    ::put actions here
    goto :utilities

:restartPC
   cls
    ::put actions here
    goto :utilities

:installSupportAssist
   cls
    ::put actions here
    goto :utilities

:joinDomain
   cls
    ::put actions here
    goto :utilities

:updateWinget-All
   cls
    ::put actions here
    goto :utilities

:cleanUpSystem
   cls
    ::put actions here
    goto :utilities

:changeHostName
   cls
    ::put actions here
    goto :utilities

:setHighPerformance
   cls
    ::put actions here
    goto :utilities

rem End of Utilities functions
REM ========================================================================================================================================
:winget
setlocal
rem Start of Winget Menu
cd /d %_dp%
cls
title Winget Main Menu
echo.
echo                    ============================================================
echo                    [  1. Install Winget         		: Press 1  ]
echo                    [  2. Install Utilities online      		: Press 2  ]
echo                    [  3. Install Remote Support          	: Press 3  ]
echo                    [  4. Upgrade online all           		: Press 4  ]
echo                    [  5. Main Menu                             	: Press 5  ]
echo                    ============================================================
Choice /N /C 12345 /M " Press your choice : "
if ERRORLEVEL == 5 goto :main
if ERRORLEVEL == 4 goto :updateWinget-All
if ERRORLEVEL == 3 goto :installWinget-RemoteSupport
if ERRORLEVEL == 2 goto :installWinget-Utilities
if ERRORLEVEL == 1 goto :installWinget
endlocal
rem End of Winget Menu
rem ==============================================================================
rem Start of Winget functions
:updateWinget-All
   cls
    ::put actions here
    goto :winget

:installWinget-RemoteSupport
   cls
    ::put actions here
    goto :winget

:installWinget-Utilities
   cls
    ::put actions here
    goto :winget

:installWinget
   cls
    ::put actions here
    goto :winget

rem End of Winget functions
REM ========================================================================================================================================
rem function update CMD via github
:updateCMD
   cls
    ::put actions here
    goto :main

REM ========================================================================================================================================
rem Start of child process functions

rem End of child process functions
REM ========================================================================================================================================
:end
exit