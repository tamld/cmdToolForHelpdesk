echo off
Title Script Auto install Software
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
set "appversion=v0.6.74 July 26, 2023"
set "dp=%~dp0"
set "sys32=%windir%\system32"
call :getOfficePath
set officePath=%cd%
set "startProgram=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
cd /d "%dp%"
cls
setlocal
title Main Menu
echo.
echo %appversion%
echo    ========================================================
echo    [1] Install All In One Online                  : Press 1
echo    [2] Windows Office Utilities                   : Press 2
echo    [3] Active Licenses                            : Press 3
echo    [4] Utilities                                  : Press 4
echo    [5] Package Management                         : Press 5
echo    [6] Update CMD                                 : Press 6
echo    [7] Exit                                       : Press 7
echo    ========================================================
Choice /N /C 1234567 /M " Your choice is :"
if %ERRORLEVEL% == 7 call :clean && goto exit
if %ERRORLEVEL% == 6 call :updateCMD & goto main
if %ERRORLEVEL% == 5 goto packageManagementMenu
if %ERRORLEVEL% == 4 goto utilities
if %ERRORLEVEL% == 3 goto activeLicenses
if %ERRORLEVEL% == 2 goto office-windows
if %ERRORLEVEL% == 1 goto installAIOMenu
endlocal
goto end

REM ========================================================================================================================================
REM ==============================================================================
REM Start of installAIOMenu
REM Install Software Online using Winget or Chocolately
:installAIOMenu
setlocal
cls
title Install All In One online
echo.
echo        ======================================================
echo        [1] Fresh Install without Office             : Press 1
echo        [2] Fresh Install with Office 2019           : Press 2
echo        [3] Fresh Install with Office 2021           : Press 3
echo        [4] Main Menu                                : Press 4
echo        ======================================================
Choice /N /C 1234 /M " Press your choice : "
if %ERRORLEVEL% == 4 goto main
if %ERRORLEVEL% == 3 goto installAIO-O2021
if %ERRORLEVEL% == 2 goto installAIO-O2019
if %ERRORLEVEL% == 1 goto installAIO-Fresh
endlocal
REM ========================================================================================================================================
REM function install fresh Windows using Winget utilities
:installAIO-Fresh
rem call :hold
Title Install All in one from fresh Windows 
cls
Echo This will adjust settings, install softwares for fresh computer wihtout Office
call :settingWindows
call :setHighPerformance
call :checkCompatibility
call :winget-Endusers
call :choco-RemoteSupport
call :installUnikey
call :createShortcut
call :installSupportAssistant
goto :installAIOMenu

:installAIO-O2019
call :hold
goto :installAIOMenu

:installAIO-O2021
call :hold
goto :installAIOMenu


:installAIO-System-Network
call :hold
goto :installAIOMenu

:installAIO-Helpdesk
call :hold
goto :installAIOMenu

REM End of Install AIO Online
::========================================================================================================================================
::==============================================================================
:: Start of Windows Office Utilities Menu
:office-windows
setlocal
cd /d %dp%
cls
title Windows Office Main Menu
echo.
echo        ==============================================================
echo        [1] Install Office Online                            : Press 1
echo        [2] Uninstall Office                                 : Press 2
echo        [3] Remove Office Key                                : Press 3
echo        [4] Convert Office Retail ^<==^> Volume License        : Press 4
echo        [5] Fix Noncore Windows                              : Press 5
echo        [6] Load SKUS Windows                                : Press 6
echo        [7] Main Menu                                        : Press 7
echo        ==============================================================
Choice /N /C 1234567 /M " Press your choice : "
if %ERRORLEVEL% == 7 goto :main
if %ERRORLEVEL% == 6 call :loadSkusMenu & goto :office-windows
if %ERRORLEVEL% == 5 goto :fixNonCore
if %ERRORLEVEL% == 4 goto :convertOfficeEddition
if %ERRORLEVEL% == 3 goto :removeOfficeKey
if %ERRORLEVEL% == 2 goto :uninstallOffice
if %ERRORLEVEL% == 1 goto :installOfficeMenu
endlocal
REM ==============================================================================
REM Start of Windows Office Utilities functions
REM ==============================================================================
REM Sub menu Install Office Online

:installOfficeMenu
Title Select Office Version to Install
setlocal
cls
echo.
echo                ================================================================
echo                [1] Office 365                                         : Press 1
echo                [2] Office 2021 Proplus Retail (Project ^& Visio)       : Press 2
echo                [3] Office 2019 Proplus Retail (Project ^& Visio)       : Press 3
echo                [4] Main Menu                                          : Press 4
echo                ================================================================
Choice /N /C 1234 /M " Press your choice : "
if %ERRORLEVEL% == 4 goto office-windows
if %ERRORLEVEL% == 3 set office=2019& call :defineOffice& goto :office-windows
if %ERRORLEVEL% == 2 set office=2021& call :defineOffice& goto :office-windows
if %ERRORLEVEL% == 1 set office=365& call :installO365& goto :office-windows
endlocal
REM ============================================
REM Stat of install office  online

:: REF code http://zone94.com/downloads/135-windows-and-office-activation-script
:: Function defines a list of variable representing for Office apps
:defineOffice
@echo off
cls
TITLE Microsoft Office ProPlus - Online Installer
REM Define value default for install
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
    
:: Function menu select app to install. Default is yes with Yes colored green.
:selectOfficeApp
cls
echo.
echo List of components to install Office %office%
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
<NUL Set/P=[Q] & echo Quit to Office Menu
echo.
CHOICE /c 123456789PDXQ /n /m "--> Select option(s) and then press [X] to start the installation: "
if %ERRORLEVEL% == 13 goto ::installOfficeMenu
if %ERRORLEVEL% == 12 goto :installOffice
if %ERRORLEVEL% == 11 (if "%optD%"=="%on%" (Set "optD=%off%") Else (Set "optD=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 10 (if "%optP%"=="%on%" (Set "optP=%off%") Else (Set "optP=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 9 (if "%opt9%"=="%on%" (Set "opt9=%off%") Else (Set "opt9=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 8 (if "%opt8%"=="%on%" (Set "opt8=%off%") Else (Set "opt8=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 7 (if "%opt7%"=="%on%" (Set "opt7=%off%") Else (Set "opt7=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 6 (if "%opt6%"=="%on%" (Set "opt6=%off%") Else (Set "opt6=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 5 (if "%opt5%"=="%on%" (Set "opt5=%off%") Else (Set "opt5=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 4 (if "%opt4%"=="%on%" (Set "opt4=%off%") Else (Set "opt4=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 3 (if "%opt3%"=="%on%" (Set "opt3=%off%") Else (Set "opt3=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 2 (if "%opt2%"=="%on%" (Set "opt2=%off%") Else (Set "opt2=%on%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 1 (if "%opt1%"=="%on%" (Set "opt1=%off%") Else (Set "opt1=%on%")) & goto :selectOfficeApp

:: Function that help colorized selection menu
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

:: Function install Office based on the version and the software selected by user input
:installOffice
cls
Title Install Office 
rem echo.
rem echo Disabling Microsoft Office %office% Telemetry . . .
rem ping -n 2 localhost 1>NUL
rem REG ADD "HKLM\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "00000001" /f 1>NUL
rem if not exist "%ProgramFiles%\7-Zip" (call :install7zip) else (echo 7zip has been installed)
if not exist "%ProgramFiles%\7-Zip" (call :install7zip)
pushd %temp%
:: Office Deployment Tools
rem curl -o "officedeploymenttool.exe" -fsSL https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16501-20196.exe
curl -O -fsSL https://github.com/tamld/cmdToolForHelpdesk/raw/main/officedeploymenttool.exe
"%ProgramFiles%\7-Zip\7z.exe" e "officedeploymenttool.exe" -y
SETLOCAL
REM REM Deploy template via link: https://config.office.com/deploymentsettings
Set "OCS="%temp%\Office %office% Setup Config.xml""
                      >%OCS% echo ^<Configuration^>
                     >>%OCS% echo   ^<Add OfficeClientEdition="%CPU%" Channel="Monthly"^>                    
if "%office%"=="O365" >>%OCS% echo     ^<Product ID="%office%ProPlusRetail"^> else (
                     >>%OCS% echo     ^<Product ID="ProPlus%office%Retail"^>    )
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
cls
echo Installing Microsoft Office %office% ProPlus %CPU%-bit
call :log Installing Microsoft Office %office% ProPlus %CPU%-bit
echo Don't close this window until the installation process is completed
ping -n 3 localhost 1>NUL
START "" /WAIT /B "setup.exe" /configure "Office %office% Setup Config.xml"
popd
call :log Finished Microsoft Office %office% ProPlus %CPU%-bit installation
cd %dp%
goto :EOF

:: Function thats help install Office 365
:installO365
cls
if not exist "%ProgramFiles%\7-Zip" (call :install7zip)
pushd %temp%
:: Fix URL download Office Deployment Tools
rem curl -o "officedeploymenttool.exe" -fsSL https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16501-20196.exe
curl -O -fsSL https://github.com/tamld/cmdToolForHelpdesk/raw/main/officedeploymenttool.exe
"%ProgramFiles%\7-Zip\7z.exe" e "officedeploymenttool.exe" -y
IF "%Processor_Architecture%"=="AMD64" Set "CPU=x64"
IF "%Processor_Architecture%"=="x86" Set "CPU=x32"
cls
echo Installing Microsoft Office 365 %CPU%-bit
call :log Installing Microsoft Office 365 %CPU%-bit
echo Don't close this window until the installation process is completed
ping -n 3 localhost 1>NUL
rem START "" /WAIT /B ".\setup.exe" /configure configuration-Office365-%CPU%.xml
START "" /WAIT /B "setup.exe" /configure configuration-Office365-%CPU%.xml
call :log Finished Microsoft Office 365 %CPU%-bit
popd
cd %dp%
goto :EOF
REM End of install office online

REM ============================================
:: Function defines which Office (x64/x86) is installed
:getOfficePath
cls
echo off
for %%a in (4,5,6) do (if exist "%ProgramFiles%\Microsoft Office\Office1%%a\ospp.vbs" (cd /d "%ProgramFiles%\Microsoft Office\Office1%%a"&& set officePath=%cd%)
if exist "%ProgramFiles(x86)%\Microsoft Office\Office1%%a\ospp.vbs" (cd /d "%ProgramFiles(x86)%\Microsoft Office\Office1%%a"&& set officePath=%cd%))
goto :eof

:: Function Menu that selects which edition Windows will convert to
:loadSkusMenu
setlocal
cls
Title Load Windows Eddition
echo.
echo Select Windows Skus edition to convert
echo.
echo        ==================================================
echo        [1] Professional                        : PRESS 1
echo        [2] ProfessionalWorkstation             : PRESS 2
echo        [3] Enterprise                          : PRESS 3
echo        [4] EnterpriseS                         : PRESS 4
echo        [5] IoTEnterprise                       : PRESS 5
echo        [6] Education                           : PRESS 6
echo        [7] LTSB 2016                           : PRESS 7
echo        [8] LTSC 2019                           : PRESS 8
echo        [9] Menu Active Office                  : PRESS 9
echo        ==================================================
Choice /N /C 123456789 /M " Press your choice : "
if %errorlevel% == 1 set keyW=VK7JG-NPHTM-C97JM-9MPGT-3V66T&& set typeW=Professional&& goto :loadSKUS
if %errorlevel% == 2 set keyW=DXG7C-N36C4-C4HTG-X4T3X-2YV77&& set typeW=ProfessionalWorkstation&& goto :loadSKUS
if %errorlevel% == 3 set keyW=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C&& set typeW=Enterprise&& goto :loadSKUS
if %errorlevel% == 4 set keyW=NK96Y-D9CD8-W44CQ-R8YTK-DYJWX&& set typeW=EnterpriseS&& goto :loadSKUS
if %errorlevel% == 5 set keyW=M7XTQ-FN8P6-TTKYV-9D4CC-J462D&& set typeW=IoTEnterprise&& goto :loadSKUS
if %errorlevel% == 6 set keyW=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY&& set typeW=Education&& goto :loadSKUS
if %errorlevel% == 7 set keyW=RW7WN-FMT44-KRGBK-G44WK-QV7YK&& set typeW=wdLTSB2016&& goto :loadSKUS
if %errorlevel% == 8 set keyW=M7XTQ-FN8P6-TTKYV-9D4CC-J462D&& set typeW=wdLTSC2019&& goto :loadSKUS
if %errorlevel% == 9 goto :office-windows
endlocal

:: Function that helps Windows convert to another edition
:loadSKUS
setlocal
cls
echo off
if not exist "%ProgramFiles%\7-Zip" (call :install7zip)
pushd %temp%
echo.
echo Generic Windows %typeW% key: %keyW%
echo Activating...
if not exist Licenses (
    curl -L -o "Licenses.zip" "https://drive.google.com/uc?export=download&id=1Cl7yQ5YPLh8laCfKBrkyVK_PEJN-GjWR" >nul 2>&1
    "%ProgramFiles%\7-Zip\7z.exe" x -y Licenses.zip >nul 2>&1
)
xcopy "Licenses\Skus Windows"\%typeW% C:\Windows\system32\spp\tokens\skus\%typeW% /IS /Y >nul 2>&1
ping -n 3 localhost > NUL
popd
pushd c:\Windows\system32
cscript.exe slmgr.vbs /rilc
cscript.exe slmgr.vbs /upk >nul 2>&1
cscript.exe slmgr.vbs /ckms >nul 2>&1
cscript.exe slmgr.vbs /cpky >nul 2>&1
cscript.exe slmgr.vbs /ipk %keyW% >nul 2>&1
sc config LicenseManager start= auto & net start LicenseManager >nul 2>&1
sc config wuauserv start= auto & net start wuauserv >nul 2>&1
clipup -v -o -altto c:\
cls
echo Load Windows eddition %typeW% completed
ping -n 3 localhost 1>NUL
endlocal
goto :EOF

:fixNonCore
cls
call :hold
goto :office-windows

:convertOfficeEddition
call :hold
goto :office-windows

REM ============================================
REM Start of Remove Office Keys
:removeOfficeKey
cls
Title Remove Office Key
echo.
echo How would you like to remove the office key?
echo            =================================================
echo            [1] One by one                          : Press 1
echo            [2] All                                 : Press 2
echo            [3] Back to Windows Office Menu         : Press 3
echo            =================================================
Choice /N /C 123 /M " Press your choice : "
if %ERRORLEVEL% == 3 goto :office-windows
if %ERRORLEVEL% == 2 call :removeOfficeKey-All & goto :office-windows
if %ERRORLEVEL% == 1 call :removeOfficeKey-1B1 & goto :office-windows

:removeOfficeKey-1B1
cls
setlocal 
pushd %officePath%
echo Your office path at: %officePath%
echo.
::Get input from user
set /p key=Write down/Paste 5 letters key need to uninstall: 
::Loop through the OSPP.VBS file and find the key to uninstall
for /f "tokens=8" %%b in ('findstr /b /c:"%key%" OSPP.VBS') do (
cscript //nologo ospp.vbs /unpkey:%%b
endlocal 
popd
ping -n 2 localhost 1>NUL
goto :eof

:removeOfficeKey-All
echo off 
cls
setlocal 
rem cd /d %officePath% 
pushd %officePath%
echo Your office path at: %officePath%
for /f "tokens=8" %%b in ('findstr /b /c:"Last 5" OSPP.VBS') do (
cscript //nologo ospp.vbs /unpkey:%%b
echo Key %%b has been removed
)
endlocal 
ping -n 2 localhost 1>NUL
goto :eof

    
    
:uninstallOffice
cls
Title Uninstall Office all versions
echo.
echo            ====================================================
echo            [1] Using SaraCMD (silent)                 : Press 1
echo            [2] Using Sara UI (interactive)            : Press 2
echo            [3] Using BCUninstaller                    : Press 3
echo            [4] Back to Windows Office Menu            : Press 4
echo            ====================================================
Choice /N /C 1234 /M " Press your choice : "
if %ERRORLEVEL% == 4 goto :office-windows
if %ERRORLEVEL% == 3 goto :removeOffice-BCUninstaller
if %ERRORLEVEL% == 2 goto :removeOffice-saraUI
if %ERRORLEVEL% == 1 goto :removeOffice-saraCmd

:removeOffice-BCUninstaller
cls
Title Uninstall Office Using BulkCrapUninstaller
echo This will install BCUninstaller into your computer
call :checkCompatibility
call :installSoft Klocman.BulkCrapUninstaller
call :bcuninstaller-Settings
goto :office-windows

:removeOffice-saraUI
cls
Title Uninstall Office Using Sara UI
echo This will download (browser download) and install Sara UI for uninstalling Office steps
echo You must install it manually and follow the wizard guide 
ping -n 4 localhost 1>NUL
start https://aka.ms/SaRA-officeUninstallFromPC
goto :office-windows

:removeOffice-saraCmd
Title Uninstall office completely using Sara Cmd
cls
echo This will download and remove office without interactive
ping -n 2 localhost 1>NUL
cls
echo off
pushd %temp%
if not exist "%ProgramFiles%\7-Zip\7z.exe" call :install7zip
curl -# -o SaRACmd.zip -fsL https://aka.ms/SaRA_CommandLineVersionFiles
::curl -# -o SaRACmd.zip -fsL https://aka.ms/SaRA_EnterpriseVersionFiles
"c:\Program Files\7-Zip\7z.exe" x -y SaRACmd.zip -o"SaRACmd"
cls
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

REM End of Remove Office Keys
REM ============================================
REM End of Windows Office Utilities functions
REM ========================================================================================================================================
:activeLicenses
REM Start of Active Licenses Menu
setlocal
Title Active Licenses Menu
cls
echo.
echo        ========================================================
echo        [1] Online                                     : Press 1
echo        [2] By Phone                                   : Press 2
echo        [3] Check Licenses                             : Press 3
echo        [4] Backup Licenses                            : Press 4
echo        [5] Restore License                            : Press 5
echo        [6] MAS (Microsoft Activation Scripts)         : Press 6
echo        [7] Back to Main Menu                          : Press 7
echo        ========================================================
Choice /N /C 1234567 /M " Press your choice : "
if %ERRORLEVEL% == 7 goto :main
if %ERRORLEVEL% == 6 goto :MAS
if %ERRORLEVEL% == 5 goto :restoreLicenses
if %ERRORLEVEL% == 4 goto :backupLicenses
if %ERRORLEVEL% == 3 goto :checkLicense
if %ERRORLEVEL% == 2 goto :activeByPhone
if %ERRORLEVEL% == 1 goto :activeOnline
endlocal

REM End of Active Licenses Menu
REM ==============================================================================
::@ Start of Active Lienses functions
:MAS
cls
REM call :hold
pushd %temp%
echo This will open an external link from Github call Microsoft Activation Script
echo Refer link https://github.com/massgravel/Microsoft-Activation-Scripts
echo Do with your own risks, be careful!!!
ping -n 5 localhost 1>NUL
start powershell.exe -command "irm https://massgrave.dev/get | iex"
popd
cd %dp%
cls
goto :activeLicenses

:restoreLicenses
cls
call :hold
goto :activeLicenses

REM ============================================
REM Start of Backup License Windows & Office
:backupLicenses
cls
Title Backup License Windows ^& Office
echo.
echo            =================================================
echo            [1] BACKUP To Local                     : Press 1
echo            [2] BACKUP To NAS STORAGE               : Press 2
echo            [3] Back to Main Menu                   : Press 3
echo            =================================================
Choice /N /C 123 /M " Press your choice : "
if %ERRORLEVEL% == 3 goto :activeLicenses
if %ERRORLEVEL% == 2 goto :backupToNAS
if %ERRORLEVEL% == 1 goto :backupToLocal

:backupToNAS
call :hold
goto :backupLicenses

:backupToLocal
call :hold
goto :backupLicenses
REM End of Backup License Windows & Office
REM ============================================
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
echo        =================================================
echo        [1] Set High Performance                : Press 1
echo        [2] Change hostname                     : Press 2
echo        [3] Clean up system                     : Press 3
echo        [4] Add user to Admin group             : Press 4
echo        [5] Add user to Users group             : Press 5
echo        [6] Install Support Assistance          : Press 6
echo        [7] Active IDM                          : Press 7
echo        [8] Join domain                         : Press 8
echo        [9] Back to Main Menu                   : Press 9
echo        =================================================
Choice /N /C 123456789 /M " Press your choice : "
if %ERRORLEVEL% == 9 goto :main
if %ERRORLEVEL% == 8 goto :joinDomain
if %ERRORLEVEL% == 7 call :activeIDM & goto :utilities
if %ERRORLEVEL% == 6 goto :installSupportAssistant
if %ERRORLEVEL% == 5 goto :addUserToUsers
if %ERRORLEVEL% == 4 goto :addUserToAdmins
if %ERRORLEVEL% == 3 goto :cleanUpSystem
if %ERRORLEVEL% == 2 goto :changeHostName
if %ERRORLEVEL% == 1 goto :setHighPerformance
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
echo This will force restart computer with 5s
shutdown -r -t 5 -f
goto :utilities

:installSupportAssistant
Title Install Support Assistant
call :checkCompatibility
cls
echo Installing Support Assistant
ping -n 3 localhost 1>NUL
setlocal
echo off
REM Detect brand name
for /f %%b in ('wmic computersystem get manufacturer ^| findstr /I "Dell HP Lenovo"') do set "BRAND=%%b"
REM Download and install the appropriate support assistant
if /I "%BRAND%" == "Dell" (
choco install -y supportassist --ignore-checksums
) else if /I "%BRAND%" == "HP" (
choco install -y hpsupportassistant --ignore-checksums
) else if /I "%BRAND%" == "Lenovo" (
choco install -y lenovo-thinkvantage-system-update --ignore-checksums
) else (
echo Unknown brand: %BRAND%
)
endlocal
goto :eof
cd %dp%
goto :utilities

:: Ping to host
:pingHost
cls
echo off
setlocal enabledelayedexpansion
set host=172.16.11.5
ping %host% | findstr /i "Reply from" >nul
if !errorlevel! == 0 (
    ping %host% | findstr /i "Destination host unreachable" >nul
    if !errorlevel! == 0 (
        echo Ping failed
    ) else (
        echo Ping succeeded
    )
) else (
    echo Ping failed
)
endlocal
goto :EOF

:joinDomain
cls
setlocal
REM input Fully Qualified Domain Name
set /p server=Enter the Domain Name: 
call :log "Joining domain %server%..."
REM check if host can reach the AD with FQDN
ping %server%
REM ping -n 4 %server% 1>NUL
if %errorlevel% neq 0 (
echo Cannot reach server. Exiting...
call :log "Cannot reach server. Exiting..."
ping -n 5 localhost 1>NUL
) else (
echo %server% is pingable. Proceeding with upgrade...
call :log "%server% is pingable. Proceeding with upgrade..."
ping -n 5 localhost 1>NUL
cls
echo Please enter FQDN username instead of username only (domain\username instead of username)
call :inputCredential
echo Joining domain...
wmic computersystem where name="%computername%" call joindomainorworkgroup name=%server% username=%username% password=%password%
if %errorlevel% neq 0 (
cls
echo Failed to join domain. Error code: %errorlevel%
call :log "Failed to join domain. Error code: %errorlevel%"
ping -n 5 localhost 1>NUL
) else (
cls
echo Successfully joined domain.
call :log "Successfully joined domain."
)
ping -n 5 localhost 1>NUL
endlocal
goto :utilities

REM This function will use Windows Disk Cleanup to remove unnecessary files
:cleanUpSystem
Title Clean Up System
cls
echo This will cleanup temp folder and add preset for Windows Cleanup Utilities
echo You can execute the command cleanmgr /sagerun:1 afterward
call :clean > NUL
ping -n 3 localhost > NUL
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
cls
echo Your new computername is:
set /p _newComputername=
cls
echo This will change your computername from: %computername% to: %_newComputername%
ping -n 2 localhost 1>NUL
WMIC ComputerSystem where Name="%computername%" call Rename Name="%_newComputername%"
for /f "skip=1 tokens=2 delims==; " %%i in ('WMIC ComputerSystem where Name^="%computername%" call Rename Name^="%_newComputername%" ^| findstr "ReturnValue ="') do set _statusChangeHostName=%%i
cls
if %_statusChangeHostName% == 0 (
echo Your computername will change to %_newComputername%
echo Restart computer to apply the change
ping -n 3 localhost 1>NUL
cls
)
if %_statusChangeHostName% NEQ 0 (
echo Your computer name will not change 
echo Try a name without containing special characters like ^~, ^!, ^@.....
echo Do you want to change your computer hostname again^?
Choice /N /C YN /M "[Yes], [No]: "
If ERRORLEVEL == Y goto :changeHostName
)
endlocal
    goto :utilities

:settingWindows
cls
echo off
echo Setting OS
echo Show file extension
powershell Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0
echo Enable Dark mode
powershell Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0
echo Show this PC view
powershell Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
echo Revert classic menu Right click W11
setlocal
:: Detect Windows 10 or 11
for /f "tokens=2,3 delims= " %%a in ('wmic os get name /value ^| findstr /i "name"') do set winver=%%b
if %winver%==11 (
echo Revert classic menu Right click W11
reg add HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2} /ve /t REG_SZ /d "" /f
reg add HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /t REG_SZ /d "" /f
)
endlocal
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
echo Change timezone to +7 Asia
tzutil /s "SE Asia Standard Time"
echo Set NTP Pool and Sync
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
w32tm /resync
echo Disable sleep mode
powercfg.exe /h off
rem echo Allow Remote Desktop
rem reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
rem reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP" /v UserAuthentication /t REG_DWORD /d "0" /f
rem echo Allow Remote Desktop from Specified IPs
rem netsh advfirewall firewall add rule name="Allow from specific IP addresses" dir=in action=allow protocol=TCP localport=3389 remoteip=A.A.A.A,B.B.B.B
REM echo ==================================================
REM echo                Don't Allow Remote Desktop
REM reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
REM echo                Turn on NLA Remote Setting
REM reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-TCP" /v UserAuthentication /t REG_DWORD /d "1" /f
echo Restart the computer to apply all settings
ping -n 2 localhost 1>NUL
goto :EOF

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
goto :EOF

:createShortcut
cls
@echo off
COPY /Y "%startProgram%\*.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\BCUninstaller\BCUninstaller.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\Foxit PDF Reader\Foxit PDF Reader.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\Slack Technologies Inc\*.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\UltraViewer\*.lnk" "%AllUsersProfile%\Desktop"
goto :eof


REM End of Utilities functions
REM ========================================================================================================================================
:packageManagementMenu
setlocal
REM Start of Winget Menu
cd /d %dp%
cls
title Package Management Software main Menu
echo.
echo        ====================================================
echo        [1] Install Package Management             : Press 1
echo        [2] Install End Users applications         : Press 2
echo        [3] Install Remote applications            : Press 3
echo        [4] Install Network applications           : Press 4
echo        [5] Install Chat applications              : Press 5
echo        [6] Upgrade online all                     : Press 6
echo        [7] Main Menu                              : Press 7
echo        ====================================================

Choice /N /C 1234567 /M " Press your choice : "
if %ERRORLEVEL% == 7 goto :main
if %ERRORLEVEL% == 6 call :updateWinget-All & goto :packageManagementMenu
if %ERRORLEVEL% == 5 call :winget-Chat & goto :packageManagementMenu
if %ERRORLEVEL% == 4 call :winget-Network & goto :packageManagementMenu
if %ERRORLEVEL% == 3 call :choco-RemoteSupport & goto :packageManagementMenu
if %ERRORLEVEL% == 2 call :winget-Endusers & goto :packageManagementMenu
if %ERRORLEVEL% == 1 call :packageManagement & goto :packageManagementMenu
REM End of Winget Menu
REM ==============================================================================
REM Start of Winget functions
::=======================================================================================================================
:: Note
:: Without Scope Machine, the software will be installed with the current user profile instead of the system profile
:: Package list can be search with command: 
::            *winget search [software name]* eg: winget search teamviewer
::TeamViewer: Remote Control 9WZDNCRFJ0RH               Unknown msstore
::TeamViewer                 TeamViewer.TeamViewer      15.42.9 winget
::TeamViewer Host            TeamViewer.TeamViewer.Host 15.42.9 winget
::=============================================
:: Advanced searching with findstr /i that help filtering with condition(s)
::            *winget search [software] eg: winget search team | findstr /i "teamviewer"
::Result
::TeamViewer Host                           TeamViewer.TeamViewer.Host           15.42.9                          winget
::TeamViewer                                TeamViewer.TeamViewer                15.42.9                          winget
::=======================================================================================================================

:updateWinget-All
Title Update software by Winget
call :checkCompatibility
cls
echo y | winget upgrade -h --all
call :log "Winget finished upgrading all packages successfully"
goto :EOF

:winget-Deskjob
cls
call :hold
goto :EOF

rem :installNetworkApp
rem cls
rem call :choco-Network 
rem call :winget-Network
rem goto :EOF

:choco-Network
Title Install Network softwares by Chocolately
cls
setlocal
echo List softwares to install
echo =================================================
echo virtualbox, processhacker, hardentools, mobaxterm
echo =================================================
ping -n 3 localhost 1>NUL
cls
call :log "Installing Network softwares by Chocolately"
call :checkCompatibility
cls
set packageList=processhacker ^
mobaxterm ^-^-version=23.2.0 ^
virtualbox ^
virtualbox-guest-additions-guest.install ^
hardentools
for %%p in (%packageList%) do (choco install -y %%p)
:: Copy Mobaxterm setting
cls
echo Setting for Mobaxterm v23.2
curl -L -o "c:\Program Files (x86)\Mobatek\MobaXterm\Custom.mxtpro" "https://drive.google.com/uc?export=download&id=1cO4GAkbdvbOKju9QVH0OXjN48_gS0D82"
call :killtasks
call :log "Finished Network softwares by Chocolately"
endlocal
goto :EOF

:winget-Network
Title Install Network softwares by Winget
setlocal
call :log "Installing Network softwares by Winget"
cls
echo List softwares to install
echo ========================================================
echo OpenSSH, rclone, rclone-browser, mobaxterm, VirtualBox
echo Advanced IP Scanner, JDownloader, VSCode, Notepad++
echo SSHFS, WinFSP, WinSCP, Putty, Network Manager, Dotnet 6
echo ========================================================
ping -n 3 localhost 1>NUL
cls
call :checkCompatibility
call :installSoft "Mobatek.MobaXterm --version 23.2.0.5082"
:: Copy Mobaxterm setting
if not exist "C:\Program Files (x86)\Mobatek\MobaXterm" (echo Mobaxterm is not installed) else (
curl -L -o "c:\Program Files (x86)\Mobatek\MobaXterm\Custom.mxtpro" "https://drive.google.com/uc?export=download&id=1cO4GAkbdvbOKju9QVH0OXjN48_gS0D82"
echo Mobaxterm setting complete
)
ping -n 2 localhost 1>NUL
cls
set packageList=Notepad++.Notepad++ ^
7zip.7zip ^
Microsoft.OpenSSH.Beta ^
Rclone.Rclone ^
kapitainsky.RcloneBrowser ^
Famatech.AdvancedIPScanner ^
AppWork.JDownloader ^
Microsoft.VisualStudioCode ^
WinFsp.WinFsp ^
SSHFS-Win.SSHFS-Win ^
WinSCP.WinSCP ^
PuTTY.PuTTY ^
Microsoft.VCRedist.2015+.x64 ^
Microsoft.DotNet.Runtime.6 ^
Microsoft.DotNet.SDK.6 ^
NETworkManager ^
Oracle.VirtualBox
rem for %%p in (%packageList%) do (call :installSoft %%p --accept-package-agreements --accept-source-agreements)
for %%p in (%packageList%) do (call :installSoft %%p)
call :killtasks
call :log "Finished Network softwares by Winget"
endlocal
goto :EOF

:winget-Mobaxterm
cls
call :checkCompatibility
echo Installing Mobaxterm v23.2.0.5082
winget install Mobatek.MobaXterm --version 23.2.0.5082 --accept-package-agreements --accept-source-agreements
:: Copy Mobaxterm setting
if not exist "C:\Program Files (x86)\Mobatek\MobaXterm" (echo Mobaxterm is not installed) else (
curl -L -o "c:\Program Files (x86)\Mobatek\MobaXterm\Custom.mxtpro" "https://drive.google.com/uc?export=download&id=1cO4GAkbdvbOKju9QVH0OXjN48_gS0D82"
echo Mobaxterm setting complete
)
ping -n 2 localhost 1>NUL
goto :EOF

:winget-Chat
Title Install Chat softwares by Winget
call :checkCompatibility
setlocal
call :log "Installing Chat softwares by Winget"
ping -n 3 localhost 1>NUL
cls
echo List softwares to install
echo ======================================
echo  Zalo, Skype, Viber, Zoom
echo  Telegram Desktop, Facebook Messenger
echo ======================================
ping -n 3 localhost 1>NUL
cls
pushd %temp%
echo Install List Software by winget
set packageList= VNGCorp.Zalo ^
Desktop.Telegram ^
Viber.Viber ^
Facebook.Messenger ^
Microsoft.Skype ^
Zoom.Zoom
for %%p in (%packageList%) do (call :installSoft %%p --accept-package-agreements --accept-source-agreements)
endlocal
goto :EOF

:winget-RemoteSupport
cls
call :checkCompatibility
call :installsoft TeamViewer.TeamViewer
call :installsoft DucFabulous.UltraViewer
goto :EOF

:choco-RemoteSupport
Title Install Remote Support Software by Chocolately
echo off
call :checkCompatibility
choco install -y teamviewer anydesk
choco install -y ultraviewer --ignore-checksums
goto :EOF

:winget-Endusers
Title Install Utilities by Winget
echo off
call :checkCompatibility
setlocal
call :log "Starting software utilities installation"
ping -n 3 localhost 1>NUL
cls
echo List Softwares to Install
echo ========================================================================
echo 7zip, Notepad++,Foxit Reader, Zalo, BulkCrap Uninstaller, Google Drive
echo DotNet Runtime.6, ShareX, Quicklook, Everything, Google Chrome, Firefox
echo ========================================================================
ping -n 3 localhost 1>NUL
cls
setlocal
pushd %temp%
echo Install List Software by winget
set packageList=Notepad++.Notepad++ ^
Google.Drive ^
Microsoft.DotNet.Runtime.6 ^
VNGCorp.Zalo ^
ShareX.ShareX ^
voidtools.Everything ^
QL-Win.QuickLook ^
IObit.IObitUnlocker ^
Facebook.Messenger ^
Telegram.TelegramDesktop ^
Microsoft.Skype ^
7zip.7zip ^
Foxit.FoxitReader ^
Notepad++.Notepad++ ^
Google.Chrome ^
Mozilla.Firefox ^
Klocman.BulkCrapUninstaller ^
Microsoft.PowerToys ^
FxSoundLLC.FxSound ^
google.drive ^
VideoLAN.VLC

for %%p in (%packageList%) do (call :installSoft %%p -h --accept-package-agreements --accept-source-agreements --ignore-security-hash --force)
endlocal
call :bcuninstaller-Settings
call :killtasks
cls
goto :EOF

:packageManagement
pushd %temp%
cls
:: Install chocolately
echo Installing Chocolately
powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
cls
echo Set Chocolately PATH
set "path=%path%;C:\ProgramData\chocolatey\bin"
if %ERRORLEVEL% EQU 0 (echo Choco PATH add successfully) else (echo Choco PATH add failed)
ping -n 2 localhost 1>nul
:: Install winget
cls
echo Installing Winget
curl -O -fsSL https://github.com/tamld/cmdToolForHelpdesk/raw/main/Microsoft.UI.Xaml.2.7.appx
curl -O -#fsSL https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
curl -o Microsoft.DesktopAppInstaller.msixbundle -#fsSL https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.VCLibs.x64.14.00.Desktop.appx
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.UI.Xaml.2.7.appx
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.DesktopAppInstaller.msixbundle
set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps"
if %ERRORLEVEL% EQU 0 (echo Winget PATH add successfully) else (echo Winget PATH add failed)
ping -n 2 localhost 1>nul
popd
goto :EOF

REM End of Winget functions
REM ========================================================================================================================================
REM function update CMD via github
:updateCMD
cls
cd /d %dp%
copy Helpdesk-Tools.cmd Helpdesk-Tools-old.cmd /Y
curl -sO https://raw.githubusercontent.com/tamld/cmdToolForHelpdesk/main/Helpdesk-Tools.cmd
echo File has been updated. Reopen it again
echo Check for the version, release date
ping -n 2 localhost 1>NUL
popd
goto :EOF

REM ========================================================================================================================================
REM Start of child process that can be reused functions

REM function checkWinget will check if winget is installed or neither. If not, go to installWinget function
:checkCompatibility
cls
echo off
rem Get the Windows version number
for /f "tokens=4 delims=[] " %%i in ('ver') do set VERSION=%%i

rem Check if the version number is 10.0.19041 or later
if "%VERSION%" GEQ "10.0.19041" (
cls
echo "Current Windows version: %VERSION% is suitable for installing winget and chocolatey"
call :log "Windows version check: Version %VERSION% is suitable for installing winget and chocolatey"
ping -n 2 localhost 1>NUL
winget -v
if ERRORLEVEL 1 (
cls
echo Installing Winget
call :installWinget
) else (
cls
echo Winget has been installed
ping -n 2 localhost 1>NUL
)
cls
choco -v
if ERRORLEVEL 1 (
cls
echo Installing Chocolately
call :installChocolately
) else (
cls
echo Chocolately has been installed
ping -n 2 localhost 1>NUL
)
) else (
call :log "Windows version check: Version %VERSION% is not suitable for installing"
echo Your Windows version is not suitable for installing
ping -n 2 localhost 1>NUL
) 
cls
goto :eof
::=====================================================================
:installChocolately
Title Install Chocolately
cls
echo Installing Chocolately
powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
cls
echo Set Chocolately PATH
set "path=%path%;C:\ProgramData\chocolatey\bin"
if %ERRORLEVEL% EQU 0 (echo Choco PATH add successfully) else (echo Choco PATH add failed)
cls
call :log "Finished Chocolately installation"
goto: EOF

:installWinget
Title Install Winget
pushd %temp%
cls
echo Install require packages VCLibs x64 14 and UI.Xaml 2.7
ping -n 2 localhost 1>NUL
curl -O -fsSL https://github.com/tamld/cmdToolForHelpdesk/raw/main/Microsoft.UI.Xaml.2.7.appx
curl -O -#fsSL https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx
curl -o Microsoft.DesktopAppInstaller.msixbundle -#fsSL https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.VCLibs.x64.14.00.Desktop.appx
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.UI.Xaml.2.7.appx
start /wait powershell Add-AppPackage -ForceUpdateFromAnyVersion ./Microsoft.DesktopAppInstaller.msixbundle
cls
echo Set Winget PATH
set "PATH=%PATH%;%LOCALAPPDATA%\Microsoft\WindowsApps"
if %ERRORLEVEL% EQU 0 (echo Winget PATH add successfully) else (echo Winget PATH add failed)
ping -n 2 localhost 1>nul
cls
popd
call :log "Finished Winget installation"
goto :EOF
:=====================================================================
::@%1 will inherit parameters from the outside input function
::@exit /b will exit function instead of remaining running scripts codes
:log
set logfile=%temp%\Helpdesk-Tools.log
set timestamp=%date% %time%
echo %timestamp% %1 >> %logfile%
cls
goto :EOF

:: Function to install soft using Winget utilities
:: To install with winget, call function by using call :installsoft "software id". eg: call :installsoft "7zip.7zip"
:installsoft
Title Install Software
REM Set the software name to install
set "software=%~1"
REM Set the scope machine if supported
set "scope=%~2"
REM Set status software installed or not
set "installed=0"

REM check if %software has been installed before
echo y | winget list %software% > nul
if "%errorlevel%" == "0" (set "installed=1")
if "%installed%"=="0" (if "%scope%"=="" (
echo y | winget install %software%
call :log "%software% installed without scope"
cls
) else (echo y | winget install %software% %scope%
call :log "%software% installed with scope %scope%"
cls
)
) else (
cls 
echo %software% already installed
ping -n 2 localhost 1>nul
call :log "%software% already installed"
cls
)
goto :EOF

:installSoft_ByChoco
Title Install Software by Chocolately
REM Set the software name to install
set "software=%~1"
REM Set status software installed or not
set "installed=0"

REM check if %software has been installed before
choco list --local-only %software% > nul
if "%errorlevel%" == "0" (set "installed=1")
if "%installed%"=="0" (
choco install %software% -y
call :log "%software% installed"
cls
) else (
cls
echo %software% already installed
ping -n 2 localhost 1>nul
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

::@ Function download Unikey from unikey.org, extract to C:\Program Files\Unikey and add to start up
:installUnikey
cls
if exist "C:\Program Files\Unikey" (echo Unikey is exist) else (
pushd %temp%
if not exist "%ProgramFiles%\7-Zip" (call :install7zip)
curl -# -o unikey43RC5-200929-win64.zip -L https://www.unikey.org/assets/release/unikey43RC5-200929-win64.zip
"c:\Program Files\7-Zip\7z.exe" x -y unikey43RC5-200929-win64.zip -o"C:\Program Files\Unikey"
echo "Copying Unikey to Startup"
mklink "%startProgram%\StartUp" "c:\Program Files\Unikey\UniKeyNT.exe"
echo "Creating Unikey shortcut on desktop"
mklink "%public%\Desktop\UnikeyNT.exe" "C:\Program Files\Unikey\UniKeyNT.exe"
popd
)
goto :EOF

:: Function install 7zip by using winget
:install7zip
cls
Title Install 7zip using Winget
call :checkCompatibility
call :installSoft 7zip.7zip
:: associate regular files extension with 7zip
echo. associate regular files extension with 7zip
ping -n 2 localhost 1>NUL
assoc .7z=7-Zip
assoc .zip=7-Zip
assoc .rar=7-Zip
assoc .tar=7-Zip
assoc .gz=7-Zip
assoc .bzip2=7-Zip
assoc .xz=7-Zip
goto :EOF

:: Ping to host
:pingHost
cls
echo off
setlocal enabledelayedexpansion
set host=172.16.11.5
ping %host% | findstr /i "Reply from" >nul
if !errorlevel! == 0 (
    ping %host% | findstr /i "Destination host unreachable" >nul
    if !errorlevel! == 0 (
        echo Ping failed
    ) else (
        echo Ping succeeded
    )
) else (
    echo Ping failed
)
endlocal
goto :EOF
    
:installNotepadThemes
Title Install Notepad++ Themes
cls
setlocal
if exist "%ProgramFiles(x86)%\Notepad++\notepad++.exe" (
set "nppPath=%ProgramFiles(x86)%\Notepad++"
) else if exist "%ProgramFiles%\Notepad++\notepad++.exe" (
set "nppPath=%ProgramFiles%\Notepad++"
) else (
call :installSoft notepad++.notepad++
set "nppPath=%ProgramFiles(x86)%\Notepad++"
)
pushd %temp%
echo Installing Notepad++ themes
:: Dracula theme
curl https://raw.githubusercontent.com/dracula/notepad-plus-plus/master/Dracula.xml -o Dracula.xml
xcopy Dracula.xml "%nppPath%\themes\" /YECIQ
::/C /I /Q
:: Material Theme
curl https://raw.githubusercontent.com/HiSandy/npp-material-theme/master/Material%20Theme.xml -o "Material Theme.xml"
xcopy "Material Theme.xml" "%nppPath%\themes\" /YECIQ

:: Nord theme
curl https://raw.githubusercontent.com/arcticicestudio/nord-notepadplusplus/develop/src/xml/nord.xml -LJ -o Nord.xml
xcopy Nord.xml "%nppPath%\themes\" /YECIQ

:: Mariana theme
curl https://raw.githubusercontent.com/Codextor/npp-mariana-theme/master/Mariana.xml -o Mariana.xml
xcopy Mariana.xml "%nppPath%\themes\" /YECIQ

call :log "Notepad++ themes installation finished"
endlocal
popd
goto :EOF

REM function asks the user to input username and password for credential checking
:inputCredential
cls
echo.
set /p username=Enter the username:
echo.
set /p password=Enter the password:
goto :EOF

:: function force delete all file created in %temp% folder
:clean
echo off
cls
:: Set the path to the log file to exclude
setlocal
set exclude_file=%temp%\Helpdesk-Tools.log
:: Delete all files in the temp directory except for the exclude file
for /F "delims=" %%f in ('dir /B /A:D "%temp%"') do (
    if /I not "%%f"=="%exclude_file%" (rd /S /Q "%temp%\%%f" >nul 2>&1)
)
for %%f in (%temp%\*.*) do (
if /I not "%%f"=="%exclude_file%" (del /F "%%f" >nul 2>&1)
)
echo All files in %temp% have been deleted except for %exclude_file%.
ping -n 3 localhost 1>nul
endlocal
goto :EOF

:bcuninstaller-Settings
cls
setlocal
if not exist "C:\Program Files\BCUninstaller" (echo App not found) else (
    taskkill /IM BCUninstaller.exe /F >NUL
    set "settings=C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo ^<?xml version="1.0" encoding="utf-8"?^> > "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo ^<Settings^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallerListSortColumn^>0^</UninstallerListSortColumn^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallerListSortOrder^>Ascending^</UninstallerListSortOrder^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscAutoLoadDefaultList^>True^</MiscAutoLoadDefaultList^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FilterShowSystemComponents^>True^</FilterShowSystemComponents^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo      ^<UninstallerListShowLegend^>True^</UninstallerListShowLegend^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<W10-HOME^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo     ^<BackupLeftoversDirectory^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo     ^</BackupLeftoversDirectory^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo     ^<WindowSize^>916, 601^</WindowSize^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo     ^<WindowPosition^>52, 52^</WindowPosition^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo     ^<WindowState^>Normal^</WindowState^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo     ^<_CacheUpdateRate^>10.00:00:00^</_CacheUpdateRate^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^</W10-HOME^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ExternalEnable^>False^</ExternalEnable^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanWinUpdates^>False^</ScanWinUpdates^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo       ^<ExternalPreCommands^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^</ExternalPreCommands^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<AdvancedHighlightSpecial^>True^</AdvancedHighlightSpecial^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallConcurrentMaxCount^>2^</UninstallConcurrentMaxCount^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscFeedbackNagShown^>False^</MiscFeedbackNagShown^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscColorblind^>False^</MiscColorblind^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FilterShowUpdates^>False^</FilterShowUpdates^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallConcurrentOneLoud^>False^</UninstallConcurrentOneLoud^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ShowTreeMap^>True^</ShowTreeMap^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanRegistry^>True^</ScanRegistry^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FoldersScanRemovable^>False^</FoldersScanRemovable^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanChocolatey^>True^</ScanChocolatey^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallConcurrentDisableManualCollisionProtection^>False^</UninstallConcurrentDisableManualCollisionProtection^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ToolbarsShowToolbar^>True^</ToolbarsShowToolbar^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscUserId^>12656455291938626621^</MiscUserId^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<Debug^>False^</Debug^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<WindowUseSystemTheme^>False^</WindowUseSystemTheme^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanSteam^>True^</ScanSteam^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FilterShowWinFeatures^>False^</FilterShowWinFeatures^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanStoreApps^>True^</ScanStoreApps^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<QuietUseDaemon^>True^</QuietUseDaemon^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallerListViewState^>AAEAAAD/////AQAAAAAAAAAMAgAAAEZPYmplY3RMaXN0VmlldywgVmVyc2lvbj0yLjEwLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1udWxsDAMAAABXU3lzdGVtLldpbmRvd3MuRm9ybXMsIFZlcnNpb249Ni4wLjIuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5BQEAAAA2QnJpZ2h0SWRlYXNTb2Z0d2FyZS5PYmplY3RMaXN0VmlldytPYmplY3RMaXN0Vmlld1N0YXRlCQAAAA1WZXJzaW9uTnVtYmVyD051bWJlck9mQ29sdW1ucwtDdXJyZW50VmlldwpTb3J0Q29sdW1uD0lzU2hvd2luZ0dyb3Vwcw1MYXN0U29ydE9yZGVyD0NvbHVtbklzVmlzaWJsZRVDb2x1bW5EaXNwbGF5SW5kaWNpZXMMQ29sdW1uV2lkdGhzAAAEAAAEAwMDCAgZU3lzdGVtLldpbmRvd3MuRm9ybXMuVmlldwMAAAAIAR5TeXN0ZW0uV2luZG93cy5Gb3Jtcy5Tb3J0T3JkZXIDAAAAHFN5c3RlbS5Db2xsZWN0aW9ucy5BcnJheUxpc3QcU3lzdGVtLkNvbGxlY3Rpb25zLkFycmF5TGlzdBxTeXN0ZW0uQ29sbGVjdGlvbnMuQXJyYXlMaXN0AgAAAAEAAAASAAAABfz///8ZU3lzdGVtLldpbmRvd3MuRm9ybXMuVmlldwEAAAAHdmFsdWVfXwAIAwAAAAEAAAAAAAAAAQX7////HlN5c3RlbS5XaW5kb3dzLkZvcm1zLlNvcnRPcmRlcgEAAAAHdmFsdWVfXwAIAwAAAAEAAAAJBgAAAAkHAAAACQgAAAAEBgAAABxTeXN0ZW0uQ29sbGVjdGlvbnMuQXJyYXlMaXN0AwAAAAZfaXRlbXMFX3NpemUIX3ZlcnNpb24FAAAICAkJAAAAEgAAABIAAAABBwAAAAYAAAAJCgAAABIAAAASAAAAAQgAAAAGAAAACQsAAAASAAAAEgAAABAJAAAAIAAAAAgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQgBAQ0OEAoAAAAgAAAACAgAAAAACAgBAAAACAgCAAAACAgDAAAACAgEAAAACAgFAAAACAgGAAAACAgHAAAACAgIAAAACAgJAAAACAgKAAAACAgLAAAACAgMAAAACAgNAAAACAgOAAAACAgPAAAACAgQAAAACAgRAAAADQ4QCwAAACAAAAAICPkAAAAICKAAAAAICFAAAAAICDwAAAAICEYAAAAICEEAAAAICDQAAAAICCgAAAAICKAAAAAICKAAAAAICKAAAAAICKAAAAAICDwAAAAICCgAAAAICCgAAAAICKAAAAAICAQBAAAICKAAAAANDgs=^</UninstallerListViewState^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MessagesShowAllBadJunk^>True^</MessagesShowAllBadJunk^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MessagesRestorePoints^>No^</MessagesRestorePoints^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallerListUseGroups^>True^</UninstallerListUseGroups^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<QuietRetryFailedOnce^>True^</QuietRetryFailedOnce^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscVersion^>5.6.0.0^</MiscVersion^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscFeedbackNagNeverShow^>True^</MiscFeedbackNagNeverShow^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<Language^>en-US^</Language^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscFirstRun^>False^</MiscFirstRun^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FilterHideMicrosoft^>False^</FilterHideMicrosoft^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<AdvancedTestCertificates^>True^</AdvancedTestCertificates^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<CacheCertificates^>True^</CacheCertificates^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscCheckForUpdates^>False^</MiscCheckForUpdates^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<QuietAutomatization^>True^</QuietAutomatization^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<AdvancedDisableProtection^>True^</AdvancedDisableProtection^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallerListUseCheckboxes^>True^</UninstallerListUseCheckboxes^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<WindowDpiAware^>True^</WindowDpiAware^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MessagesAskRemoveLoudItems^>True^</MessagesAskRemoveLoudItems^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanDrives^>True^</ScanDrives^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanWinFeatures^>False^</ScanWinFeatures^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscRatingCacheDate^>07/17/2023 14:46:12^</MiscRatingCacheDate^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscUserRatings^>True^</MiscUserRatings^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ExternalPostCommands^>../BleachBit/bleachbit_console.exe --clean system.tmp system.logs system.memory_dump system.muicache system.prefetch system.recycle_bin^</ExternalPostCommands^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ToolbarsShowSettings^>True^</ToolbarsShowSettings^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<BackupLeftovers^>No^</BackupLeftovers^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallerListDoubleClickAction^>OpenProperties^</UninstallerListDoubleClickAction^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FilterShowTweaks^>True^</FilterShowTweaks^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<AdvancedTestInvalid^>True^</AdvancedTestInvalid^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanPreDefined^>True^</ScanPreDefined^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanScoop^>True^</ScanScoop^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FilterShowStoreApps^>True^</FilterShowStoreApps^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<AdvancedIntelligentUninstallerSorting^>True^</AdvancedIntelligentUninstallerSorting^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<AdvancedSimulate^>False^</AdvancedSimulate^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MessagesRemoveJunk^>Yes^</MessagesRemoveJunk^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FoldersCustomProgramDirs^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^</FoldersCustomProgramDirs^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallPreventShutdown^>True^</UninstallPreventShutdown^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<QuietAutomatizationKillStuck^>True^</QuietAutomatizationKillStuck^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<AdvancedDisplayOrphans^>True^</AdvancedDisplayOrphans^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<QuietAutoKillStuck^>True^</QuietAutoKillStuck^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FoldersAutoDetect^>True^</FoldersAutoDetect^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<MiscSendStatistics^>False^</MiscSendStatistics^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ScanOculus^>True^</ScanOculus^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<CreateRestorePoint^>False^</CreateRestorePoint^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<ToolbarsShowStatusbar^>True^</ToolbarsShowStatusbar^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<FilterShowProtected^>True^</FilterShowProtected^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<UninstallConcurrency^>False^</UninstallConcurrency^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo   ^<CacheAppInfo^>True^</CacheAppInfo^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    echo ^</Settings^> >> "C:\Program Files\BCUninstaller\BCUninstaller.settings"
    "C:\Program Files\BCUninstaller\BCUninstaller.exe"
)
ping -n 2 localhost 1>NUL
endlocal
goto :EOF

:activeIDM
Title Active IDM
cls
if not exist "C:\Program Files (x86)\Internet Download Manager" (
echo IDM is not installed
echo Installing..
ping -n 2 localhost 1>NUL
call :checkCompatibility
call :installSoft Tonec.InternetDownloadManager
) else (
echo IDM is installed, go to activation
)
ping -n 4 localhost 1>NUL
cls
echo This will open an external link from Github call IDM Activation Script
echo Refer link https://github.com/lstprjct/IDM-Activation-Script/tree/main
echo Do with your own risks, be careful!!!
ping -n 4 localhost 1>NUL
start powershell.exe -command iwr -useb https://raw.githubusercontent.com/lstprjct/IDM-Activation-Script/main/IAS.ps1 ^| iex
ping -n 2 localhost 1>NUL
goto :EOF

::Kill all the app running
:killtasks
cls
setlocal
set applist=IObitUnlocker.exe ^
ShareX.exe ^
BCUninstaller.exe ^
advanced_ip_scanner.exe ^
PowerToys.exe ^
FxSound.exe
for %%p in (%applist%) do (taskkill /IM %%p /F >NUL)
endlocal
goto :EOF

:: End of child process functions
:: ========================================================================================================================================
:hold
cls
echo Function in developing
echo Please contact the author for further information via https://github.com/tamld/cmdToolForHelpdesk
ping -n 3 localhost 1>NUL
goto :EOF

:end
call :clean
exit