echo off
set "_dp=%~dp0"
set "_sys32=%windir%\system32"
cd /d "%_dp%"
call :checkWinget
call :installWinget-Utilities
goto :end

:checkWinget
    rem Get the Windows build number
    for /f "tokens=4" %%i in ('systeminfo ^| find "OS Build"') do (
        set BUILD=%%i
    )

    rem Check if the build number is 19041 or later
    if %BUILD% geq 19041 (
        call :log "Windows build check: Build %BUILD% is suitable for installing winget"
        cls
        winget -v
        if "%errorlevel%" NEQ "0" (
            echo Start to install winget
            call :log "Winget Installation started"
            call :installWinget
            call :log "Winget Installation finished"
        ) else (
            echo Winget already installed
            call :log "Winget already installed"
        )
    ) else (
        call :log "Windows build check: Build %BUILD% is not suitable for installing winget"
        echo Your Windows build is not suitable for installing winget.
        goto :EOF
    )
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


:installWinget-Utilities
	setlocal
    REM call :installSoft 7zip.7zip
    REM call :installSoft VNGCorp.Zalo
    REM call :installSoft "SlackTechnologies.Slack" "--scope machine"
    REM call :installSoft Foxit.FoxitReader
    REM call :installSoft Notepad++.Notepad++
    REM call :installSoft Google.Chrome "--scope machine"
    REM call :installSoft Mozilla.Firefox
    REM call :installSoft Klocman.BulkCrapUninstaller
    REM call :installSoft google.drive "--scope machine"
	set packageList=7zip.7zip ^
					Notepad++.Notepad++ ^
					Klocman.BulkCrapUninstaller ^
					google.drive ^
					VideoLAN.VLC
	for %%p in (%packageList%) do (
		call :installSoft %%p
	)
	endlocal
	exit /b
:end



