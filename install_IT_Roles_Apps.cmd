echo off
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
::===================================================================================================================================================================
:main
call :checkOS
call :checkWinget
call :installChoco
call :settingOS
call :installUnikey
call :listInstallSoftware_winget
call :listInstallSoftware_choco
call :activeIDM
call :settingNotepad
call :settingMobaXterm
call :installFastone
call :addStartup
call :restoreBackup
call :addVagrantImage
call :installSupportAssist
call :enableWindowsSandbox
refreshenv
call :installcygwin
refreshenv
call :settingOpenSSH
call :taskkill
call :clean
call :w11Debloat
goto :end
::===================================================================================================================================================================
:checkWinget
echo off
rem Get the Windows version number
for /f "tokens=4 delims=[] " %%i in ('ver') do set VERSION=%%i
rem Check if the version number is 10.0.19041 or later
if "%VERSION%" GEQ "10.0.19041" (
cls
echo "Current Windows version: %VERSION% is suitable for installing winget"
ping -n 2 localhost 1>NUL
cls
winget -v
if ERRORLEVEL 1 (
echo Start to install winget
call :installWinget
cls
) else (
echo Winget already installed
cls
)
) else (
echo Your Windows version is not suitable for installing winget
ping -n 2 localhost 1>NUL
)
cls
goto :EOF
	
:installWinget
pushd %temp%
cls
echo Install require packages VCLibs x64 14 and UI.Xaml 2.7
ping -n 2 localhost 1>NUL 
curl -O -fsSL https://github.com/tamld/cmdToolForHelpdesk/raw/main/Microsoft.UI.Xaml.2.7.appx
curl -O -fsSL https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
curl -o Microsoft.DesktopAppInstaller.msixbundle -fsSL https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.VCLibs.x64.14.00.Desktop.appx
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.UI.Xaml.2.7.appx
cls
echo Install winget application
ping -n 2 localhost 1>NUL
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.DesktopAppInstaller.msixbundle
cls
popd
goto :EOF

:installChoco
cls
echo Install chocolately
powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
set "path=%path%;C:\ProgramData\chocolatey\bin"
rem Check if choco is in the PATH
REM echo Checking choco if exist in the PATH
REM echo %PATH% | findstr "C:\ProgramData\chocolatey" > nul
REM if errorlevel 1 (
REM cls
REM echo The choco path does not exist. Add to the PATH....
REM setx PATH "%PATH%;C:\ProgramData\chocolatey" /M
REM ) else (echo Choco has been set to the PATH already)
REM ping -n 2 localhost 1>NUL
goto :EOF

:installSoft
REM Set the software name to install
set "software=%~1"
REM Set the scope machine if supported
set "scope=%~2"
REM Set status software installed or not
set "installed=0"

REM check if %software has been installed before
echo y | winget list %software% > nul
if "%errorlevel%" == "0" (set "installed=1")
if "%installed%"=="0" (
if "%scope%"=="" (
echo y | winget install %software%
cls
) else (
echo y | winget install %software% %scope%
cls
)
) else (
echo %software% already installed
ping -n 2 localhost 1>NUL
cls
)
goto :EOF

:installUnikey
REM function download Unikey from unikey.org, extract to C:\Program Files\Unikey and add to start up
cls
echo Install Unikey
pushd %temp%
if not exist "%ProgramFiles%\7-Zip" (call :install7zip)
if not exist "C:\Program Files\Unikey" (
curl -sL -o unikey43RC5-200929-win64.zip https://www.unikey.org/assets/release/unikey43RC5-200929-win64.zip
"%ProgramFiles%\7-Zip\7z.exe" x -y unikey43RC5-200929-win64.zip -o"C:\Program Files\Unikey"
REM mklink "%public%\Desktop\UnikeyNT.exe" "C:\Program Files\Unikey\UniKeyNT.exe"
) else (echo Unikey has been installed
mklink "%public%\Desktop\UnikeyNT.exe" "C:\Program Files\Unikey\UniKeyNT.exe")
popd
goto :EOF
	
REM function install 7zip by using winget
:install7zip
cls 
call :checkWinget
echo Install 7zip
call :installsoft 7zip.7zip
REM associate regular files extension with 7zip
echo associate regular files extension with 7zip
ping -n 2 localhost 1>NUL
setlocal
set FILE_EXTS=.7z .zip .rar .tar .gz .bzip2 .xz
for %%f in (%FILE_EXTS%) do (
	assoc %%f=7-Zip
)
endlocal
goto :EOF

::Check if Windows is running Home SL or not. Some apps and settings may not be available.
:checkOS
setlocal
REM Get the OS name and version using the systeminfo command
for /f "tokens=3-5,6* delims=: " %%a in ('systeminfo ^| findstr /i /c:"OS Name"') do set win=%%a %%b %%c&set ver=%%d
REM Check if the OS version contains "Home SL"
echo %ver% | findstr /I /C:"Home SL" > nul
if %errorlevel%==0 (
echo This is a computer running Windows %win% Home Single Language.
echo Some apps and settings may not be available.
) else (
echo The OS version is: %win% %ver%
)
ping -n 3 localhost 1>NUL
endlocal
goto :EOF

:settingOS
cls
echo off
echo Show file extension
powershell Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0
echo Enable Dark mode
powershell Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0
echo Show this PC view
powershell Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
echo Setting OS
echo Revert classic menu Right click W11
reg add HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2} /ve /t REG_SZ /d "" /f
reg add HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /t REG_SZ /d "" /f
echo Check for update
wuauclt /detectnow
echo Enable Photoviewer
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open" /ve /t REG_SZ /d "@photoviewer.dll,-3043" /f
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "\"%SystemRoot%\System32\rundll32.exe\" \"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %1" /f
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\DropTarget" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f 
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print" /ve /t REG_SZ /d "Print with Windows Photo Viewer" /f
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "\"%SystemRoot%\System32\rundll32.exe\" \"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_PrintTo %1" /f
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\DropTarget" /ve /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f
echo Turn off hibernation feature
powercfg -h off
echo Keep US Keyboard and remove others
reg delete "HKCU\Keyboard Layout\Preload" /va /f
reg add "HKCU\Keyboard Layout\Preload" /v 1 /t REG_SZ /d 00000409 /f
REM Powerplan ref can be found at https://www.windowsafg.com/power10.html
echo Set High Perfomance
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 1
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 1
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
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 1
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
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 3600
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 1800
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 900
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 900
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 100
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 75
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 75
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 50
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 2
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 2
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 0
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 0
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
echo Setting Time Zone +7 GMT
tzutil /s "SE Asia Standard Time"
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
w32tm /resync
echo Cleanup System With Sagerun :1
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
echo Allow Remote Desktop
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP" /v UserAuthentication /t REG_DWORD /d "0" /f
echo Allow Remote Desktop from Specified IPs
netsh advfirewall firewall add rule name="Allow from specific IP addresses" dir=in action=allow protocol=TCP localport=3389 remoteip=192.168.100.125,172.16.11.3,10.241.217.1,10.241.217.2,10.241.217.3 
goto :EOF

:installcygwin
cls
echo Install cygwin and packages
REM Check for $HOME folder exist
if not exist (C:\tools\cygwin\home\%username%) mkdir C:\tools\cygwin\home\%username%
REM Install apt-cyg
pushd C:\tools\cygwin\home\%username%
REM Check if required packages are already installed
REM Set package list
setlocal
set packageList=lynx nano zsh curl git wget mosh
REM Check if required packages are already installed
for %%p in (%packageList%) do (
if not exist "C:\tools\cygwin\bin\%%p.exe" (
echo Installing package: %%p
choco install -y %%p --source cygwin
) else (
echo Package %%p is already installed.
)
)
endlocal
::====================================================
REM add git to $PATH to the top
REM set PATH=C:\tools\cygwin\bin;%PATH%
REM export PATH=/cygdrive/c/tools/cygwin/bin:$PATH
::====================================================
rem Check if cygwin is in the top of 
echo %PATH% | findstr /b /c:"C:\tools\cygwin\bin;" > nul
if errorlevel 1 (
echo The Cygwin path is not at the top of the PATH environment variable. Adding it to the top...
REM remove other path "C:\tools\cygwin\bin"
setx PATH "%PATH:;C:\tools\cygwin\bin=%" /M
REM move cygwin in the top menu
setx PATH "C:\tools\cygwin\bin;%PATH%" /M
REM add to the end of the PATH
REM setx PATH "%PATH%;C:\tools\cygwin\bin" /M
) else (
echo The Cygwin path is already at the top of the PATH environment variable.
)
::====================================================
curl -s -o c:\tools\cygwin\home\%username%\apt-cyg https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
install c:\tools\cygwin\home\%username%\apt-cyg /bin
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
pushd c:\tools\cygwin\home\%username%
del apt-cyg
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git .oh-my-zsh\custom\themes\powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh\custom\plugins\zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh\custom\plugins\zsh-syntax-highlighting
if not exist "c:\tools\cygwin\usr\local\share\zsh\site-functions\_tmuxinator" mkdir "c:\tools\cygwin\usr\local\share\zsh\site-functions" /p
curl -s -o c:\tools\cygwin\usr\local\share\zsh\site-functions\_tmuxinator https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh
popd
REM config for ZSH plugin
setlocal
set "ZSHRC_PATH=c:\tools\cygwin\home\%username%\.zshrc"
echo POWERLEVEL9K_DISABLE_GITSTATUS=true > %ZSHRC_PATH%
echo export ZSH_DISABLE_COMPFIX=true >> %ZSHRC_PATH%
echo if [[ -r "%{XDG_CACHE_HOME:-%%HOME%%/.cache}/p10k-instant-prompt-%%(%):-%%n}.zsh" ]]; then >> %ZSHRC_PATH%
echo source "%{XDG_CACHE_HOME:-%%HOME%%/.cache}/p10k-instant-prompt-%%(%):-%%n}.zsh" >> %ZSHRC_PATH%
echo fi >> %ZSHRC_PATH%
echo export ZSH="$HOME/.oh-my-zsh" >> %ZSHRC_PATH%
echo ZSH_THEME="powerlevel10k/powerlevel10k" >> %ZSHRC_PATH%
echo plugins=(git docker docker-compose vagrant ansible mosh zsh-syntax-highlighting zsh-autosuggestions) >> %ZSHRC_PATH%
echo source $ZSH/oh-my-zsh.sh >> %ZSHRC_PATH%
echo #Vagrant shortcut keyset >> %ZSHRC_PATH%
echo alias v="vagrant" >> %ZSHRC_PATH%
echo alias vv="vagrant validate" >> %ZSHRC_PATH%
echo alias vu="vagrant up" >> %ZSHRC_PATH%
echo alias vh="vagrant halt" >> %ZSHRC_PATH%
echo alias vpd="vagrant provision --debug" >> %ZSHRC_PATH%
echo alias vr="vagrant reload" >> %ZSHRC_PATH%
echo alias vrp="vagrant reload --provision" >> %ZSHRC_PATH%
echo alias vg="vagrant global-status" >> %ZSHRC_PATH%
echo alias vgp="vagrant global-status --prune" >> %ZSHRC_PATH%
echo alias vdf="vagrant destroy -f" >> %ZSHRC_PATH%
echo alias vs="vagrant ssh" >> %ZSHRC_PATH%
echo alias vsl="vagrant snapshot list" >> %ZSHRC_PATH%
echo alias vss="vagrant snapshot save" >> %ZSHRC_PATH%
echo alias vsr="vagrant snapshot restore" >> %ZSHRC_PATH%
echo #End of vagrant keysets >> %ZSHRC_PATH%
echo.  >> %ZSHRC_PATH%
echo #docker, docker-compose keysets >> %ZSHRC_PATH%
echo alias dc="docker-compose" >> %ZSHRC_PATH%
echo alias dcu="docker-compose up -d" >> %ZSHRC_PATH%
echo alias dcd="docker-compose down" >> %ZSHRC_PATH%
echo alias dcr="docker-compose restart" >> %ZSHRC_PATH%
echo alias dcp="docker-compose ps -a" >> %ZSHRC_PATH%
echo alias dcps="docker-compose ps -aq" >> %ZSHRC_PATH%
echo alias dci="docker-compose inspect" >> %ZSHRC_PATH%
echo alias dcs="docker-compose stop" >> %ZSHRC_PATH%
echo alias dnp="yes | docker network prune" >> %ZSHRC_PATH%
echo alias dvp="yes | docker volume prune" >> %ZSHRC_PATH%
echo alias dirf='docker image rm -f $(docker image ls -aq)' >> %ZSHRC_PATH%
echo alias dp="docker ps -a" >> %ZSHRC_PATH%
echo alias dpaq="docker ps -aq" >> %ZSHRC_PATH%
echo # End of docker, docker-compose keysets >> %ZSHRC_PATH%
echo.  >> %ZSHRC_PATH%
echo alias udug="sudo apt update && sudo apt -y full-upgrade && sudo apt -y dist-upgrade" >> %ZSHRC_PATH%
echo alias atrm="sudo apt autoremove -y" >> %ZSHRC_PATH%
echo # Advanced Aliases. >> %ZSHRC_PATH%
echo # ls, the common ones I use a lot shortened for rapid fire usage >> %ZSHRC_PATH%
echo alias his="history | tail -n 20 | cut -c 8-" >> %ZSHRC_PATH%
echo alias cl="clear" >> %ZSHRC_PATH%
echo alias l='ls -lah'     #size,show type,human readable >> %ZSHRC_PATH%
echo alias lc="clear; ls" >> %ZSHRC_PATH%
echo alias clls="clear; ls -lah" >> %ZSHRC_PATH%
echo alias ls='ls -lFh'     #size,show type,human readable >> %ZSHRC_PATH%
echo # alias ldot='ls -ld .*' >> %ZSHRC_PATH%
echo alias grep='grep --color' >> %ZSHRC_PATH%
echo alias t='tail -f' >> %ZSHRC_PATH%
echo alias p='ps -f' >> %ZSHRC_PATH%
echo alias d="du -h" >> %ZSHRC_PATH%
echo # alias pip='noglob pip' >> %ZSHRC_PATH%
echo [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh >> %ZSHRC_PATH%
echo cd $HOME >> %ZSHRC_PATH%
endlocal
REM End of ZSH plugin config
popd
goto :EOF

:settingMS-Terminal
pushd %localappdata%\Packages\Microsoft.WindowsTerminal*\LocalState
call :taskkill
choco install -y nerdfont-hack font-nerd-dejavusansmono nerd-fonts-meslo
curl -sL -o "terminal_settings.zip" "https://drive.google.com/uc?export=download&id=1RBI_AliiFsWExSiZLR_HddGy7jhirb_2"
"%ProgramFiles%\7-Zip\7z.exe" e -y terminal_settings.zip
del terminal_settings.zip
popd
goto :EOF

:listInstallSoftware_choco
cls
echo Install List Software by choco
choco install -y vmwareworkstation --version 17.0.1.21139696 --params='"/SERIALNUMBER=MC60H-DWHD5-H80U9-6V85M-8280D"' --force ^
vagrant ^
vagrant-manager ^
python ^
lockhunter ^
ultraviewer --ignore-checksums ^
internet-download-manager --ignore-checksums ^
rclone ^
rdm ^
virtualbox ^
virtualbox-guest-additions-guest.install ^
processhacker ^
vagrant-vmware-utility ^
nerdfont-hack ^
font-nerd-dejavusansmono ^
terminal-icons.powershell ^
jdownloader ^
bulk-crap-uninstaller ^
packer
refreshenv	
goto :EOF

:listInstallSoftware_winget
cls
setlocal
echo Install List Software by winget
pushd %temp%
REM ============================================================================
REM Install VC Redist 2019 x64 for Virtualbox package
REM These packages is not necessary cause choco solves the problem
REM curl -fsSL -o vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe
REM vc_redist.x64.exe /install /quiet /norestart
REM ============================================================================
REM List software to install
set packageList=Notepad++.Notepad++ ^
ZeroTier.ZeroTierOne ^
Microsoft.OpenSSH.Beta ^
git.git ^
lencx.ChatGPT ^
Singlebox ^
WinFsp.WinFsp ^
SSHFS-Win.SSHFS-Win ^
Microsoft.VisualStudioCode ^
Microsoft.WindowsTerminal ^
Mobatek.MobaXterm ^
Google.Drive ^
Famatech.AdvancedIPScanner

for %%p in (%packageList%) do (
call :installSoft %%p
)
popd
endlocal
goto :EOF

:checkEnvironment
cls
REM Set the path has been to check
set "_path=%~1"
REM Set status software found or not
set "found=0"
REM check if path has exist
echo Checking if %_path% is exist in the PATH enviroment
ping -n 3 localhost 1 > NUL
echo %PATH% | findstr "%_path%" > nul
if "%errorlevel%" == "0" (
set "found=1"
echo The "%_path%" is found in the PATH environment variable
)
if "%found%"=="0" (
if exist "%_path%" (
echo Adding directory %_path% into the PATH...
REM set to the top of the PATH
REM set "PATH=C:\tools\cygwin\bin;%PATH%"
REM add to the end of the PATH
REM set "PATH=%PATH%;C:\tools\cygwin\bin"
REM set to current session
REM set "PATH=%PATH%;%_path%"
REM set to system, permanent
setx PATH "%PATH%;%_path%" /M
) else (
echo Can not adding %_path% into the PATH. The directory is not found
)
)
refreshenv
ping -n 3 localhost 1>NUL
goto :EOF

:checkPath
cls
setlocal enabledelayedexpansion
echo.
echo Checking directories...
ping -n 3 localhost 1>NUL
set dirsToCheck="C:\Program Files\OpenSSH\" ^
"C:\WINDOWS\System32\OpenSSH\" ^
"C:\Program Files (x86)\ZeroTier\One\" ^
"C:\HashiCorp\Vagrant\bin\" ^
"C:\Program Files\Git\cmd\" ^
"%localappdata%\Microsoft VS Code\bin\"
for %%d in (%dirsToCheck%) do (
cls
echo.
set "dirToAdd=%%~d"
echo Checking if "!dirToAdd!" is in the PATH...
echo .....
echo ;!PATH!; | find /C /I ";!dirToAdd!;" >nul
if errorlevel 1 (
echo The directory "!dirToAdd!" is not in the PATH. Adding directory to PATH...
ping -n 3 localhost 1>NUL
SET "PATH=!dirToAdd!;%PATH%" >nul
echo Directory !dirToAdd! added to PATH.
ping -n 2 localhost 1>NUL
) else (
echo The directory "!dirToAdd!" is already in the PATH.
ping -n 3 localhost 1>NUL
)
)
cls
echo.
echo Finished checking directories.
goto :EOF

:settingNotepad
cls
pushd %temp%
echo Start install Notepad++ style configurator
ping -n 3 localhost 1>NUL
REM Dracula theme
curl -s https://raw.githubusercontent.com/dracula/notepad-plus-plus/master/Dracula.xml -o Dracula.xml
xcopy Dracula.xml %AppData%\Notepad++\themes\ /E /C /I /Q /Y
REM Material Theme
curl -s  https://raw.githubusercontent.com/HiSandy/npp-material-theme/master/Material%20Theme.xml -o "Material Theme.xml"
xcopy "Material Theme.xml" %AppData%\Notepad++\themes\ /E /C /I /Q /Y
REM Nord theme
curl -s https://raw.githubusercontent.com/arcticicestudio/nord-notepadplusplus/develop/src/xml/nord.xml -LJ -o Nord.xml
xcopy Nord.xml %AppData%\Notepad++\themes\ /E /C /I /Q /Y
REM Mariana theme
curl -s https://raw.githubusercontent.com/Codextor/npp-mariana-theme/master/Mariana.xml -o Mariana.xml
xcopy Mariana.xml %AppData%\Notepad++\themes\ /E /C /I /Q /Y
popd
goto :EOF

:settingOpenSSH
cls
echo Setting OpenSSH
::=======================================================================================================================================
REM Fix issue that openssh can not read config from %userprofile%\.ssh\ folder
echo %PATH% | findstr /b /c:"C:\Program Files\OpenSSH;" > nul
if errorlevel 1 (
echo The SSH path is not at the top of the PATH environment variable. Adding it to the top...
REM remove the OpenSSH directory from the PATH environment variable:
setx PATH "%PATH:;C:\Program Files\OpenSSH=%" /M
REM add openSSH to the Top
setx PATH "C:\Program Files\OpenSSH;%PATH%" /M
) else (
echo  The SSH path is already at the top of the PATH environment variable.
)
ping -n 3 localhost 1>NUL
::=======================================================================================================================================
if not exist %userprofile%\.ssh\*.pub (
mkdir %userprofile%\.ssh
ssh-keygen -t rsa -f %userprofile%\.ssh\id_rsa -q -N ""
)
cls
echo Your ssh-keygen profile has been placed at %USERPROFILE%\.ssh\
echo Your public keygen is:
type %USERPROFILE%\.ssh\id_rsa.pub
ping -n 3 localhost 1>NUL
goto :EOF
	
:installFastone
cls
setlocal
ping -n 2 localhost 1 > NUL
pushd %userprofile%\Desktop
set "file_url=https://www.faststonesoft.net/DN/FSCaptureSetup99.exe"
set "file_name=Fastone Capture 99.exe"
echo Downloading %file_name%... to %userprofile%\Desktop
curl -fsSL -o "%file_name%" "%file_url%" > nul
icacls "Fastone Capture 99.exe" /grant:r "Administrators":(F) /grant:r "SYSTEM":(F) /grant:r "%USERNAME%":(F) /grant:r "Everyone":(R) /remove:g "Authenticated Users" /remove:g "Users" /inheritance:r > nul
echo Free Software > fastone_key.txt
echo BXRQE-RMMXB-QRFSZ-CVVOX >> fastone_key.txt
popd
endlocal
goto :EOF	

:activeIDM
cls
pushd %temp%
curl -sL -o "IAS.rar" "https://drive.google.com/uc?export=download&id=1PH4mhy3ODBF9X9boZNyHLoUG1y9GSp1G"
if not exist "c:\Program Files\7-Zip\7z.exe" call :installSoft 7zip.7zip
"%ProgramFiles%\7-Zip\7z.exe" e -y -p1234 "IAS.rar"
xcopy /y IAS_0.7_CRC32_58F0EACC.cmd %userprofile%\Desktop\
setlocal
set file=%userprofile%\Desktop\IAS_0.7_CRC32_58F0EACC.cmd
PowerShell -Command "(Get-Content '%file%') -replace 'set name=', 'set name=IDM' | Set-Content '%file%'"
REM (echo 1 & echo 6) | IAS_0.7_CRC32_58F0EACC.cmd
endlocal
popd
goto :EOF

REM Kill the process by name
:taskkill
setlocal
echo list of process to be killed when install 
set task_to_kill= msteams.exe advanced_ip_scanner.exe GoogleDriveFS.exe msedge.exe WindowsTerminal.exe
for %%p in (%task_to_kill%) do (taskkill /IM %%p /F)
endlocal
goto :EOF

:restoreBackup
cls
echo Restore from backup located in D:\Backup
if exist d:\Backup\%username% (
call :taskkill
robocopy d:\Backup\%username%\ %userprofile%\ /zb /e /copyall /W:10
) else (
echo No backup found
ping -n 2 localhost 1>NUL)
goto :EOF

:settingMobaXterm
cls
echo Setting MobaXterm
ping -n 3 localhost 1>NUL
if not exist "C:\Program Files (x86)\Mobatek\MobaXterm\Custom.mxtpro" (curl -sL -o "C:\Program Files (x86)\Mobatek\MobaXterm\Custom.mxtpro" "https://drive.google.com/uc?export=download&id=1La_J5_5Ntng35S-mL_h_zuYa2iSceXUC")
if exist "C:\Program Files (x86)\Mobatek\MobaXterm\Custom.mxtpro" (
echo Copy complete
ping -n 2 localhost 1>NUL )
goto :EOF

:installSupportAssist
cls
echo Installing Support Assistant
ping -n 3 localhost 1>NUL
setlocal
echo off
REM Detect brand name
for /f %%b in ('wmic computersystem get manufacturer ^| findstr /I "Dell HP Lenovo"') do set "BRAND=%%b"
REM Download and install the appropriate support assistant
if /I "%BRAND%" == "Dell" (
choco install -y supportassist --ignore-checksums --no-exec
) else if /I "%BRAND%" == "HP" (
choco install -y hpsupportassistant --ignore-checksums --no-exec
) else if /I "%BRAND%" == "Lenovo" (
choco install -y lenovo-thinkvantage-system-update --ignore-checksums --no-exec
) else (
echo Unknown brand: %BRAND%
)
endlocal
goto :EOF	

:addVagrantImage
cls
call :checkEnvironment "C:\HashiCorp\Vagrant\bin"
echo Add vagrant image
echo Please wait. This could take a while, depending on your network speed
ping -n 3 localhost 1>NUL
setlocal
REM bento/ubuntu-20.04 ^
REM generic/ubuntu2010 ^
REM gusztavvargadr/windows-10 ^
REM gusztavvargadr/windows-11 ^
REM gusztavvargadr/windows-server
REM set boxes=bento/ubuntu-20.04 gusztavvargadr/windows-11 gusztavvargadr/windows-server
set boxes=bento/ubuntu-20.04
set providers=virtualbox vmware_workstation
REM Download a list of boxes for the specified providers
for %%b in (%boxes%) do (
for %%p in (%providers%) do (
cls
echo Adding box %%b to provider %%p
vagrant box add %%b --provider %%p	
)
)
endlocal
goto :EOF

:addStartup
cls
echo Add program start with Windows
ping -n 2 localhost 1 > NUL
mklink "%programDATA%\Microsoft\Windows\Start Menu\Programs\Startup\UniKeyNT.lnk" "c:\Program Files\Unikey\UniKeyNT.exe"
mklink "%programDATA%\Microsoft\Windows\Start Menu\Programs\Startup\zerotier_desktop_ui.lnk" "C:\Program Files (x86)\ZeroTier\One\zerotier_desktop_ui.exe"
goto :EOF

:w11Debloat
pushd %temp%
curl -O -fsSL https://github.com/LeDragoX/Win-Debloat-Tools/archive/main.zip
"%ProgramFiles%\7-Zip\7z.exe" x -y main.zip
start /wait powershell.exe -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force; ls -Recurse *.ps*1 | Unblock-File; .\Win-Debloat-Tools-main\WinDebloatTools.ps1"
popd
goto :EOF
	
:enableWindowsSandbox
cls
echo Enable Windows Sandbox
start powershell dism.exe /online /enable-feature /featurename:Containers-DisposableClientVM
cls
echo.
echo Windows need restart to update the setting
ping -n 3 localhost 1>NUL
goto :EOF

:clean
cls
echo Cleanup temporary data for installation steps
ping -n 2 localhost 1>NUL
del /q /f /s %temp%\*.*
exit /b
	
:end