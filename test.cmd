echo off
set "_dp=%~dp0"
set "_sys32=%windir%\system32"
cd /d "%_dp%"
REM call :checkWinget
REM call :installWinget-Utilities
REM call :addScheduleUpgrade
REM call :installNotepadplusplusThemes
REM call :setHighPerformance
REM call :cleanUpSystem
REM call :installSupportAssistant
call :addLocalUser
REM call :clean
goto :end
REM Add local admin user 
	
:addLocalUser
	Title Add local user with administrator privilege
	setLocal EnableDelayedExpansion
	echo Write down new username to add:
	set /p _user=

	echo Do you want to set a password for %_user%? [Y/N]
	set /p _setpass=

	if /i "%_setpass%" == "Y" (
	  echo %_user%'s password is:
	  set /p _pass=
	  net user %_user% %_pass% /add 2>nul
	) else (
	  net user %_user% "" /add 2>nul
	)

	if %errorlevel% equ 0 (
	  net localgroup administrators %_user% /add
	  echo User "%_user%" with admin privileges added successfully.
	) else (
	  echo Failed to add user.
	)
	endlocal
	goto :eof


:installSupportAssistant
	Title install Support Assistant
	setlocal
	cd %temp%
	REM Detect brand name
	for /f %%b in ('wmic computersystem get manufacturer ^| findstr /I "Dell HP Lenovo"') do set "BRAND=%%b"

	REM Download and install appropriate support assistant
	if /I "%BRAND%" == "Dell Inc." (
	  curl -o SupportAssistx64-3.12.3.5.msi https://downloads.dell.com/serviceability/catalog/SupportAssistx64-3.12.3.5.msi
	  start /wait SupportAssistx64-3.12.3.5.msi /quiet
	  call :log DELL Assistant is installed
	) else if /I "%BRAND%" == "HP" (
	  curl -fSL -o sp114036.exe https://ftp.hp.com/pub/softpaq/sp114001-114500/sp114036.exe
	  "c:\Program Files\7-Zip\7z.exe" x -y sp114036.exe -o"sp114036"
	  start /wait sp114036\InstallHPSA.exe
	  call :log HP Assistant is installed
	) else if /I "%BRAND%" == "Lenovo" (
	  call :checkWinget
	  call :installSoft "Lenovo.SystemUpdate"
	) else (
	  echo Unknown brand: %BRAND%
	)
	endlocal
	cd %_dp%
	exit /b
	
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
	REM goto :utilities
:cleanUpSystem
	Title Clean Up System
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
REM cleanmgr /sagerun:1
	goto :EOF
	REM goto :utilities	
:changeHostName
	Title Change host name
	setlocal EnableDelayedExpansion
	echo.
	echo Your new computername is:
	set /p _newComputername=
	echo This will change your computername from: %computername% to: %_newComputername%
	timeout 3
	WMIC ComputerSystem where Name="%computername%" call Rename Name="%_newComputername%"
	for /f "skip=1 tokens=2 delims==; " %%i in ('WMIC ComputerSystem where Name^="%computername%" call Rename Name^="%_newComputername%" ^| findstr "ReturnValue ="') do set _statusChangeHostName=%%i
	cls
	if %_statusChangeHostName% == 0 (
						echo Your computername will change to %_newComputername%
						echo Restart computer to apply the change
						cls
					)
	if %_statusChangeHostName% NEQ 0 (
						echo Your computer name will not change 
						echo Try a name containing special characters like ^~, ^!, ^@.....
						echo Do you want to change your computer hostname again^?
						Choice /N /C YN /M "[Y], [N]:     Default [N]"
						If ERRORLEVEL ==Y goto :changeHostName
						)
	endlocal
	PAUSE
	exit /b
:checkWinget
	Title Check Winget 
	echo off
    rem Get the Windows version number
    for /f "tokens=4 delims=[] " %%i in ('ver') do set VERSION=%%i

    rem Check if the version number is 10.0.19041 or later
    if "%VERSION%" GEQ "10.0.19041" (
        cls
		echo "Current Windows version: %VERSION% is suitable for installing winget"
		call :log "Windows version check: Version %VERSION% is suitable for installing winget"
		timeout 2
		cls
        winget -v
        if ERRORLEVEL 1 (
            echo Start to install winget
            call :installWinget
			cls
        ) else (
            echo Winget already installed
            call :log "Winget already installed"
			cls
        )
    ) else (
        call :log "Windows version check: Version %VERSION% is not suitable for installing winget"
        echo Your Windows version is not suitable for installing winget
		timeout 2
    )
    cls
    goto :EOF
	

:installWinget
	Title Install Winget
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
	Title Install Software
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
			call :log "%software% installed with scope %scope%"
			cls
		)
	) else (
		echo %software% already installed
		timeout 1
		call :log "%software% already installed"
		cls
	)
    goto :EOF

:addScheduleUpgrade
	Title Add Winget Shedule Upgrade
	REM Create schedule task auto upgrade all software with hidden option
	REM Schedule task run onlogon with current user running
	schtasks /create /tn "Winget Upgrade" /tr "winget.exe upgrade -h --all" /sc onlogon /ru %username% /f
	goto :eof


:installWinget-Utilities
	Title Install Utilities by Winget
	call :checkWinget
	setlocal
	call :log "Starting software utilities installation"
    cls
    echo.
    echo **********************************************************************
    echo 		List Software to Install
    echo 		7zip, Notepad++, Foxit Reader
    echo 		Zalo, Slack, Skype, Unikey
    echo 		Google Chrome, Firefox
    echo 		BulkCrapUninstaller, Microsoft PowerToys
    echo 		Google Drive
    echo **********************************************************************
	timeout 3
	REM Without Scope Machine, the software will be installed with the current user profile instead of the system profile
	set packageListWithScope=SlackTechnologies.Slack ^
								Google.Chrome ^
								Mozilla.Firefox ^
								google.drive ^
								Google.Chrome ^
								Microsoft.PowerToys ^
								Mozilla.Firefox
	set packageListWithoutScope=7zip.7zip ^
									VideoLAN.VLC ^
									Foxit.FoxitReader ^
									Notepad++.Notepad ^
									Klocman.BulkCrapUninstaller ^
									VNGCorp.Zalo
	REM first loop to install software without scope machine
	for %%p in (%packageListWithoutScope%) do (
		call :installSoft %%p ""
	)
	
	REM second loop to install software with scope machine
	for %%p in (%packageListWithScope%) do (
		call :installSoft %%p "--scope machine"
	)
	endlocal
	call :installNotepadplusplusThemes
	call :installUnikey
	exit /b

:installNotepadplusplusThemes
	Title Install Notepad++ Themes
	if not exist "%ProgramFiles(x86)%\Notepad++" (
		echo Notepad++ not found, exiting...
		goto :EOF
	)
	call :log "Notepad++ found, proceeding with installation"
	cd %temp%
	REM Dracula theme
	call :log "Installing Dracula theme"
	curl https://raw.githubusercontent.com/dracula/notepad-plus-plus/master/Dracula.xml -o Dracula.xml
	if %errorlevel% neq 0 (
		echo Failed to download Dracula theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	xcopy Dracula.xml %AppData%\Notepad++\themes\ /E /C /I /Q
	if %errorlevel% neq 0 (
		echo Failed to copy Dracula theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	REM Material Theme
	call :log "Installing Material Theme"
	curl https://raw.githubusercontent.com/HiSandy/npp-material-theme/master/Material%20Theme.xml -o "Material Theme.xml"
	if %errorlevel% neq 0 (
		echo Failed to download Material Theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	xcopy "Material Theme.xml" %AppData%\Notepad++\themes\ /E /C /I /Q
	if %errorlevel% neq 0 (
		echo Failed to copy Material Theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	REM Nord theme
	call :log "Installing Nord theme"
	curl https://raw.githubusercontent.com/arcticicestudio/nord-notepadplusplus/develop/src/xml/nord.xml -LJ -o Nord.xml
	if %errorlevel% neq 0 (
		echo Failed to download Nord theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	xcopy Nord.xml %AppData%\Notepad++\themes\ /E /C /I /Q
	if %errorlevel% neq 0 (
		echo Failed to copy Nord theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	REM Mariana theme
	call :log "Installing Mariana theme"
	curl https://raw.githubusercontent.com/Codextor/npp-mariana-theme/master/Mariana.xml -o Mariana.xml
	if %errorlevel% neq 0 (
		echo Failed to download Mariana theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	xcopy Mariana.xml %AppData%\Notepad++\themes\ /E /C /I /Q
	if %errorlevel% neq 0 (
		echo Failed to copy Mariana theme, error code %errorlevel%, exiting...
		goto :EOF
	)
	


:installUnikey
    cls
    call :log "Starting Unikey installation"
    @echo off
    cd /d %temp%
    call :log "Downloading Unikey"
    curl -# -o unikey43RC5-200929-win64.zip -L https://www.unikey.org/assets/release/unikey43RC5-200929-win64.zip
    if not exist "%ProgramFiles%\7-Zip" (
      call :log "Installing 7zip"
      call :install7zip
    )
    if not exist "C:\Program Files\Unikey" (
      call :log "Unzipping Unikey"
      "c:\Program Files\7-Zip\7z.exe" x -y unikey43RC5-200929-win64.zip -o"C:\Program Files\Unikey"
    )
    call :log "Copying Unikey to Startup"
    mklink "c:\Program Files\Unikey\UniKeyNT.exe" "%_programDATA%\StartUp" /y
    call :log "Creating Unikey shortcut on desktop"
    mklink "%public%\Desktop\UnikeyNT.exe" "C:\Program Files\Unikey\UniKeyNT.exe"
    cd /d %_dp%
    call :log "Finishing Unikey installation"
    exit /b

REM function install 7zip by using winget
:install7zip
    cls
	call :installsoft 7zip.7zip
    REM associate regular files extension with 7zip
    assoc .7z=7-Zip
    assoc .zip=7-Zip
    assoc .rar=7-Zip
    assoc .tar=7-Zip
    assoc .gz=7-Zip
    assoc .bzi
:end

:clean
    del /q /f /s %temp%\*.*
    REM forfiles search files with criteria > 7 days and delete
    REM forfiles /p %temp% /s /m *.* /d -7 /c "cmd /c del /f /q @path"
    exit /b



