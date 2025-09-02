$ErrorActionPreference = 'Stop'
$shims = Join-Path $PSScriptRoot 'shims'
New-Item -ItemType Directory -Force -Path $shims | Out-Null

@('winget','choco','curl','aria2c') | ForEach-Object {
  $p = Join-Path $shims ("{0}.cmd" -f $_)
  @"
@echo off
echo [SHIM] %~n0 %*
exit /b 0
"@ | Set-Content -Path $p -Encoding ASCII
}

$env:PATH = "$shims;$($env:PATH)"
Write-Host "Shims ready at $shims and PATH updated for this session"
