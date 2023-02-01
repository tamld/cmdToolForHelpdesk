REM REM REF code http://zone94.com/downloads/135-windows-and-office-activation-script
:defineOffice
	@echo off
	cls
	TITLE Microsoft Office ProPlus - Online Installer
	REM Define value default for install
	set "_dp=%~dp0"
	set "_sys32=%windir%\system32"
	cd /d "%_dp%"
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
	
:selectOfficeApp
	cls
	REM Menu select app to install. Default is yes with Yes colored green.
	echo.
	echo Select options to install Office
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
	echo.
	CHOICE /c 123456789PDX /n /m "--> Toggle your option(s) and toggle [X] to Start: "
	if ERRORLEVEL 12 goto :installOffice
	if ERRORLEVEL 11 (if "%optD%"=="%on%" (Set "optD=%off%") Else (Set "optD=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 10 (if "%optP%"=="%on%" (Set "optP=%off%") Else (Set "optP=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 9 (if "%opt9%"=="%on%" (Set "opt9=%off%") Else (Set "opt9=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 8 (if "%opt8%"=="%on%" (Set "opt8=%off%") Else (Set "opt8=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 7 (if "%opt7%"=="%on%" (Set "opt7=%off%") Else (Set "opt7=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 6 (if "%opt6%"=="%on%" (Set "opt6=%off%") Else (Set "opt6=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 5 (if "%opt5%"=="%on%" (Set "opt5=%off%") Else (Set "opt5=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 4 (if "%opt4%"=="%on%" (Set "opt4=%off%") Else (Set "opt4=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 3 (if "%opt3%"=="%on%" (Set "opt3=%off%") Else (Set "opt3=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 2 (if "%opt2%"=="%on%" (Set "opt2=%off%") Else (Set "opt2=%on%")) & goto :selectOfficeApp
	if ERRORLEVEL 1 (if "%opt1%"=="%on%" (Set "opt1=%off%") Else (Set "opt1=%on%")) & goto :selectOfficeApp
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
	
:installOffice
	cls
	echo.
	echo Disabling Microsoft Office 2021 Telemetry . . .
	ping -n 2 localhost 1>NUL
	REG ADD "HKLM\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "00000001" /f 1>NUL
	SETLOCAL
	Set "OCS=".\Office 2021 Setup Config.xml""
						  >%OCS% echo ^<Configuration^>
						 REM >>%OCS% echo   ^<Add OfficeClientEdition="%CPU%" Channel="Monthly" SourcePath="%_dp%"^>
						 >>%OCS% echo   ^<Add OfficeClientEdition="%CPU%" Channel="Monthly"^>					 
						 >>%OCS% echo     ^<Product ID="ProPlus2021Retail"^>
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
	if "%opt8%"=="%on%"  >>%OCS% echo     ^<Product ID="VisioPro2021Retail"^>
	if "%opt8%"=="%on%"  >>%OCS% echo       ^<Language ID="MatchOS" Fallback="en-US" /^>
	if "%opt8%"=="%on%"  >>%OCS% echo     ^</Product^>
	if "%opt9%"=="%on%"  >>%OCS% echo     ^<Product ID="ProjectPro2021Retail"^>
	if "%opt9%"=="%on%"  >>%OCS% echo       ^<Language ID="MatchOS" Fallback="en-US" /^>
	if "%opt9%"=="%on%"  >>%OCS% echo     ^</Product^>
	if "%optP%"=="%on%"  >>%OCS% echo     ^<Product ID="ProofingTools"^>
	if "%optP%"=="%on%"  >>%OCS% echo       ^<Language ID="MatchOS" Fallback="en-US" /^>
	if "%optP%"=="%on%"  >>%OCS% echo     ^</Product^>
						 >>%OCS% echo   ^</Add^>
						 >>%OCS% echo ^</Configuration^>
	ENDLOCAL
	echo Installing Microsoft Office 2021 ProPlus %CPU%-bit . . .
	ping -n 3 localhost 1>NUL
	START "" /WAIT /B ".\setup.exe" /configure ".\Office 2021 Setup Config.xml"
	exit /b 

:end