echo off
Title Script Auto install Software

:: Check for /test or /test:<Label> argument
if /i "%~1:~0,5"=="/test" (
    for /f "tokens=1,2 delims=:" %%a in ("%~1") do (
        if /i "%%a"=="/test" (
            if not "%%b"=="" goto %%b
            goto MainMenu
        )
    )
)

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
:MainMenu
@echo off
set "appversion=v0.6.80 Feb 15, 2025"
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
::echo    [8] Test                                       : Press 8
echo    ========================================================
if /i "%~1"=="/test" goto :EOF
Choice /N /C 1234567 /M " Press your choice :"
::if %ERRORLEVEL% == 8 call :checkCompatibility & goto MainMenu
if %ERRORLEVEL% == 7 call :clean && goto exit
if %ERRORLEVEL% == 6 call :updateCMD & goto MainMenu
if %ERRORLEVEL% == 5 goto packageManagementMenu
if %ERRORLEVEL% == 4 goto utilities
if %ERRORLEVEL% == 3 goto activeLicenses
if %ERRORLEVEL% == 2 goto office-windows
if %ERRORLEVEL% == 1 goto InstallMenu
endlocal
goto end

REM ========================================================================================================================================
REM ==============================================================================
REM Start of installAIOMenu
REM Install Software Online using Winget or Chocolatey
:InstallMenu
setlocal
cls
title Install All In One Online
echo.
echo        ======================================================
echo        [1] Fresh Install without Office             : Press 1
echo        [2] Fresh Install with Office 2024           : Press 2
echo        [3] Fresh Install with Office 2021           : Press 3
echo        [4] Fresh Install with Office 2019           : Press 4
echo        [5] Main Menu                                : Press 5
echo        ======================================================
if /i "%~1"=="/test" goto :EOF
choice /n /c 12345 /M "Press your choice: "

if errorlevel 5 goto MainMenu
if errorlevel 4 goto installAIO-O2019
if errorlevel 3 goto installAIO-O2021
if errorlevel 2 goto installAIO-O2024
if errorlevel 1 goto installAIO-Fresh

echo Invalid selection. Please try again.
pause >nul
endlocal
goto InstallMenu

REM ========================================================================================================================================
REM function install fresh Windows using Winget utilities
:installAio
Title Install All in One 
cls
call :checkCompatibility
call :settingWindows
call :setHighPerformance
call :installEndusers
call :installChatApps
call :installRemoteApps
call :installUnikey
call :createShortcut
call :installSupportAssistant
call :debloat
goto :EOF


:installAIO-Fresh
call :installAio
call :Clean
goto :installAIOMenu

:installAIO-O2019
Title Install All in One with Office 2019
call :installAio
set opt5=(NO)
set opt6=(NO)
set opt7=(NO)
set opt8=(NO)
set opt9=(NO)
set optP=(NO)
set optD=(NO)
set optS=(NO)
set office=2019
set office_type=Volume
call :installOffice
goto :installAIOMenu

:installAIO-O2021
Title Install All in One with Office 2021
call :installAio
set opt5=(NO)
set opt6=(NO)
set opt7=(NO)
set opt8=(NO)
set opt9=(NO)
set optP=(NO)
set optD=(NO)
set optS=(NO)
set office=2021
set office_type=Volume
call :installOffice
goto :installAIOMenu

:installAIO-O2024
Title Install All in One with Office 2024
call :installAio
set opt5=(NO)
set opt6=(NO)
set opt7=(NO)
set opt8=(NO)
set opt9=(NO)
set optP=(NO)
set optD=(NO)
set optS=(NO)
set office=2024
set office_type=Volume
call :installOffice
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
:DisplayOfficeWindowsMenu
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
goto :eof

:office-windows
setlocal
cd /d %dp%
call :DisplayOfficeWindowsMenu
Choice /N /C 1234567 /M " Press your choice : "
if %ERRORLEVEL% == 7 goto :MainMenu
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

:DisplayInstallOfficeMenu
Title Install Office Online
cls
echo.
echo Select Office Version to Install
echo                ================================================================
echo                [1] Office 365                                         : Press 1
echo                [2] Office 2024 (PerpetualVL)                          : Press 2
echo                [3] Office 2021 (PerpetualVL)                          : Press 3
echo                [4] Office 2019 (PerpetualVL)                          : Press 4
echo                [5] Install Manually using Office Deploy Tool          : Press 5
echo                [6] Main Menu                                          : Press 6
echo                ================================================================
goto :eof

:installOfficeMenu
setlocal
call :DisplayInstallOfficeMenu
Choice /N /C 123456 /M " Press your choice : "
if %ERRORLEVEL% == 6 goto :office-windows
if %ERRORLEVEL% == 5 call :downloadOffice & "%temp%\Office Tool\Office Tool Plus.exe" & goto office-windows
if %ERRORLEVEL% == 4 set "office=2019"& set "office_type=Volume"& call :defineOffice& goto :office-windows
if %ERRORLEVEL% == 3 set "office=2021"& set "office_type=Volume"& call :defineOffice& goto :office-windows
if %ERRORLEVEL% == 2 set "office=2024"& set "office_type=Volume"& call :defineOffice& goto :office-windows
if %ERRORLEVEL% == 1 set "office=365"& call :installO365& goto :office-windows
endlocal
REM ============================================
REM Stat of install office  online

:: Downloads the Office Tool Plus runtime and extracts it.
:: Uses aria2c for download if available, otherwise falls back to curl.
:downloadOffice
cls
pushd %temp%

:: Determine system architecture.
set "arch=x64"
if /I "%PROCESSOR_ARCHITECTURE%"=="x86" set "arch=x86"
if /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "arch=x64"
if /I "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "arch=arm64"
echo [*] Detected Architecture: %arch%

:: Construct the download URL.
set "downloadURL=https://otp.landian.vip/redirect/download.php?type=runtime&arch=%arch%&site=github"

:: Download using aria2c if available, otherwise use curl.
where aria2c >nul 2>&1
if %ERRORLEVEL%==0 (
    echo [*] Using aria2c for download...
    aria2c -x 16 -c -V -o Office-Tool.zip "%downloadURL%"
) else (
    echo [*] aria2c not found. Using curl for download...
    curl -fsSL -o Office-Tool.zip "%downloadURL%"
)

cls
call :extractZip "Office-Tool.zip" "%temp%"  :: Use :extractZip
popd
goto :EOF

:: REF code http://zone94.com/downloads/135-windows-and-office-activation-script
:: Function defines a list of variable representing for Office apps
:defineOffice
cls
@echo off
cd /d "%dp%"
:: set app id
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
Set "optS=%on%" ::Skype
goto :selectOfficeApp
     
:: Function menu select app to install. Default is yes with Yes colored green.
:selectOfficeApp
cls
@echo off
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
<NUL Set/P=[S] & (if "%optS%"=="%on%" (Call :setColor "%optS%" 0a) Else (<NUL Set/P="%optS%")) & echo  Microsoft Skype.
<NUL Set/P=[Q] & echo Quit to Office Menu
echo.
CHOICE /c 123456789PDSXQ /n /m "--> Select option(s) and then press [X] to start the installation: "
if %ERRORLEVEL% == 14 goto :installOfficeMenu
if %ERRORLEVEL% == 13 goto :installOffice
if %ERRORLEVEL% == 12 (if "%optS%"=="%off%" (Set "optS=%on%") Else (Set "optS=%off%")) & goto :selectOfficeApp
if %ERRORLEVEL% == 11 (if "%optD%"=="%off%" (Set "optD=%on%") Else (Set "optD=%off%")) & goto :selectOfficeApp
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

::
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

:: New function install office using OT
:installOffice
::https://github.com/YerongAI/Office-Tool
Title Install Office by Office-Tool
@echo off
pushd %temp%
call :downloadOffice
SETLOCAL
:: define channel
set "channel=Current"
if %office% == 2019 (set "channel=PerpetualVL2019")
if %office% == 2021 (set "channel=PerpetualVL2021")
if %office% == 2024 (set "channel=PerpetualVL2024")
:: set version Architecture 
IF "%Processor_Architecture%"=="AMD64" Set "CPU=64"
IF "%Processor_Architecture%"=="x86" Set "CPU=32"

:: define exclude apps list
Set "exclapps="
if "%opt1%"=="(NO)" (if not defined exclapps (Set "exclapps=Word") else (Set "exclapps=%exclapps%,Word"))
if "%opt2%"=="(NO)" (if not defined exclapps (Set "exclapps=Excel") else (Set "exclapps=%exclapps%,Excel"))
if "%opt3%"=="(NO)" (if not defined exclapps (Set "exclapps=PowerPoint") else (Set "exclapps=%exclapps%,PowerPoint"))
if "%opt4%"=="(NO)" (if not defined exclapps (Set "exclapps=Outlook") else (Set "exclapps=%exclapps%,Outlook"))
if "%opt5%"=="(NO)" (if not defined exclapps (Set "exclapps=OneNote") else (Set "exclapps=%exclapps%,OneNote"))
if "%opt6%"=="(NO)" (if not defined exclapps (Set "exclapps=Publisher") else (Set "exclapps=%exclapps%,Publisher"))
if "%opt7%"=="(NO)" (if not defined exclapps (Set "exclapps=Access") else (Set "exclapps=%exclapps%,Access"))
if "%opt8%"=="(NO)" (if not defined exclapps (Set "exclapps=Visio") else (Set "exclapps=%exclapps%,Visio"))
if "%opt9%"=="(NO)" (if not defined exclapps (Set "exclapps=Project") else (Set "exclapps=%exclapps%,Project"))
if "%optP%"=="(NO)" (if not defined exclapps (Set "exclapps=ProofingTools") else (Set "exclapps=%exclapps%,ProofingTools"))
if "%optD%"=="(NO)" (if not defined exclapps (Set "exclapps=OneDrive,Groove") else (Set "exclapps=%exclapps%,OneDrive,Groove"))
if "%optS%"=="(NO)" (if not defined exclapps (Set "exclapps=Skype,Lync") else (Set "exclapps=%exclapps%,Skype,Lync"))
cls
::"Office Tool\Office Tool Plus.Console.exe" deploy /add ProPlus%office%%office_type%_en-us /ProPlus%office%%office_type%.exclapps %exclapps% /edition %CPU% /acpteula
"Office Tool\Office Tool Plus.Console.exe" deploy /add ProPlus%office%%office_type%_en-us /ProPlus%office%%office_type%.exclapps %exclapps% /edition %CPU% /channel %channel% /acpteula
ENDLOCAL
popd
goto :EOF

:: Function thats help install Office 365
:: Installs Office 365 using the Office Deployment Tool.
:installO365
cls
call :checkCompatibility  :: Ensure 7-Zip is available
pushd %temp%
:: Fix URL download Office Deployment Tools
rem curl -o "officedeploymenttool.exe" -fsSL https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16501-20196.exe
curl -O -fsSL https://github.com/tamld/cmdToolForHelpdesk/raw/main/officedeploymenttool.exe
call :extractZip "officedeploymenttool.exe" "%temp%"
IF "%Processor_Architecture%"=="AMD64" Set "CPU=x64"
IF "%Processor_Architecture%"=="x86" Set "CPU=x32"
cls
echo Installing Microsoft Office 365 %CPU%-bit
echo Don't close this window until the installation process is completed
ping -n 2 localhost 1>NUL
START "" /WAIT /B "setup.exe" /configure configuration-Office365-%CPU%.xml
popd
cd %dp%
goto :EOF

REM ============================================
:: Function defines which Office (x64/x86) is installed
:getOfficePath
cls
echo off
for %%a in (4,5,6) do (if exist "%ProgramFiles%\Microsoft Office\Office1%%a\ospp.vbs" (cd /d "%ProgramFiles%\Microsoft Office\Office1%%a"&& set officePath=%cd%)
if exist "%ProgramFiles(x86)%\Microsoft Office\Office1%%a\ospp.vbs" (cd /d "%ProgramFiles(x86)%\Microsoft Office\Office1%%a"&& set officePath=%cd%))
goto :eof

:: Function Menu that selects which edition Windows will convert to
:DisplayLoadSkusMenu
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
goto :eof

:loadSkusMenu
setlocal
call :DisplayLoadSkusMenu
Choice /N /C 123456789 /M " Press your choice : "
if %ERRORLEVEL% == 1 set keyW=VK7JG-NPHTM-C97JM-9MPGT-3V66T&& set typeW=Professional&& goto :loadSKUS
if %ERRORLEVEL% == 2 set keyW=DXG7C-N36C4-C4HTG-X4T3X-2YV77&& set typeW=ProfessionalWorkstation&& goto :loadSKUS
if %ERRORLEVEL% == 3 set keyW=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C&& set typeW=Enterprise&& goto :loadSKUS
if %ERRORLEVEL% == 4 set keyW=NK96Y-D9CD8-W44CQ-R8YTK-DYJWX&& set typeW=EnterpriseS&& goto :loadSKUS
if %ERRORLEVEL% == 5 set keyW=M7XTQ-FN8P6-TTKYV-9D4CC-J462D&& set typeW=IoTEnterprise&& goto :loadSKUS
if %ERRORLEVEL% == 6 set keyW=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY&& set typeW=Education&& goto :loadSKUS
if %ERRORLEVEL% == 7 set keyW=RW7WN-FMT44-KRGBK-G44WK-QV7YK&& set typeW=wdLTSB2016&& goto :loadSKUS
if %ERRORLEVEL% == 8 set keyW=M7XTQ-FN8P6-TTKYV-9D4CC-J462D&& set typeW=wdLTSC2019&& goto :loadSKUS
if %ERRORLEVEL% == 9 goto :office-windows
endlocal

:: Loads a specified Windows SKU (edition) using downloaded license files.
:loadSKUS
setlocal
cls
echo off
pushd %temp%
echo.
echo Generic Windows %typeW% key: %keyW%
echo Activating...
if not exist Licenses (
    ::curl -L -o Licenses.zip https://github.com/tamld/cmdToolForHelpdesk/blob/main/Licenses.zip?raw=true >nul 2>&1
	curl -L -o Licenses.zip https://github.com/tamld/cmdToolForHelpdesk/blob/main/packages/Licenses.zip?raw=true >nul 2>&1
    call :extractZip "Licenses.zip" "%temp%"  :: Use :extractZip
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
:DisplayRemoveOfficeKeyMenu
cls
Title Remove Office Key
echo.
echo How would you like to remove the office key?
echo            =================================================
echo            [1] One by one                          : Press 1
echo            [2] All                                 : Press 2
echo            [3] Back to Windows Office Menu         : Press 3
echo            =================================================
goto :eof

:removeOfficeKey
call :DisplayRemoveOfficeKeyMenu
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
call :DisplayUninstallOfficeMenu
Choice /N /C 1234 /M " Press your choice : "
if %ERRORLEVEL% == 4 goto :office-windows
if %ERRORLEVEL% == 3 goto :removeOffice-BCUninstaller
if %ERRORLEVEL% == 2 goto :removeOffice-OfficeTool
if %ERRORLEVEL% == 1 goto :removeOffice-saraCmd

:DisplayUninstallOfficeMenu
cls
Title Uninstall Office all versions
echo.
echo            ====================================================
echo            [1] Using SaraCMD (silent)                 : Press 1
echo            [2] Using Office Tool Plus                 : Press 2
echo            [3] Using BCUninstaller                    : Press 3
echo            [4] Back to Windows Office Menu            : Press 4
echo            ====================================================
goto :eof

:removeOffice-BCUninstaller
cls
Title Uninstall Office Using BulkCrapUninstaller
echo This will install BCUninstaller into your computer
call :checkCompatibility
call :installSoft_ByWinget Klocman.BulkCrapUninstaller
call :bcuninstaller-Settings
goto :office-windows

:removeOffice-OfficeTool
Title Uninstall Office Using Office Tool
cls
pushd %temp%
call :downloadOffice
cls
echo This script will uninstall your Office installation using the Office Tool. 
echo Please wait until the wizard has completed the uninstallation process
ping -n 3 localhost > nul
"Office Tool\Office Tool Plus.Console.exe" deploy /rmall /acpteula
goto :office-windows

:removeOffice-saraUI
Title Uninstall Office Using Office Tool
cls
Title Uninstall Office Using Sara UI
echo This will download (browser download) and install Sara UI for uninstalling Office steps
echo You must install it manually and follow the wizard guide 
ping -n 4 localhost 1>NUL
start https://aka.ms/SaRA-officeUninstallFromPC
goto :office-windows

:: Uninstalls Office completely using the SaRA command-line tool.
:removeOffice-saraCmd
Title Uninstall office completely using Sara Cmd
cls
echo This will download and remove office without interactive
ping -n 2 localhost 1>NUL
cls
echo off
pushd %temp%
curl -# -o SaRACmd.zip -fsL https://aka.ms/SaRA_CommandLineVersionFiles
call :extractZip "SaRACmd.zip" "SaRACmd"  :: Use :extractZip
cls
echo Start to uninstall office via SaRACmd
echo It could took a while, please wait to end
ping -n 2 localhost 1>NUL
cls
SaRACmd\SaRAcmd.exe -S OfficeScrubScenario -AcceptEula
popd
cd /d %dp%
cls
goto :office-windows

REM End of Remove Office Keys
REM ============================================
REM End of Windows Office Utilities functions
REM ========================================================================================================================================
:DisplayActiveLicensesMenu
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
goto :eof

:activeLicenses
REM Start of Active Licenses Menu
setlocal
Title Active Licenses Menu
cls
call :DisplayActiveLicensesMenu
Choice /N /C 1234567 /M " Press your choice : "
if %ERRORLEVEL% == 7 goto :MainMenu
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
start powershell.exe -command "irm https://get.activated.win | iex"
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
:DisplayBackupLicensesMenu
Title Backup License Windows ^& Office
echo.
echo            =================================================
echo            [1] BACKUP To Local                     : Press 1
echo            [2] BACKUP To NAS STORAGE               : Press 2
echo            [3] Back to Main Menu                   : Press 3
echo            =================================================
goto :eof

:backupLicenses
cls
call :DisplayBackupLicensesMenu
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
:DisplayUtilitiesMenu
echo.
echo        =================================================
echo        [1] Set High Performance                : Press 1
echo        [2] Change hostname                     : Press 2
echo        [3] Clean up system                     : Press 3
echo        [4] ChrisTitusTech/winutil              : Press 4
echo        [5] Install Support Assistance          : Press 5
echo        [6] Active IDM                          : Press 6
echo        [7] Windows Debloat                     : Press 7
echo        [8] Back to Main Menu                   : Press 8
echo        =================================================
goto :eof

:utilities
setlocal
REM Start of Utilities Menu
cls
title Utilities Main Menu
call :DisplayUtilitiesMenu
Choice /N /C 12345678 /M " Press your choice : "
if %ERRORLEVEL% == 8 goto :MainMenu
if %ERRORLEVEL% == 7 goto :debloat & goto :utilities
if %ERRORLEVEL% == 6 call :activeIDM & goto :utilities
if %ERRORLEVEL% == 5 goto :installSupportAssistant
if %ERRORLEVEL% == 4 call :winutil & goto :utilities
if %ERRORLEVEL% == 3 goto :cleanUpSystem & goto :utilities
if %ERRORLEVEL% == 2 goto :changeHostName & goto :utilities
if %ERRORLEVEL% == 1 goto :setHighPerformance & goto :utilities
endlocal
REM End of Utilities Menu
REM ==============================================================================
REM Start of Utilities functions
:winutil  
:: call https://github.com/ChrisTitusTech/winutil Powershell
start powershell -command "irm "https://christitus.com/win" | iex"
goto :EOF


:debloat
TITLE Windows Debloat
echo Remove Unused Packages, Bloatwares
echo Winget uninstall debloat packages
call :winget_debloat
cls
echo Powershell uninstall packages
call :windows_debloat
cls
echo Disabled the unnecessary services
call :disable_os_services
goto :EOF	

:getUserInformation
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

ping -n 2 localhost 1>NUL
cls
) else if /i "%setpass%" == "N" (
net user %user% "" /add 2>nul

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

echo User %user% was added to administrators group.
ping -n 2 localhost 1>NUL
cls
) else (

echo Failed to add user %user% to administrators group.
)
cls
goto :utilities

:addUserToUsers
REM This function adds the user to the Users group.
Title Add User to Users Group
call :GetUserInformation

echo User %user% was added to users group.
ping -n 2 localhost 1>NUL
cls
goto :utilities

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


:joinDomain
cls
setlocal
REM input Fully Qualified Domain Name
set /p server=Enter the Domain Name: 

REM check if host can reach the AD with FQDN
ping %server%
REM ping -n 4 %server% 1>NUL
if %errorlevel% neq 0 (
echo Cannot reach server. Exiting...

ping -n 5 localhost 1>NUL
) else (
echo %server% is pingable. Proceeding with upgrade...

ping -n 5 localhost 1>NUL
cls
echo Please enter FQDN username instead of username only (domain\username instead of username)
call :inputCredential
echo Joining domain...
wmic computersystem where name="%computername%" call joindomainorworkgroup name=%server% username=%username% password=%password%
if %errorlevel% neq 0 (
cls
echo Failed to join domain. Error code: %errorlevel%

ping -n 5 localhost 1>NUL
) else (
cls
echo Successfully joined domain.

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
echo Hide Search Menu Bar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f >nul
:: Turn off News and Interests
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f >nul
:: Use Small Taskbar Buttons
::reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 1 /f >nul
:: Replace Command Prompt with PowerShell in the Menu
::reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontUsePowerShellOnWinX" /t REG_DWORD /d 0 /f >nul
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
:: Enable Photoviewer
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open" /ve /t REG_SZ /d "@photoviewer.dll,-3043" /f > nul 2>&1
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "\"%SystemRoot%\System32\rundll32.exe\" \"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %1" /f > nul 2>&1
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\DropTarget" /ve /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul 2>&1 
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print" /ve /t REG_SZ /d "Print with Windows Photo Viewer" /f > nul 2>&1
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "\"%SystemRoot%\System32\rundll32.exe\" \"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_PrintTo %1" /f > nul 2>&1
reg add "HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\DropTarget" /ve /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f > nul 2>&1
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



:createShortcut
cls
@echo off
COPY /Y "%startProgram%\*.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\BCUninstaller\BCUninstaller.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\Foxit PDF Reader\Foxit PDF Reader.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\Slack Technologies Inc\*.lnk" "%AllUsersProfile%\Desktop"
COPY /Y "%startProgram%\UltraViewer\*.lnk" "%AllUsersProfile%\Desktop"
goto :eof

:DisplayPackageManagerMenu
echo.
echo        ====================================================
echo        [1] Install Package Management             : Press 1
echo        [2] Install End Users Applications         : Press 2
echo        [3] Install Remote Applications            : Press 3
echo        [4] Install Network Applications           : Press 4
echo        [5] Install Chat Applications              : Press 5
echo        [6] Upgrade All Software Online            : Press 6
echo        [7] Main Menu                              : Press 7
echo        ====================================================
goto :eof

:packageManagementMenu
cls
title Package Management Software Main Menu

:: Define menu mapping
set "pkg_menu[1]=packageManagement"
set "pkg_menu[2]=installEndusers"
set "pkg_menu[3]=installRemoteApps"
set "pkg_menu[4]=installNetworkApps"
set "pkg_menu[5]=installChatApps"
set "pkg_menu[6]=update-All"
set "pkg_menu[7]=MainMenu"

:: Display menu
call :DisplayPackageManagerMenu
choice /n /c 1234567 /m "Press your choice (1-7):"

set "USER_CHOICE=%errorlevel%"
call :dispatch_menu pkg_menu USER_CHOICE
goto :packageManagementMenu


:update-All
Title Update Softwares
call :checkCompatibility
cls
echo Update Winget packages
echo y | winget upgrade -h --all
ping -n 2 localhost > nul
cls
echo Update Chocolatey packages
choco upgrade all -y
call :killtasks
echo Task done!
ping -n 2 localhost > nul
goto :EOF

:winget-Deskjob
cls
call :hold
goto :EOF

:installEndusers
cls
Title Install End User Softwares
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install End Users Applications...
    call :winget-Endusers
) else (
    echo [*] Winget not found. Switching to Chocolatey...
    call :choco-Endusers
)
goto :EOF

:installRemoteApps
cls
Title Install Remote Apps
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install Remote Applications...
    call :winget-RemoteSupport
) else (
    echo [*] Winget not found. Switching to Chocolatey for Remote Applications...
    call :choco-RemoteSupport
)
goto :EOF

:installNetworkApps
cls
Title Install Network Apps
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install Network Applications...
    call :winget-Network
) else (
    echo [*] Winget not found. Switching to Chocolatey for Network Applications...
    call :choco-Network
)
goto :EOF

:installChatApps
cls
Title Install Chat Apps
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install Chat Applications...
    call :winget-Chat
) else (
    echo [*] Winget not found. Switching to Chocolatey for Chat Applications...
    call :choco-Chat
)
goto :EOF

:choco-Network
cls
Title Install Network softwares by Chocolatey
call :checkCompatibility
setlocal
cls
echo List softwares to install
echo ========================================================
echo OpenSSH, rclone, rclone-browser, mobaxterm, VirtualBox
echo Advanced IP Scanner, JDownloader, VSCode, Notepad++
echo SSHFS, WinFSP, WinSCP, Putty, Network Manager, Dotnet 6
echo ========================================================
ping -n 3 localhost 1>NUL
cls
set packageList=notepadplusplus ^
7zip ^
openssh ^
rclone ^
rclonebrowser ^
advanced-ipscanner ^
jdownloader ^
visualstudiocode ^
sshfs ^
winscp ^
putty ^
vcredist2010 ^
vcredist2012 ^
vcredist2013 ^
vcredist2015 ^
vcredist2017 ^
networkmanager ^
virtualbox ^
VBoxGuestAdditions.install ^
virtualbox-guest-additions-guest.install ^
"Mobatek.MobaXterm --version 23.5.5182"


for %%p in (%packageList%) do (
	cls
	echo Installing %%p
	choco install -y %%p
)
call :killtasks
endlocal
goto :EOF

:winget-Network
Title Install Network softwares by Winget
setlocal

cls
echo List softwares to install
echo ========================================================
echo OpenSSH, rclone, rclone-browser, mobaxterm, VirtualBox
echo Advanced IP Scanner, JDownloader, VSCode, Notepad++
echo SSHFS, WinFSP, WinSCP, Putty, Network Manager, Dotnet 6
echo ========================================================
call :checkCompatibility
ping -n 2 localhost 1>NUL
cls
set packageList=Notepad++.Notepad++ ^
7zip.7zip ^
Microsoft.OpenSSH.Beta ^
Rclone.Rclone ^
kapitainsky.RcloneBrowser ^
Famatech.AdvancedIPScanner ^
Microsoft.VisualStudioCode ^
WinFsp.WinFsp ^
SSHFS-Win.SSHFS-Win ^
WinSCP.WinSCP ^
PuTTY.PuTTY ^
Microsoft.VCRedist.2015+.x64 ^
Microsoft.DotNet.Runtime.6 ^
Microsoft.DotNet.SDK.6 ^
NETworkManager ^
Oracle.VirtualBox ^
xpipe-io.xpipe ^
LocalSend.LocalSend 

:: for %%p in (%packageList%) do (call :installSoft_ByWinget %%p --accept-package-agreements --accept-source-agreements)
for %%p in (%packageList%) do (call :installSoft_ByWinget %%p)
:: Copy Mobaxterm setting
if not exist "C:\Program Files (x86)\Mobatek\MobaXterm" (echo Mobaxterm is not installed) else (
curl -L -o "c:\Program Files (x86)\Mobatek\MobaXterm\Custom.mxtpro" "https://drive.google.com/uc?export=download&id=1cO4GAkbdvbOKju9QVH0OXjN48_gS0D82"
echo Mobaxterm setting complete
)
call :killtasks

endlocal
goto :EOF

:choco-Chat
Title Install Chat softwares by Chocolatey
call :checkCompatibility
setlocal
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
echo Install List Software by Chocolatey
set packageList= zalopc ^
telegram ^
viber ^
messenger ^
skype ^
zoom
for %%p in (%packageList%) do (choco install -y %%p)
endlocal
goto :EOF

:winget-Chat
Title Install Chat softwares by Winget
call :checkCompatibility
setlocal

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
for %%p in (%packageList%) do (call :installSoft_ByWinget %%p --accept-package-agreements --accept-source-agreements)
endlocal
call :killtasks
goto :EOF

:winget-RemoteSupport
cls
call :checkCompatibility
call :installSoft_ByWinget TeamViewer.TeamViewer
call :installSoft_ByWinget DucFabulous.UltraViewer
call :killtasks
goto :EOF

:choco-RemoteSupport
cls
Title Install Remote Support Software by Chocolatey
echo off
call :checkCompatibility
choco install -y teamviewer ultraviewer anydesk.install
REM choco install -y ultraviewer --ignore-checksums
goto :EOF

:choco-Endusers
cls
Title Install Enduser Software by Chocolatey
echo off
call :checkCompatibility
cls
:: Set the list of packages to install
SETLOCAL
set packageList=notepadplusplus^
dotnet-runtime-6 ^
zalo ^
sharex ^
everything ^
iobit-unlocker ^
7zip ^
foxitreader ^
googlechrome ^
firefox ^
fxsound ^
vlc
::choco install -y notepadplusplus googledrivesync dotnet-runtime-6 zalo sharex everything quicklook iobit-unlocker messenger-for-desktop telegram-desktop skype 7zip foxitreader googlechrome firefox bulkcra???installer powertoys fxsound vlc
for %%p in (%packageList%) do (choco install -y %%p > nul)
call :bcuninstaller-Settings
call :installUnikey
call :killtasks
cls
ENDLOCAL
goto :EOF

:winget-Endusers
Title Install Enduser Software by Winget
echo off
call :checkCompatibility
setlocal
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
Microsoft.DotNet.Runtime.6 ^
ShareX.ShareX ^
voidtools.Everything ^
Microsoft.WindowsTerminal ^
7zip.7zip ^
Foxit.FoxitReader ^
Google.Chrome ^
Mozilla.Firefox ^
VideoLAN.VLC ^
PrestonN.FreeTube ^
CrystalRich.LockHunter ^
PDFgear.PDFgear ^
FxSound.FxSound ^
CodeSector.TeraCopy ^
Microsoft.VisualStudioCode ^
Starship.Starship ^
chrisant996.Clink ^
th-ch.YouTubeMusic ^
hluk.CopyQ ^
LocalSend.LocalSend ^
HiBitSoftware.HiBitUninstaller

for %%p in (%packageList%) do (call :installSoft_ByWinget %%p -h --accept-package-agreements --accept-source-agreements --ignore-security-hash --force)
endlocal
::call :bcuninstaller-Settings
call :killtasks
cls
goto :EOF

:packageManagement
pushd %temp%
cls

:: ============================================================
:: Install Chocolatey
:: ============================================================
echo [*] Checking if Chocolatey is installed...

if exist "C:\ProgramData\chocolatey\bin\choco.exe" (
    echo [*] Chocolatey is already installed. Skipping installation.

) else (
    echo [*] Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    if exist "C:\ProgramData\chocolatey\bin\choco.exe" (
        echo [*] Chocolatey installation completed successfully.

        set "PATH=%PATH%;C:\ProgramData\chocolatey\bin"
    ) else (
        echo [Warning] Chocolatey installation failed.

        exit /B 1
    )
)
ping -n 2 localhost 1>NUL
echo [*] Installing aria2c, jq, yq, 7zip...

choco install -y aria2 7zip jq yq
assoc .7z=7-Zip
assoc .zip=7-Zip
assoc .rar=7-Zip
assoc .tar=7-Zip
assoc .gz=7-Zip
assoc .bzip2=7-Zip
assoc .xz=7-Zip
ping -n 2 localhost 1>NUL
echo.
:: ============================================================
:: Install Winget (Dependencies & Core) from GitHub using aria2c
:: ============================================================
echo [*] Fetching latest Winget release information from GitHub...

set "GITHUB_API_URL=https://api.github.com/repos/microsoft/winget-cli/releases/latest"

:: Retrieve the MSIXBUNDLE file URL
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command " (Invoke-RestMethod -Uri '%GITHUB_API_URL%' -Headers @{ 'User-Agent'='winget-installer' }).assets | Where-Object { $_.name -like 'Microsoft.DesktopAppInstaller_*.msixbundle' } | Select-Object -First 1 -ExpandProperty browser_download_url"`) do (
    set "MSIXBUNDLE_URL=%%i"
)

:: Retrieve the DesktopAppInstaller_Dependencies.zip file URL
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command " (Invoke-RestMethod -Uri '%GITHUB_API_URL%' -Headers @{ 'User-Agent'='winget-installer' }).assets | Where-Object { $_.name -eq 'DesktopAppInstaller_Dependencies.zip' } | Select-Object -First 1 -ExpandProperty browser_download_url"`) do (
    set "DEP_ZIP_URL=%%i"
)

echo.
echo [*] Detected Assets:
echo     Dependencies ZIP: %DEP_ZIP_URL%
echo     Main Package: %MSIXBUNDLE_URL%
echo.


:: Define local filenames & folders in %temp%
set "MSIXBUNDLE_FILE=%temp%\Microsoft.DesktopAppInstaller.msixbundle"
set "DEP_ZIP_FILE=%temp%\DesktopAppInstaller_Dependencies.zip"
set "DEP_FOLDER=%temp%\DesktopAppInstaller_Dependencies"

:: Download files using aria2c
echo [*] Downloading Winget package with aria2c...

aria2c -x 16 -c -d "%temp%" -o "Microsoft.DesktopAppInstaller.msixbundle" "%MSIXBUNDLE_URL%"

echo [*] Downloading dependencies ZIP file with aria2c...

aria2c -x 16 -c -d "%temp%" -o "DesktopAppInstaller_Dependencies.zip" "%DEP_ZIP_URL%"

:: Extract the dependencies ZIP file
echo [*] Extracting dependencies...

powershell -NoProfile -Command "Expand-Archive -Path '%DEP_ZIP_FILE%' -DestinationPath '%DEP_FOLDER%' -Force"

:: Determine system architecture
set "arch=x64"
if /I "%PROCESSOR_ARCHITECTURE%"=="x86" set "arch=x86"
if /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "arch=x64"
if /I "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "arch=arm64"
echo [*] Detected Architecture: %arch%


:: Install dependency packages (.appx files)
echo [*] Installing dependency packages...
for /r "%DEP_FOLDER%\%arch%" %%f in (*.appx) do (
    echo  Installing: %%f
    powershell -NoProfile -Command "Add-AppxPackage -Path '%%~f'"
)

:: Install the main Winget package
echo [*] Installing Winget package...
powershell -NoProfile -Command "Add-AppxPackage -Path '%MSIXBUNDLE_FILE%'"

:: Cleanup downloaded files & folders from %temp%
echo [*] Cleaning up Winget installer files...
if exist "%MSIXBUNDLE_FILE%" del /f /q "%MSIXBUNDLE_FILE%"
if exist "%DEP_ZIP_FILE%" del /f /q "%DEP_ZIP_FILE%"
if exist "%DEP_FOLDER%" rd /s /q "%DEP_FOLDER%"


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

:: Checks for required tools (Chocolatey, 7-Zip, Winget) and installs them if missing.
:checkCompatibility
@echo off
cls

REM --- Check Chocolatey ---
choco -v >nul 2>&1 || call :packageManagement
for /f "delims=" %%p in ('powershell -NoProfile -Command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/chocolatey/choco/releases/latest').tag_name"') do set "choco_latest_release=%%p"
for /f "delims=" %%p in ('choco -v') do set "choco_current_version=%%p"
if not "%choco_current_version%"=="%choco_latest_release%" (
    call :packageManagement
) else (
    echo [*] Chocolatey is up-to-date: %choco_current_version%
)

REM --- Check Winget ---
for /f "tokens=4 delims=[]" %%i in ('ver') do set "VERSION=%%i"
if not "%VERSION%" GEQ "10.0.19041" exit /b 0
winget -v >nul 2>&1 || call :packageManagement
for /f "delims=" %%a in ('powershell -NoProfile -Command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/microsoft/winget-cli/releases/latest').tag_name"') do set "winget_latest_release=%%a"
for /f "delims=" %%b in ('winget -v') do set "winget_current_version=%%b"
if not "%winget_current_version%"=="%winget_latest_release%" (
    call :packageManagement
) else (
    echo [*] Winget is up-to-date: %winget_current_version%
)
ping -n 2 localhost 1>NUL
exit /b 0

:installSoft_ByWinget
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

cls
) else (echo y | winget install %software% %scope%

cls
)
) else (
cls 
echo %software% already installed
ping -n 2 localhost 1>nul

cls
)
goto :EOF

:installSoft_ByChoco
Title Install Software by Chocolatey
REM Set the software name to install
set "software=%~1"
REM Set status software installed or not
set "installed=0"

REM check if %software has been installed before
choco list --local-only %software% > nul
if "%errorlevel%" == "0" (set "installed=1")
if "%installed%"=="0" (
choco install %software% -y

cls
) else (
cls
echo %software% already installed
ping -n 2 localhost 1>nul

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

:: Downloads and installs UniKey (Vietnamese keyboard input).
:installUnikey
cls
pushd %temp%
curl -# -o unikey43RC5-200929-win64.zip -L https://www.unikey.org/assets/release/unikey46RC2-230919-win64.zip
call :extractZip "unikey43RC5-200929-win64.zip" "C:\Program Files\Unikey"  :: Use :extractZip
echo "Copying Unikey to Startup"
mklink "%startProgram%\StartUp\UniKeyNT.lnk" "c:\Program Files\Unikey\UniKeyNT.exe"
echo "Creating Unikey shortcut on desktop"
mklink "%public%\Desktop\UnikeyNT.exe" "C:\Program Files\Unikey\UniKeyNT.exe"
popd
goto :EOF

:: Function install 7zip by using winget
:install7zip
cls
Title Install 7zip using Winget
call :checkCompatibility
choco install -y 7zip.install > nul
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
setlocal
:: Delete all files in the temp directory except for the exclude file
for /F "delims=" %%f in ('dir /B /A:D "%temp%"') do (
    if /I not "%%f"=="%exclude_file%" (rd /S /Q "%temp%\%%f" >nul 2>&1)
)
for %%f in (%temp%\*.*) do (
if /I not "%%f"=="%exclude_file%" (del /F "%%f" >nul 2>&1)
)
echo All files in %temp% have been deleted.
ping -n 3 localhost 1>nul
endlocal
goto :EOF

:activeIDM
cls
pushd %temp%
dir /b "C:\Program Files (x86)\Internet Download Manager" > nul 2>&1 || (
	call :checkCompatibility
	choco install -y internet-download-manager > nul 2>&1
)
powershell -Command "iex(irm is.gd/idm_reset)"
popd
call :clean
goto :EOF

:: Kill all non-essential applications gracefully
:killtasks
cls
setlocal EnableDelayedExpansion

echo [*] Terminating running application processes...

:: List of process names (space-separated)
set "appList=notepad++.exe chrome.exe firefox.exe FoxitPDFReader.exe vlc.exe ShareX.exe Everything.exe IObitUnlocker.exe FxSound.exe Telegram.exe Skype.exe Zoom.exe Viber.exe Messenger.exe MobaXterm.exe WinSCP.exe putty.exe VirtualBox.exe rclone.exe RcloneBrowser.exe Advanced_IP_Scanner.exe JDownloader2.exe Code.exe sshfs-win.exe NetworkManager.exe TeamViewer.exe UltraViewer_Desktop.exe AnyDesk.exe UnikeyNT.exe xpipe.exe LocalSend.exe TeraCopy.exe WindowsTerminal.exe LockHunter.exe PDFgear.exe CopyQ.exe HiBitUninstaller.exe Zalo.exe FreeTube.exe VirtualBox-7.1.6-167084-W.exe TeamViewer_Service.exe UltraViewer_Service.exe TeraCopyService.exe msedge.exe "YouTube Music.exe" "PDFLauncher.exe""

:: List of essential processes to exclude
set "excludeList=explorer.exe svchost.exe taskmgr.exe cmd.exe conhost.exe winlogon.exe csrss.exe lsass.exe services.exe wininit.exe smss.exe"

for %%a in (%appList%) do (
    set "proc=%%~a"
    echo [*] Checking process: !proc!...

    echo !excludeList! | find /i "!proc!" >nul
    if !errorlevel! equ 0 (
        echo [!] Skipping essential process: !proc!
    ) else (
        tasklist /fi "imagename eq !proc!" | find /i "!proc!" >nul
        if !errorlevel! equ 0 (
            echo [*] Attempting to terminate: !proc!
            taskkill /F /IM "!proc!" >nul 2>&1
            if !errorlevel! equ 0 (
                echo [+] Terminated: !proc!
            ) else (
                echo [!] Failed to terminate: !proc!
            )
        ) else (
            echo [-] Process not found or not running: !proc!
        )
    )
)

endlocal
echo [*] Task killing process completed.
ping -n 2 localhost >nul
goto :EOF

:: End of child process functions
:: ========================================================================================================================================
:hold
cls
echo This function is not fully implemented yet.
echo Please open a request or contact the developer to expedite the development of this feature.
echo For more information, visit: https://github.com/tamld/cmdToolForHelpdesk
ping -n 3 localhost >NUL
goto :EOF

:end
call :clean
goto :EOF



:extractZip
:: Usage: call :extractZip "path\to\zipfile.zip" "destination\folder"
if "%~1"=="" (
    echo [ERROR] No ZIP file specified.
    exit /B 1
)
if "%~2"=="" (
    echo [ERROR] No destination folder specified.
    exit /B 1
)
if not exist "%~1" (
    echo [ERROR] ZIP file "%~1" not found.
    exit /B 1
)
if not exist "%~2" (
    echo [*] Destination folder "%~2" not found. Creating...
    mkdir "%~2"
)

echo [*] Extracting "%~1" to "%~2" using PowerShell...
powershell -NoProfile -Command "try { Expand-Archive -Path '%~1' -DestinationPath '%~2' -Force } catch { Write-Error $_; exit 1 }"
if errorlevel 1 (
    echo [ERROR] Extraction failed.
    exit /B 1
)
echo [*] Extraction completed successfully.
goto :EOF

:downloadFile
:: Function to download files using aria2c, curl, or PowerShell
:: Usage: call :downloadFile "URL" "OUTPUT_PATH"

setlocal
set "downloadUrl=%~1"
set "outputFile=%~2"

:: Check if aria2c is available
where aria2c >nul 2>&1
if %errorlevel%==0 (
    aria2c -x 16 -s 16 -j 5 -o "%outputFile%" "%downloadUrl%" && endlocal & exit /b 0
)

:: Check if curl is available
where curl >nul 2>&1
if %errorlevel%==0 (
    curl -L -o "%outputFile%" "%downloadUrl%" && endlocal & exit /b 0
)

:: Use PowerShell as a last resort
powershell -Command "& {
    try {
        Invoke-WebRequest -Uri '%downloadUrl%' -OutFile '%outputFile%'
    } catch {
        exit 1
    }
}"
endlocal
exit /b 0

:dispatch_menu
:: Usage: call :dispatch_menu <array_prefix> <choice_var>
setlocal EnableDelayedExpansion
set "prefix=%~1"
set "varName=%~2"
set "sel=!%varName%!"

:: Get the actual label from the menu array
for /f "tokens=2 delims==" %%A in ('set %prefix%[%sel%] 2^>nul') do (
    set "target=%%A"
)

if defined target (
    endlocal & goto :%target%
) else (
    echo.
    echo [ERROR] Invalid selection: !sel!
    timeout /t 1 >nul
)

endlocal
goto :eof
