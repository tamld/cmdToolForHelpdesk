param(
  [ValidateSet('static','smoke','unattend','all')]
  [string]$Stage = 'all',
  [switch]$Offline
)

$ErrorActionPreference = 'Stop'
function Write-Ok($m){ Write-Host "[OK] $m" -ForegroundColor Green }
function Write-Warn($m){ Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Fail($m){ Write-Host "[FAIL] $m" -ForegroundColor Red; exit 1 }

$repo = Split-Path -Parent $PSScriptRoot
$cmdFile = Join-Path $repo 'Helpdesk-Tools.cmd'
$unattend1 = Join-Path $repo 'packages/autounattend.xml'
$unattend2 = Join-Path $repo 'packages/autounattend_wipe-all.xml'

if(-not (Test-Path $cmdFile)){ Write-Fail "Missing $cmdFile" }

function Test-Static {
  Write-Host "== Static checks =="
  $content = Get-Content -Raw -Path $cmdFile

  # Collect labels
  $labels = Select-String -InputObject $content -Pattern '^[ \t]*:([A-Za-z0-9_\-]+)' -AllMatches -Multiline | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }
  $dup = $labels | Group-Object | Where-Object { $_.Count -gt 1 }
  if($dup){ $dup | ForEach-Object { Write-Warn ("Duplicate label: {0} x{1}" -f $_.Name, $_.Count) } }
  else { Write-Ok "No duplicate labels" }

  # Collect gotos/calls
  $calls = @()
  $calls += (Select-String -InputObject $content -Pattern '(?mi)\bcall\s*:\s*([A-Za-z0-9_\-]+)' | ForEach-Object { $_.Matches.Groups[1].Value })
  $calls += (Select-String -InputObject $content -Pattern '(?mi)\bgoto\s*:?(\S+)' | ForEach-Object { $_.Matches.Groups[1].Value })
  $labelsSet = [Collections.Generic.HashSet[string]]::new()
  $null = $labels | ForEach-Object { [void]$labelsSet.Add($_) }
  $unresolved = $calls | Where-Object { -not $labelsSet.Contains($_) } | Select-Object -Unique
  if($unresolved){ $unresolved | ForEach-Object { Write-Warn "Unresolved target: $_" } } else { Write-Ok "All goto/call targets resolvable" }

  # Banned/risky patterns (warn only for initial setup)
  if($content -match '(?mi)call\s*:\s*hold'){ Write-Warn "Found placeholder calls to :hold" } else { Write-Ok "No :hold placeholders referenced" }
  if($content -match '--ignore-checksums'){ Write-Warn "Found --ignore-checksums (consider removing or justifying)" } else { Write-Ok "No --ignore-checksums" }
  if($content -match '(?mi)wmic\s+os\s+get\s+name'){ Write-Warn "WMIC OS name detection present; prefer build/registry" } else { Write-Ok "No WMIC OS name detection found" }

  # setlocal presence
  if($content -match '(?mi)^\s*setlocal\b'){ Write-Ok "setlocal found" } else { Write-Warn "setlocal not found" }
}

function Test-Smoke {
  Write-Host "== Smoke test (dry-run) =="
  # Setup shims
  & (Join-Path $PSScriptRoot 'setup-shims.ps1') | Out-Null
  $env:SAFE_MODE = '1'; $env:DRY_RUN = '1'; $env:CI = '1'
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = 'cmd.exe'
  # Build arguments safely with quoted path
  $quoted = '"' + $cmdFile + '"'
  $psi.Arguments = "/c echo 7| $quoted"
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.UseShellExecute = $false
  $p = [System.Diagnostics.Process]::Start($psi)
  $out = $p.StandardOutput.ReadToEnd()
  $err = $p.StandardError.ReadToEnd()
  $p.WaitForExit()
  if($p.ExitCode -ne 0){ Write-Fail "Helpdesk-Tools exited with $($p.ExitCode): $err" }
  if($out -match '\[1\] Install All In One Online' -or $out -match 'Main Menu'){ Write-Ok "Main menu rendered" } else { Write-Warn "Menu banner not detected; review output" }
}

function Test-Unattend {
  Write-Host "== Unattend XML validation =="
  foreach($f in @($unattend1,$unattend2)){
    if(Test-Path $f){
      try { [xml]$x = Get-Content -Raw -Path $f } catch { Write-Fail "XML not well-formed: $f" }
      Write-Ok "XML well-formed: $f"
      # Check key nodes
      $ns = @{ wcm = 'http://schemas.microsoft.com/WMIConfig/2002/State' }
      if($x.unattend.settings.component | Where-Object { $_.name -like '*Shell-Setup*' }){ Write-Ok "Shell-Setup component present" } else { Write-Warn "Shell-Setup missing" }
      # Check passwords encoded
      if($x.unattend.settings.component.UserAccounts.AdministratorPassword.Value){
        $plain = $x.unattend.settings.component.UserAccounts.AdministratorPassword.PlainText
        if($plain -eq 'false'){ Write-Ok "Administrator password not plaintext" } else { Write-Warn "Administrator password marked plaintext" }
      }
      # Check FirstLogonCommands exists
      if($x.unattend.settings.component.FirstLogonCommands){ Write-Ok "FirstLogonCommands present" } else { Write-Warn "FirstLogonCommands missing" }
    } else {
      Write-Warn "Unattend file not found: $f"
    }
  }
}

switch($Stage){
  'static' { Test-Static }
  'smoke' { Test-Smoke }
  'unattend' { Test-Unattend }
  'all' { Test-Static; Test-Smoke; Test-Unattend }
}

Write-Host "== Done =="
