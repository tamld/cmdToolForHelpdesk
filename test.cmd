echo off
set "_dp=%~dp0"
set "_sys32=%windir%\system32"
cd /d "%_dp%"
call :checkWinget
call :installWinget-Utilities
goto :end

:checkWinget
    cls
    if not exist "%localappdata%\Microsoft\WindowsApps\winget.exe" (
		echo Start to install winget
		call :log "Winget Installation started"
		call :installWinget
		call :log "Winget Installation finished"
    ) else (
		echo Winget already installed
		call :log "Winget already installed"
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

REM REM function to install software using winget
:installSoft
    set "software=%~1"
    set "scope=%~2"

    if "%scope%"=="" (
        echo y | winget install %software%
        call :log "%software% installed without scope"
		cls
    ) else (
        echo y | winget install %software% %scope%
        call :log "%software% installed with %scope%"
		cls
    )
    goto :EOF


:installWinget-Utilities
    call :installSoft 7zip.7zip
    call :installSoft VNGCorp.Zalo
    call :installSoft "SlackTechnologies.Slack" "--scope machine"
    call :installSoft Foxit.FoxitReader
    call :installSoft Notepad++.Notepad++
    call :installSoft Google.Chrome "--scope machine"
    call :installSoft Mozilla.Firefox
    call :installSoft Klocman.BulkCrapUninstaller
    call :installSoft google.drive "--scope machine"
	REM set "packageList=7zip.7zip ^
					REM VNGCorp.Zalo ^
					REM SlackTechnologies.Slack ^
					REM Foxit.FoxitReader ^
					REM Notepad++.Notepad++ ^
					REM Google.Chrome ^
					REM Mozilla.Firefox ^
					REM Klocman.BulkCrapUninstaller ^
					REM google.drive ^
					REM VideoLAN.VLC"
	REM for %%p in (%packageList%) do (
		REM call :installSoft %%p
	REM )
	exit /b
:end



