param(
  [string]$Root = "C:\TNBC_project"
)

$Rep = Join-Path $Root "results\REPORTS"
$SumFile = Join-Path $Rep "checksums_M3.sha256"

if (!(Test-Path $SumFile)) {
  Write-Error "Missing: $SumFile"
  exit 2
}

$lines = Get-Content $SumFile | Where-Object { $_ -match '\*' }
$fail = 0

foreach ($ln in $lines) {
  # HASH *FILENAME
  $m = [regex]::Match($ln, '^(?<hash>[0-9A-Fa-f]{64})\s+\*(?<name>.+)$')
  if (-not $m.Success) { continue }

  $hash = $m.Groups['hash'].Value.ToUpper()
  $name = $m.Groups['name'].Value

  $candidates = @(
    Join-Path $Rep $name,
    Join-Path (Join-Path $Root 'results\m3') $name
  ) | Where-Object { Test-Path $_ }

  if (-not $candidates) {
    Write-Host ("❌ Missing file locally: {0}" -f $name) -ForegroundColor Red
    $fail++
    continue
  }

  $file  = $candidates[0]
  $local = (Get-FileHash -Algorithm SHA256 -Path $file).Hash.ToUpper()

  if ($local -ne $hash) {
    Write-Host ("❌ Hash mismatch: {0}`n     expected {1}`n     got      {2}" -f $name, $hash, $local) -ForegroundColor Red
    $fail++
  } else {
    Write-Host ("✅ {0}" -f $name) -ForegroundColor Green
  }
}

if ($fail -gt 0) { exit 1 } else { exit 0 }
