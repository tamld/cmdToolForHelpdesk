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