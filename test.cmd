echo off
set "_dp=%~dp0"
set "_sys32=%windir%\system32"
cd /d "%_dp%"
call :checkWinget
call :installWinget-Utilities
call :addScheduleUpgrade
goto :end

:checkWinget
	echo off
    rem Get the Windows version number
    for /f "tokens=4 delims=[] " %%i in ('ver') do set VERSION=%%i

    rem Check if the version number is 10.0.19041 or later
    if "%VERSION%" GEQ "10.0.19041" (
        echo.
		echo "Current Windows version: %VERSION% is suitable for installing winget"
		call :log "Windows version check: Version %VERSION% is suitable for installing winget"
		timeout 2
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
		timeout 2
    )
    cls
    goto :EOF
	

:installWinget
    cd /d %temp%
    cls
    call :log "Starting Winget installation from GitHub"
    rem Download the latest version of Winget from GitHub
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

:log
    set logfile=%temp%\installAPP.log
    set timestamp=%date% %time%
    echo %timestamp% %1 >> %logfile%
    goto :EOF

REM function to install software using winget
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
			call :log "%software% installed with scope %scope%"
			cls
		)
	) else (
		echo %software% already installed
		timeout 3
		call :log "%software% already installed"
		cls
	)
    goto :EOF

:addScheduleUpgrade
REM Create schedule task auto upgrade all software with hidden option
REM Schedule task run onlogon with current user running
schtasks /create /tn "Winget Upgrade" /tr "winget.exe upgrade -h --all" /sc onlogon
goto :eof

:installWinget-Utilities
	setlocal
	set packageListWithScope=SlackTechnologies.Slack ^
								Notepad++.Notepad								
	set packageListWithoutScope=VNGCorp.Zalo
	REM first loop to install software without scope machine
	for %%p in (%packageListWithoutScope%) do (
		call :installSoft %%p ""
	)
	
	REM second loop to install software with scope machine
	for %%p in (%packageListWithScope%) do (
		call :installSoft %%p "--scope machine"
	)
	endlocal
	exit /b

:end



