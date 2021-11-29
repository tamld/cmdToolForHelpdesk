echo off
Title Script Auto install Software v0.1
cd /d %~dp0
CHCP 65001 >nul 2>&1
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' ( echo Chạy CMD với quyền quản trị Administrator - Run as Administrator...
							PAUSE 
							goto exit
							) else ( goto main )
:main
cls
title Main menu
@echo Bạn muốn làm gì
@echo                    ===========================================================================
@echo                    [  1. Cài Minisoft                             : Nhấn phím số 1  ]
@echo                    [  2. Cài Office 2016                          : Nhấn phím số 2  ]
@echo                    [  3. Active Windows+Office     		  : Nhấn phím số 3  ]
@echo                    [  4. Đổi tên hostname       		  : Nhấn phím số 4  ]
REM @echo                    [  5. Lấy thông tin máy tính       		  : Nhấn phím số 5  ]
@echo                    [  5. Cài đặt Support Assistant                : Nhấn phím số 5  ]
@echo                    [  6. Update bộ ứng dụng                	  : Nhấn phím số 6  ]
@echo                    [  7. Winget                	  		  : Nhấn phím số 7  ]
@echo                    [  8. Thoát                               	  : Nhấn phím số 8  ]
@echo                    ===========================================================================
Choice /N /C 123456789 /M "* Nhập lựa chọn của bạn :
if ERRORLEVEL == 8 goto :end
if ERRORLEVEL == 7 goto :winget
if ERRORLEVEL == 6 goto :updateSoftware
if ERRORLEVEL == 5 goto :supportAssistant
REM if ERRORLEVEL == 5 goto :getPCInfor
if ERRORLEVEL == 4 goto :changeComputerName
if ERRORLEVEL == 3 goto :activeLicenses
if ERRORLEVEL == 2 goto :installOffice
if ERRORLEVEL == 1 goto :installMiniSofts
PAUSE
goto end

:winFreshConfigure
cls
echo 					Change timezone to +7 Asia
tzutil /s "SE Asia Standard Time"
echo 					Enable powercfg Hight performance
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
REM set High performance Power Option
echo 					Set powercfg High Performance
for /f "tokens=4 delims= " %%b in ('powercfg /l ^| find "High performance"') do powercfg /s %%b
echo 					Disable sleep mode
powercfg.exe /h off
timeout 2
cls
@echo off
REM echo ==================================================
echo 				Allow Remote Desktop
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
echo 					Turn of NLA Remote Setting
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP" /v UserAuthentication /t REG_DWORD /d "0" /f
REM echo 				Add firewall rule RDP
REM netsh advfirewall firewall add rule name="Open Remote Desktop" protocol=TCP dir=in localport=3389 action=allow
REM echo ==================================================
REM echo				Don't Allow Remote Desktop
REM reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
REM echo 				Turn on NLA Remote Setting
REM reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP" /v UserAuthentication /t REG_DWORD /d "1" /f
REM echo ==================================================
echo 					Restart máy tính để apply các thiết đặt
timeout 2
cls
goto main

:installMiniSofts
cls
echo ==================================================
echo 					Script auto install some software
echo 	7zip, Unikey, Chrome, Firefox, Notepad++, PDF Reader (Adobe)
echo 	offline files must place within batch file
echo ==================================================
timeout 2
cls
@echo off
7zx64.exe /S
if not exist "C:\Program Files\Unikey" ("c:\Program Files\7-Zip\7z.exe" x -y unikey43RC5-200929-win64.zip -o"C:\Program Files\Unikey")
ChromeStandaloneSetup64.exe /silent /install
FirefoxSetup.exe /silent /install
npp.Installer.x64.exe /S
AcroRdrDC.exe /sAll /rs /msi EULA_ACCEPT=YES
BCUninstaller.exe /VERYSILENT 
MsiExec.exe /i SlackSetup.msi /qn /norestart
xcopy "c:\Program Files\Unikey\UniKeyNT.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" /y
echo Softwares have been installed successfully
goto winFreshConfigure

:changeComputerName
cls
echo ==================================================
echo 			Change Computer Name
echo ==================================================
echo Nhập hostname mới
echo Hostname cần viết liền, gồm chữ và số và dấu - hoặc _
echo Không có kí tự đặc biệt (!@#$~./...)
echo Restart để apply 
set /p newcomputername=
REM WMIC computersystem where caption=%computername% rename %newcomputername%
WMIC ComputerSystem where Name="%computername%" call Rename Name="%newcomputername%"
PAUSE
goto main
timeout 5

:getPCInfor
REM Get "Model","Manufacturer","Username","Name","Domain","Workgroup"
REM wmic computersystem get "Model","Manufacturer","Username","Name","Domain","Workgroup" >%computername%-Infor.txt
wmic computersystem get "Model","Manufacturer","Username","Name","Domain","Workgroup" /value >%computername%-Infor.txt
REM Get serial number pc
wmic bios get serialnumber>>%computername%-Infor.txt
echo Thông tin đã xuất vào file %computername%-Infor.txt
timeout 2
goto main

:installOffice
cls
REM call SW_DVD5_Office_2016_64Bit_English_MLF_X20-42479\setup.exe
call ProPlus2019Retail\Office\Setup64.exe
timeout 2
goto main

:activeLicenses
cls
start AcitveWindows_Office_CMD.cmd
start key.txt
goto main

:supportAssistant
cls
for /f "tokens=2 delims==" %%b in ('wmic csproduct get vendor /value') do set branch=%%b
for /f "tokens=2 delims==" %%c in ('wmic computersystem get model /value') do set model=%%c
echo ========================================================================
echo 			Máy bạn là hãng: "%branch%"
echo 			Model: "%model%"
echo ========================================================================
timeout 3
if "%branch%"=="HP" (goto installSupportAssistant) else if "%branch%"=="DELL" (goto installSupportAssistant) else (cls && echo 			Máy không hỗ trợ ứng dụng này)
timeout 1
goto main

:installSupportAssistant
cls 
echo Tiến hành cài đặt ứng dụng
timeout 2
if "%branch%"=="HP" (
				if not exist HPSupportTools.exe (curl -# -o HPSupportTools.exe -fSL https://ftp.ext.hp.com/pub/softpaq/sp136001-136500/sp136195.exe)
				call HPSupportTools.exe /s /f %temp%\HP)
if "%branch%"=="DELL" (
					if not exist DellSupportAssistant.exe (curl -# -o DellSupportAssistant.exe -L https://downloads.dell.com/serviceability/catalog/SupportAssistInstaller.exe)
					call DellSupportAssistant.exe /s)
echo Đã cài đặt xong và tiến hành dọn file rác
if exist "%temp%\HP" (rd "%temp%\HP" /q /s) else (echo Không tìm thấy file rác)
if exist c:\system.sav (rd c:\system.sav /q /s)
timeout 2
goto main

:updateSoftware
cls
echo Update Unikey 4.3 RC5 200929
curl -# -o unikey43RC5-200929-win64.zip -L https://www.unikey.org/assets/release/unikey43RC5-200929-win64.zip
timeout 1
cls
echo Update Dell Support Assistant
curl -# -o DellSupportAssistant.exe -L https://downloads.dell.com/serviceability/catalog/SupportAssistInstaller.exe
timeout 1
cls
echo Update HP Support Assistant
curl -# -o HPSupportTools.exe -fSL https://ftp.ext.hp.com/pub/softpaq/sp136001-136500/sp136195.exe
timeout 1
cls
echo Update Firefox x64
curl -# -o FirefoxSetup.exe -L https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US
timeout 1
cls
echo Update Google Chrome x64
curl -# -o "ChromeStandaloneSetup64.exe" https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B41299C1F-E927-9C06-11D6-167C8029D58B%7D%26lang%3Dvi%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe
timeout 1
cls
echo Update 7zip Offline Installer
curl -# -o "7zx64.exe" -L "https://sourceforge.net/projects/sevenzip/files/latest/download"
timeout 1
cls
echo Update Notepad++
curl -o npp.Installer.x64.exe -#fSL https://sourceforge.net/projects/notepadplusplus.mirror/files/latest/download
timeout 1
cls
echo Update Slack Setup Offline Installer
curl -# -o SlackSetup.msi -L https://slack.com/ssb/download-win64-msi-legacy
timeout 1
cls
echo Update BCUninstaller
curl -o BCUninstaller.exe -#fSL https://sourceforge.net/projects/bulk-crap-uninstaller/files/latest/download
timeout 1
cls
echo Update Adobe Reader DC
curl -o AcroRdrDC.exe -#fSL https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2100720099/AcroRdrDC2100720099_en_US.exe
timeout 1
cls
echo Update VCLibs.x64.14
curl -o Microsoft.VCLibs.x64.14.00.Desktop.appx -fsSL https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
echo Update Winget
curl -o Microsoft.DesktopAppInstaller.msixbundle -fsSL https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
cls
echo update date (MM/DD/YY): %time%-%date% >>update.log
echo Update các gói ứng dụng hoàn tất
timeout 3
goto main

:winget
cls
title Winget Main Menu
@echo Bạn muốn làm gì
@echo                    ===========================================================================
@echo                    [  1. Cài đặt Winget         			: Nhấn phím số 1  ]
@echo                    [  2. Cài các ứng dụng cơ bản online         	: Nhấn phím số 1  ]
@echo                    [  3. Cài các ứng dụng hỗ trợ từ xa          	: Nhấn phím số 2  ]
@echo                    [  4. Uprade tất cả ứng dụng online          	: Nhấn phím số 3  ]
@echo                    [  5. Về Main Menu                             	: Nhấn phím số 4  ]
@echo                    ===========================================================================
Choice /N /C 12345 /M "* Nhập lựa chọn của bạn :

if ERRORLEVEL == 5 goto :main
if ERRORLEVEL == 4 goto :wingetUpdateAll
if ERRORLEVEL == 3 goto :wingetInstallRemoteSupport
if ERRORLEVEL == 2 goto :wingetInstallOnlineUtilities
if ERRORLEVEL == 1 goto :installWinget
PAUSE
goto main

:installWinget
cls
echo Tiến hành cài đặt Winget
if not exist Microsoft.VCLibs.x64.14.00.Desktop.appx (curl -o Microsoft.VCLibs.x64.14.00.Desktop.appx -fsSL https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx)
start powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.VCLibs.x64.14.00.Desktop.appx
if not exist Microsoft.DesktopAppInstaller.msixbundle (curl -o Microsoft.DesktopAppInstaller.msixbundle -fsSL https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle)
start powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.DesktopAppInstaller.msixbundle
REM del Microsoft.VCLibs.x64.14.00.Desktop.appx
REM del Microsoft.DesktopAppInstaller.msixbundle
echo Đã cài đặt Winget thành công
timeout 2
goto :winget

:wingetInstallOnlineUtilities
echo *******************************************
echo 		Danh sách ứng dụng cài đặt
echo 		7zip, Notepad++ 
echo 		Foxit Reader
echo 		Zalo, Slack
echo 		Google Chrome, Firefox
echo 		BulkCrapUninstaller
echo *******************************************
timeout 2
cls
winget install VNGCorp.Zalo -h && winget install SlackTechnologies.Slack --scope machine -h && winget install -h 7zip.7zip && winget install -h Foxit.FoxitReader && winget install -h Notepad++.Notepad++ && winget install -h --scope machine Google.Chrome && winget install -h --scope machine Mozilla.Firefox && winget install -h Klocman.BulkCrapUninstaller && winget install --scope machine -h Klocman.BulkCrapUninstaller
if not exist "C:\Program Files\Unikey" ("c:\Program Files\7-Zip\7z.exe" x -y unikey43RC5-200929-win64.zip -o"C:\Program Files\Unikey")
if not exist "C:\Program Files\Unikey" (echo Không tìm thấy Unikey để thêm vào startup) else (xcopy "c:\Program Files\Unikey\UniKeyNT.exe" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" /y)
REM winget install --scope machine -h
REM winget install -h
REM 7zip.7zip
REM VideoLAN.VLC
REM Foxit.FoxitReader
REM Notepad++.Notepad++
REM Google.Chrome
REM Mozilla.Firefox
REM SlackTechnologies.Slack
REM VNGCorp.Zalo
REM Klocman.BulkCrapUninstaller
goto :winget

:wingetInstallRemoteSupport
REM winget install --scope machine -h 
REM DucFabulous.UltraViewer
REM TeamViewer.TeamViewer
echo Tiến hành cài đặt Ultraviewer và Teamviewer 
winget install TeamViewer.TeamViewer -h --accept-source-agreements && winget install DucFabulous.UltraViewer -h --force --accept-source-agreements
cls
goto :winget

:wingetUpdateAll
winget upgrade -h --accept-package-agreements --accept-source-agreements --all
goto :winget

:end