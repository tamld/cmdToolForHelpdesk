echo off
Title Script Auto install Software v0.1 Jan 16, 2023
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo  Run CMD as Administrator...
    goto goUAC
) else (
 goto goADMIN )

REM Go UAC to get Admin privileges
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
REM ========================================================================================================================================	
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
REM ==============================================================================
REM Start of installAIOMenu
REM Install Software Online using Winget or Chocolately
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
REM function install fresh Windows using Winget utilities
:installAIO-Fresh
REM call :settingWindows
REM call :installWinget
REM call :installWinget-Utilities
REM call :installWinget-Remote
REM call :installUnikey
REM call :func_CreateShortcut
REM call :settingPowerPlan
REM call :func_InstallOffice19Pro_VL
REM call :func_InstallSupportAssist
cls
echo.
echo All the steps has been running successfully
echo Logs has been generated and placed in the %temp% folder
echo Have a nice day!
PAUSE
goto :main

REM function install Windows from a backup - has been generated from Winget and reinstalled once
:installAIO-FromBackup
REM call :settingWindows
REM call :installWinget
REM call :installWinget-Utilities
REM call :installWinget-Remote
REM call :installUnikey
REM call :func_InstallOffice19Pro_VL
REM call :func_CreateShortcut
REM call :settingPowerPlan
REM call :func_InstallSupportAssist
echo All the steps has been running successfully
echo Logs has been generated and placed in the %temp% folder
echo Have a nice day!
PAUSE
goto :main
REM End of Install AIO Online
REM ========================================================================================================================================
REM ==============================================================================
REM Start of Windows Office Utilities Menu
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
REM ==============================================================================
REM Start of Windows Office Utilities functions
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
REM End of Windows Office Utilities functions
REM ========================================================================================================================================
:activeLicenses
REM Start of Active Licenses Menu
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
REM End of Active Licenses Menu
REM ==============================================================================
REM Start of Active Lienses functions
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
REM End of Active Lienses functions
REM ========================================================================================================================================
:utilities
setlocal
REM Start of Utilities Menu
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
REM End of Utilities Menu
REM ==============================================================================
REM Start of Utilities functions
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

REM End of Utilities functions
REM ========================================================================================================================================
:winget
setlocal
REM Start of Winget Menu
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
REM End of Winget Menu
REM ==============================================================================
REM Start of Winget functions
:updateWinget-All
    call :checkWinget
	 cls
    REM accept all question with "yes" or "y". All packages will be installed silent with -h
	 REM winget source reset msstore
    echo y | winget upgrade -h --all
	 call :log "Winget finished upgrading all packages successfully"
    goto :winget

:installWinget-RemoteSupport
    call :checkWinget
    cls
    echo y | winget install TeamViewer.TeamViewer -h
	 call :log "Installing Teamviewer"
    REM echo y | winget install TeamViewer.TeamViewer -h --accept-source-agreements
	 call :log "Installing Ultraview"
	 echo y| winget install DucFabulous.UltraViewer -h
    goto :winget

:installWinget-Utilities
    call :checkWinget
    call :log "Starting software utilities installation"
    cls
    echo.
    echo *******************************************
    echo 		List Software to Install
    echo 		7zip, Notepad++, Foxit Reader
    echo 		Zalo, Slack, Skype, Unikey
    echo 		Google Chrome, Firefox
    echo 		BulkCrapUninstaller
    echo 		Google Drive
    echo *******************************************
    timeout 2
    cls
	setlocal
	REM for each software named by command [winget search "software"]
	REM Use the "software ID" instead of Name to specify softwares list
	REM Each software must be gather with ^
	REM The last one use nothing to complete the set packageList variable
	set packageList=7zip.7zip ^
					VNGCorp.Zalo ^
					Foxit.FoxitReader ^
					Google.Chrome ^
					Mozilla.Firefox ^
					Notepad++.Notepad++ ^
					Klocman.BulkCrapUninstaller ^
					google.drive ^
					VideoLAN.VLC
	for %%p in (%packageList%) do (
		call :installSoft %%p
	)
	endlocal
	exit /b
    call :installUnikey
	REM Notepad++ theme is a plus action. Comment "REM" before the function to avoid this task
	call :installNotepadplusplusThemes
	goto :winget

:installWinget
    cls
    call :checkWinget
    goto :winget

REM End of Winget functions
REM ========================================================================================================================================
REM function update CMD via github
:updateCMD
   cls
    ::put actions here
    goto :main

REM ========================================================================================================================================
REM Start of child process that can be reused functions
REM function checkWinget will check if winget is installed or neither. If not, go to installWinget function
:checkWinget
    cls
    if not exist "%localappdata%\Microsoft\WindowsApps\winget.exe" (
       echo Start to install winget
    	 call :log "Winget Installation started"
       call :installWinget
       call :log "Winget Installation finished"
    	 timeout 3
    ) else (
        echo Winget already installed
		  call :log "Winget already installed"
        timeout 3
    )
    exit /b

:installWinget
    cd /d %temp%
    cls
    call :log "Starting Winget installation from GitHub"
    REM Download the latest version of Winget from GitHub
    curl -O -#fsSL https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
    curl -o Microsoft.DesktopAppInstaller.msixbundle -#fsSL https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.VCLibs.x64.14.00.Desktop.appx
    call :log "Finished Winget installation requesting packages"
	 start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.DesktopAppInstaller.msixbundle
    call :log "Finished Winget installation msixbundle"
	 call :log "Finished Winget installation from GitHub"
	 cls
    cd /d "%_dp%"
    exit /b



REM function log will append log to %temp%\installAPP.log with time, date, and the other function task
REM %1 will inherit parameters from outside input function
REM exit /b will exit function instead of remaining running scripts codes
:log
    set logfile=%temp%\installAPP.log
    set timestamp=%date% %time%
    echo %timestamp% %1 >> %logfile%
    goto :EOF

REM function to install soft using Winget utilities
REM to install winget, call function by using call :installsoft "software id"
:installSoft
	REM Set the software name to install
    set "software=%~1"
	REM Set the scope machine if supported
    set "scope=%~2"
	REM Set status software installed or not
	set "installed=0"
	
	REM check if %software has been installed before
	echo y | winget list %software% > nul
	if "%errorlevel%" == "0" (
		set "installed=1"
	)
	if "%installed%"=="0" (
		if "%scope%"=="" (
			echo y | winget install %software%
			call :log "%software% installed without scope"
			cls
		) else (
			echo y | winget install %software% %scope%
			call :log "%software% installed with %scope%"
			cls
		)
	) else (
		echo %software% already installed
		timeout 3
		call :log "%software% already installed"
		cls
	)
    goto :EOF
	
REM function download Unikey from unikey.org, extract to C:\Program Files\Unikey and add to start up
:installUnikey
    cls
    call :log "Starting Unikey installation"
    @echo off
    cd /d %temp%
    call :log "Downloading Unikey"
    curl -# -o unikey43RC5-200929-win64.zip -L https://www.unikey.org/assets/release/unikey43RC5-200929-win64.zip
    if not exist "%ProgramFiles%\7-Zip" (
      call :log "Installing 7zip"
      call :install7zip
    )
    if not exist "C:\Program Files\Unikey" (
      call :log "Unzipping Unikey"
      "c:\Program Files\7-Zip\7z.exe" x -y unikey43RC5-200929-win64.zip -o"C:\Program Files\Unikey"
    )
    call :log "Copying Unikey to Startup"
    xcopy "c:\Program Files\Unikey\UniKeyNT.exe" "%_programDATA%\StartUp" /y
    call :log "Creating Unikey shortcut on desktop"
    mklink "%public%\Desktop\UnikeyNT.exe" "C:\Program Files\Unikey\UniKeyNT.exe"
    cd /d %_dp%
    call :log "Finishing Unikey installation"
    exit /b

function install 7zip by using winget
:install7zip
    cls
    call :checkWinget
    if not exist "%ProgramFiles%\7-Zip" (
      call :log "Starting 7zip installation"
      echo y | winget install 7zip.7zip -h --accept-package-agreements --accept-source-agreements
      call :log "Finishing 7zip installation"
    ) else (
      call :log "7zip already installed"
    )
    REM associate regular files extension with 7zip
    assoc .7z=7-Zip
    assoc .zip=7-Zip
    assoc .rar=7-Zip
    assoc .tar=7-Zip
    assoc .gz=7-Zip
    assoc .bzip2=7-Zip
    assoc .xz=7-Zip
    exit /b
	
:installNotepadplusplusThemes
if not exist "%ProgramFiles(x86)%\Notepad++" (
    call :log "Notepad++ not found, go for it"
	call :checkWinget
	echo y | winget install notepad++.notepad++
	call :log "Notepad++ is installed" )
	call :log "Starting Notepad++ theme installation"
	cd /d %temp%
	echo Notepad++ theme installation started > themes_installation.log
	REM Dracula theme
	call :log "Installing Dracula theme"
	curl https://raw.githubusercontent.com/dracula/notepad-plus-plus/master/Dracula.xml -o Dracula.xml
	xcopy Dracula.xml %AppData%\Notepad++\themes\ /E /C /I /Q >> themes_installation.log
	REM Material Theme
	call :log "Installing Material Theme"
	curl https://raw.githubusercontent.com/HiSandy/npp-material-theme/master/Material%20Theme.xml -o "Material Theme.xml"
	xcopy "Material Theme.xml" %AppData%\Notepad++\themes\ /E /C /I /Q >> themes_installation.log
	REM Nord theme
	call :log "Installing Nord theme"
	curl https://raw.githubusercontent.com/arcticicestudio/nord-notepadplusplus/develop/src/xml/nord.xml -LJ -o Nord.xml
	xcopy Nord.xml %AppData%\Notepad++\themes\ /E /C /I /Q >> themes_installation.log
	REM Mariana theme
	call :log "Installing Mariana theme"
	curl https://raw.githubusercontent.com/Codextor/npp-mariana-theme/master/Mariana.xml -o Mariana.xml
	xcopy Mariana.xml %AppData%\Notepad++\themes\ /E /C /I /Q >> themes_installation.log
	call :log "Notepad++ themes installation finished"
	

REM function force delete all file created in %temp% folder
:clean
    del /q /f /s %temp%\*.*
    REM forfiles search files with criteria > 7 days and delete
    REM forfiles /p %temp% /s /m *.* /d -7 /c "cmd /c del /f /q @path"
    exit /b

REM End of child process functions
REM ========================================================================================================================================
:end
exit