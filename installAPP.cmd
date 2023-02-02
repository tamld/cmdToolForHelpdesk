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
	@echo off
	REM version 0.1
	set "version=0.1"
	set "dp=%~dp0"
	set "sys32=%windir%\system32"
	REM call :get_OfficePath
	REM set "_officePath=%cd%"
	set "programDATA=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
	cd /d "%dp%"
	cls
	setlocal
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
	if ERRORLEVEL == 6 call :updateCMD & goto :main
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
	call :hold
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
	cls
	call :hold
	goto :main
REM End of Install AIO Online
REM ========================================================================================================================================
REM ==============================================================================
REM Start of Windows Office Utilities Menu
:office-windows
	setlocal
	cd /d %dp%
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
	Choice /N /C 1234567 /M " Press your choice : "
	if ERRORLEVEL == 7 goto :main
	if ERRORLEVEL == 6 goto :loadSkus
	if ERRORLEVEL == 5 goto :fixNonCore
	if ERRORLEVEL == 4 goto :convertOfficeEddition
	if ERRORLEVEL == 3 goto :removeOfficeKey
	if ERRORLEVEL == 2 goto :uninstallOffice
	if ERRORLEVEL == 1 goto :installOfficeMenu
	endlocal
REM ==============================================================================
REM Start of Windows Office Utilities functions
REM ==============================================================================
REM Sub menu Install Office Online
:installOfficeMenu
	Title Select Office Version to Install
	cls
	echo.
	echo  Sub menu Install Office Online
	echo.
	echo                =================================================
	echo                [1] Office 365                          : Press 1
	echo                [2] Office 2021 Proplus Retail          : Press 2
	echo                [3] Office 2019 Proplus Retail          : Press 3
	echo                [4] Office 2016 Proplus Retail          : Press 4
	echo                [5] Main Menu                           : Press 5
	echo                =================================================
	Choice /N /C 12345 /M " Press your choice : "
	if ERRORLEVEL == 5 goto :office-windows
	if ERRORLEVEL == 4 set office=2016& call :defineOffice& goto :office-windows
	if ERRORLEVEL == 3 set office=2019& call :defineOffice& goto :office-windows
	if ERRORLEVEL == 2 set office=2021& call :defineOffice& goto :office-windows
	REM if ERRORLEVEL == 1 set office=365& goto :defineOffice
	if ERRORLEVEL == 1 call :hold& goto :office-windows
REM ============================================
REM Stat of install office  online

REM REM REF code http://zone94.com/downloads/135-windows-and-office-activation-script
:defineOffice
	@echo off
	cls
	TITLE Microsoft Office ProPlus - Online Installer
	REM Define value default for install
	set "_dp=%~dp0"
	set "sys32=%windir%\system32"
	cd /d "%dp%"
	Set "on=(YES)"
	Set "off=(NO)"
	Set "opt1=%on%" ::Word
	Set "opt2=%on%" ::Excel
	Set "opt3=%on%" ::PowerPoint
	Set "opt4=%on%" ::Outlook
	Set "opt5=%on%" ::OneNote
	Set "opt6=%on%" ::Publisher
	Set "opt7=%on%" ::Access
	Set "opt8=%on%" ::OneDrive
	Set "opt9=%on%" ::VisioPro2021Retail
	Set "optP=%on%" ::ProjectPro2021Retail
	Set "optD=%on%" ::ProofingTools
	REM Dectect version Architecture 
	IF "%Processor_Architecture%"=="AMD64" Set "CPU=64"
	IF "%Processor_Architecture%"=="x86" Set "CPU=32"
	
:selectOfficeApp
	cls
	REM Menu select app to install. Default is yes with Yes colored green.
	echo.
	echo Select options to install Office %office%
	<NUL Set/P=[1] & (if "%opt1%"=="%on%" (Call :setColor "%opt1%" 0a) Else (<NUL Set/P="%opt1%")) & echo  Microsoft Office Word.
	<NUL Set/P=[2] & (if "%opt2%"=="%on%" (Call :setColor "%opt2%" 0a) Else (<NUL Set/P="%opt2%")) & echo  Microsoft Office Excel.
	<NUL Set/P=[3] & (if "%opt3%"=="%on%" (Call :setColor "%opt3%" 0a) Else (<NUL Set/P="%opt3%")) & echo  Microsoft Office PowerPoint.
	<NUL Set/P=[4] & (if "%opt4%"=="%on%" (Call :setColor "%opt4%" 0a) Else (<NUL Set/P="%opt4%")) & echo  Microsoft Office Outlook.
	<NUL Set/P=[5] & (if "%opt5%"=="%on%" (Call :setColor "%opt5%" 0a) Else (<NUL Set/P="%opt5%")) & echo  Microsoft Office OneNote.
	<NUL Set/P=[6] & (if "%opt6%"=="%on%" (Call :setColor "%opt6%" 0a) Else (<NUL Set/P="%opt6%")) & echo  Microsoft Office Publisher.
	<NUL Set/P=[7] & (if "%opt7%"=="%on%" (Call :setColor "%opt7%" 0a) Else (<NUL Set/P="%opt7%")) & echo  Microsoft Office Access.
	<NUL Set/P=[8] & (if "%opt8%"=="%on%" (Call :setColor "%opt8%" 0a) Else (<NUL Set/P="%opt8%")) & echo  Microsoft Office Visio.
	<NUL Set/P=[9] & (if "%opt9%"=="%on%" (Call :setColor "%opt9%" 0a) Else (<NUL Set/P="%opt9%")) & echo  Microsoft Office Project.
	<NUL Set/P=[P] & (if "%optP%"=="%on%" (Call :setColor "%optP%" 0a) Else (<NUL Set/P="%optP%")) & echo  Microsoft Office Proofing Tools.
	<NUL Set/P=[D] & (if "%optD%"=="%on%" (Call :setColor "%optD%" 0a) Else (<NUL Set/P="%optD%")) & echo  Microsoft OneDrive Desktop.
	echo.
	CHOICE /c 123456789PDX /n /m "--> Toggle your option(s) and toggle [X] to Start: "
	if ERRORLEVEL 12 goto :installOffice
	if ERRORLEVEL 11 (if "%optD%"=="%on%" (Set "optD=%off%") Else (Set "optD=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 10 (if "%optP%"=="%on%" (Set "optP=%off%") Else (Set "optP=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 9 (if "%opt9%"=="%on%" (Set "opt9=%off%") Else (Set "opt9=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 8 (if "%opt8%"=="%on%" (Set "opt8=%off%") Else (Set "opt8=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 7 (if "%opt7%"=="%on%" (Set "opt7=%off%") Else (Set "opt7=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 6 (if "%opt6%"=="%on%" (Set "opt6=%off%") Else (Set "opt6=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 5 (if "%opt5%"=="%on%" (Set "opt5=%off%") Else (Set "opt5=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 4 (if "%opt4%"=="%on%" (Set "opt4=%off%") Else (Set "opt4=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 3 (if "%opt3%"=="%on%" (Set "opt3=%off%") Else (Set "opt3=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 2 (if "%opt2%"=="%on%" (Set "opt2=%off%") Else (Set "opt2=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 1 (if "%opt1%"=="%on%" (Set "opt1=%off%") Else (Set "opt1=%on%")) & goto :selectOfficeApp
	:setColor (Text, Color)
	REM Function that will colored text with Green = 0a	
	MkDir "%Temp%\_%1" 1>NUL
	PushD "%Temp%\_%1"
	For /f %%a in ('Echo PROMPT $H ^| "CMD.exe"') do Set "bs=%%a"
	<NUL Set /P="_" >"%1"
	FindStr /s /b /p /a:%2 /C:"_" "%1"
	<NUL Set /P=%bs%%bs%
	PopD
	RmDir /s /q "%Temp%\_%1"
	GoTo :EOF
	
:installOffice
	cls
	echo.
	echo Disabling Microsoft Office %office% Telemetry . . .
	ping -n 2 localhost 1>NUL
	REG ADD "HKLM\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "00000001" /f 1>NUL
	REM start "" explorer %temp%
	if not exist "%ProgramFiles%\7-Zip" call :install7zip
	pushd %temp%
	curl -o "officedeploymenttool.exe" -fsSL https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_15928-20216.exe
	"%ProgramFiles%\7-Zip\7z.exe" e "officedeploymenttool.exe" -y
	SETLOCAL
	REM REM Deploy template via link: https://config.office.com/deploymentsettings
	Set "OCS="%temp%\Office %office% Setup Config.xml""
						  >%OCS% echo ^<Configuration^>
						 REM >>%OCS% echo   ^<Add OfficeClientEdition="%CPU%" Channel="Monthly" SourcePath="%dp%"^>
						 >>%OCS% echo   ^<Add OfficeClientEdition="%CPU%" Channel="Monthly"^>					 
						 >>%OCS% echo     ^<Product ID="ProPlus%office%Retail"^>
						 >>%OCS% echo       ^<Language ID="MatchOS" Fallback="en-US" /^>
	if "%opt1%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="Word" /^>
	if "%opt2%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="Excel" /^>
	if "%opt3%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="PowerPoint" /^>
	if "%opt4%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="Outlook" /^>
	if "%opt5%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="OneNote" /^>
	if "%opt6%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="Publisher" /^>
	if "%opt7%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="Access" /^>
	if "%optD%"=="%off%" >>%OCS% echo       ^<ExcludeApp ID="OneDrive" /^>
						 >>%OCS% echo     ^</Product^>
	if "%opt8%"=="%on%"  >>%OCS% echo     ^<Product ID="VisioPro%office%Retail"^>
	if "%opt8%"=="%on%"  >>%OCS% echo       ^<Language ID="MatchOS" Fallback="en-US" /^>
	if "%opt8%"=="%on%"  >>%OCS% echo     ^</Product^>
	if "%opt9%"=="%on%"  >>%OCS% echo     ^<Product ID="ProjectPro%office%Retail"^>
	if "%opt9%"=="%on%"  >>%OCS% echo       ^<Language ID="MatchOS" Fallback="en-US" /^>
	if "%opt9%"=="%on%"  >>%OCS% echo     ^</Product^>
	if "%optP%"=="%on%"  >>%OCS% echo     ^<Product ID="ProofingTools"^>
	if "%optP%"=="%on%"  >>%OCS% echo       ^<Language ID="MatchOS" Fallback="en-US" /^>
	if "%optP%"=="%on%"  >>%OCS% echo     ^</Product^>
						 >>%OCS% echo   ^</Add^>
						 >>%OCS% echo ^</Configuration^>
	ENDLOCAL
	echo Installing Microsoft Office %office% ProPlus %CPU%-bit . . .
	ping -n 3 localhost 1>NUL
	
	START "" /WAIT /B ".\setup.exe" /configure ".\Office %office% Setup Config.xml"
	popd
	exit /b
REM End of install office online
REM ============================================
:loadSkus
	cls
	call :hold
	goto :office-windows

:fixNonCore
	cls
	call :hold
	goto :office-windows

:convertOfficeEddition
	cls
	call :hold
	goto :office-windows

:removeOfficeKey
	cls
	call :hold
	goto :office-windows

:uninstallOffice
	Title Uninstall office completely
	cls
	@echo off
	pushd %temp%
	if not exist "%ProgramFiles%\7-Zip\7z.exe" call :install7zip
	curl -# -o SaRACmd.zip -fsL https://aka.ms/SaRA_CommandLineVersionFiles
	"c:\Program Files\7-Zip\7z.exe" x -y SaRACmd.zip -o"SaRACmd"
	cls
	echo.
	echo Start to uninstall office via SaRACmd
	echo It could took a while, please wait to end
	ping -n 2 localhost 1>NUL
	cls
	SaRACmd\SaRAcmd.exe -S OfficeScrubScenario -AcceptEula
	call :log "Office uninstalled successfully"
	popd
	cd /d %dp%
	cls
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
	endlocal

REM End of Active Licenses Menu
REM ==============================================================================
REM Start of Active Lienses functions
:MAS
	cls
	call :hold
	goto :activeLicenses

:restoreLicenses
	cls
	call :hold
	goto :activeLicenses

:backupLicenses
    cls
    call :hold
    goto :activeLicenses

:checkLicense
    cls
    call :hold
    goto :activeLicenses

:activeByPhone
    cls
    call :hold
    goto :activeLicenses

:activeOnline
    cls
    call :hold
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
	echo        [4] Add user to Admin group             : Press 4
	echo        [5] Add user to Users group             : Press 5
	echo        [6] Install Support Assistance          : Press 6
	echo        [7] Restart Windows                     : Press 7
	echo        [8] Join domain                         : Press 8
	echo        [9] Back to Main Menu                   : Press 9
	echo        =================================================
	Choice /N /C 123456789 /M " Press your choice : "
	if ERRORLEVEL == 9 goto :main
	if ERRORLEVEL == 8 goto :joinDomain
	if ERRORLEVEL == 7 goto :restartPC
	if ERRORLEVEL == 6 goto :installSupportAssist
	if ERRORLEVEL == 5 goto :addUserToUsers
	if ERRORLEVEL == 4 goto :addUserToAdmins
	if ERRORLEVEL == 3 goto :cleanUpSystem
	if ERRORLEVEL == 2 goto :changeHostName
	if ERRORLEVEL == 1 goto :setHighPerformance
	endlocal
REM End of Utilities Menu
REM ==============================================================================
REM Start of Utilities functions

:GetUserInformation
	Title Get User Information
	REM Prompt user for new username
	echo Enter new username that you'd like to add:
	set /p user=

	REM Prompt user to set password or not
	:input_pass
	echo Do you want to set a password for %user%? [Y/N]
	set /p setpass=

	REM Add user with or without password
	if /i "%setpass%" == "Y" (
	  echo %user%'s password is:
	  set /p _pass=
	  net user %user% %_pass% /add 2>nul
	  call :log "User %user% added with password successfully."
	  ping -n 2 localhost 1>NUL
	  cls
	) else if /i "%setpass%" == "N" (
	  net user %user% "" /add 2>nul
	  call :log "User %user% added without password successfully."
	  cls
	) else (
	  echo Invalid input. Please try again.
	  goto :input_pass
	  cls
	)
	goto :EOF

:addUserToAdmins
	REM This function adds the user to the Administrators group.
	Title Add User to Administrators Group
	call :GetUserInformation
	net localgroup administrators %user% /add
	if %errorlevel% == 0 (
	call :log "User %user% was added to administrators group"
	echo User %user% was added to administrators group.
	ping -n 2 localhost 1>NUL
	cls
	) else (
	call :log "Failed to add user %user% to administrators group"
	echo Failed to add user %user% to administrators group.
	)
	cls
	goto :utilities

:addUserToUsers
	REM This function adds the user to the Users group.
	Title Add User to Users Group
	call :GetUserInformation
	call :log "User %user% was added to Users group"
	echo User %user% was added to users group.
	ping -n 2 localhost 1>NUL
	cls
	goto :utilities
	

REM REM Add local admin user 
REM :addLocalUserAdmin
	REM REM Add local user with administrator privilege
	REM setLocal EnableDelayedExpansion
	REM REM Prompt user for new username
	REM echo Enter new username with administrator privilege to add:
	REM set /p user=

	REM REM Prompt user to set password or not
	REM :input_pass
	REM echo Do you want to set a password for %user%? [Y/N]
	REM set /p setpass=

	REM REM Add user with or without password
	REM if /i "%setpass%" == "Y" (
	  REM echo %user%'s password is:
	  REM set /p _pass=
	  REM net user %user% %_pass% /add 2>nul
	  REM call :log "User %user% added with password successfully."
	  REM ping -n 2 localhost 1>NUL
	  REM cls
	REM ) else if /i "%setpass%" == "N" (
	  REM net user %user% "" /add 2>nul
	  REM call :log "User %user% added without password successfully."
	  REM cls
	REM ) else (
	  REM echo Invalid input. Please try again.
	  REM goto :input_pass
	  REM cls
	REM )
	REM REM Add user to local administrators group
	REM if %errorlevel% equ 0 (
	  REM net localgroup administrators %user% /add
	  REM call :log "User %user% added to local administrators group successfully."
	  REM echo User "%user%" with admin privileges added successfully.
	  REM ping -n 2 localhost 1>NUL
	REM ) else (
	  REM call :log "Failed to add user %user%."
	  REM echo Failed to add user.
	  REM ping -n 2 localhost 1>NUL
	REM )
	REM endlocal
	REM cls
	REM goto :utilities

:restartPC
	cls
	goto :utilities

:installSupportAssistant
	Title install Support Assistant
	setlocal
	cd %temp%
	REM Detect brand name
	for /f %%b in ('wmic computersystem get manufacturer ^| findstr /I "Dell HP Lenovo"') do set "BRAND=%%b"

	REM Download and install the appropriate support assistant
	if /I "%BRAND%" == "Dell Inc." (
	  curl -o SupportAssistx64-3.12.3.5.msi https://downloads.dell.com/serviceability/catalog/SupportAssistx64-3.12.3.5.msi
	  start /wait SupportAssistx64-3.12.3.5.msi /quiet
	  call :log DELL Assistant is installed
	) else if /I "%BRAND%" == "HP" (
	  curl -fSL -o sp114036.exe https://ftp.hp.com/pub/softpaq/sp114001-114500/sp114036.exe
	  "c:\Program Files\7-Zip\7z.exe" x -y sp114036.exe -o"sp114036"
	  start /wait sp114036\InstallHPSA.exe
	  call :log HP Assistant is installed
	) else if /I "%BRAND%" == "Lenovo" (
	  call :checkWinget
	  call :installSoft "Lenovo.SystemUpdate"
	) else (
	  echo Unknown brand: %BRAND%
	)
	endlocal
	cd %dp%
    goto :utilities

:joinDomain
   cls
    call :hold
    goto :utilities

REM This function will use Windows Disk Cleanup to remove unnecessary files
:cleanUpSystem
	Title Clean Up System
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\D3D Shader Cache" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Delivery Optimization Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Diagnostic Data Viewer database files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Feedback Hub Archive log files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Language Pack" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
	cls
	cleanmgr /sagerun:1
    goto :utilities

:changeHostName
	Title Change host name
	setlocal EnableDelayedExpansion
	echo.
	echo Your new computername is:
	set /p _newComputername=
	echo This will change your computername from: %computername% to: %_newComputername%
	ping -n 3 localhost 1>NUL
	WMIC ComputerSystem where Name="%computername%" call Rename Name="%_newComputername%"
	for /f "skip=1 tokens=2 delims==; " %%i in ('WMIC ComputerSystem where Name^="%computername%" call Rename Name^="%_newComputername%" ^| findstr "ReturnValue ="') do set _statusChangeHostName=%%i
	cls
	if %_statusChangeHostName% == 0 (
						echo Your computername will change to %_newComputername%
						echo Restart computer to apply the change
						cls
					)
	if %_statusChangeHostName% NEQ 0 (
						echo Your computer name will not change 
						echo Try a name containing special characters like ^~, ^!, ^@.....
						echo Do you want to change your computer hostname again^?
						Choice /N /C YN /M "[Y], [N]:     Default [N]"
						If ERRORLEVEL ==Y goto :changeHostName
						)
	endlocal
	PAUSE
	exit /b
    goto :utilities

:setHighPerformance
	Title "Set Windows Powerplan - High performance"
	cls
	REM Turn off hibernation feature
	REM Powerplan ref can be found at https://www.windowsafg.com/power10.html
	powercfg -h off
	powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 2
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 2
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 100
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 75
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 75
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 50
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 2
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 2
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 3
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 3
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 7
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 7
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 10
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 10
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 1
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 1
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 3
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 3
	powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 3
	powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 3
    call :log High performance has been set
	goto :utilities

REM End of Utilities functions
REM ========================================================================================================================================
:winget
	setlocal
	REM Start of Winget Menu
	cd /d %dp%
	cls
	title Winget Main Menu
	echo.
	echo        =================================================
	echo        [1] Install Winget                      : Press 1
	echo        [2] Install Utilities online            : Press 2
	echo        [3] Install Remote Support              : Press 3
	echo        [4] Upgrade online all                  : Press 4
	echo        [5] Main Menu                           : Press 5
	echo        =================================================

	Choice /N /C 12345 /M " Press your choice : "
	if ERRORLEVEL == 5 goto :main
	if ERRORLEVEL == 4 goto :updateWinget-All
	if ERRORLEVEL == 3 goto :installWinget-RemoteSupport
	if ERRORLEVEL == 2 goto :installWinget-Utilities
	if ERRORLEVEL == 1 goto :installWingetMenu
	endlocal
REM End of Winget Menu
REM ==============================================================================
REM Start of Winget functions
:updateWinget-All
	call :checkWinget
	cls
	echo y | winget upgrade -h --all
	call :log "Winget finished upgrading all packages successfully"
    goto :winget
	
:installWinget-RemoteSupport
    call :checkWinget
	call :installsoft TeamViewer.TeamViewer
	call :installsoft DucFabulous.UltraViewer
    goto :winget

:installWinget-Utilities
	Title Install Utilities by Winget
	call :checkWinget
	setlocal
	call :log "Starting software utilities installation"
    cls
    echo.
    echo **********************************************************************
    echo 		List Software to Install
    echo 		7zip, Notepad++, Foxit Reader
    echo 		Zalo, Slack, Skype, Unikey
    echo 		Google Chrome, Firefox
    echo 		BulkCrapUninstaller, Microsoft PowerToys
    echo 		Google Drive
    echo **********************************************************************
	ping -n 3 localhost 1>NUL
	REM Without Scope Machine, the software will be installed with the current user profile instead of the system profile
	set packageListWithScope=SlackTechnologies.Slack ^
								Google.Chrome ^
								Mozilla.Firefox ^
								google.drive ^
								Google.Chrome ^
								Microsoft.PowerToys ^
								Mozilla.Firefox
	set packageListWithoutScope=7zip.7zip ^
									VideoLAN.VLC ^
									Foxit.FoxitReader ^
									Notepad++.Notepad ^
									Klocman.BulkCrapUninstaller ^
									VNGCorp.Zalo
	REM first loop to install software without scope machine
	for %%p in (%packageListWithoutScope%) do (
		call :installSoft %%p ""
	)
	
	REM second loop to install software with scope machine
	for %%p in (%packageListWithScope%) do (
		call :installSoft %%p "--scope machine"
	)
	endlocal
	call :installNotepadplusplusThemes
	exit /b


:installWingetMenu
    call :checkWinget
    goto :winget

REM End of Winget functions
REM ========================================================================================================================================
REM function update CMD via github
:updateCMD
	cls
	cd %dp%
	curl -sO https://raw.githubusercontent.com/tamld/cmdToolForHelpdesk/main/installAPP.cmd
	call :log installAPP file has been updated
	echo installAPP file has been updated
	ping -n 2 localhost 1>NUL
	exit /b

REM ========================================================================================================================================
REM Start of child process that can be reused functions
REM function checkWinget will check if winget is installed or neither. If not, go to installWinget function
:checkWinget
	Title Check Winget 
	echo off
    rem Get the Windows version number
    for /f "tokens=4 delims=[] " %%i in ('ver') do set VERSION=%%i

    rem Check if the version number is 10.0.19041 or later
    if "%VERSION%" GEQ "10.0.19041" (
        cls
		echo "Current Windows version: %VERSION% is suitable for installing winget"
		call :log "Windows version check: Version %VERSION% is suitable for installing winget"
		ping -n 2 localhost 1>NUL
		cls
        winget -v
        if ERRORLEVEL 1 (
            echo Start to install winget
            call :installWinget
			cls
        ) else (
            echo Winget already installed
            call :log "Winget already installed"
			cls
        )
    ) else (
        call :log "Windows version check: Version %VERSION% is not suitable for installing winget"
        echo Your Windows version is not suitable for installing winget
		ping -n 2 localhost 1>NUL
    )
    cls
    goto :EOF

:installWinget
	Title Install Winget
    cd /d %temp%
    cls
	REM Install require packages VCLibs x64 14 and UI.Xaml 2.7
	echo. 
	echo Install require packages VCLibs x64 14 and UI.Xaml 2.7
	ping -n 2 localhost 1>NUL
    call :log "Starting Winget installation from GitHub"
    curl -O -fSL https://github.com/tamld/cmdToolForHelpdesk/raw/main/Microsoft.UI.Xaml.2.7.appx
	curl -O -#fsSL https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
	curl -o Microsoft.DesktopAppInstaller.msixbundle -#fsSL https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
	start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.VCLibs.x64.14.00.Desktop.appx
	start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.UI.Xaml.2.7.appx
	call :log "Finished Winget installation requesting packages"
	cls
	echo.
	echo Install winget application
	ping -n 1 localhost 1>NUL
	start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.DesktopAppInstaller.msixbundle
	call :log "Finished Winget installation msixbundle"
	call :log "Finished Winget installation from GitHub"
	cls
    cd /d "%_dp%"
    exit /b

REM function log will append log to %temp%\installAPP.log with time, date, and the other function task
REM %1 will inherit parameters from the outside input function
REM exit /b will exit function instead of remaining running scripts codes
:log
    set logfile=%temp%\installAPP.log
    set timestamp=%date% %time%
    echo %timestamp% %1 >> %logfile%
    goto :EOF

REM function to install soft using Winget utilities
REM to install winget, call function by using call :installsoft "software id"
:installSoft
	Title Install Software
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
			call :log "%software% installed with scope %scope%"
			cls
		)
	) else (
		echo %software% already installed
		timeout 1
		call :log "%software% already installed"
		cls
	)
    goto :EOF

:addScheduleUpgrade
	Title Add Winget Shedule Upgrade
	REM Create schedule task auto upgrade all software with hidden option
	REM Schedule task run onlogon with current user running
	REM schtasks /create /tn "Winget Upgrade" /tr "winget.exe upgrade -h --all" /sc onlogon
	schtasks /create /tn "Winget Upgrade" /tr "winget upgrade -h --all" /sc onlogon /ru %username% /f
	goto :eof	

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
    mklink "c:\Program Files\Unikey\UniKeyNT.exe" "%programDATA%\StartUp" /y
    call :log "Creating Unikey shortcut on desktop"
    mklink "%public%\Desktop\UnikeyNT.exe" "C:\Program Files\Unikey\UniKeyNT.exe"
    cd /d %dp%
    call :log "Finishing Unikey installation"
    exit /b

REM function install 7zip by using winget
:install7zip
    cls
	call :checkWinget
	call :installsoft 7zip.7zip
    REM associate regular files extension with 7zip
	echo. associate regular files extension with 7zip
	ping -n 2 localhost 1>NUL
    assoc .7z=7-Zip
    assoc .zip=7-Zip
    assoc .rar=7-Zip
    assoc .tar=7-Zip
    assoc .gz=7-Zip
    assoc .bzip2=7-Zip
    assoc .xz=7-Zip
    exit /b
	REM goto :EOF
	
:installNotepadplusplusThemes
	Title Install Notepad++ Themes
	if not exist "%ProgramFiles(x86)%\Notepad++" (
    call :log "Notepad++ not found, go for it"
	call :installSoft notepad++.notepad++
	cd /d %temp%
	echo Notepad++ theme installation started > themes_installation.log
	REM Dracula theme
	call :log "Installing Dracula theme"
	curl https://raw.githubusercontent.com/dracula/notepad-plus-plus/master/Dracula.xml -o Dracula.xml
	xcopy Dracula.xml %AppData%\Notepad++\themes\ /E /C /I /Q
	REM Material Theme
	call :log "Installing Material Theme"
	curl https://raw.githubusercontent.com/HiSandy/npp-material-theme/master/Material%20Theme.xml -o "Material Theme.xml"
	xcopy "Material Theme.xml" %AppData%\Notepad++\themes\ /E /C /I /Q
	REM Nord theme
	call :log "Installing Nord theme"
	curl https://raw.githubusercontent.com/arcticicestudio/nord-notepadplusplus/develop/src/xml/nord.xml -LJ -o Nord.xml
	xcopy Nord.xml %AppData%\Notepad++\themes\ /E /C /I /Q
	REM Mariana theme
	call :log "Installing Mariana theme"
	curl https://raw.githubusercontent.com/Codextor/npp-mariana-theme/master/Mariana.xml -o Mariana.xml
	xcopy Mariana.xml %AppData%\Notepad++\themes\ /E /C /I /Q
	call :log "Notepad++ themes installation finished"
	cd %dp%
	goto :EOF

REM function force delete all file created in %temp% folder
:clean
    del /q /f /s %temp%\*.*
    REM forfiles search files with criteria > 7 days and delete
    REM forfiles /p %temp% /s /m *.* /d -7 /c "cmd /c del /f /q @path"
    exit /b

REM End of child process functions
REM ========================================================================================================================================
:hold
	@echo off
	cls
	echo.
	echo Function in developing
	echo Please be patient
	ping -n 3 localhost 1>NUL
	exit /b
:end
call :clean
exit