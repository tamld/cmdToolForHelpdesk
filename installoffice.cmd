:installOffice
	@echo off
	set "_dp=%~dp0"
	set "_sys32=%windir%\system32"
	cd /d "%_dp%"
	TITLE Microsoft Office ProPlus 2021 - Online Installer
	REM Define value default for install
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
	
	REM Function that will colored text with Green = 0a
	:setColor (Text, Color)
	MkDir "%Temp%\_%1" 1>NUL
	PushD "%Temp%\_%1"
	For /f %%a in ('Echo PROMPT $H ^| "CMD.exe"') do Set "bs=%%a"
	<NUL Set /P="_" >"%1"
	FindStr /s /b /p /a:%2 /C:"_" "%1"
	<NUL Set /P=%bs%%bs%
	PopD
	RmDir /s /q "%Temp%\_%1"
	GoTo :EOF
	
	:selectOfficeApp
	cls
	echo.
	echo Select options to install Office
	<NUL Set/P=[1] & (If "%opt1%"=="%on%" (Call :setColor "%opt1%" 0a) Else (<NUL Set/P="%opt1%")) & echo  Microsoft Office Word.
	<NUL Set/P=[2] & (If "%opt2%"=="%on%" (Call :setColor "%opt2%" 0a) Else (<NUL Set/P="%opt2%")) & echo  Microsoft Office Excel.
	<NUL Set/P=[3] & (If "%opt3%"=="%on%" (Call :setColor "%opt3%" 0a) Else (<NUL Set/P="%opt3%")) & echo  Microsoft Office PowerPoint.
	<NUL Set/P=[4] & (If "%opt4%"=="%on%" (Call :setColor "%opt4%" 0a) Else (<NUL Set/P="%opt4%")) & echo  Microsoft Office Outlook.
	<NUL Set/P=[5] & (If "%opt5%"=="%on%" (Call :setColor "%opt5%" 0a) Else (<NUL Set/P="%opt5%")) & echo  Microsoft Office OneNote.
	<NUL Set/P=[6] & (If "%opt6%"=="%on%" (Call :setColor "%opt6%" 0a) Else (<NUL Set/P="%opt6%")) & echo  Microsoft Office Publisher.
	<NUL Set/P=[7] & (If "%opt7%"=="%on%" (Call :setColor "%opt7%" 0a) Else (<NUL Set/P="%opt7%")) & echo  Microsoft Office Access.
	<NUL Set/P=[8] & (If "%opt8%"=="%on%" (Call :setColor "%opt8%" 0a) Else (<NUL Set/P="%opt8%")) & echo  Microsoft Office Visio.
	<NUL Set/P=[9] & (If "%opt9%"=="%on%" (Call :setColor "%opt9%" 0a) Else (<NUL Set/P="%opt9%")) & echo  Microsoft Office Project.
	<NUL Set/P=[P] & (If "%optP%"=="%on%" (Call :setColor "%optP%" 0a) Else (<NUL Set/P="%optP%")) & echo  Microsoft Office Proofing Tools.
	<NUL Set/P=[D] & (If "%optD%"=="%on%" (Call :setColor "%optD%" 0a) Else (<NUL Set/P="%optD%")) & echo  Microsoft OneDrive Desktop.
	ECHO.
	CHOICE /c 123456789PDX /n /m "--> Toggle your option(s) and toggle [X] to Start: "	