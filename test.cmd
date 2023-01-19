:checkWinget
    cls
    if not exist "%localappdata%\Microsoft\WindowsApps\winget.exe" (
       echo Start to install winget
    	 call :log "Winget Installation started"
       call :installWinget
       call :log "Winget Installation finished"
    	 PAUSE
    ) else (
        echo Winget already installed
		  call :log "Winget already installed"
        PAUSE
    )
    exit /b

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
	
:installSoftByWinget
	set "soft=%~1"
	winget install %soft% -h --accept-package-agreements --accept-source-agreements
	PAUSE
	if %errorlevel% == 0 (
		call :log "Software %soft% already installed"
		PAUSE
	) else (
		call :log "Installed software %soft%"
		PAUSE
	)
	PAUSE
	goto :eof

:install
	PAUSE
	call :installSoftByWinget 7zip.7zip
	call :installSoftByWinget Notepad++.Notepad++
	call :installSoftByWinget Microsoft.Skype
	exit /b
	
:main
echo off
call :checkWinget
PAUSE
REM call :install
goto :EOF