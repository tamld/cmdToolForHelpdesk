@echo off

:: TEST DISPATCHER: Check if a specific function is being called for testing
if /i "%~1"=="checkCompatibility" goto :checkCompatibility
if /i "%~1"=="DisplayMainMenu" goto :DisplayMainMenu
if /i "%~1"=="displayWindowsOfficeMenu" goto :displayWindowsOfficeMenu
if /i "%~1"=="displayUtilitiesMenu" goto :displayUtilitiesMenu
if /i "%~1"=="displayLicenseMenu" goto :displayLicenseMenu
if /i "%~1"=="displayPackageManagerMenu" goto :displayPackageManagerMenu
if not "%~1"=="" goto :eof
set "BASE_DIRECTORY=%~dp0"
cd /d "%BASE_DIRECTORY%"

:Main
setlocal
set "choiceMap[1]=InstallSoftware"
set "choiceMap[2]=WindowsOfficeUtils"
set "choiceMap[3]=LicenseUtils"
set "choiceMap[4]=UtilitiesMenu"
set "choiceMap[5]=PackageManagerMenu"
set "choiceMap[6]=updateScript"
set "choiceMap[7]=exit"

:DisplayMainMenu
cls
title Helpdesk Tools v0.6.80 Feb 15, 2025
echo.
echo    ========================================================
echo    [1] Install All In One Online                  : Press 1
echo    [2] Windows Office Utilities                   : Press 2
echo    [3] License Activation                         : Press 3
echo    [4] System Utilities                           : Press 4
echo    [5] Package Management                         : Press 5
echo    [6] Update This Script                         : Press 6
echo    [7] Exit                                       : Press 7
echo    ========================================================
goto :eof

:LoopMainMenu
call :DisplayMainMenu
choice /N /C 1234567 /M "Enter your choice: "
set "userChoice=%errorlevel%"
call :dispatchMenu choiceMap userChoice
goto :LoopMainMenu

:InstallSoftware
setlocal
:DisplayInstallMenu
cls
title Install All In One
echo.
echo        ========================================================
echo        [1] Install All In One with Office 365         : Press 1
echo        [2] Install All In One with Office 2019        : Press 2
echo        [3] Install All In One with Office 2021        : Press 3
echo        [4] Install All In One with Office 2024        : Press 4
echo        [5] Install System - Network - Helpdesk        : Press 5
echo        [6] Back to Main Menu                          : Press 6
echo        ========================================================
Choice /N /C 123456 /M " Press your choice : "
if %ERRORLEVEL% == 6 goto :LoopMainMenu
if %ERRORLEVEL% == 5 goto :InstallAioSystemNetwork
if %ERRORLEVEL% == 4 goto :InstallAioWithOffice2024
if %ERRORLEVEL% == 3 goto :InstallAioWithOffice2021
if %ERRORLEVEL% == 2 goto :InstallAioWithOffice2019
if %ERRORLEVEL% == 1 goto :InstallAioWithOffice365
endlocal
goto :EOF

:InstallAioCommon
call :installEndUsers
call :installRemoteApps
call :installNetworkApps
call :installChatApps
goto :EOF

:InstallAioWithOffice365
Title Install All in One with Office 365
call :InstallAioCommon
set opt5=(NO)
set optS=(NO)
set officeVersion=365
call :installO365
goto :DisplayInstallMenu

:InstallAioWithOffice2019
Title Install All in One with Office 2019
call :InstallAioCommon
set opt5=(NO)
set optS=(NO)
set officeVersion=2019
set officeType=Volume
call :installOffice
goto :DisplayInstallMenu

:InstallAioWithOffice2021
Title Install All in One with Office 2021
call :installAIO
set opt5=(NO)
set optS=(NO)
set officeVersion=2021
set officeType=Volume
call :installOffice
goto :DisplayInstallMenu

:InstallAioWithOffice2024
Title Install All in One with Office 2024
call :installAIO
set opt5=(NO)
set optS=(NO)
set officeVersion=2024
set officeType=Volume
call :installOffice
goto :DisplayInstallMenu

:InstallAioSystemNetwork
call :hold
goto :DisplayInstallMenu

:InstallAioHelpdesk
call :hold
goto :DisplayInstallMenu

REM End of Install AIO Online
::========================================================================================================================
================
::==============================================================================
:: Start of Windows Office Utilities Menu
:DisplayWindowsOfficeMenu
cls
title Windows Office Main Menu
echo.
echo        ==============================================================
echo        [1] Install Office Online                        : Press 1
echo        [2] Uninstall Office                             : Press 2
echo        [3] Remove Office License                        : Press 3
echo        [4] Convert Office Edition                       : Press 4
echo        [5] Fix non-Core                                 : Press 5
echo        [6] Load SKUS Windows                            : Press 6
echo        [7] Main Menu                                    : Press 7
echo        ==============================================================
goto :eof

:WindowsOfficeUtils
setlocal
cd /d %BASE_DIRECTORY%
call :DisplayWindowsOfficeMenu
Choice /N /C 1234567 /M " Press your choice : "
if %ERRORLEVEL% == 7 goto :LoopMainMenu
if %ERRORLEVEL% == 6 call :DisplayLoadSkusMenu & goto :WindowsOfficeUtils
if %ERRORLEVEL% == 5 goto :FixNonCoreActivation
if %ERRORLEVEL% == 4 goto :ConvertOfficeEdition
if %ERRORLEVEL% == 3 goto :DisplayRemoveOfficeKeyMenu
if %ERRORLEVEL% == 2 goto :DisplayUninstallOfficeMenu
if %ERRORLEVEL% == 1 goto :DisplayInstallOfficeMenu
endlocal
REM ==============================================================================
REM Start of Windows Office Utilities functions
REM ==============================================================================
REM Sub menu Install Office Online

:DisplayInstallOfficeMenu
setlocal
cls
echo.
echo                ================================================================
echo                [1] Install Office 365 (license required)        : Press 1
echo                [2] Install Office 2024 Volume                   : Press 2
echo                [3] Install Office 2021 Volume                   : Press 3
echo                [4] Install Office 2019 Volume                   : Press 4
echo                [5] Install Manually using Office Deploy Tool    : Pre
echo                [6] Main Menu                                    : Press 6
echo                ================================================================
Choice /N /C 123456 /M " Press your choice : "
if %ERRORLEVEL% == 6 goto :WindowsOfficeUtils
if %ERRORLEVEL% == 5 call :DownloadOfficeTool & "%temp%\Office Tool\Office Tool Plus.exe" & goto :WindowsOfficeUtils
if %ERRORLEVEL% == 4 set "officeVersion=2019"& set "officeType=Volume"& call :DefineOfficeInstallation& goto :WindowsOfficeUtils
if %ERRORLEVEL% == 3 set "officeVersion=2021"& set "officeType=Volume"& call :DefineOfficeInstallation& goto :WindowsOfficeUtils
if %ERRORLEVEL% == 2 set "officeVersion=2024"& set "officeType=Volume"& call :DefineOfficeInstallation& goto :WindowsOfficeUtils
if %ERRORLEVEL% == 1 set "officeVersion=365"& call :InstallOffice365& goto :WindowsOfficeUtils
endlocal
REM ============================================
REM Stat of install office  online
:InstallOffice365
Title Install Office 365
cls
pushd %temp%
curl -L -o OfficeSetup.exe https://go.microsoft.com/fwlink/p/?linkid=2186291
start OfficeSetup.exe
popd
goto :eof

:DefineOfficeInstallation
cls
@echo off
cd /d %BASE_DIRECTORY%
:: set app id
Set "on=(YES)"
Set "off=(NO)"
Set "optPowerPoint=%off%"
Set "optOneNote=%off%"
Set "optAccess=%off%"
Set "optExcel=%off%"
Set "optWord=%off%"
Set "optOutlook=%off%"
Set "optVisio=%off%"
Set "optProject=%off%"
Set "optTeams=%off%"
Set "optPublisher=%on%"
Set "optOneDrive=%on%"
:SelectOfficeApps
cls
echo Office %officeVersion% %officeType% will be installed with the following components:
echo.
<NUL Set/P=[1] & echo Access      : %optAccess%
<NUL Set/P=[2] & echo Excel       : %optExcel%
<NUL Set/P=[3] & echo Word        : %optWord%
<NUL Set/P=[4] & echo Outlook     : %optOutlook%
<NUL Set/P=[5] & echo PowerPoint  : %optPowerPoint%
<NUL Set/P=[6] & echo OneNote     : %optOneNote%
<NUL Set/P=[7] & echo VisioPro    : %optVisio%
<NUL Set/P=[8] & echo ProjectPro  : %optProject%
<NUL Set/P=[9] & echo Teams       : %optTeams%
<NUL Set/P=[P] & echo Publisher   : %optPublisher%
<NUL Set/P=[D] & echo OneDrive    : %optOneDrive%
echo.
echo List of components to install Office %officeVersion%
<NUL Set/P=[Q] & echo Quit to Office Menu
echo.
CHOICE /c 123456789PDSXQ /n /m "--> Select option(s) and then press [X] to start the installation: "
if %ERRORLEVEL% == 14 goto :DisplayInstallOfficeMenu
if %ERRORLEVEL% == 13 goto :InstallOfficeFromODT
if %ERRORLEVEL% == 12 (if "%optPublisher%"=="%off%" (Set "optPublisher=%on%") Else (Set "optPublisher=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 11 (if "%optOneDrive%"=="%off%" (Set "optOneDrive=%on%") Else (Set "optOneDrive=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 10 (if "%optTeams%"=="%off%" (Set "optTeams=%on%") Else (Set "optTeams=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 9 (if "%optProject%"=="%off%" (Set "optProject=%on%") Else (Set "optProject=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 8 (if "%optVisio%"=="%off%" (Set "optVisio=%on%") Else (Set "optVisio=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 7 (if "%optOneNote%"=="%off%" (Set "optOneNote=%on%") Else (Set "optOneNote=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 6 (if "%optPowerPoint%"=="%off%" (Set "optPowerPoint=%on%") Else (Set "optPowerPoint=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 5 (if "%optOutlook%"=="%off%" (Set "optOutlook=%on%") Else (Set "optOutlook=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 4 (if "%optWord%"=="%off%" (Set "optWord=%on%") Else (Set "optWord=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 3 (if "%optExcel%"=="%off%" (Set "optExcel=%on%") Else (Set "optExcel=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 2 (if "%optAccess%"=="%off%" (Set "optAccess=%on%") Else (Set "optAccess=%off%")) & goto :SelectOfficeApps
if %ERRORLEVEL% == 1 (if "%optPowerPoint%"=="%off%" (Set "optPowerPoint=%on%") Else (Set "optPowerPoint=%off%")) & goto :SelectOfficeApps
goto :SelectOfficeApps

:InstallOfficeFromODT
call :DownloadOfficeTool
pushd %temp%\Office_Tool
if "%optAccess%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"Access%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optExcel%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"Excel%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optWord%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"Word%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optOutlook%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"Outlook%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optPowerPoint%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"PowerPoint%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optOneNote%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"OneNote%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optVisio%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"VisioPro%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optProject%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"ProjectPro%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optTeams%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"Teams%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optPublisher%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"Publisher%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
if "%optOneDrive%"=="%on%" Set "odtConfigXml=%odtConfigXml%<Add OfficeClientEdition=\"64\" Channel=\"%officeType%\"><Product ID=\"OneDrive%officeVersion%Retail\"><Language ID=\"en-us\" /></Product></Add>"
(echo ^<Configuration^>%odtConfigXml%</Configuration^) > %temp%\Office_Tool\configuration.xml
setup.exe /configure configuration.xml
popd
goto :eof

:DownloadOfficeTool
pushd %temp%
curl -L -o Office_Tool.zip https://github.com/YerongAI/Office-Tool/releases/latest/download/Office_Tool_with_runtime_v10.1.5.3.zip
tar -xf Office_Tool.zip
popd
goto :EOF
REM End of install office  online
REM ============================================
REM ============================================
REM Start of Get Office Path
:GetOfficePath
cls
echo off
for %%a in (4,5,6) do (
if exist "%ProgramFiles%\Microsoft Office\Office1%%a\ospp.vbs" (cd /d "%ProgramFiles%\Microsoft Office\Office1%%a"&& set officePath=%cd%)
if exist "%ProgramFiles(x86)%\Microsoft Office\Office1%%a\ospp.vbs" (cd /d "%ProgramFiles(x86)%\Microsoft Office\Office1%%a"&& set officePath=%cd%))
goto :eof

:: Function Menu that selects which edition Windows will convert to
:DisplayLoadSkusMenu
setlocal
cls
Title Load Windows Eddition
echo.
echo        ==================================================
echo        [1] Professional                        : PRESS 1
echo        [2] ProfessionalWorkstation             : PRESS 2
echo        [3] Enterprise                          : PRESS 3
echo        [4] EnterpriseS                         : PRESS 4
echo        [5] IoTEnterprise                       : PRESS 5
echo        [6] Education                           : PRESS 6
echo        [7] LTSC 2016                           : PRESS 7
echo        [8] LTSC 2019                           : PRESS 8
echo        [9] Menu Active Office                  : PRESS 9
echo        ==================================================
Choice /N /C 123456789 /M " Press your choice : "
if %errorlevel% == 1 set windowsKey=VK7JG-NPHTM-C97JM-9MPGT-3V66T&& set windowsEdition=Professional&& goto :LoadWindowsSku
if %errorlevel% == 2 set windowsKey=DXG7C-N36C4-C4HTG-X4T3X-2YV77&& set windowsEdition=ProfessionalWorkstation&& goto :LoadWindowsSku
if %errorlevel% == 3 set windowsKey=XGVPP-NMH47-7TTHJ-W3FW7-8HV2C&& set windowsEdition=Enterprise&& goto :LoadWindowsSku
if %errorlevel% == 4 set windowsKey=NK96Y-D9CD8-W44CQ-R8YTK-DYJWX&& set windowsEdition=EnterpriseS&& goto :LoadWindowsSku
if %errorlevel% == 5 set windowsKey=M7XTQ-FN8P6-TTKYV-9D4CC-J462D&& set windowsEdition=IoTEnterprise&& goto :LoadWindowsSku
if %errorlevel% == 6 set windowsKey=YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY&& set windowsEdition=Education&& goto :LoadWindowsSku
if %errorlevel% == 7 set windowsKey=RW7WN-FMT44-KRGBK-G44WK-QV7YK&& set windowsEdition=wdLTSB2016&& goto :LoadWindowsSku
if %errorlevel% == 8 set windowsKey=M7XTQ-FN8P6-TTKYV-9D4CC-J462D&& set windowsEdition=wdLTSC2019&& goto :LoadWindowsSku
if %errorlevel% == 9 goto :WindowsOfficeUtils
endlocal

:: Loads a specified Windows SKU (edition) using downloaded license files.
:LoadWindowsSku
setlocal
cls
echo off
echo ==================================================================
echo This script will load the specified Windows SKU using the provided license key.
echo Please wait until the process is complete.
echo ==================================================================
ping -n 3 localhost > nul
cscript //nologo %windir%\system32\slmgr.vbs /ipk %windowsKey%
cscript //nologo %windir%\system32\slmgr.vbs /ato
endlocal
goto :EOF

:FixNonCoreActivation
cls
call :hold
goto :WindowsOfficeUtils

:ConvertOfficeEdition
call :hold
goto :WindowsOfficeUtils

REM ============================================
REM Start of Remove Office Keys
:DisplayRemoveOfficeKeyMenu
cls
echo.
echo            =================================================
echo            [1] One by one                          : Press 1
echo            [2] All                                 : Press 2
echo            [3] Back to Windows Office Menu         : Press 3
echo            =================================================
Choice /N /C 123 /M " Press your choice : "
if %ERRORLEVEL% == 3 goto :WindowsOfficeUtils
if %ERRORLEVEL% == 2 call :RemoveOfficeKeyAll & goto :WindowsOfficeUtils
if %ERRORLEVEL% == 1 call :RemoveOfficeKeyOneByOne & goto :WindowsOfficeUtils

:RemoveOfficeKeyOneByOne
cls
setlocal
pushd %officePath%
for /f "tokens=2 delims=: " %%a in ('cscript //nologo ospp.vbs /dstatus ^| findstr /b /c:"Last 5 characters of installed product key"') do (cscript //nologo ospp.vbs /unpkey:%%a)
popd
ping -n 2 localhost 1>NUL
goto :eof

:RemoveOfficeKeyAll
echo off
cls
setlocal
call :GetOfficePath
pushd %officePath%
cscript //nologo ospp.vbs /dstatus | findstr /b /c:"Last 5 characters of installed product key" > %temp%\keys.txt
for /f "tokens=2 delims=: " %%a in (%temp%\keys.txt) do (cscript //nologo ospp.vbs /unpkey:%%a)
del %temp%\keys.txt
popd
goto :eof
REM End of Remove Office Keys
REM ============================================
REM ============================================
REM Start of Uninstall Office
:DisplayUninstallOfficeMenu
cls
echo.
echo            ====================================================
echo            [1] Using Sara Cmd                         : Press 1
echo            [2] Using Office Tool                      : Press 2
echo            [3] Using BCUninstaller                    : Press 3
echo            [4] Back to Windows Office Menu            : Press 4
echo            ====================================================
Choice /N /C 1234 /M " Press your choice : "
if %ERRORLEVEL% == 4 goto :WindowsOfficeUtils
if %ERRORLEVEL% == 3 goto :UninstallOfficeWithBCU
if %ERRORLEVEL% == 2 goto :UninstallOfficeWithODT
if %ERRORLEVEL% == 1 goto :UninstallOfficeWithSaraCmd

:UninstallOfficeWithBCU
cls
Title Uninstall Office Using BulkCrapUninstaller
echo This will install BCUninstaller into your computer
call :checkCompatibility
call :installSoftByWinget Klocman.BulkCrapUninstaller
call :bcuninstaller-Settings
goto :WindowsOfficeUtils

:UninstallOfficeWithODT
Title Uninstall Office Using Office Tool
cls
pushd %temp%
call :DownloadOfficeTool
echo This script will uninstall your Office installation using the Office Tool.
echo Please wait until the wizard has completed the uninstallation process
ping -n 3 localhost > nul
"Office Tool\Office Tool Plus.Console.exe" deploy /rmall /acpteula
goto :WindowsOfficeUtils

:UninstallOfficeWithSaraUI
Title Uninstall Office Using Sara UI
echo This will download (browser download) and install Sara UI for uninstalling Office steps
echo You must install it manually and follow the wizard guide
ping -n 4 localhost 1>NUL
start https://aka.ms/SaRA-officeUninstallFromPC
goto :WindowsOfficeUtils

:: Uninstalls Office completely using the SaRA command-line tool.
:UninstallOfficeWithSaraCmd
Title Uninstall office completely using Sara Cmd
cls
echo This will download and remove office without interactive
pushd %temp%
curl -L -o SaRACmd.zip https://aka.ms/SaRA-office-uninstall
tar -xf SaRACmd.zip
SaRACmd\SaRACmd.exe -S OfficeScrubScenario -AcceptEula
popd
cd /d %dp%
cls
goto :WindowsOfficeUtils

REM End of Remove Office Keys
REM ============================================
REM End of Windows Office Utilities functions
REM ========================================================================================================================
================
:DisplayLicenseMenu
echo.
echo        ========================================================
echo        [1] Online                                     : Press 1
echo        [2] By Phone                                   : Press 2
echo        [3] Check License Status                       : Press 3
echo        [4] Backup License                             : Press 4
echo        [5] Restore License                            : Press 5
echo        [6] MAS (Microsoft Activation Scripts)         : Press 6
echo        [7] Back to Main Menu                          : Press 7
echo        ========================================================
goto :eof

:LicenseUtils
REM Start of Active Licenses Menu
setlocal
Title Active Licenses Menu
cls
call :DisplayLicenseMenu
Choice /N /C 1234567 /M " Press your choice : "
if %ERRORLEVEL% == 7 goto :LoopMainMenu
if %ERRORLEVEL% == 6 goto :RunMicrosoftActivationScripts
if %ERRORLEVEL% == 5 goto :RestoreLicenses
if %ERRORLEVEL% == 4 goto :DisplayBackupMenu
if %ERRORLEVEL% == 3 goto :CheckLicenseStatus
if %ERRORLEVEL% == 2 goto :ActivateByPhone
if %ERRORLEVEL% == 1 goto :ActivateOnline
endlocal

REM End of Active Licenses Menu
REM ==============================================================
::@ Start of Active Lienses functions
:RunMicrosoftActivationScripts
cls
REM call :hold
pushd %temp%
start powershell.exe -command "irm https://get.activated.win | iex"
popd
cd %dp%
cls
goto :LicenseUtils

:RestoreLicenses
cls
call :hold
goto :LicenseUtils

REM ============================================
REM Start of Backup License Windows & Office
:DisplayBackupMenu
Title Backup License Windows ^& Office
echo.
echo            =================================================
echo            [1] BACKUP To Local                     : Press 1
echo            [2] BACKUP To NAS STORAGE               : Press 2
echo            [3] Back to Main Menu                   : Press 3
echo            =================================================
Choice /N /C 123 /M " Press your choice : "
if %ERRORLEVEL% == 3 goto :LicenseUtils
if %ERRORLEVEL% == 2 goto :BackupToNas
if %ERRORLEVEL% == 1 goto :BackupToLocal

:BackupToNas
goto :DisplayBackupMenu

:BackupToLocal
call :hold
goto :DisplayBackupMenu
REM End of Backup License Windows & Office
REM ============================================
:CheckLicenseStatus
cls
call :hold
goto :LicenseUtils

:ActivateByPhone
cls
call :hold
goto :LicenseUtils

:ActivateOnline
cls
call :hold
goto :LicenseUtils
REM End of Active Lienses functions
REM ========================================================================================================================
================
:displayUtilitiesMenu
echo.
echo        =================================================
echo        [1] Set High Performance                : Press 1
echo        [2] Change hostname                     : Press 2
echo        [3] Clean up System                     : Press 3
echo        [4] Chris Titus Tech Windows Utility    : Press 4
echo        [5] Install Support Assistant           : Press 5
echo        [6] Active IDM                          : Press 6
echo        [7] Windows Debloat                     : Press 7
echo        [8] Back to Main Menu                   : Press 8
echo        =================================================
goto :eof

:UtilitiesMenu
setlocal
REM Start of Utilities Menu
cls
title Utilities Main Menu
call :displayUtilitiesMenu
Choice /N /C 12345678 /M " Press your choice : "
if %ERRORLEVEL% == 8 goto :MainMenuLoop
if %ERRORLEVEL% == 7 goto :debloat & goto :UtilitiesMenu
if %ERRORLEVEL% == 6 call :activeIdm & goto :UtilitiesMenu
if %ERRORLEVEL% == 5 goto :installSupportAssistant
if %ERRORLEVEL% == 4 call :winUtil & goto :UtilitiesMenu
if %ERRORLEVEL% == 3 goto :cleanUpSystem & goto :UtilitiesMenu
if %ERRORLEVEL% == 2 goto :changeHostName & goto :UtilitiesMenu
if %ERRORLEVEL% == 1 goto :setHighPerformance & goto :UtilitiesMenu
endlocal
REM End of Utilities Menu
REM ==============================================================
REM Start of Utilities functions
:winUtil
:: call https://github.com/ChrisTitusTech/winutil Powershell
start powershell -command "irm "https://christitus.com/win" | iex"
goto :EOF

:debloat
start powershell -command "iwr -useb https://git.io/debloat|iex"
goto :EOF

:setHighPerformance
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
goto :EOF

:GetUserInformation
echo Enter new username that you'd like to add:
set /p user=

REM Prompt user to set password or not
:inputPass
echo Do you want to set a password for %user%? [Y/N]
set /p setpass=

if /i %setpass% == y (
set /p pass=Enter password:
net user %user% %pass% /add 2>nul
cls
) else if /i %setpass% == n (
net user %user% "" /add 2>nul
cls
) else (
echo Invalid input. Please try again.
goto :inputPass
cls
)
goto :EOF

:addUserToAdmins
REM This function adds the user to the Administrators group.
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
goto :UtilitiesMenu

:addUserToUsers
REM This function adds the user to the Users group.
call :GetUserInformation
echo User %user% was added to users group.
ping -n 2 localhost 1>NUL
cls
goto :UtilitiesMenu

:restartPc
cls
echo This will force restart computer with 5s
shutdown -r -t 5 -f
goto :UtilitiesMenu

:installSupportAssistant
Title Install Support Assistant
setlocal
echo This script will automatically detect your computer's brand (Dell, HP, or Lenovo) and install the appropriate support assistant software.
ping -n 3 localhost 1>NUL
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
goto :UtilitiesMenu


:joinDomain
setlocal
set /p server=Enter the FQDN of the domain controller:
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
goto :UtilitiesMenu

REM This function will use Windows Disk Cleanup to remove unnecessary files
:cleanUpSystem
Title Clean up System
echo This script will use Windows Disk Cleanup to remove unnecessary files.
echo Please wait until the wizard has completed the cleanup process.
ping -n 3 localhost > nul
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Delivery Optimization Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags0001 /t REG_DWORD /d 00000002 /f
cls
cleanmgr /sagerun:1
goto :UtilitiesMenu

:changeHostName
Title Change host name
setlocal
set /p _newComputername=Enter new computer name:
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
    goto :UtilitiesMenu

:settingWindows
cls
echo This script will perform some basic Windows settings.
echo Please wait until the process is complete.
ping -n 3 localhost > nul
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
powershell.exe -command "Install-Module PSWindowsUpdate -Force -Confirm:$false; Import-Module PSWindowsUpdate; Get-WindowsUpdate -AcceptAll -Install"
echo Install some basic softwares
call :installSoftByWinget "7-Zip.7-Zip"
call :installSoftByWinget "Google.Chrome"
call :installSoftByWinget "Mozilla.Firefox"
call :installSoftByWinget "Microsoft.Edge"
call :installSoftByWinget "Adobe.Acrobat.Reader.64-bit"
call :installSoftByWinget "VideoLAN.VLC"
call :installSoftByWinget "WinRAR"
call :installSoftByWinget "TeamViewer.TeamViewer"
call :installSoftByWinget "AnyDesk"
call :installSoftByWinget "UltraViewer.UltraViewer"
call :installSoftByWinget "SlackTechnologies.Slack"
call :installSoftByWinget "Zoom.Zoom"
call :installSoftByWinget "Microsoft.Teams"
call :installSoftByWinget "Discord"
call :installSoftByWinget "Telegram.TelegramDesktop"
call :installSoftByWinget "Viber.Viber"
call :installSoftByWinget "WhatsApp.WhatsApp"
call :installSoftByWinget "Zalo.Zalo"
call :installSoftByWinget "Skype"
call :installSoftByWinget "Signal.Signal"
call :installSoftByWinget "Notepad++.Notepad++"
call :installSoftByWinget "SublimeHQ.SublimeText.4"
call :installSoftByWinget "Microsoft.VisualStudioCode"
call :installSoftByWinget "JetBrains.IntelliJIDEA.Community"
call :installSoftByWinget "JetBrains.PyCharm.Community"
call :installSoftByWinget "JetBrains.WebStorm"
call :installSoftByWinget "JetBrains.DataGrip"
call :installSoftByWinget "JetBrains.GoLand"
call :installSoftByWinget "JetBrains.Rider"
call :installSoftByWinget "JetBrains.CLion"
call :installSoftByWinget "JetBrains.AndroidStudio"
call :installSoftByWinget "Docker.DockerDesktop"
call :installSoftByWinget "Git.Git"
call :installSoftByWinget "GitHub.cli"
call :installSoftByWinget "Python.Python.3"
call :installSoftByWinget "Oracle.Java.JDK"
call :installSoftByWinget "Microsoft.dotnet.SDK"
call :installSoftByWinget "Node.js.LTS"
call :installSoftByWinget "Google.Go"
call :installSoftByWinget "Rustlang.Rust.MSVC"
call :installSoftByWinget "Ruby.Ruby"
call :installSoftByWinget "PowerShell.PowerShell"
call :installSoftByWinget "Microsoft.WindowsTerminal"
call :installSoftByWinget "Gerardog.gsudo"
call :installSoftByWinget "JanDeDobbeleer.OhMyPosh"
call :installSoftByWinget "ShareX.ShareX"
call :installSoftByWinget "GIMP.GIMP"
call :installSoftByWinget "Inkscape.Inkscape"
call :installSoftByWinget "KDE.Krita"
call :installSoftByWinget "Blender.Blender"
call :installSoftByWinget "Audacity.Audacity"
call :installSoftByWinget "OBSProject.OBSStudio"
call :installSoftByWinget "HandBrake.HandBrake"
call :installSoftByWinget "KeePassXCTeam.KeePassXC"
call :installSoftByWinget "Bitwarden.Bitwarden"
call :installSoftByWinget "1Password.1Password"
call :installSoftByWinget "LastPass.LastPass"
call :installSoftByWinget "Dashlane.Dashlane"
call :installSoftByWinget "NordVPN.NordVPN"
call :installSoftByWinget "Proton.VPN"
call :installSoftByWinget "ExpressVPN.ExpressVPN"
call :installSoftByWinget "CyberGhost.VPN"
call :installSoftByWinget "Surfshark.Surfshark"
call :installSoftByWinget "PrivateInternetAccess.PrivateInternetAccess"
call :installSoftByWinget "Mullvad.VPN"
call :installSoftByWinget "Windscribe.Windscribe"
call :installSoftByWinget "TunnelBear.TunnelBear"
call :installSoftByWinget "HotspotShield.HotspotShield"
call :installSoftByWinget "Proton.Mail"
call :installSoftByWinget "Tutanota.Tutanota"
call :installSoftByWinget "StandardNotes.StandardNotes"
call :installSoftByWinget "Joplin.Joplin"
call :installSoftByWinget "Obsidian.Obsidian"
call :installSoftByWinget "Logseq.Logseq"
call :installSoftByWinget "Notion.Notion"
call :installSoftByWinget "Evernote.Evernote"
call :installSoftByWinget "Todoist.Todoist"
call :installSoftByWinget "TickTick.TickTick"
call :installSoftByWinget "Any.do"
call :installSoftByWinget "Microsoft.Todo"
call :installSoftByWinget "Google.Keep"
call :installSoftByWinget "Simplenote.Simplenote"
call :installSoftByWinget "Spotify.Spotify"
call :installSoftByWinget "Apple.iTunes"
call :installSoftByWinget "Amazon.Music"
call :installSoftByWinget "Google.PlayMusic"
call :installSoftByWinget "Deezer.Deezer"
call :installSoftByWinget "TIDAL.TIDAL"
call :installSoftByWinget "Pandora.Pandora"
call :installSoftByWinget "SoundCloud.SoundCloud"
call :installSoftByWinget "Bandcamp.Bandcamp"
call :installSoftByWinget "Netflix.Netflix"
call :installSoftByWinget "Hulu.Hulu"
call :installSoftByWinget "Disney.Plus"
call :installSoftByWinget "HBOMax.HBOMax"
call :installSoftByWinget "Amazon.PrimeVideo"
call :installSoftByWinget "YouTube.YouTube"
call :installSoftByWinget "Twitch.Twitch"
call :installSoftByWinget "Steam.Steam"
call :installSoftByWinget "EpicGames.EpicGamesLauncher"
call :installSoftByWinget "GOG.Galaxy"
call :installSoftByWinget "Ubisoft.Connect"
call :installSoftByWinget "ElectronicArts.EADesktop"
call :installSoftByWinget "Battle.net"
call :installSoftByWinget "RiotGames.RiotClient"
call :installSoftByWinget "Valve.Steam"
call :installSoftByWinget "Discord.Discord"
call :installSoftByWinget "Parsec.Parsec"
call :installSoftByWinget "Rainmeter.Rainmeter"
call :installSoftByWinget "WallpaperEngine.WallpaperEngine"
call :installSoftByWinget "Fences.Fences"
call :installSoftByWinget "StartIsBack.StartIsBack"
call :installSoftByWinget "OpenShell.OpenShell"
call :installSoftByWinget "ClassicShell.ClassicShell"
call :installSoftByWinget "Winaero.WinaeroTweaker"
call :installSoftByWinget "Sysinternals.ProcessExplorer"
call :installSoftByWinget "Sysinternals.ProcessMonitor"
call :installSoftByWinget "Sysinternals.Autoruns"
call :installSoftByWinget "Sysinternals.TCPView"
call :installSoftByWinget "NirSoft.NirLauncher"
call :installSoftByWinget "Piriform.CCleaner"
call :installSoftByWinget "Piriform.Defraggler"
call :installSoftByWinget "Piriform.Recuva"
call :installSoftByWinget "Piriform.Speccy"
call :installSoftByWinget "Malwarebytes.Malwarebytes"
call :installSoftByWinget "SUPERAntiSpyware.SUPERAntiSpyware"
call :installSoftByWinget "AdwCleaner.AdwCleaner"
call :installSoftByWinget "HitmanPro.HitmanPro"
call :installSoftByWinget "Zemana.AntiMalware"
call :installSoftByWinget "ESET.OnlineScanner"
call :installSoftByWinget "Kaspersky.VirusRemovalTool"
call :installSoftByWinget "McAfee.Stinger"
call :install-unikey
call :create-shortcut
goto :eof

:create-shortcut
set "startProgram=%ProgramFiles%\Microsoft Office\root\Office16"
set "AllUsersProfile=%PUBLIC%\Desktop"
COPY /Y "%startProgram%\WINWORD.EXE" "%AllUsersProfile%\Word.lnk"
COPY /Y "%startProgram%\EXCEL.EXE" "%AllUsers-Profile%\Excel.lnk"
COPY /Y "%startProgram%\POWERPNT.EXE" "%AllUsersProfile%\PowerPoint.lnk"
COPY /Y "%startProgram%\OUTLOOK.EXE" "%AllUsersProfile%\Outlook.lnk"
COPY /Y "%startProgram%\ONENOTE.EXE" "%AllUsersProfile%\OneNote.lnk"
COPY /Y "%startProgram%\MSPUB.EXE" "%AllUsersProfile%\Publisher.lnk"
COPY /Y "%startProgram%\MSACCESS.EXE" "%AllUsersProfile%\Access.lnk"
COPY /Y "%startProgram%\Teams.exe" "%AllUsersProfile%\Teams.lnk"
COPY /Y "%startProgram%\OneDrive.exe" "%AllUsersProfile%\OneDrive.lnk"
COPY /Y "%ProgramFiles%\Windows NT\Accessories\wordpad.exe" "%AllUsersProfile%\Wordpad.lnk"
COPY /Y "%SystemRoot%\system32\notepad.exe" "%AllUsersProfile%\Notepad.lnk"
COPY /Y "%SystemRoot%\system32\calc.exe" "%AllUsersProfile%\Calculator.lnk"
COPY /Y "%SystemRoot%\system32\mspaint.exe" "%AllUsersProfile%\Paint.lnk"
COPY /Y "%SystemRoot%\system32\SnippingTool.exe" "%AllUsersProfile%\Snipping Tool.lnk"
COPY /Y "%ProgramFiles%\Internet Explorer\iexplore.exe" "%AllUsersProfile%\Internet Explorer.lnk"
COPY /Y "%ProgramFiles%\Mozilla Firefox\firefox.exe" "%AllUsersProfile%\Firefox.lnk"
COPY /Y "%ProgramFiles%\Google\Chrome\Application\chrome.exe" "%AllUsersProfile%\Google Chrome.lnk"
COPY /Y "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" "%AllUsersProfile%\Microsoft Edge.lnk"
COPY /Y "%ProgramFiles%\VideoLAN\VLC\vlc.exe" "%AllUsersProfile%\VLC media player.lnk"
COPY /Y "%ProgramFiles%\WinRAR\WinRAR.exe" "%AllUsersProfile%\WinRAR.lnk"
COPY /Y "%ProgramFiles%\7-Zip\7zFM.exe" "%AllUsersProfile%\7-Zip File Manager.lnk"
COPY /Y "%ProgramFiles%\Notepad++\notepad++.exe" "%AllUsersProfile%\Notepad++.lnk"
COPY /Y "%ProgramFiles%\Sublime Text 3\sublime_text.exe" "%AllUsersProfile%\Sublime Text.lnk"
COPY /Y "%ProgramFiles%\Microsoft VS Code\Code.exe" "%AllUsersProfile%\Visual Studio Code.lnk"
COPY /Y "%ProgramFiles%\Git\git-bash.exe" "%AllUsersProfile%\Git Bash.lnk"
COPY /Y "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" "%AllUsersProfile%\Docker Desktop.lnk"
COPY /Y "%ProgramFiles%\Oracle\VirtualBox\VirtualBox.exe" "%AllUsersProfile%\VirtualBox.lnk"
COPY /Y "%ProgramFiles%\TeamViewer\TeamViewer.exe" "%AllUsersProfile%\TeamViewer.lnk"
COPY /Y "%ProgramFiles%\AnyDesk\AnyDesk.exe" "%AllUsersProfile%\AnyDesk.lnk"
COPY /Y "%ProgramFiles%\UltraViewer\UltraViewer_Desktop.exe" "%AllUsersProfile%\UltraViewer.lnk"
COPY /Y "%AppData%\Zoom\bin\Zoom.exe" "%AllUsersProfile%\Zoom.lnk"
COPY /Y "%AppData%\Microsoft\Teams\current\Teams.exe" "%AllUsersProfile%\Microsoft Teams.lnk"
COPY /Y "%AppData%\Discord\Update.exe" --processStart Discord.exe "%AllUsersProfile%\Discord.lnk"
COPY /Y "%AppData%\Telegram Desktop\Telegram.exe" "%AllUsersProfile%\Telegram.lnk"
COPY /Y "%AppData%\Viber\Viber.exe" "%AllUsersProfile%\Viber.lnk"
COPY /Y "%AppData%\WhatsApp\WhatsApp.exe" "%AllUsersProfile%\WhatsApp.lnk"
COPY /Y "%AppData%\Signal\Signal.exe" "%AllUsersProfile%\Signal.lnk"
COPY /Y "%AppData%\Skype\Skype.exe" "%AllUsersProfile%\Skype.lnk"
COPY /Y "%AppData%\Zalo\Zalo.exe" "%AllUsersProfile%\Zalo.lnk"
COPY /Y "%ProgramFiles%\Slack\slack.exe" "%AllUsersProfile%\Slack.lnk"
COPY /Y "%ProgramFiles%\Everything\Everything.exe" "%AllUsersProfile%\Everything.lnk"
COPY /Y "%ProgramFiles%\Classic Shell\ClassicStartMenu.exe" "%AllUsersProfile%\Classic Start Menu.lnk"
COPY /Y "%ProgramFiles%\Open-Shell\StartMenu\OpenShellStartMenu.exe" "%AllUsersProfile%\Open-Shell Start Menu.lnk"
COPY /Y "%ProgramFiles%\Winaero Tweaker\WinaeroTweaker.exe" "%AllUsersProfile%\Winaero Tweaker.lnk"
COPY /Y "%ProgramFiles%\SysinternalsSuite\procexp.exe" "%AllUsersProfile%\Process Explorer.lnk"
COPY /Y "%ProgramFiles%\SysinternalsSuite\procmon.exe" "%AllUsers-Profile%\Process Monitor.lnk"
COPY /Y "%ProgramFiles%\SysinternalsSuite\autoruns.exe" "%AllUsersProfile%\Autoruns.lnk"
COPY /Y "%ProgramFiles%\SysinternalsSuite\tcpview.exe" "%AllUsersProfile%\TCPView.lnk"
COPY /Y "%ProgramFiles%\NirLauncher\NirLauncher.exe" "%AllUsersProfile%\NirLauncher.lnk"
COPY /Y "%ProgramFiles%\CCleaner\CCleaner.exe" "%AllUsersProfile%\CCleaner.lnk"
COPY /Y "%ProgramFiles%\Defraggler\Defraggler.exe" "%AllUsersProfile%\Defraggler.lnk"
COPY /Y "%ProgramFiles%\Recuva\Recuva.exe" "%AllUsersProfile%\Recuva.lnk"
COPY /Y "%ProgramFiles%\Speccy\Speccy.exe" "%AllUsersProfile%\Speccy.lnk"
COPY /Y "%ProgramFiles%\Malwarebytes\Anti-Malware\mbam.exe" "%AllUsersProfile%\Malwarebytes.lnk"
COPY /Y "%ProgramFiles%\SUPERAntiSpyware\SUPERAntiSpyware.exe" "%AllUsersProfile%\SUPERAntiSpyware.lnk"
COPY /Y "%ProgramFiles%\AdwCleaner\AdwCleaner.exe" "%AllUsersProfile%\AdwCleaner.lnk"
COPY /Y "%ProgramFiles%\HitmanPro\HitmanPro.exe" "%AllUsersProfile%\HitmanPro.lnk"
COPY /Y "%ProgramFiles%\Zemana\AntiMalware\Zemana.exe" "%AllUsersProfile%\Zemana AntiMalware.lnk"
COPY /Y "%ProgramFiles%\ESET\ESET Online Scanner\ESETOnlineScanner.exe" "%AllUsersProfile%\ESET Online Scanner.lnk"
COPY /Y "%ProgramFiles%\Kaspersky Lab\Kaspersky Virus Removal Tool\KVRT.exe" "%AllUsersProfile%\Kaspersky Virus Removal Tool.lnk"
COPY /Y "%ProgramFiles%\McAfee\Stinger\Stinger.exe" "%AllUsersProfile%\McAfee Stinger.lnk"
COPY /Y "%ProgramFiles%\ShareX\ShareX.exe" "%AllUsersProfile%\ShareX.lnk"
COPY /Y "%ProgramFiles%\GIMP 2\bin\gimp-2.10.exe" "%AllUsersProfile%\GIMP.lnk"
COPY /Y "%ProgramFiles%\Inkscape\bin\inkscape.exe" "%AllUsersProfile%\Inkscape.lnk"
COPY /Y "%ProgramFiles%\Krita (x64)\bin\krita.exe" "%AllUsersProfile%\Krita.lnk"
COPY /Y "%ProgramFiles%\Blender Foundation\Blender\blender.exe" "%AllUsersProfile%\Blender.lnk"
COPY /Y "%ProgramFiles%\Audacity\audacity.exe" "%AllUsersProfile%\Audacity.lnk"
COPY /Y "%ProgramFiles (x86)%\OBS Studio\bin\64bit\obs64.exe" "%AllUsersProfile%\OBS Studio.lnk"
COPY /Y "%ProgramFiles%\HandBrake\HandBrake.exe" "%AllUsersProfile%\HandBrake.lnk"
COPY /Y "%ProgramFiles%\KeePassXC\KeePassXC.exe" "%AllUsersProfile%\KeePassXC.lnk"
COPY /Y "%ProgramFiles%\Bitwarden\Bitwarden.exe" "%AllUsersProfile%\Bitwarden.lnk"
COPY /Y "%ProgramFiles%\1Password\1Password.exe" "%AllUsersProfile%\1Password.lnk"
COPY /Y "%ProgramFiles%\LastPass\LastPass.exe" "%AllUsersProfile%\LastPass.lnk"
COPY /Y "%ProgramFiles%\Dashlane\Dashlane.exe" "%AllUsersProfile%\Dashlane.lnk"
COPY /Y "%ProgramFiles%\NordVPN\NordVPN.exe" "%AllUsersProfile%\NordVPN.lnk"
COPY /Y "%ProgramFiles%\Proton\VPN\ProtonVPN.exe" "%AllUsersProfile%\ProtonVPN.lnk"
COPY /Y "%ProgramFiles%\ExpressVPN\expressvpn-ui\ExpressVPN.exe" "%AllUsersProfile%\ExpressVPN.lnk"
COPY /Y "%ProgramFiles%\CyberGhost 8\CyberGhost.exe" "%AllUsersProfile%\CyberGhost VPN.lnk"
COPY /Y "%ProgramFiles%\Surfshark\Surfshark.exe" "%AllUsersProfile%\Surfshark.lnk"
COPY /Y "%ProgramFiles%\Private Internet Access\pia-client.exe" "%AllUsersProfile%\Private Internet Access.lnk"
COPY /Y "%ProgramFiles%\Mullvad VPN\Mullvad VPN.exe" "%AllUsersProfile%\Mullvad VPN.lnk"
COPY /Y "%ProgramFiles%\Windscribe\Windscribe.exe" "%AllUsersProfile%\Windscribe.lnk"
COPY /Y "%ProgramFiles%\TunnelBear\TunnelBear.exe" "%AllUsersProfile%\TunnelBear.lnk"
COPY /Y "%ProgramFiles%\Hotspot Shield\bin\hsscp.exe" "%AllUsersProfile%\Hotspot Shield.lnk"
COPY /Y "%ProgramFiles%\Proton\Mail\ProtonMail.exe" "%AllUsersProfile%\ProtonMail.lnk"
COPY /Y "%ProgramFiles%\Tutanota Desktop\Tutanota Desktop.exe" "%AllUsersProfile%\Tutanota.lnk"
COPY /Y "%ProgramFiles%\Standard Notes\Standard Notes.exe" "%AllUsersProfile%\Standard Notes.lnk"
COPY /Y "%ProgramFiles%\Joplin\Joplin.exe" "%AllUsersProfile%\Joplin.lnk"
COPY /Y "%ProgramFiles%\Obsidian\Obsidian.exe" "%AllUsersProfile%\Obsidian.lnk"
COPY /Y "%ProgramFiles%\Logseq\Logseq.exe" "%AllUsersProfile%\Logseq.lnk"
COPY /Y "%ProgramFiles%\Notion\Notion.exe" "%AllUsersProfile%\Notion.lnk"
COPY /Y "%ProgramFiles%\Evernote\Evernote\Evernote.exe" "%AllUsersProfile%\Evernote.lnk"
COPY /Y "%ProgramFiles%\Todoist\Todoist.exe" "%AllUsersProfile%\Todoist.lnk"
COPY /Y "%ProgramFiles%\TickTick\TickTick.exe" "%AllUsersProfile%\TickTick.lnk"
COPY /Y "%ProgramFiles%\Any.do\Any.do.exe" "%AllUsersProfile%\Any.do.lnk"
COPY /Y "%ProgramFiles%\Microsoft To Do\Todo.exe" "%AllUsersProfile%\Microsoft To Do.lnk"
COPY /Y "%ProgramFiles%\Google\Keep\Google Keep.exe" "%AllUsersProfile%\Google Keep.lnk"
COPY /Y "%ProgramFiles%\Simplenote\Simplenote.exe" "%AllUsersProfile%\Simplenote.lnk"
COPY /Y "%ProgramFiles%\Spotify\Spotify.exe" "%AllUsersProfile%\Spotify.lnk"
COPY /Y "%ProgramFiles%\iTunes\iTunes.exe" "%AllUsersProfile%\iTunes.lnk"
COPY /Y "%ProgramFiles%\Amazon Music\Amazon Music.exe" "%AllUsersProfile%\Amazon Music.lnk"
COPY /Y "%ProgramFiles%\Google\Play Music\Google Play Music.exe" "%AllUsersProfile%\Google Play Music.lnk"
COPY /Y "%ProgramFiles%\Deezer\Deezer.exe" "%AllUsersProfile%\Deezer.lnk"
COPY /Y "%ProgramFiles%\TIDAL\TIDAL.exe" "%AllUsersProfile%\TIDAL.lnk"
COPY /Y "%ProgramFiles%\Pandora\Pandora.exe" "%AllUsersProfile%\Pandora.lnk"
COPY /Y "%ProgramFiles%\SoundCloud\SoundCloud.exe" "%AllUsersProfile%\SoundCloud.lnk"
COPY /Y "%ProgramFiles%\Bandcamp\Bandcamp.exe" "%AllUsersProfile%\Bandcamp.lnk"
COPY /Y "%ProgramFiles%\Netflix\Netflix.exe" "%AllUsersProfile%\Netflix.lnk"
COPY /Y "%ProgramFiles%\Hulu\Hulu.exe" "%AllUsersProfile%\Hulu.lnk"
COPY /Y "%ProgramFiles%\Disney+\DisneyPlus.exe" "%AllUsersProfile%\Disney+.lnk"
COPY /Y "%ProgramFiles%\HBO Max\HBO Max.exe" "%AllUsersProfile%\HBO Max.lnk"
COPY /Y "%ProgramFiles%\Amazon Prime Video\Amazon Prime Video.exe" "%AllUsersProfile%\Amazon Prime Video.lnk"
COPY /Y "%ProgramFiles%\YouTube\YouTube.exe" "%AllUsersProfile%\YouTube.lnk"
COPY /Y "%ProgramFiles%\Twitch\Twitch.exe" "%AllUsersProfile%\Twitch.lnk"
COPY /Y "%ProgramFiles%\Steam\Steam.exe" "%AllUsersProfile%\Steam.lnk"
COPY /Y "%ProgramFiles%\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe" "%AllUsersProfile%\Epic Games Launcher.lnk"
COPY /Y "%ProgramFiles%\GOG Galaxy\GalaxyClient.exe" "%AllUsersProfile%\GOG Galaxy.lnk"
COPY /Y "%ProgramFiles%\Ubisoft\Ubisoft Game Launcher\UbisoftGameLauncher.exe" "%AllUsersProfile%\Ubisoft Connect.lnk"
COPY /Y "%ProgramFiles%\Electronic Arts\EA Desktop\EA Desktop\EADesktop.exe" "%AllUsersProfile%\EA Desktop.lnk"
COPY /Y "%ProgramFiles%\Battle.net\Battle.net Launcher.exe" "%AllUsersProfile%\Battle.net.lnk"
COPY /Y "%ProgramFiles%\Riot Games\Riot Client\RiotClientServices.exe" "%AllUsersProfile%\Riot Client.lnk"
COPY /Y "%ProgramFiles%\Valve\Steam\steam.exe" "%AllUsersProfile%\Valve Steam.lnk"
COPY /Y "%ProgramFiles%\Discord\Update.exe" --processStart Discord.exe "%AllUsersProfile%\Discord.lnk"
COPY /Y "%ProgramFiles%\Parsec\ps_core.exe" "%AllUsersProfile%\Parsec.lnk"
COPY /Y "%ProgramFiles%\Rainmeter\Rainmeter.exe" "%AllUsersProfile%\Rainmeter.lnk"
COPY /Y "%ProgramFiles%\Wallpaper Engine\wallpaper32.exe" "%AllUsersProfile%\Wallpaper Engine.lnk"
COPY /Y "%ProgramFiles%\Stardock\Fences\Fences.exe" "%AllUsersProfile%\Fences.lnk"
COPY /Y "%ProgramFiles%\StartIsBack\StartIsBack.exe" "%AllUsersProfile%\StartIsBack.lnk"
COPY /Y "%ProgramFiles%\Open-Shell\StartMenu\OpenShellStartMenu.exe" "%AllUsersProfile%\Open-Shell.lnk"
COPY /Y "%ProgramFiles%\Classic Shell\ClassicStartMenu.exe" "%AllUsersProfile%\Classic Shell.lnk"
COPY /Y "%ProgramFiles%\Winaero Tweaker\WinaeroTweaker.exe" "%AllUsersProfile%\Winaero Tweaker.lnk"
COPY /Y "%ProgramFiles%\Sysinternals\procexp.exe" "%AllUsersProfile%\Process Explorer.lnk"
COPY /Y "%ProgramFiles%\Sysinternals\procmon.exe" "%AllUsersProfile%\Process Monitor.lnk"
COPY /Y "%ProgramFiles%\Sysinternals\autoruns.exe" "%AllUsersProfile%\Autoruns.lnk"
COPY /Y "%ProgramFiles%\Sysinternals\tcpview.exe" "%AllUsersProfile%\TCPView.lnk"
COPY /Y "%ProgramFiles%\NirSoft\nirlauncher.exe" "%AllUsersProfile%\NirLauncher.lnk"
COPY /Y "%ProgramFiles%\Piriform\CCleaner\CCleaner.exe" "%AllUsersProfile%\CCleaner.lnk"
COPY /Y "%ProgramFiles%\Piriform\Defraggler\Defraggler.exe" "%AllUsersProfile%\Defraggler.lnk"
COPY /Y "%ProgramFiles%\Piriform\Recuva\Recuva.exe" "%AllUsersProfile%\Recuva.lnk"
COPY /Y "%ProgramFiles%\Piriform\Speccy\Speccy.exe" "%AllUsersProfile%\Speccy.lnk"
COPY /Y "%ProgramFiles%\Malwarebytes\Anti-Malware\mbam.exe" "%AllUsersProfile%\Malwarebytes Anti-Malware.lnk"
COPY /Y "%ProgramFiles%\SUPERAntiSpyware\SUPERAntiSpyware.exe" "%AllUsersProfile%\SUPERAntiSpyware.lnk"
COPY /Y "%ProgramFiles%\AdwCleaner\AdwCleaner.exe" "%AllUsersProfile%\AdwCleaner.lnk"
COPY /Y "%ProgramFiles%\HitmanPro\HitmanPro.exe" "%AllUsersProfile%\HitmanPro.lnk"
COPY /Y "%ProgramFiles%\Zemana\AntiMalware\Zemana AntiMalware.exe" "%AllUsersProfile%\Zemana AntiMalware.lnk"
COPY /Y "%ProgramFiles%\ESET\ESET Online Scanner\ESETOnlineScanner.exe" "%AllUsersProfile%\ESET Online Scanner.lnk"
COPY /Y "%ProgramFiles%\Kaspersky Lab\Kaspersky Virus Removal Tool\KVRT.exe" "%AllUsersProfile%\Kaspersky Virus Removal Tool.lnk"
COPY /Y "%ProgramFiles%\McAfee\Stinger\stinger.exe" "%AllUsersProfile%\McAfee Stinger.lnk"
goto :eof

:displayPackageManagerMenu
echo.
echo        ====================================================
echo        [1] Install Package Management             : Press 1
echo        [2] Install End Users Applications         : Press 2
echo        [3] Install Remote Applications            : Press 3
echo        [4] Install Network Applications           : Press 4
echo        [5] Install Chat Applications              : Press 5
echo        [6] Update All                             : Press 6
echo        [7] Back to Main Menu                      : Press 7
echo        ====================================================
goto :eof

:PackageManagerMenu
cls
title Package Management Software Main Menu

:: Define menu mapping
set "pkg_menu[1]=packageManagement"
set "pkg_menu[2]=installEndUsers"
set "pkg_menu[3]=installRemoteApps"
set "pkg_menu[4]=installNetworkApps"
set "pkg_menu[5]=installChatApps"
set "pkg_menu[6]=updateAll"
set "pkg_menu[7]=MainMenuLoop"

:: Display menu
call :displayPackageManagerMenu
choice /n /c 1234567 /m "Press your choice (1-7):"

set "USER_CHOICE=%errorlevel%"
call :dispatchMenu pkg_menu USER_CHOICE
goto :PackageManagerMenu


:updateAll
Title Update Softwares
call :checkCompatibility
cls
echo Update Winget packages
echo y | winget upgrade -h --all
ping -n 2 localhost > nul
cls
echo Update Chocolatey packages
call :killTasks
echo Task done!
ping -n 2 localhost > nul
goto :EOF

:wingetDeskjob
cls
call :hold
goto :EOF

:installEndUsers
cls
Title Install End User Softwares
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install End Users Applications...
    call :wingetEndUsers
) else (
    echo [*] Winget not found. Switching to Chocolatey...
    call :chocoEndUsers
)
goto :EOF

:installRemoteApps
cls
Title Install Remote Apps
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install Remote Applications...
    call :wingetRemoteSupport
) else (
    echo [*] Winget not found. Switching to Chocolatey for Remote Applications...
    call :chocoRemoteSupport
)
goto :EOF

:installNetworkApps
cls
Title Install Network Apps
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install Network Applications...
    call :wingetNetwork
) else (
    echo [*] Winget not found. Switching to Chocolatey for Network Applications...
    call :chocoNetwork
)
goto :EOF

:installChatApps
cls
Title Install Chat Apps
where winget >nul 2>&1
if %errorlevel%==0 (
    echo [*] Using Winget to install Chat Applications...
    call :wingetChat
) else (
    echo [*] Winget not found. Switching to Chocolatey for Chat Applications...
    call :chocoChat
)
goto :EOF

:chocoNetwork
cls
Title Install Network softwares by Chocolatey
call :checkCompatibility
setlocal
set "packageList=mobaxterm wireshark nmap zenmap"
echo Installing Network softwares...
for %%p in (%packageList%) do (
    choco install -y %%p
)
endlocal
goto :EOF

:winget-Network
Title Install Network softwares by Winget
setlocal

set "packageList=^
Mobatek.MobaXterm ^
WiresharkFoundation.Wireshark ^
Nmap.Nmap ^
Zenmap.Zenmap"

for %%p in (%packageList%) do (call :installSoftByWinget %%p)
endlocal
goto :EOF

:choco-Chat
Title Install Chat softwares by Chocolatey
setlocal
set "packageList=slack discord telegram viber whatsapp"
echo Installing Chat softwares...
for %%p in (%packageList%) do (choco install -y %%p)
endlocal
goto :EOF

:wingetChat
Title Install Chat softwares by Winget
call :checkCompatibility
setlocal
set "packageList=^
SlackTechnologies.Slack ^
Discord.Discord ^
Telegram.TelegramDesktop ^
Viber.Viber ^
WhatsApp.WhatsApp ^
Zalo.Zalo ^
Facebook.Messenger ^
Microsoft.Skype ^
Zoom.Zoom"
for %%p in (%packageList%) do (call :installSoftByWinget %%p --accept-package-agreements --accept-source-agreements)
endlocal
call :killTasks
goto :EOF

:wingetRemoteSupport
cls
call :checkCompatibility
call :installSoftByWinget TeamViewer.TeamViewer
call :installSoftByWinget DucFabulous.UltraViewer
call :killTasks
goto :EOF

:chocoRemoteSupport
cls
Title Install Remote Support Software by Chocolatey
echo off
choco install -y teamviewer ultraviewer anydesk.install
REM choco install -y ultraviewer --ignore-checksums
goto :EOF

:chocoEndUsers
cls
Title Install Enduser Software by Chocolatey
echo off
setlocal
set "packageList=^
everything ^
googlechrome ^
firefox ^
microsoft-edge ^
adobereader ^
vlc"
for %%p in (%packageList%) do (choco install -y %%p > nul)
call :bcuninstaller-Settings
call :installUnikey
call :killTasks
cls
ENDLOCAL
goto :EOF

:wingetEndUsers
Title Install Enduser Software by Winget
echo off
call :checkCompatibility
setlocal EnableDelayedExpansion
set "packageList=^
voidtools.Everything ^
Google.Chrome ^
Mozilla.Firefox ^
Microsoft.Edge ^
Adobe.Acrobat.Reader.64-bit ^
VideoLAN.VLC ^
RARLab.WinRAR ^
7-Zip.7-Zip ^
Glarysoft.GlaryUtilities ^
IObit.Uninstaller ^
IObit.SmartDefrag ^
IObit.DriverBooster ^
IObit.MalwareFighter ^
CCleaner.CCleaner ^
BleachBit.BleachBit ^
WizTree.WizTree ^
TreeSize.Free ^
WinDirStat.WinDirStat ^
CPU-Z.CPU-Z ^
GPU-Z.GPU-Z ^
HWiNFO.HWiNFO ^
CrystalDiskInfo.CrystalDiskInfo ^
CrystalDiskMark.CrystalDiskMark ^
AIDA64.AIDA64.Extreme ^
Geekbench.Geekbench ^
MSI.Afterburner ^
RTSS.RivaTunerStatisticsServer ^
OBSProject.OBSStudio ^
ShareX.ShareX ^
Lightshot.Lightshot ^
Greenshot.Greenshot ^
Flameshot.Flameshot ^
KDE.Krita ^
GIMP.GIMP ^
Inkscape.Inkscape ^
Blender.Blender ^
Audacity.Audacity ^
HandBrake.HandBrake ^
K-Lite.CodecPack.Standard ^
PotPlayer.PotPlayer ^
MPC-HC.MPC-HC ^
foobar2000.foobar2000 ^
MusicBee.MusicBee ^
AIMP.AIMP ^
Spotify.Spotify ^
Viber.Viber ^
Telegram.TelegramDesktop ^
WhatsApp.WhatsApp ^
Discord.Discord ^
SlackTechnologies.Slack ^
Zoom.Zoom ^
Microsoft.Teams ^
AnyDesk ^
TeamViewer.TeamViewer ^
DucFabulous.UltraViewer ^
Google.Drive ^
Dropbox.Dropbox ^
Microsoft.OneDrive ^
MEGA.MEGAsync ^
pCloud.pCloud ^
KeePassXCTeam.KeePassXC ^
Bitwarden.Bitwarden ^
NordVPN.NordVPN ^
Proton.VPN ^
TorProject.TorBrowser ^
Brave.Brave ^
Vivaldi.Vivaldi ^
Opera.Opera ^
Notepad++.Notepad++ ^
SublimeHQ.SublimeText.4 ^
Microsoft.VisualStudioCode ^
Microsoft.WindowsTerminal ^
PowerShell.PowerShell ^
JanDeDobbeleer.OhMyPosh ^
Gerardog.gsudo ^
htop.htop ^
lazygit.lazygit ^
jesseduffield.lazydocker ^
tldr-pages.tldr ^
cheat.cheat ^
charludo.cliner ^
dandavison.delta ^
sharkdp.bat ^
sharkdp.fd ^
BurntSushi.ripgrep ^
junegunn.fzf ^
zoxide.zoxide ^
eza-community.eza ^
starship.starship ^
denisidoro.navi ^
arthur-s.z ^
gsamokovarov.jump ^
wting.autojump ^
joel-jeremy.jello ^
stedolan.jq ^
mikefarah.yq ^
itchyny.gojq ^
kisielk.godepgraph ^
FiloSottile.mkcert ^
ngrok.ngrok ^
httpie.httpie ^
curl.curl ^
wget.wget ^
aria2.aria2 ^
unzip.unzip ^
zip.zip ^
tar.tar ^
gzip.gzip ^
bzip2.bzip2 ^
xz.xz ^
less.less ^
vim.vim ^
neovim.neovim ^
emacs.emacs ^
nano.nano ^
tree.tree ^
ack.ack ^
ag.the_silver_searcher ^
ggreer.the_silver_searcher ^
tmux.tmux ^
screen.screen ^
byobu.byobu ^
htop.htop ^
glances.glances ^
nmon.nmon ^
atop.atop ^
powertop.powertop ^
iotop.iotop ^
iftop.iftop ^
nethogs.nethogs ^
speedtest-cli.speedtest-cli ^
iperf3.iperf3 ^
mtr.mtr ^
prettyping.prettyping ^
gping.gping ^
dnsutils.dnsutils ^
bind.dig ^
bind.host ^
bind.nslookup ^
whois.whois ^
netcat.netcat ^
socat.socat ^
nmap.nmap ^
masscan.masscan ^
tcpdump.tcpdump ^
wireshark.wireshark ^
tshark.tshark ^
ettercap.ettercap-graphical ^
bettercap.bettercap ^
aircrack-ng.aircrack-ng ^
reaver.reaver ^
bully.bully ^
pixiewps.pixiewps ^
hashcat.hashcat ^
john.john-the-ripper ^
hydra.hydra ^
medusa.medusa ^
metasploit.metasploit-framework ^
sqlmap.sqlmap ^
burpsuite.burpsuite ^
owasp.zap ^
nikto.nikto ^
wpscan.wpscan ^
gobuster.gobuster ^
dirb.dirb ^
dirbuster.dirbuster ^
wfuzz.wfuzz ^
ffuf.ffuf ^
cewl.cewl ^
crunch.crunch ^
cupp.cupp ^
theharvester.theharvester ^
sublist3r.sublist3r ^
amass.amass ^
recon-ng.recon-ng ^
maltego.maltego-ce ^
sherlock.sherlock ^
social-engineer-toolkit.set ^
gophish.gophish ^
beef.beef-xss ^
radare2.radare2 ^
ghidra.ghidra-sre ^
ida.ida-free ^
x64dbg.x64dbg ^
ollydbg.ollydbg ^
windbg.windbg-preview ^
immunityinc.immunity-debugger ^
cutter.cutter ^
binary-ninja.binary-ninja ^
angr.angr ^
AyrtonSparling.figma-plugins-downloader ^
Figma.Figma ^
Adobe.CreativeCloud ^
Adobe.Photoshop ^
Adobe.Illustrator ^
Adobe.InDesign ^
Adobe.PremierePro ^
Adobe.AfterEffects ^
Adobe.Audition ^
Adobe.Lightroom ^
Adobe.XD ^
Sketch.Sketch ^
InVision.Studio ^
Marvel.Marvel ^
Framer.Framer ^
Principle.Principle ^
Origami.Studio ^
Axure.RP ^
Balsamiq.Wireframes ^
Justinmind.Prototyper ^
Proto.io ^
ProtoPie.ProtoPie ^
Zeplin.Zeplin ^
Avocode.Avocode ^
Abstract.Abstract ^
Plant.Plant ^
Lingo.Lingo ^
IconJar.IconJar ^
RightFont.RightFont ^
FontBase.FontBase ^
NexusFont.NexusFont ^
Transfonter.Transfonter ^
Glyphr.Studio ^
Birdfont.Birdfont ^
FontForge.FontForge ^
Coolors.Coolors ^
Adobe.Color ^
Paletton.Paletton ^
ColorHexa.ColorHexa ^
Canva.Canva ^
Crello.Crello ^
Snappa.Snappa ^
Easil.Easil ^
Piktochart.Piktochart ^
Infogram.Infogram ^
Venngage.Venngage ^
Visme.Visme ^
Genially.Genially ^
Prezi.Prezi ^
Powtoon.Powtoon ^
Animaker.Animaker ^
Vyond.Vyond ^
Moovly.Moovly ^
Wideo.Wideo ^
Lumen5.Lumen5 ^
Biteable.Biteable ^
Animoto.Animoto ^
Magisto.Magisto ^
Renderforest.Renderforest ^
Placeit.Placeit ^
Artlist.Artlist ^
EpidemicSound.EpidemicSound ^
PremiumBeat.PremiumBeat ^
Soundstripe.Soundstripe ^
Musicbed.Musicbed ^
Artgrid.Artgrid ^
Storyblocks.Storyblocks ^
Pexels.Pexels ^
Unsplash.Unsplash ^
Pixabay.Pixabay ^
Freepik.Freepik ^
Vecteezy.Vecteezy ^
Flaticon.Flaticon ^
TheNounProject.TheNounProject ^
Google.Fonts ^
DaFont.DaFont ^
FontSquirrel.FontSquirrel ^
Behance.Behance ^
Dribbble.Dribbble ^
Pinterest.Pinterest ^
Instagram.Instagram ^
Facebook.Facebook ^
Twitter.Twitter ^
LinkedIn.LinkedIn ^
YouTube.YouTube ^
Vimeo.Vimeo ^
TikTok.TikTok ^
Reddit.Reddit ^
Medium.Medium ^
Quora.Quora ^
StackOverflow.StackOverflow ^
GitHub.GitHub ^
GitLab.GitLab ^
Bitbucket.Bitbucket ^
SourceForge.SourceForge ^
CodePen.CodePen ^
JSFiddle.JSFiddle ^
CodeSandbox.CodeSandbox ^
Repl.it ^
Glitch.Glitch ^
Heroku.Heroku ^
Netlify.Netlify ^
Vercel.Vercel ^
DigitalOcean.DigitalOcean ^
Linode.Linode ^
Vultr.Vultr ^
Amazon.AWS ^
Google.Cloud ^
Microsoft.Azure ^
IBM.Cloud ^
Oracle.Cloud ^
Alibaba.Cloud ^
Tencent.Cloud ^
Cloudflare.Cloudflare ^
Fastly.Fastly ^
Akamai.Akamai ^
GoDaddy.GoDaddy ^
Namecheap.Namecheap ^
Hover.Hover ^
Gandi.Gandi ^
Squarespace.Squarespace ^
Wix.Wix ^
Weebly.Weebly ^
Shopify.Shopify ^
BigCommerce.BigCommerce ^
Magento.Magento ^
WooCommerce.WooCommerce ^
Mailchimp.Mailchimp ^
ConstantContact.ConstantContact ^
CampaignMonitor.CampaignMonitor ^
AWeber.AWeber ^
GetResponse.GetResponse ^
Sendinblue.Sendinblue ^
HubSpot.HubSpot ^
Salesforce.Salesforce ^
Zoho.Zoho ^
Freshworks.Freshworks ^
Zendesk.Zendesk ^
Intercom.Intercom ^
Drift.Drift ^
SlackTechnologies.Slack ^
Microsoft.Teams ^
Google.Chat ^
Discord.Discord ^
Zoom.Zoom ^
Skype.Skype ^
Google.Meet ^
Cisco.Webex ^
GoTo.GoToMeeting ^
Jitsi.Meet ^
Whereby.Whereby ^
Trello.Trello ^
Asana.Asana ^
Jira.Jira ^
Monday.com ^
ClickUp.ClickUp ^
Airtable.Airtable ^
Notion.Notion ^
Basecamp.Basecamp ^
Wrike.Wrike ^
Smartsheet.Smartsheet ^
Miro.Miro ^
Mural.Mural ^
Lucidchart.Lucidchart ^
Draw.io.Draw.io ^
Grammarly.Grammarly ^
ProWritingAid.ProWritingAid ^
Hemingway.Editor ^
Evernote.Evernote ^
OneNote.OneNote ^
Google.Keep ^
Simplenote.Simplenote ^
StandardNotes.StandardNotes ^
Joplin.Joplin ^
Obsidian.Obsidian ^
Logseq.Logseq ^
RoamResearch.RoamResearch ^
Typora.Typora ^
iA.Writer ^
Ulysses.Ulysses ^
Scrivener.Scrivener ^
FinalDraft.FinalDraft ^
Celtx.Celtx ^
FadeIn.FadeIn ^
Trelby.Trelby ^
LibreOffice.LibreOffice ^
OpenOffice.OpenOffice ^
WPS.Office ^
FreeOffice.FreeOffice ^
OnlyOffice.OnlyOffice ^
Google.Docs ^
Microsoft.Office ^
Apple.iWork ^
Dropbox.Paper ^
Last.fm.Last.fm ^
Goodreads.Goodreads ^
Letterboxd.Letterboxd ^
IMDb.IMDb ^
RottenTomatoes.RottenTomatoes ^
Metacritic.Metacritic ^
Trakt.Trakt ^
MyAnimeList.MyAnimeList ^
AniList.AniList ^
Kitsu.Kitsu ^
TV.Time ^
Hobi.Hobi ^
SeriesGuide.SeriesGuide ^
Todoist.Todoist ^
TickTick.TickTick ^
Any.do ^
Microsoft.Todo ^
Things.Things ^
OmniFocus.OmniFocus ^
RememberTheMilk.RememberTheMilk ^
Habitica.Habitica ^
Forest.Forest ^
Flora.Flora ^
Headspace.Headspace ^
Calm.Calm ^
InsightTimer.InsightTimer ^
WakingUp.WakingUp ^
TenPercentHappier.TenPercentHappier ^
SimpleHabit.SimpleHabit ^
MyFitnessPal.MyFitnessPal ^
LoseIt.LoseIt ^
Noom.Noom ^
WW.WeightWatchers ^
Fitbit.Fitbit ^
Garmin.Connect ^
Strava.Strava ^
Nike.RunClub ^
Adidas.Running ^
MapMyRun.MapMyRun ^
Runkeeper.Runkeeper ^
Zwift.Zwift ^
Peloton.Peloton ^
Duolingo.Duolingo ^
Babbel.Babbel ^
Memrise.Memrise ^
RosettaStone.RosettaStone ^
Busuu.Busuu ^
Lingodeer.Lingodeer ^
Pimsleur.Pimsleur ^
Anki.Anki ^
Quizlet.Quizlet ^
KhanAcademy.KhanAcademy ^
Coursera.Coursera ^
edX.edX ^
Udemy.Udemy ^
Skillshare.Skillshare ^
LinkedIn.Learning ^
MasterClass.MasterClass ^
Brilliant.org ^
Codecademy.Codecademy ^
freeCodeCamp.freeCodeCamp ^
TheOdinProject.TheOdinProject ^
HackerRank.HackerRank ^
LeetCode.LeetCode ^
Codewars.Codewars ^
Topcoder.Topcoder ^
ProjectEuler.ProjectEuler ^
Exercism.Exercism ^
Kaggle.Kaggle ^
DataCamp.DataCamp ^
Dataquest.Dataquest ^
Fast.ai ^
Google.AIPlatform ^
Amazon.SageMaker ^
Microsoft.AzureML ^
IBM.WatsonStudio ^
H2O.ai ^
DataRobot.DataRobot ^
RapidMiner.RapidMiner ^
KNIME.KNIME ^
Alteryx.Alteryx ^
Tableau.Tableau ^
PowerBI.PowerBI ^
Qlik.QlikSense ^
Looker.Looker ^
Domo.Domo ^
Sisense.Sisense ^
MicroStrategy.MicroStrategy ^
ThoughtSpot.ThoughtSpot ^
Yellowfin.Yellowfin ^
Metabase.Metabase ^
Redash.Redash ^
Superset.Superset ^
Grafana.Grafana ^
Kibana.Kibana ^
Prometheus.Prometheus ^
Datadog.Datadog ^
NewRelic.NewRelic ^
Dynatrace.Dynatrace ^
AppDynamics.AppDynamics ^
Splunk.Splunk ^
Elastic.Stack ^
Logz.io ^
SumoLogic.SumoLogic ^
Graylog.Graylog ^
Fluentd.Fluentd ^
Logstash.Logstash ^
Telegraf.Telegraf ^
Collectd.Collectd ^
StatsD.StatsD ^
Nagios.Nagios ^
Zabbix.Zabbix ^
Icinga.Icinga ^
Sensu.Sensu ^
Consul.Consul ^
Terraform.Terraform ^
Ansible.Ansible ^
Puppet.Puppet ^
Chef.Chef ^
SaltStack.SaltStack ^
Jenkins.Jenkins ^
GitLab.CI ^
CircleCI.CircleCI ^
TravisCI.TravisCI ^
TeamCity.TeamCity ^
Bamboo.Bamboo ^
GoCD.GoCD ^
Spinnaker.Spinnaker ^
Argo.ArgoCD ^
Flux.Flux ^
Kubernetes.Kubernetes ^
Docker.Swarm ^
Apache.Mesos ^
Nomad.Nomad ^
OpenShift.OpenShift ^
Rancher.Rancher ^
Portainer.Portainer ^
Kustomize.Kustomize ^
Helm.Helm ^
Skaffold.Skaffold ^
Knative.Knative ^
Istio.Istio ^
Linkerd.Linkerd ^
Envoy.Envoy ^
CoreDNS.CoreDNS ^
etcd.etcd ^
containerd.containerd ^
runc.runc ^
crun.crun ^
gVisor.gVisor ^
Kata.Containers ^
Firecracker.Firecracker ^
VirtualBox.VirtualBox ^
VMware.Workstation ^
Parallels.Desktop ^
QEMU.QEMU ^
KVM.KVM ^
Xen.Xen ^
Hyper-V.Hyper-V ^
Proxmox.VE ^
oVirt.oVirt ^
XCP-ng.XCP-ng ^
OpenStack.OpenStack ^
CloudStack.CloudStack ^
Eucalyptus.Eucalyptus ^
OpenNebula.OpenNebula ^
Ceph.Ceph ^
Gluster.GlusterFS ^
MinIO.MinIO ^
OpenEBS.OpenEBS ^
Rook.Rook ^
Longhorn.Longhorn ^
MySQL.MySQL ^
PostgreSQL.PostgreSQL ^
MariaDB.MariaDB ^
SQLite.SQLite ^
Microsoft.SQLServer ^
Oracle.Database ^
IBM.Db2 ^
SAP.HANA ^
MongoDB.MongoDB ^
Redis.Redis ^
Cassandra.Cassandra ^
Couchbase.Couchbase ^
Neo4j.Neo4j ^
ArangoDB.ArangoDB ^
OrientDB.OrientDB ^
InfluxDB.InfluxDB ^
TimescaleDB.TimescaleDB ^
Prometheus.Prometheus ^
Elasticsearch.Elasticsearch ^
Solr.Solr ^
Algolia.Algolia ^
MeiliSearch.MeiliSearch ^
Typesense.Typesense ^
RabbitMQ.RabbitMQ ^
ActiveMQ.ActiveMQ ^
Kafka.Kafka ^
Pulsar.Pulsar ^
NATS.NATS ^
ZeroMQ.ZeroMQ ^
gRPC.gRPC ^
Thrift.Thrift ^
Avro.Avro ^
ProtocolBuffers.ProtocolBuffers ^
FlatBuffers.FlatBuffers ^
MessagePack.MessagePack ^
JSON.JSON ^
XML.XML ^
YAML.YAML ^
TOML.TOML ^
CSV.CSV ^
Parquet.Parquet ^
Arrow.Arrow ^
Feather.Feather ^
HDF5.HDF5 ^
NetCDF.NetCDF ^
Zarr.Zarr ^
OpenCV.OpenCV ^
Pillow.Pillow ^
scikit-image.scikit-image ^
SimpleITK.SimpleITK ^
Mahotas.Mahotas ^
NumPy.NumPy ^
SciPy.SciPy ^
Pandas.Pandas ^
Matplotlib.Matplotlib ^
Seaborn.Seaborn ^
Plotly.Plotly ^
Bokeh.Bokeh ^
Altair.Altair ^
ggplot.ggplot ^
scikit-learn.scikit-learn ^
TensorFlow.TensorFlow ^
PyTorch.PyTorch ^
Keras.Keras ^
Theano.Theano ^
Caffe.Caffe ^
MXNet.MXNet ^
CNTK.CNTK ^
Chainer.Chainer ^
fastai.fastai ^
JAX.JAX ^
HuggingFace.Transformers ^
spaCy.spaCy ^
NLTK.NLTK ^
Gensim.Gensim ^
AllenNLP.AllenNLP ^
Flair.Flair ^
Stanza.Stanza ^
CoreNLP.CoreNLP ^
OpenNLP.OpenNLP ^
Spark.NLP ^
Rasa.Rasa ^
Dialogflow.Dialogflow ^
Microsoft.BotFramework ^
Amazon.Lex ^
IBM.WatsonAssistant ^
wit.ai ^
snips.nlu ^
Dask.Dask ^
Ray.Ray ^
Modin.Modin ^
Vaex.Vaex ^
cuDF.cuDF ^
cuML.cuML ^
cuGraph.cuGraph ^
BlazingSQL.BlazingSQL ^
RAPIDS.RAPIDS ^
Numba.Numba ^
Cython.Cython ^
PyPy.PyPy ^
Jython.Jython ^
IronPython.IronPython ^
CPython.CPython ^
Flask.Flask ^
Django.Django ^
FastAPI.FastAPI ^
Tornado.Tornado ^
Sanic.Sanic ^
aiohttp.aiohttp ^
Bottle.Bottle ^
CherryPy.CherryPy ^
Pyramid.Pyramid ^
Falcon.Falcon ^
Hug.Hug ^
Eve.Eve ^
Dash.Dash ^
Streamlit.Streamlit ^
Panel.Panel ^
Voila.Voila ^
Gradio.Gradio ^
Requests.Requests ^
HTTPX.HTTPX ^
aiohttp.aiohttp-client ^
urllib3.urllib3 ^
BeautifulSoup.BeautifulSoup ^
lxml.lxml ^
Scrapy.Scrapy ^
Selenium.Selenium ^
Playwright.Playwright ^
Puppeteer.Puppeteer ^
Cypress.Cypress ^
TestCafe.TestCafe ^
SQLAlchemy.SQLAlchemy ^
peewee.peewee ^
PonyORM.PonyORM ^
tortoise-orm.tortoise-orm ^
GIN.GIN ^
Echo.Echo ^
Fiber.Fiber ^
Beego.Beego ^
Revel.Revel ^
Buffalo.Buffalo ^
Gorilla.Mux ^
Chi.Chi ^
httprouter.httprouter ^
Express.Express ^
Koa.Koa ^
Hapi.Hapi ^
NestJS.NestJS ^
Next.js ^
Nuxt.js ^
SvelteKit.SvelteKit ^
Gatsby.Gatsby ^
Remix.Remix ^
React.React ^
Vue.js ^
Angular.Angular ^
Svelte.Svelte ^
Ember.js ^
Backbone.js ^
jQuery.jQuery ^
Lodash.Lodash ^
Underscore.js ^
Moment.js ^
date-fns.date-fns ^
Day.js ^
Luxon.Luxon ^
RxJS.RxJS ^
Redux.Redux ^
MobX.MobX ^
Vuex.Vuex ^
NgRx.NgRx ^
Recoil.Recoil ^
Jotai.Jotai ^
Zustand.Zustand ^
GraphQL.GraphQL ^
Apollo.ApolloClient ^
Relay.Relay ^
URQL.URQL ^
TailwindCSS.TailwindCSS ^
Bootstrap.Bootstrap ^
Material-UI.MUI ^
AntDesign.AntDesign ^
ChakraUI.ChakraUI ^
SemanticUI.SemanticUI ^
Foundation.Foundation ^
Bulma.Bulma ^
Sass.Sass ^
Less.Less ^
Stylus.Stylus ^
PostCSS.PostCSS ^
Webpack.Webpack ^
Rollup.Rollup ^
Parcel.Parcel ^
Vite.Vite ^
esbuild.esbuild ^
Snowpack.Snowpack ^
Babel.Babel ^
TypeScript.TypeScript ^
ESLint.ESLint ^
Prettier.Prettier ^
Jest.Jest ^
Mocha.Mocha ^
Jasmine.Jasmine ^
AVA.AVA ^
Vitest.Vitest ^
TestingLibrary.TestingLibrary ^
Enzyme.Enzyme ^
Storybook.Storybook ^
Ladl.Ladle ^
Chromatic.Chromatic ^
Gulp.Gulp ^
Grunt.Grunt ^
NPM.NPM ^
Yarn.Yarn ^
PNPM.PNPM ^
Lerna.Lerna ^
Nx.Nx ^
Turborepo.Turborepo ^
Rush.Rush ^
Gradle.Gradle ^
Maven.Maven ^
Ant.Ant ^
Bazel.Bazel ^
Buck.Buck ^
CMake.CMake ^
Make.Make ^
Rake.Rake ^
Capistrano.Capistrano ^
Fabric.Fabric ^
pytest.pytest ^
unittest.unittest ^
nose2.nose2 ^
tox.tox ^
nox.nox ^
PHPUnit.PHPUnit ^
Codeception.Codeception ^
Behat.Behat ^
PHPSpec.PHPSpec ^
RSpec.RSpec ^
Minitest.Minitest ^
Capybara.Capybara ^
Cucumber.Cucumber ^
JUnit.JUnit ^
TestNG.TestNG ^
Mockito.Mockito ^
PowerMock.PowerMock ^
Spock.Spock ^
NUnit.NUnit ^
xUnit.net ^
MSTest.MSTest ^
Moq.Moq ^
Bogus.Bogus ^
AutoFixture.AutoFixture ^
Go.testing ^
Testify.Testify ^
Go.GoConvey ^
Go.GoMega ^
Go.GoCheck ^
Swift.XCTest ^
Quick.Quick ^
Nimble.Nimble ^
Rust.testing ^
cargo-test.cargo-test ^
proptest.proptest ^
quickcheck.quickcheck-rust ^
criterion.criterion-rs ^
Elixir.ExUnit ^
Kotlin.kotlin.test ^
Spek.Spek ^
Kotest.Kotest ^
ScalaTest.ScalaTest ^
Specs2.Specs2 ^
uTest.uTest ^
Clojure.test ^
Midje.Midje ^
Kaocha.Kaocha ^
Haskell.Hspec ^
Haskell.tasty ^
Haskell.QuickCheck ^
OCaml.OUnit ^
OCaml.QCheck ^
Erlang.EUnit ^
CommonLisp.FiveAM ^
CommonLisp.rove ^
D.unittest ^
Crystal.spec ^
Zig.test ^
Nim.unittest ^
Julia.Test ^
MATLAB.UnitTestingFramework ^
R.testthat ^
Perl.Test-Simple ^
Lua.Busted ^
Dart.test ^
Flutter.test ^
hluk.CopyQ ^
LocalSend.LocalSend ^
HiBitSoftware.HiBitUninstaller"

for %%p in (%packageList%) do (call :installSoftByWinget %%p -h --accept-package-agreements --accept-source-agreements --ignore-security-hash --force)
endlocal
::call :bcuninstaller-Settings
call :killTasks
cls
goto :EOF

:checkCompatibility
:: ============================================================
:: Check if the script is running with administrator privileges
:: ============================================================
echo [*] Checking for administrator privileges...
fsutil dirty query %systemdrive% >nul
if %ERRORLEVEL% NEQ 0 (
    echo This script requires administrator privileges.
    echo Please run it as an administrator.
    ping -n 3 localhost 1>NUL
    exit /b 1
)
echo Administrator privileges confirmed.
ping -n 2 localhost 1>NUL
goto :EOF

:packageManagement
cls
:: ============================================================
:: Install Chocolatey
:: ============================================================
echo [*] Checking if Chocolatey is installed...

if exist "%ProgramData%\chocolatey\bin\choco.exe" (
    echo Chocolatey is already installed.
) else (
    echo Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
)
echo.
:: ============================================================
:: Install Winget (Dependencies & Core) from GitHub using aria2c
:: ============================================================
echo [*] Fetching latest Winget release information from GitHub...

set "GITHUB_API_URL=https://api.github.com/repos/microsoft/winget-cli/releases/latest"
set "POWERSHELL_COMMAND=(Invoke-RestMethod -Uri %GITHUB_API_URL%).assets | ForEach-Object { $_.browser_download_url } | Select-String -Pattern 'msixbundle|msix'"
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "%POWERSHELL_COMMAND%"`) do (
    if "%%i" neq "" (
        if "%%i" neq " " (
            set "MSIXBUNDLE_URL=%%i"
        )
    )
)

echo.
echo [*] Detected Assets:
    echo     Dependencies ZIP: %DEP_ZIP_URL%
    echo     Main Package: %MSIXBUNDLE_URL%
    echo.


:: Define local filenames & folders in %temp%
set "TEMP_WINGET_DIR=%TEMP%\winget-install"
set "DEP_ZIP_NAME=winget-dependencies.zip"
set "MSIXBUNDLE_NAME=winget-cli.msixbundle"
set "DEP_ZIP_PATH=%TEMP_WINGET_DIR%\%DEP_ZIP_NAME%"
set "MSIXBUNDLE_PATH=%TEMP_WINGET_DIR%\%MSIXBUNDLE_NAME%"

:: Create temporary directory
if not exist "%TEMP_WINGET_DIR%" mkdir "%TEMP_WINGET_DIR%"

:: Download dependencies and main package using aria2c
echo [*] Downloading Winget assets using aria2c...
aria2c -x 16 -s 16 -k 1M -d "%TEMP_WINGET_DIR%" -o "%DEP_ZIP_NAME%" "%DEP_ZIP_URL%"
aria2c -x 16 -s 16 -k 1M -d "%TEMP_WINGET_DIR%" -o "%MSIXBUNDLE_NAME%" "%MSIXBUNDLE_URL%"

:: Verify downloads
if not exist "%DEP_ZIP_PATH%" (
    echo [ERROR] Failed to download dependencies ZIP.
    goto :EOF
)
if not exist "%MSIXBUNDLE_PATH%" (
    echo [ERROR] Failed to download main Winget package.
    goto :EOF
)

echo.
echo [*] Downloads complete.

:: Install dependencies
echo [*] Installing dependencies...
powershell -NoProfile -Command "Expand-Archive -Path '%DEP_ZIP_PATH%' -DestinationPath '%TEMP_WINGET_DIR%\dependencies'; Add-AppxPackage -Path '%TEMP_WINGET_DIR%\dependencies\*.appx' -DependencyPath '%TEMP_WINGET_DIR%\dependencies\*.appx'"

:: Install Winget
echo [*] Installing Winget...
powershell -NoProfile -Command "Add-AppxPackage -Path '%MSIXBUNDLE_PATH%'"

:: Clean up temporary files
echo [*] Cleaning up...
rmdir /s /q "%TEMP_WINGET_DIR%"

echo.
echo [*] Winget installation process finished.
goto :EOF
REM End of Winget functions
REM ========================================================================================================================
================
REM function update CMD via github
:updateScript
cls
cd /d %dp%
copy Helpdesk-Tools.cmd Helpdesk-Tools-old.cmd /Y
powershell -command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/tamld/cmdToolForHelpdesk/main/Helpdesk-Tools.cmd', 'Helpdesk-Tools.cmd')"
cls
echo Script updated successfully.
ping -n 2 localhost 1>NUL
exit

:checkUpdate
call :get_latest_release
if not "%cmd_current_version%"=="%cmd_latest_release%" (
    echo A new version of this script is available: %cmd_latest_release%
    echo Do you want to update?
    Choice /N /C YN /M "[Yes], [No]: "
    If ERRORLEVEL == 1 call :updateScript
)
goto :eof

:get_latest_release
for /f "tokens=*" %%a in ('powershell -command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/tamld/cmdToolForHelpdesk/releases/latest').tag_name"') do (
    set "cmd_latest_release=%%a"
)
goto :eof

:checkWingetUpdate
for /f "tokens=*" %%a in ('powershell -command "(Invoke-RestMethod -Uri 'https://api.github.com/repos/microsoft/winget-cli/releases/latest').tag_name"') do (
    set "winget_latest_release=%%a"
)
for /f "tokens=*" %%a in ('winget --version') do (
    set "winget_current_version=%%a"
)
if not "%winget_current_version%"=="%winget_latest_release%" (
    echo A new version of Winget is available: %winget_latest_release%
    echo Do you want to update?
    Choice /N /C YN /M "[Yes], [No]: "
    If ERRORLEVEL == 1 call :packageManagement
)
ping -n 2 localhost 1>NUL
exit /b 0

:installSoftByWinget
Title Install Software
REM Set the software name to install
set "software=%~1"
shift
set "args=%*"

REM Check if the software is already installed
winget list --id %software% >nul 2>&1
if %errorlevel%==0 (
    echo %software% is already installed.
) else (
    echo Installing %software%...
    winget install --id %software% %args%
)
goto :EOF

:installSoftByChoco
Title Install Software by Chocolatey
REM Set the software name to install
set "software=%~1"
shift
set "args=%*"

REM Check if the software is already installed
choco list --local-only --exact %software% >nul 2>&1
if %errorlevel%==0 (
    echo %software% is already installed.
) else (
    echo Installing %software%...
    choco install %software% %args% -y
)
goto :EOF

:installUnikey
Title Install Unikey
pushd %temp%
curl -L -o unikey.exe "https://www.unikey.org/download/UniKey43RC4-2201-Setup.exe"
start unikey.exe /S
popd
goto :EOF

:: Function install 7zip by using winget
:install7Zip
cls
Title Install 7zip using Winget
call :checkCompatibility
call :installSoftByWinget "7-Zip.7-Zip"
goto :EOF

:inputCredential
cls
echo.
set /p username=Enter the username:
set /p password=Enter the password:
goto :EOF

:hold
echo Press any key to continue...
pause > nul
goto :EOF

:clean
del %temp%\*.zip >nul 2>&1
del %temp%\*.exe >nul 2>&1
del %temp%\*.log >nul 2>&1
del %temp%\*.txt >nul 2>&1
del %temp%\*.xml >nul 2>&1
rmdir /s /q %temp%\Office_Tool >nul 2>&1
rmdir /s /q %temp%\SaRACmd >nul 2>&1
goto :EOF

:activeIdm
cls
pushd %temp%
dir /b "C:\Program Files (x86)\Internet Download Manager" > nul 2>&1 || (
    echo IDM is not installed.
    ping -n 2 localhost 1>NUL
    goto :EOF
)
curl -L -o IDM.zip "https://www.dropbox.com/s/l98mp6no8nd092y/IDM.zip?dl=1"
tar -xf IDM.zip
cd IDM
call IDM.cmd
cd ..
del /q IDM.zip
rmdir /s /q IDM
call :clean
goto :EOF

:: Kill all non-essential applications gracefully
:killTasks
cls
setlocal EnableDelayedExpansion
echo Closing non-essential applications...
set "appList=^
msedge.exe ^
chrome.exe ^
firefox.exe ^
WINWORD.EXE ^
EXCEL.EXE ^
POWERPNT.EXE ^
OUTLOOK.EXE ^
ONENOTE.EXE ^
MSPUB.EXE ^
MSACCESS.EXE ^
Teams.exe ^
OneDrive.exe ^
wordpad.exe ^
notepad.exe ^
calc.exe ^
mspaint.exe ^
SnippingTool.exe ^
iexplore.exe ^
vlc.exe ^
WinRAR.exe ^
7zFM.exe ^
notepad++.exe ^
sublime_text.exe ^
Code.exe ^
git-bash.exe ^
Docker Desktop.exe ^
VirtualBox.exe ^
TeamViewer.exe ^
AnyDesk.exe ^
UltraViewer_Desktop.exe ^
Zoom.exe ^
Teams.exe ^
Discord.exe ^
Telegram.exe ^
Viber.exe ^
WhatsApp.exe ^
Signal.exe ^
Skype.exe ^
Zalo.exe ^
slack.exe ^
Everything.exe ^
ClassicStartMenu.exe ^
OpenShellStartMenu.exe ^
WinaeroTweaker.exe ^
procexp.exe ^
procmon.exe ^
autoruns.exe ^
tcpview.exe ^
NirLauncher.exe ^
CCleaner.exe ^
Defraggler.exe ^
Recuva.exe ^
Speccy.exe ^
mbam.exe ^
SUPERAntiSpyware.exe ^
AdwCleaner.exe ^
HitmanPro.exe ^
Zemana.exe ^
ESETOnlineScanner.exe ^
KVRT.exe ^
Stinger.exe ^
ShareX.exe ^
gimp-2.10.exe ^
inkscape.exe ^
krita.exe ^
blender.exe ^
audacity.exe ^
obs64.exe ^
HandBrake.exe ^
KeePassXC.exe ^
Bitwarden.exe ^
1Password.exe ^
LastPass.exe ^
Dashlane.exe ^
NordVPN.exe ^
ProtonVPN.exe ^
expressvpn.exe ^
CyberGhost.exe ^
Surfshark.exe ^
pia-client.exe ^
Mullvad VPN.exe ^
Windscribe.exe ^
TunnelBear.exe ^
hsscp.exe ^
ProtonMail.exe ^
Tutanota Desktop.exe ^
Standard Notes.exe ^
Joplin.exe ^
Obsidian.exe ^
Logseq.exe ^
Notion.exe ^
Evernote.exe ^
Todoist.exe ^
TickTick.exe ^
Any.do.exe ^
Todo.exe ^
Google Keep.exe ^
Simplenote.exe ^
Spotify.exe ^
iTunes.exe ^
Amazon Music.exe ^
Google Play Music.exe ^
Deezer.exe ^
TIDAL.exe ^
Pandora.exe ^
SoundCloud.exe ^
Bandcamp.exe ^
Netflix.exe ^
Hulu.exe ^
DisneyPlus.exe ^
HBO Max.exe ^
Amazon Prime Video.exe ^
YouTube.exe ^
Twitch.exe ^
Steam.exe ^
EpicGamesLauncher.exe ^
GalaxyClient.exe ^
UbisoftGameLauncher.exe ^
EADesktop.exe ^
Battle.net Launcher.exe ^
RiotClientServices.exe ^
steam.exe ^
Discord.exe ^
ps_core.exe ^
Rainmeter.exe ^
wallpaper32.exe ^
Fences.exe ^
StartIsBack.exe ^
OpenShellStartMenu.exe ^
ClassicShell.exe ^
WinaeroTweaker.exe ^
procexp.exe ^
procmon.exe ^
autoruns.exe ^
tcpview.exe ^
nirlauncher.exe ^
CCleaner.exe ^
Defraggler.exe ^
Recuva.exe ^
Speccy.exe ^
mbam.exe ^
SUPERAntiSpyware.exe ^
AdwCleaner.exe ^
HitmanPro.exe ^
Zemana AntiMalware.exe ^
ESETOnlineScanner.exe ^
KVRT.exe ^
stinger.exe"
for %%a in (%appList%) do (
    taskkill /f /im %%a >nul 2>&1
)
endlocal
goto :EOF

:about
cls
echo =================================================================
echo Helpdesk Tools v0.6.80
echo.
echo This script is designed to automate common helpdesk tasks.
echo For more information, visit: https://github.com/tamld/cmdToolForHelpdesk
ping -n 3 localhost >NUL
goto :EOF

:exit
call :clean
exit

:bcuninstaller-Settings
pushd %appdata%
if not exist "BCUninstaller" mkdir BCUninstaller
cd BCUninstaller
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<BCU-settings^>
echo  ^<Advanced.AutoUpdate bool="False" /^>
echo  ^<Advanced.CheckForBetas bool="False" /^>
echo  ^<Advanced.Concurrent bool="True" /^>
echo  ^<Advanced.Language string="" /^>
echo  ^<Advanced.Logging bool="False" /^>
echo  ^<Advanced.ScanForOrphans bool="True" /^>
echo  ^<Advanced.Theme int="0" /^>
echo  ^<Advanced.UseGoogleForInfo bool="False" /^>
echo  ^<External.Steam.IsEnabled bool="True" /^>
echo  ^<External.Steam.Path string="" /^>
echo  ^<External.WindowsFeatures.IsEnabled bool="True" /^>
echo  ^<External.WindowsStore.IsEnabled bool="True" /^>
echo  ^<Filtering.ShowAll bool="False" /^>
echo  ^<Filtering.ShowProtected bool="False" /^>
echo  ^<Filtering.ShowSystemComponents bool="False" /^>
echo  ^<Filtering.ShowUpdates bool="False" /^>
echo  ^<Filtering.ShowStoreApps bool="True" /^>
echo  ^<Main.AdvancedTools bool="True" /^>
echo  ^<Main.CheckForUpdates bool="False" /^>
echo  ^<Main.SendStatistics bool="False" /^>
echo  ^<Main.ShowAllUsers bool="True" /^>
echo  ^<Main.SystemRestore bool="False" /^>
echo  ^<Uninstall.AutoCRemove bool="True" /^>
echo  ^<Uninstall.AutoKill bool="False" /^>
echo  ^<Uninstall.Confidence int="2" /^>
echo  ^<Uninstall.DeleteJunk bool="True" /^>
echo  ^<Uninstall.UseQuiet bool="True" /^>
echo ^</BCU-settings^>
) > BCUninstaller.xml
popd
goto :eof

:dispatchMenu
:: Usage: call :dispatch_menu <array_prefix> <choice_var>
setlocal EnableDelayedExpansion
set "prefix=%~1"
set "varName=%~2"
set "sel=!%varName%!
for /f "tokens=2 delims==" %%A in ('set %prefix%[%sel%] 2^>nul') do (
    set "target=%%A"
)

if defined target (
    call :%target%
)

endlocal
goto :eof
