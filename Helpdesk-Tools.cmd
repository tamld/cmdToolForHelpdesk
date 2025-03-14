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
Choice /N /C 1234567 /M " Press your choice :"
::if %ERRORLEVEL% == 8 call :checkCompatibility & goto main
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
REM Install Software Online using Winget or Chocolatey
:installAIOMenu
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
choice /n /c 12345 /M "Press your choice: "

if errorlevel 5 goto main
if errorlevel 4 goto installAIO-O2019
if errorlevel 3 goto installAIO-O2021
if errorlevel 2 goto installAIO-O2024
if errorlevel 1 goto installAIO-Fresh

echo Invalid selection. Please try again.
pause >nul
endlocal
goto installAIOMenu

REM ========================================================================================================================================
REM function install fresh Windows using Winget utilities
:installAIO
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
Title Install All in One from fresh Windows without Office
call :installAIO
call :Clean
goto :installAIOMenu

:installAIO-O2019
Title Install All in One with Office 2019
call :installAIO
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
call :installAIO
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
call :installAIO
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
Title Install Office Online
setlocal
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
echo            [2] Using Office Tool Plus                 : Press 2
echo            [3] Using BCUninstaller                    : Press 3
echo            [4] Back to Windows Office Menu            : Press 4
echo            ====================================================
Choice /N /C 1234 /M " Press your choice : "
if %ERRORLEVEL% == 4 goto :office-windows
if %ERRORLEVEL% == 3 goto :removeOffice-BCUninstaller
if %ERRORLEVEL% == 2 goto :removeOffice-OfficeTool
if %ERRORLEVEL% == 1 goto :removeOffice-saraCmd

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
echo        [4] ChrisTitusTech/winutil              : Press 4
echo        [5] Install Support Assistance          : Press 5
echo        [6] Active IDM                          : Press 6
echo        [7] Windows Debloat                     : Press 7
echo        [8] Back to Main Menu                   : Press 8
echo        =================================================
Choice /N /C 12345678 /M " Press your choice : "
if %ERRORLEVEL% == 8 goto :main
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

:setHighPerformance
cls
REM Powerplan ref can be found at https://www.windowsafg.com/power10.html
powercfg -h off
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -h off
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
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1
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
REM Start of Package Management Software Main Menu
cd /d %dp%
cls
title Package Management Software Main Menu
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

Choice /N /C 1234567 /M "Press your choice: "
if errorlevel 7 goto :main
if errorlevel 6 (
    call :update-All 
    goto :packageManagementMenu
)
if errorlevel 5 (
    call :installChatApps 
    goto :packageManagementMenu
)
if errorlevel 4 (
    call :installNetworkApps 
    goto :packageManagementMenu
)
if errorlevel 3 (
    call :installRemoteApps 
    goto :packageManagementMenu
)
if errorlevel 2 (
    call :installEndusers 
    goto :packageManagementMenu
)
if errorlevel 1 (
    call :packageManagement 
    goto :packageManagementMenu
)

echo Invalid selection. Please try again.
pause
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
call :log "Installing Network softwares by Winget"
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
call :log "Finished Network softwares by Winget"
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
call :log "[INFO] Checking if Chocolatey is installed"
if exist "C:\ProgramData\chocolatey\bin\choco.exe" (
    echo [*] Chocolatey is already installed. Skipping installation.
    call :log "[INFO] Chocolatey is already installed. Skipping installation."
) else (
    echo [*] Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    if exist "C:\ProgramData\chocolatey\bin\choco.exe" (
        echo [*] Chocolatey installation completed successfully.
        call :log "[INFO] Chocolatey installation completed successfully."
        set "PATH=%PATH%;C:\ProgramData\chocolatey\bin"
    ) else (
        echo [Warning] Chocolatey installation failed.
        call :log "[WARNING] Chocolatey installation failed."
        exit /B 1
    )
)
ping -n 2 localhost 1>NUL
echo [*] Installing aria2c, jq, yq, 7zip...
call :log "[INFO] Installing aria2c, jq, yq, 7zip...
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
call :log "[INFO] Fetching latest Winget release information from GitHub"
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
call :log "[INFO] Detected Winget assets: Main Package: %MSIXBUNDLE_URL%, Dependencies: %DEP_ZIP_URL%"

:: Define local filenames & folders in %temp%
set "MSIXBUNDLE_FILE=%temp%\Microsoft.DesktopAppInstaller.msixbundle"
set "DEP_ZIP_FILE=%temp%\DesktopAppInstaller_Dependencies.zip"
set "DEP_FOLDER=%temp%\DesktopAppInstaller_Dependencies"

:: Download files using aria2c
echo [*] Downloading Winget package with aria2c...
call :log "[INFO] Downloading Winget package with aria2c..."
aria2c -x 16 -c -d "%temp%" -o "Microsoft.DesktopAppInstaller.msixbundle" "%MSIXBUNDLE_URL%"

echo [*] Downloading dependencies ZIP file with aria2c...
call :log "[INFO] Downloading dependencies ZIP file with aria2c..."
aria2c -x 16 -c -d "%temp%" -o "DesktopAppInstaller_Dependencies.zip" "%DEP_ZIP_URL%"

:: Extract the dependencies ZIP file
echo [*] Extracting dependencies...
call :log "[INFO] Extracting dependencies..."
powershell -NoProfile -Command "Expand-Archive -Path '%DEP_ZIP_FILE%' -DestinationPath '%DEP_FOLDER%' -Force"

:: Determine system architecture
set "arch=x64"
if /I "%PROCESSOR_ARCHITECTURE%"=="x86" set "arch=x86"
if /I "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "arch=x64"
if /I "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "arch=arm64"
echo [*] Detected Architecture: %arch%
call :log "[INFO] Detected architecture: %arch%"

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
call :log "[INFO] Winget installation completed"

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

::=====================================================================
:log
setlocal

set "logfile=%TEMP%\Helpdesk-Tools.log"

for /f "tokens=2 delims==" %%I in ('wmic os get LocalDateTime /value ^| find "="') do set "dt=%%I"  :: Get current datetime from WMIC
set "timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2% %dt:~8,2%:%dt:~10,2%:%dt:~12,2%"  :: Format datetime to readable format

set "msg=%~1"

if /I "%LOG_LEVEL%"=="DEBUG" (
    echo %timestamp% %msg% >> "%logfile%"
) else (
    echo %msg% | findstr /I "ERROR WARNING" >nul  :: Check if message contains ERROR or WARNING
    if %errorlevel% equ 0 (
        echo %timestamp% %msg% >> "%logfile%"
    )
)

endlocal
goto :EOF


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

::Kill all the app running
:killtasks
cls
setlocal EnableDelayedExpansion
echo [*] Terminating running application processes...

REM List of executables to terminate (space-separated).
REM For processes with spaces in the name, include the name in quotes.
set "appList=notepad++.exe chrome.exe firefox.exe FoxitPDFReader.exe vlc.exe ShareX.exe Everything.exe IObitUnlocker.exe FxSound.exe Telegram.exe Skype.exe Zoom.exe Viber.exe Messenger.exe MobaXterm.exe WinSCP.exe putty.exe VirtualBox.exe rclone.exe RcloneBrowser.exe Advanced_IP_Scanner.exe JDownloader2.exe Code.exe sshfs-win.exe NetworkManager.exe TeamViewer.exe UltraViewer_Desktop.exe AnyDesk.exe UnikeyNT.exe xpipe.exe LocalSend.exe TeraCopy.exe WindowsTerminal.exe LockHunter.exe PDFgear.exe CopyQ.exe HiBitUninstaller.exe Zalo.exe FreeTube.exe VirtualBox-7.1.6-167084-W.exe TeamViewer_Service.exe UltraViewer_Service.exe TeraCopyService.exe msedge.exe "YouTube Music.exe" "PDFLauncher.exe""

REM Comma-separated list of essential processes to exclude.
set "excludeList=explorer.exe,svchost.exe,taskmgr.exe,cmd.exe,conhost.exe,winlogon.exe,csrss.exe,lsass.exe,services.exe,wininit.exe,smss.exe"

for %%a in (%appList%) do (
    REM Remove any surrounding quotes from the token.
    set "proc=%%~a"
    echo [*] Checking for process: !proc!...
    echo %excludeList% | findstr /i "\<!proc!\>" >nul
    if !errorlevel! equ 0 (
        echo [!] Skipping essential process: !proc!
    ) else (
        taskkill /F /IM "!proc!" /FI "STATUS eq RUNNING" >nul 2>&1
        if !errorlevel! equ 0 (
            echo [*] Terminated: !proc!
        ) else (
            echo [*] !proc! not running or not found.
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
exit

:winget_debloat
Title Winget Debloat
cls
setlocal
set uninstall_list=Microsoft.GamingApp_8wekyb3d8bbwe ^
Microsoft.XboxApp_8wekyb3d8bbwe ^
Microsoft.Xbox.TCUI_8wekyb3d8bbwe ^
Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe ^
Microsoft.XboxIdentityProvider_8wekyb3d8bbwe ^
Microsoft.XboxGamingOverlay_8wekyb3d8bbwe ^
Microsoft.XboxGameOverlay_8wekyb3d8bbwe ^
Microsoft.ZuneMusic_8wekyb3d8bbwe ^
Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe ^
Microsoft.Getstarted_8wekyb3d8bbwe ^
Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe ^
9NBLGGH5FV99 ^
Microsoft.BingWeather_8wekyb3d8bbwe ^
Microsoft.YourPhone_8wekyb3d8bbwe ^
Microsoft.People_8wekyb3d8bbwe ^
Microsoft.Wallet_8wekyb3d8bbwe ^
Microsoft.WindowsMaps_8wekyb3d8bbwe ^
Microsoft.Office.OneNote_8wekyb3d8bbwe ^
Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe ^
Microsoft.ZuneVideo_8wekyb3d8bbwe ^
Microsoft.MixedReality.Portal_8wekyb3d8bbwe ^
Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe ^
Microsoft.GetHelp_8wekyb3d8bbwe ^
Microsoft.OneDrive ^
Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe ^
Microsoft.BingNews_8wekyb3d8bbwe ^
MicrosoftTeams_8wekyb3d8bbwe ^
MicrosoftCorporationII.MicrosoftFamily_8wekyb3d8bbwe ^
MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe ^
disney+ ^
Clipchamp.Clipchamp_yxz26nhyzhsrt

for %%p in (%uninstall_list%) do (
	cls
    winget uninstall %%p -h --accept-source-agreements --silent > nul
)
endlocal
goto :EOF

:windows_debloat
Title Windows Debloat
cls
:: Initialize environment
setlocal EnableExtensions DisableDelayedExpansion
echo --- Empty trash (Recycle Bin)
PowerShell -ExecutionPolicy Unrestricted -Command "$bin = (New-Object -ComObject Shell.Application).NameSpace(10); $bin.items() | ForEach {; Write-Host "^""Deleting $($_.Name) from Recycle Bin"^""; Remove-Item $_.Path -Recurse -Force; }"
:: ----------------------------------------------------------
echo --- Clear previous Windows installations
:: Delete directory (with additional permissions) : "%SYSTEMDRIVE%\Windows.old"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%SYSTEMDRIVE%\Windows.old'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; <# Not using `Get-Acl`/`Set-Acl` to avoid adjusting token privileges #>; $parentDirectory = [System.IO.Path]::GetDirectoryName($expandedPath); $fileName = [System.IO.Path]::GetFileName($expandedPath); if ($parentDirectory -like '*[*?]*') {; throw "^""Unable to grant permissions to glob path parent directory: `"^""$parentDirectory`"^"", wildcards in parent directory are not supported by ``takeown`` and ``icacls``."^""; }; if (($fileName -ne '*') -and ($fileName -like '*[*?]*')) {; throw "^""Unable to grant permissions to glob path file name: `"^""$fileName`"^"", wildcards in file name is not supported by ``takeown`` and ``icacls``."^""; }; Write-Host "^""Taking ownership of `"^""$expandedPath`"^""."^""; $cmdPath = $expandedPath; if ($cmdPath.EndsWith('\')) {; $cmdPath += '\' <# Escape trailing backslash for correct handling in batch commands #>; }; $takeOwnershipCommand = "^""takeown /f `"^""$cmdPath`"^"" /a"^"" <# `icacls /setowner` does not succeed, so use `takeown` instead. #>; if (-not (Test-Path -Path "^""$expandedPath"^"" -PathType Leaf)) {; $takeOwnershipCommand += ' /r /d y'; }; $takeOwnershipOutput = cmd /c "^""$takeOwnershipCommand 2>&1"^"" <# `stderr` message is misleading, e.g. "^""ERROR: The system cannot find the file specified."^"" is not an error. #>; if ($LASTEXITCODE -eq 0) {; Write-Host "^""Successfully took ownership of `"^""$expandedPath`"^"" (using ``$takeOwnershipCommand``)."^""; } else {; Write-Host "^""Did not take ownership of `"^""$expandedPath`"^"" using ``$takeOwnershipCommand``, status code: $LASTEXITCODE, message: $takeOwnershipOutput."^""; <# Do not write as error or warning, because this can be due to missing path, it's handled in next command. #>; <# `takeown` exits with status code `1`, making it hard to handle missing path here. #>; }; Write-Host "^""Granting permissions for `"^""$expandedPath`"^""."^""; $adminSid = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-32-544'; $adminAccount = $adminSid.Translate([System.Security.Principal.NTAccount]); $adminAccountName = $adminAccount.Value; $grantPermissionsCommand = "^""icacls `"^""$cmdPath`"^"" /grant `"^""$($adminAccountName):F`"^"" /t"^""; $icaclsOutput = cmd /c "^""$grantPermissionsCommand"^""; if ($LASTEXITCODE -eq 3) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } elseif ($LASTEXITCODE -ne 0) {; Write-Host "^""Take ownership message:`n$takeOwnershipOutput"^""; Write-Host "^""Grant permissions:`n$icaclsOutput"^""; Write-Warning "^""Failed to assign permissions for `"^""$expandedPath`"^"" using ``$grantPermissionsCommand``, status code: $LASTEXITCODE."^""; } else {; $fileStats = $icaclsOutput | ForEach-Object { $_ -match '\d+' | Out-Null; $matches[0] } | Where-Object { $_ -ne $null } | ForEach-Object { [int]$_ }; if ($fileStats.Count -gt 0 -and ($fileStats | ForEach-Object { $_ -eq 0 } | Where-Object { $_ -eq $false }).Count -eq 0) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } else {; Write-Host "^""Successfully granted permissions for `"^""$expandedPath`"^"" (using ``$grantPermissionsCommand``)."^""; }; }; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: ----------------------------------------------------------
:: ------------Remove "Microsoft 3D Builder" app-------------
:: ----------------------------------------------------------
echo --- Remove "Microsoft 3D Builder" app
:: Uninstall 'Microsoft.3DBuilder' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.3DBuilder' | Remove-AppxPackage"
:: Mark 'Microsoft.3DBuilder' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.3DBuilder_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Remove "3D Viewer" app------------------
:: ----------------------------------------------------------
echo --- Remove "3D Viewer" app
:: Uninstall 'Microsoft.Microsoft3DViewer' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Microsoft3DViewer' | Remove-AppxPackage"
:: Mark 'Microsoft.Microsoft3DViewer' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Microsoft3DViewer_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Remove "MSN Weather" app-----------------
:: ----------------------------------------------------------
echo --- Remove "MSN Weather" app
:: Uninstall 'Microsoft.BingWeather' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingWeather' | Remove-AppxPackage"
:: Mark 'Microsoft.BingWeather' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingWeather_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Remove "MSN Sports" app------------------
:: ----------------------------------------------------------
echo --- Remove "MSN Sports" app
:: Uninstall 'Microsoft.BingSports' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingSports' | Remove-AppxPackage"
:: Mark 'Microsoft.BingSports' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingSports_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------Remove "Microsoft News" app----------------
:: ----------------------------------------------------------
echo --- Remove "Microsoft News" app
:: Uninstall 'Microsoft.BingNews' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingNews' | Remove-AppxPackage"
:: Mark 'Microsoft.BingNews' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingNews_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Remove "MSN Money" app------------------
:: ----------------------------------------------------------
echo --- Remove "MSN Money" app
:: Uninstall 'Microsoft.BingFinance' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.BingFinance' | Remove-AppxPackage"
:: Mark 'Microsoft.BingFinance' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.BingFinance_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Remove "Microsoft 365 (Office)" app------------
:: ----------------------------------------------------------
echo --- Remove "Microsoft 365 (Office)" app
:: Uninstall 'Microsoft.MicrosoftOfficeHub' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.MicrosoftOfficeHub' | Remove-AppxPackage"
:: Mark 'Microsoft.MicrosoftOfficeHub' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Remove "OneNote" app-------------------
:: ----------------------------------------------------------
echo --- Remove "OneNote" app
:: Uninstall 'Microsoft.Office.OneNote' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Office.OneNote' | Remove-AppxPackage"
:: Mark 'Microsoft.Office.OneNote' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Office.OneNote_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------------Remove "Sway" app---------------------
:: ----------------------------------------------------------
echo --- Remove "Sway" app
:: Uninstall 'Microsoft.Office.Sway' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Office.Sway' | Remove-AppxPackage"
:: Mark 'Microsoft.Office.Sway' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Office.Sway_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Remove "Xbox Console Companion" app------------
:: ----------------------------------------------------------
echo --- Remove "Xbox Console Companion" app
:: Uninstall 'Microsoft.XboxApp' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxApp' | Remove-AppxPackage"
:: Mark 'Microsoft.XboxApp' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxApp_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Remove "Xbox Live in-game experience" app---------
:: ----------------------------------------------------------
echo --- Remove "Xbox Live in-game experience" app
:: Uninstall 'Microsoft.Xbox.TCUI' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Xbox.TCUI' | Remove-AppxPackage"
:: Mark 'Microsoft.Xbox.TCUI' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Xbox.TCUI_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Remove "Xbox Game Bar" app----------------
:: ----------------------------------------------------------
echo --- Remove "Xbox Game Bar" app
:: Uninstall 'Microsoft.XboxGamingOverlay' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxGamingOverlay' | Remove-AppxPackage"
:: Mark 'Microsoft.XboxGamingOverlay' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Remove "Xbox Game Bar Plugin" app-------------
:: ----------------------------------------------------------
echo --- Remove "Xbox Game Bar Plugin" app
:: Uninstall 'Microsoft.XboxGameOverlay' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxGameOverlay' | Remove-AppxPackage"
:: Mark 'Microsoft.XboxGameOverlay' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxGameOverlay_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: Remove "Xbox Identity Provider" app (breaks Xbox sign-in)-
:: ----------------------------------------------------------
echo --- Remove "Xbox Identity Provider" app (breaks Xbox sign-in)
:: Uninstall 'Microsoft.XboxIdentityProvider' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxIdentityProvider' | Remove-AppxPackage"
:: Mark 'Microsoft.XboxIdentityProvider' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------Remove "Xbox Speech To Text Overlay" app---------
:: ----------------------------------------------------------
echo --- Remove "Xbox Speech To Text Overlay" app
:: Uninstall 'Microsoft.XboxSpeechToTextOverlay' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.XboxSpeechToTextOverlay' | Remove-AppxPackage"
:: Mark 'Microsoft.XboxSpeechToTextOverlay' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Remove "Your Phone Companion" app-------------
:: ----------------------------------------------------------
echo --- Remove "Your Phone Companion" app
:: Uninstall 'Microsoft.WindowsPhone' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.WindowsPhone' | Remove-AppxPackage"
:: Mark 'Microsoft.WindowsPhone' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.WindowsPhone_8wekyb3d8bbwe" /f
:: Uninstall 'Microsoft.Windows.Phone' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Windows.Phone' | Remove-AppxPackage"
:: Mark 'Microsoft.Windows.Phone' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Windows.Phone_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Remove "Communications - Phone" app------------
:: ----------------------------------------------------------
echo --- Remove "Communications - Phone" app
:: Uninstall 'Microsoft.CommsPhone' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.CommsPhone' | Remove-AppxPackage"
:: Mark 'Microsoft.CommsPhone' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.CommsPhone_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Remove "Phone Link" app------------------
:: ----------------------------------------------------------
echo --- Remove "Phone Link" app
:: Uninstall 'Microsoft.YourPhone' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.YourPhone' | Remove-AppxPackage"
:: Mark 'Microsoft.YourPhone' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.YourPhone_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Remove "Shazam" app--------------------
:: ----------------------------------------------------------
echo --- Remove "Shazam" app
:: Uninstall 'ShazamEntertainmentLtd.Shazam' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'ShazamEntertainmentLtd.Shazam' | Remove-AppxPackage"
:: Mark 'ShazamEntertainmentLtd.Shazam' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\ShazamEntertainmentLtd.Shazam_pqbynwjfrbcg4" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Remove "Flipboard" app------------------
:: ----------------------------------------------------------
echo --- Remove "Flipboard" app
:: Uninstall 'Flipboard.Flipboard' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Flipboard.Flipboard' | Remove-AppxPackage"
:: Mark 'Flipboard.Flipboard' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Flipboard.Flipboard_3f5azkryzdbc4" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Remove "Twitter" app-------------------
:: ----------------------------------------------------------
echo --- Remove "Twitter" app
:: Uninstall '9E2F88E3.Twitter' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage '9E2F88E3.Twitter' | Remove-AppxPackage"
:: Mark '9E2F88E3.Twitter' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\9E2F88E3.Twitter_wgeqdkkx372wm" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------Remove "iHeart: Radio, Music, Podcasts" app--------
:: ----------------------------------------------------------
echo --- Remove "iHeart: Radio, Music, Podcasts" app
:: Uninstall 'ClearChannelRadioDigital.iHeartRadio' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'ClearChannelRadioDigital.iHeartRadio' | Remove-AppxPackage"
:: Mark 'ClearChannelRadioDigital.iHeartRadio' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\ClearChannelRadioDigital.iHeartRadio_a76a11dkgb644" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------Remove "Duolingo - Language Lessons" app---------
:: ----------------------------------------------------------
echo --- Remove "Duolingo - Language Lessons" app
:: Uninstall 'D5EA27B7.Duolingo-LearnLanguagesforFree' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'D5EA27B7.Duolingo-LearnLanguagesforFree' | Remove-AppxPackage"
:: Mark 'D5EA27B7.Duolingo-LearnLanguagesforFree' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\D5EA27B7.Duolingo-LearnLanguagesforFree_yx6k7tf7xvsea" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Remove "Adobe Photoshop Express" app-----------
:: ----------------------------------------------------------
echo --- Remove "Adobe Photoshop Express" app
:: Uninstall 'AdobeSystemsIncorporated.AdobePhotoshopExpress' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'AdobeSystemsIncorporated.AdobePhotoshopExpress' | Remove-AppxPackage"
:: Mark 'AdobeSystemsIncorporated.AdobePhotoshopExpress' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\AdobeSystemsIncorporated.AdobePhotoshopExpress_ynb6jyjzte8ga" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Remove "Pandora" app-------------------
:: ----------------------------------------------------------
echo --- Remove "Pandora" app
:: Uninstall 'PandoraMediaInc.29680B314EFC2' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'PandoraMediaInc.29680B314EFC2' | Remove-AppxPackage"
:: Mark 'PandoraMediaInc.29680B314EFC2' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\PandoraMediaInc.29680B314EFC2_n619g4d5j0fnw" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------Remove "Eclipse Manager" app---------------
:: ----------------------------------------------------------
echo --- Remove "Eclipse Manager" app
:: Uninstall '46928bounde.EclipseManager' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage '46928bounde.EclipseManager' | Remove-AppxPackage"
:: Mark '46928bounde.EclipseManager' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\46928bounde.EclipseManager_a5h4egax66k6y" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Remove "Code Writer" app-----------------
:: ----------------------------------------------------------
echo --- Remove "Code Writer" app
:: Uninstall 'ActiproSoftwareLLC.562882FEEB491' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'ActiproSoftwareLLC.562882FEEB491' | Remove-AppxPackage"
:: Mark 'ActiproSoftwareLLC.562882FEEB491' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\ActiproSoftwareLLC.562882FEEB491_24pqs290vpjk0" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Remove "Spotify - Music and Podcasts" app---------
:: ----------------------------------------------------------
echo --- Remove "Spotify - Music and Podcasts" app
:: Uninstall 'SpotifyAB.SpotifyMusic' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'SpotifyAB.SpotifyMusic' | Remove-AppxPackage"
:: Mark 'SpotifyAB.SpotifyMusic' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\SpotifyAB.SpotifyMusic_zpdnekdrzrea0" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Remove "Cortana" app-------------------
:: ----------------------------------------------------------
echo --- Remove "Cortana" app
:: Uninstall 'Microsoft.549981C3F5F10' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.549981C3F5F10' | Remove-AppxPackage"
:: Mark 'Microsoft.549981C3F5F10' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.549981C3F5F10_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -Remove "Get Help" app (breaks built-in troubleshooting)--
:: ----------------------------------------------------------
echo --- Remove "Get Help" app (breaks built-in troubleshooting)
:: Uninstall 'Microsoft.GetHelp' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.GetHelp' | Remove-AppxPackage"
:: Mark 'Microsoft.GetHelp' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.GetHelp_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------Remove "Microsoft Tips" app----------------
:: ----------------------------------------------------------
echo --- Remove "Microsoft Tips" app
:: Uninstall 'Microsoft.Getstarted' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Getstarted' | Remove-AppxPackage"
:: Mark 'Microsoft.Getstarted' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Getstarted_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Remove "Microsoft Messaging" app-------------
:: ----------------------------------------------------------
echo --- Remove "Microsoft Messaging" app
:: Uninstall 'Microsoft.Messaging' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Messaging' | Remove-AppxPackage"
:: Mark 'Microsoft.Messaging' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Messaging_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Remove "Mixed Reality Portal" app-------------
:: ----------------------------------------------------------
echo --- Remove "Mixed Reality Portal" app
:: Uninstall 'Microsoft.MixedReality.Portal' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.MixedReality.Portal' | Remove-AppxPackage"
:: Mark 'Microsoft.MixedReality.Portal' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MixedReality.Portal_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Remove "Feedback Hub" app-----------------
:: ----------------------------------------------------------
echo --- Remove "Feedback Hub" app
:: Uninstall 'Microsoft.WindowsFeedbackHub' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage"
:: Mark 'Microsoft.WindowsFeedbackHub' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Remove "Paint 3D" app-------------------
:: ----------------------------------------------------------
echo --- Remove "Paint 3D" app
:: Uninstall 'Microsoft.MSPaint' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.MSPaint' | Remove-AppxPackage"
:: Mark 'Microsoft.MSPaint' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MSPaint_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Remove "Windows Maps" app-----------------
:: ----------------------------------------------------------
echo --- Remove "Windows Maps" app
:: Uninstall 'Microsoft.WindowsMaps' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.WindowsMaps' | Remove-AppxPackage"
:: Mark 'Microsoft.WindowsMaps' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.WindowsMaps_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Remove "Minecraft for Windows" app------------
:: ----------------------------------------------------------
echo --- Remove "Minecraft for Windows" app
:: Uninstall 'Microsoft.MinecraftUWP' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.MinecraftUWP' | Remove-AppxPackage"
:: Mark 'Microsoft.MinecraftUWP' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MinecraftUWP_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------Remove "Microsoft People" app---------------
:: ----------------------------------------------------------
echo --- Remove "Microsoft People" app
:: Uninstall 'Microsoft.People' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.People' | Remove-AppxPackage"
:: Mark 'Microsoft.People' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.People_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Remove "Microsoft Pay" app----------------
:: ----------------------------------------------------------
echo --- Remove "Microsoft Pay" app
:: Uninstall 'Microsoft.Wallet' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Wallet' | Remove-AppxPackage"
:: Mark 'Microsoft.Wallet' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Wallet_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Remove "Print 3D" app-------------------
:: ----------------------------------------------------------
echo --- Remove "Print 3D" app
:: Uninstall 'Microsoft.Print3D' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.Print3D' | Remove-AppxPackage"
:: Mark 'Microsoft.Print3D' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.Print3D_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Remove "Mobile Plans" app-----------------
:: ----------------------------------------------------------
echo --- Remove "Mobile Plans" app
:: Uninstall 'Microsoft.OneConnect' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.OneConnect' | Remove-AppxPackage"
:: Mark 'Microsoft.OneConnect' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.OneConnect_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------Remove "Microsoft Solitaire Collection" app--------
:: ----------------------------------------------------------
echo --- Remove "Microsoft Solitaire Collection" app
:: Uninstall 'Microsoft.MicrosoftSolitaireCollection' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.MicrosoftSolitaireCollection' | Remove-AppxPackage"
:: Mark 'Microsoft.MicrosoftSolitaireCollection' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Remove "Windows Media Player" app-------------
:: ----------------------------------------------------------
echo --- Remove "Windows Media Player" app
:: Uninstall 'Microsoft.ZuneMusic' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.ZuneMusic' | Remove-AppxPackage"
:: Mark 'Microsoft.ZuneMusic' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.ZuneMusic_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------------Remove "Movies & TV" app-----------------
:: ----------------------------------------------------------
echo --- Remove "Movies ^& TV" app
:: Uninstall 'Microsoft.ZuneVideo' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.ZuneVideo' | Remove-AppxPackage"
:: Mark 'Microsoft.ZuneVideo' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.ZuneVideo_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------------Remove "Skype" app--------------------
:: ----------------------------------------------------------
echo --- Remove "Skype" app
:: Uninstall 'Microsoft.SkypeApp' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.SkypeApp' | Remove-AppxPackage"
:: Mark 'Microsoft.SkypeApp' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.SkypeApp_kzf8qxf38zg5c" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------------Remove "GroupMe" app-------------------
:: ----------------------------------------------------------
echo --- Remove "GroupMe" app
:: Uninstall 'Microsoft.GroupMe10' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.GroupMe10' | Remove-AppxPackage"
:: Mark 'Microsoft.GroupMe10' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.GroupMe10_kzf8qxf38zg5c" /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Remove "Network Speed Test" app--------------
:: ----------------------------------------------------------
echo --- Remove "Network Speed Test" app
:: Uninstall 'Microsoft.NetworkSpeedTest' Microsoft Store app.
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage 'Microsoft.NetworkSpeedTest' | Remove-AppxPackage"
:: Mark 'Microsoft.NetworkSpeedTest' as deprovisioned to block reinstall during Windows updates.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\Microsoft.NetworkSpeedTest_8wekyb3d8bbwe" /f
:: ----------------------------------------------------------

:: ----------------------------------------------------------
:: ------------------Kill OneDrive process-------------------
:: ----------------------------------------------------------
echo --- Kill OneDrive process
:: Check and terminate the running process "OneDrive.exe"
tasklist /fi "ImageName eq OneDrive.exe" /fo csv 2>NUL | find /i "OneDrive.exe">NUL && (
    echo OneDrive.exe is running and will be killed.
    taskkill /f /im OneDrive.exe
) || (
    echo Skipping, OneDrive.exe is not running.
)
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------Remove OneDrive from startup---------------
:: ----------------------------------------------------------
echo --- Remove OneDrive from startup
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f 2>nul
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Remove OneDrive through official installer--------
:: ----------------------------------------------------------
echo --- Remove OneDrive through official installer
if exist "%SYSTEMROOT%\System32\OneDriveSetup.exe" (
    "%SYSTEMROOT%\System32\OneDriveSetup.exe" /uninstall
) else (
    if exist "%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe" (
        "%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe" /uninstall
    ) else (
        echo Failed to uninstall, uninstaller could not be found. 1>&2
    )
)
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------------Remove OneDrive residual files--------------
:: ----------------------------------------------------------
echo --- Remove OneDrive residual files
:: Delete directory  : "%USERPROFILE%\OneDrive"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%USERPROFILE%\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Delete directory (with additional permissions) : "%LOCALAPPDATA%\Microsoft\OneDrive"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; <# Not using `Get-Acl`/`Set-Acl` to avoid adjusting token privileges #>; $parentDirectory = [System.IO.Path]::GetDirectoryName($expandedPath); $fileName = [System.IO.Path]::GetFileName($expandedPath); if ($parentDirectory -like '*[*?]*') {; throw "^""Unable to grant permissions to glob path parent directory: `"^""$parentDirectory`"^"", wildcards in parent directory are not supported by ``takeown`` and ``icacls``."^""; }; if (($fileName -ne '*') -and ($fileName -like '*[*?]*')) {; throw "^""Unable to grant permissions to glob path file name: `"^""$fileName`"^"", wildcards in file name is not supported by ``takeown`` and ``icacls``."^""; }; Write-Host "^""Taking ownership of `"^""$expandedPath`"^""."^""; $cmdPath = $expandedPath; if ($cmdPath.EndsWith('\')) {; $cmdPath += '\' <# Escape trailing backslash for correct handling in batch commands #>; }; $takeOwnershipCommand = "^""takeown /f `"^""$cmdPath`"^"" /a"^"" <# `icacls /setowner` does not succeed, so use `takeown` instead. #>; if (-not (Test-Path -Path "^""$expandedPath"^"" -PathType Leaf)) {; $takeOwnershipCommand += ' /r /d y'; }; $takeOwnershipOutput = cmd /c "^""$takeOwnershipCommand 2>&1"^"" <# `stderr` message is misleading, e.g. "^""ERROR: The system cannot find the file specified."^"" is not an error. #>; if ($LASTEXITCODE -eq 0) {; Write-Host "^""Successfully took ownership of `"^""$expandedPath`"^"" (using ``$takeOwnershipCommand``)."^""; } else {; Write-Host "^""Did not take ownership of `"^""$expandedPath`"^"" using ``$takeOwnershipCommand``, status code: $LASTEXITCODE, message: $takeOwnershipOutput."^""; <# Do not write as error or warning, because this can be due to missing path, it's handled in next command. #>; <# `takeown` exits with status code `1`, making it hard to handle missing path here. #>; }; Write-Host "^""Granting permissions for `"^""$expandedPath`"^""."^""; $adminSid = New-Object System.Security.Principal.SecurityIdentifier 'S-1-5-32-544'; $adminAccount = $adminSid.Translate([System.Security.Principal.NTAccount]); $adminAccountName = $adminAccount.Value; $grantPermissionsCommand = "^""icacls `"^""$cmdPath`"^"" /grant `"^""$($adminAccountName):F`"^"" /t"^""; $icaclsOutput = cmd /c "^""$grantPermissionsCommand"^""; if ($LASTEXITCODE -eq 3) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } elseif ($LASTEXITCODE -ne 0) {; Write-Host "^""Take ownership message:`n$takeOwnershipOutput"^""; Write-Host "^""Grant permissions:`n$icaclsOutput"^""; Write-Warning "^""Failed to assign permissions for `"^""$expandedPath`"^"" using ``$grantPermissionsCommand``, status code: $LASTEXITCODE."^""; } else {; $fileStats = $icaclsOutput | ForEach-Object { $_ -match '\d+' | Out-Null; $matches[0] } | Where-Object { $_ -ne $null } | ForEach-Object { [int]$_ }; if ($fileStats.Count -gt 0 -and ($fileStats | ForEach-Object { $_ -eq 0 } | Where-Object { $_ -eq $false }).Count -eq 0) {; Write-Host "^""Skipping, no items available for deletion according to: ``$grantPermissionsCommand``."^""; exit 0; } else {; Write-Host "^""Successfully granted permissions for `"^""$expandedPath`"^"" (using ``$grantPermissionsCommand``)."^""; }; }; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Delete directory  : "%PROGRAMDATA%\Microsoft OneDrive"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%PROGRAMDATA%\Microsoft OneDrive'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Delete directory  : "%SYSTEMDRIVE%\OneDriveTemp"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%SYSTEMDRIVE%\OneDriveTemp'; if (-Not $directoryGlob.EndsWith('\')) { $directoryGlob += '\' }; $directoryGlob )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------------Remove OneDrive shortcuts-----------------
:: ----------------------------------------------------------
echo --- Remove OneDrive shortcuts
PowerShell -ExecutionPolicy Unrestricted -Command "$shortcuts = @(; @{ Revert = $True;  Path = "^""$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:USERPROFILE\Links\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\LocalService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; @{ Revert = $False; Path = "^""$env:WINDIR\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"^""; }; ); foreach ($shortcut in $shortcuts) {; if (-Not (Test-Path $shortcut.Path)) {; Write-Host "^""Skipping, shortcut does not exist: `"^""$($shortcut.Path)`"^""."^""; continue; }; try {; Remove-Item -Path $shortcut.Path -Force -ErrorAction Stop; Write-Output "^""Successfully removed shortcut: `"^""$($shortcut.Path)`"^""."^""; } catch {; Write-Error "^""Encountered an issue while attempting to remove shortcut at: `"^""$($shortcut.Path)`"^""."^""; }; }"
PowerShell -ExecutionPolicy Unrestricted -Command "Set-Location "^""HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"^""; Get-ChildItem | ForEach-Object {Get-ItemProperty $_.pspath} | ForEach-Object {; $leftnavNodeName = $_."^""(default)"^"";; if (($leftnavNodeName -eq "^""OneDrive"^"") -Or ($leftnavNodeName -eq "^""OneDrive - Personal"^"")) {; if (Test-Path $_.pspath) {; Write-Host "^""Deleting $($_.pspath)."^""; Remove-Item $_.pspath;; }; }; }"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------------Disable OneDrive usage------------------
:: ----------------------------------------------------------
echo --- Disable OneDrive usage
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSyncNGSC" /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSync" /d 1 /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------Disable automatic OneDrive installation----------
:: ----------------------------------------------------------
echo --- Disable automatic OneDrive installation
PowerShell -ExecutionPolicy Unrestricted -Command "reg delete "^""HKCU\Software\Microsoft\Windows\CurrentVersion\Run"^"" /v "^""OneDriveSetup"^"" /f 2>$null"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: --------Remove OneDrive folder from File Explorer---------
:: ----------------------------------------------------------
echo --- Remove OneDrive folder from File Explorer
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f
reg add "HKCR\Wow6432Node\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /d "0" /t REG_DWORD /f
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -------------Disable OneDrive scheduled tasks-------------
:: ----------------------------------------------------------
echo --- Disable OneDrive scheduled tasks
:: Disable scheduled task(s): `\OneDrive Reporting Task-*`
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Reporting Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }"
:: Disable scheduled task(s): `\OneDrive Standalone Update Task-*`
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Standalone Update Task-*'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }"
:: Disable scheduled task(s): `\OneDrive Per-Machine Standalone Update`
PowerShell -ExecutionPolicy Unrestricted -Command "$taskPathPattern='\'; $taskNamePattern='OneDrive Per-Machine Standalone Update'; Write-Output "^""Disabling tasks matching pattern `"^""$taskNamePattern`"^""."^""; $tasks = @(Get-ScheduledTask -TaskPath $taskPathPattern -TaskName $taskNamePattern -ErrorAction Ignore); if (-Not $tasks) {; Write-Output "^""Skipping, no tasks matching pattern `"^""$taskNamePattern`"^"" found, no action needed."^""; exit 0; }; $operationFailed = $false; foreach ($task in $tasks) {; $taskName = $task.TaskName; if ($task.State -eq [Microsoft.PowerShell.Cmdletization.GeneratedTypes.ScheduledTask.StateEnum]::Disabled) {; Write-Output "^""Skipping, task `"^""$taskName`"^"" is already disabled, no action needed."^""; continue; }; try {; $task | Disable-ScheduledTask -ErrorAction Stop | Out-Null; Write-Output "^""Successfully disabled task `"^""$taskName`"^""."^""; } catch {; Write-Error "^""Failed to disable task `"^""$taskName`"^"": $($_.Exception.Message)"^""; $operationFailed = $true; }; }; if ($operationFailed) {; Write-Output 'Failed to disable some tasks. Check error messages above.'; exit 1; }"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: -----------Clear OneDrive environment variable------------
:: ----------------------------------------------------------
echo --- Clear OneDrive environment variable
reg delete "HKCU\Environment" /v "OneDrive" /f 2>nul
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------Disable "Windows Fax and Scan" feature----------
:: ----------------------------------------------------------
echo --- Disable "Windows Fax and Scan" feature
dism /Online /Disable-Feature /FeatureName:"FaxServicesClientPackage" /NoRestart
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ---------------Remove Widgets from taskbar----------------
:: ----------------------------------------------------------
echo --- Remove Widgets from taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d "0" /f
:: ----------------------------------------------------------

:: ----------------------------------------------------------
:: ------------Remove Meet Now icon from taskbar-------------
:: ----------------------------------------------------------
echo --- Remove Meet Now icon from taskbar
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f
:: ----------------------------------------------------------

endlocal
goto :EOF

:disable_os_services
cls
:: Initialize environment
setlocal EnableExtensions DisableDelayedExpansion
:: ----------------------------------------------------------
:: ---------Disable "Xbox Live Auth Manager" service---------
:: ----------------------------------------------------------
echo --- Disable "Xbox Live Auth Manager" service
:: Disable service(s): `XblAuthManager`
PowerShell -ExecutionPolicy Unrestricted -Command "$serviceName = 'XblAuthManager'; Write-Host "^""Disabling service: `"^""$serviceName`"^""."^""; <# -- 1. Skip if service does not exist #>; $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue; if(!$service) {; Write-Host "^""Service `"^""$serviceName`"^"" could not be not found, no need to disable it."^""; Exit 0; }; <# -- 2. Stop if running #>; if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) {; Write-Host "^""`"^""$serviceName`"^"" is running, stopping it."^""; try {; Stop-Service -Name "^""$serviceName"^"" -Force -ErrorAction Stop; Write-Host "^""Stopped `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Warning "^""Could not stop `"^""$serviceName`"^"", it will be stopped after reboot: $_"^""; }; } else {; Write-Host "^""`"^""$serviceName`"^"" is not running, no need to stop."^""; }; <# -- 3. Skip if already disabled #>; $startupType = $service.StartType <# Does not work before .NET 4.6.1 #>; if(!$startupType) {; $startupType = (Get-WmiObject -Query "^""Select StartMode From Win32_Service Where Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; if(!$startupType) {; $startupType = (Get-WmiObject -Class Win32_Service -Property StartMode -Filter "^""Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; }; }; if($startupType -eq 'Disabled') {; Write-Host "^""$serviceName is already disabled, no further action is needed"^""; }; <# -- 4. Disable service #>; try {; Set-Service -Name "^""$serviceName"^"" -StartupType Disabled -Confirm:$false -ErrorAction Stop; Write-Host "^""Disabled `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Error "^""Could not disable `"^""$serviceName`"^"": $_"^""; }"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------Disable "Xbox Live Game Save" service-----------
:: ----------------------------------------------------------
echo --- Disable "Xbox Live Game Save" service
:: Disable service(s): `XblGameSave`
PowerShell -ExecutionPolicy Unrestricted -Command "$serviceName = 'XblGameSave'; Write-Host "^""Disabling service: `"^""$serviceName`"^""."^""; <# -- 1. Skip if service does not exist #>; $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue; if(!$service) {; Write-Host "^""Service `"^""$serviceName`"^"" could not be not found, no need to disable it."^""; Exit 0; }; <# -- 2. Stop if running #>; if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) {; Write-Host "^""`"^""$serviceName`"^"" is running, stopping it."^""; try {; Stop-Service -Name "^""$serviceName"^"" -Force -ErrorAction Stop; Write-Host "^""Stopped `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Warning "^""Could not stop `"^""$serviceName`"^"", it will be stopped after reboot: $_"^""; }; } else {; Write-Host "^""`"^""$serviceName`"^"" is not running, no need to stop."^""; }; <# -- 3. Skip if already disabled #>; $startupType = $service.StartType <# Does not work before .NET 4.6.1 #>; if(!$startupType) {; $startupType = (Get-WmiObject -Query "^""Select StartMode From Win32_Service Where Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; if(!$startupType) {; $startupType = (Get-WmiObject -Class Win32_Service -Property StartMode -Filter "^""Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; }; }; if($startupType -eq 'Disabled') {; Write-Host "^""$serviceName is already disabled, no further action is needed"^""; }; <# -- 4. Disable service #>; try {; Set-Service -Name "^""$serviceName"^"" -StartupType Disabled -Confirm:$false -ErrorAction Stop; Write-Host "^""Disabled `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Error "^""Could not disable `"^""$serviceName`"^"": $_"^""; }"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ----------Disable "Xbox Live Networking Service"----------
:: ----------------------------------------------------------
echo --- Disable "Xbox Live Networking Service"
:: Disable service(s): `XboxNetApiSvc`
PowerShell -ExecutionPolicy Unrestricted -Command "$serviceName = 'XboxNetApiSvc'; Write-Host "^""Disabling service: `"^""$serviceName`"^""."^""; <# -- 1. Skip if service does not exist #>; $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue; if(!$service) {; Write-Host "^""Service `"^""$serviceName`"^"" could not be not found, no need to disable it."^""; Exit 0; }; <# -- 2. Stop if running #>; if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) {; Write-Host "^""`"^""$serviceName`"^"" is running, stopping it."^""; try {; Stop-Service -Name "^""$serviceName"^"" -Force -ErrorAction Stop; Write-Host "^""Stopped `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Warning "^""Could not stop `"^""$serviceName`"^"", it will be stopped after reboot: $_"^""; }; } else {; Write-Host "^""`"^""$serviceName`"^"" is not running, no need to stop."^""; }; <# -- 3. Skip if already disabled #>; $startupType = $service.StartType <# Does not work before .NET 4.6.1 #>; if(!$startupType) {; $startupType = (Get-WmiObject -Query "^""Select StartMode From Win32_Service Where Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; if(!$startupType) {; $startupType = (Get-WmiObject -Class Win32_Service -Property StartMode -Filter "^""Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; }; }; if($startupType -eq 'Disabled') {; Write-Host "^""$serviceName is already disabled, no further action is needed"^""; }; <# -- 4. Disable service #>; try {; Set-Service -Name "^""$serviceName"^"" -StartupType Disabled -Confirm:$false -ErrorAction Stop; Write-Host "^""Disabled `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Error "^""Could not disable `"^""$serviceName`"^"": $_"^""; }"
:: ----------------------------------------------------------


:: ----------------------------------------------------------
:: ------------Disable NetBios for all interfaces------------
:: ----------------------------------------------------------
echo --- Disable NetBios for all interfaces
PowerShell -ExecutionPolicy Unrestricted -Command "$key = 'HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces'; Get-ChildItem $key | ForEach {; Set-ItemProperty -Path "^""$key\$($_.PSChildName)"^"" -Name NetbiosOptions -Value 2 -Verbose; }"
:: Restore previous environment settings
endlocal
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
