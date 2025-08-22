param(
  [string]$Root = "C:\TNBC_project"
)

# Robust SHA256 using built-in cmdlet (always uppercase hex)
function Get-FileSha256([string]$p){
  if (-not (Test-Path -LiteralPath $p)) { return $null }
  try { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToUpper() }
  catch { return $null }
}

$Rep     = Join-Path $Root "results\REPORTS"
$SumFile = Join-Path $Rep  "checksums_M3.sha256"

if (-not (Test-Path -LiteralPath $SumFile)) { Write-Error "Missing: $SumFile"; exit 2 }

$lines = Get-Content -LiteralPath $SumFile | Where-Object { $_ -match '\*' }

$fail = 0; $ok = 0; $seen = 0

foreach ($ln in $lines) {
  # HASH *FILENAME
  $m = [regex]::Match($ln, '^(?<hash>[0-9A-Fa-f]{64})\s+\*(?<name>.+)$')
  if (-not $m.Success) { continue }

  $seen++
  $expected = $m.Groups['hash'].Value.ToUpper()
  $name     = ($m.Groups['name'].Value) -replace '[\r\n]+',''  # trim CR/LF

  # Look in REPORTS first, then results\m3
  $candidates = @(
    (Join-Path $Rep $name),
    (Join-Path (Join-Path $Root 'results\m3') $name)
  )

  $file = $null
  foreach ($c in $candidates) {
    if (Test-Path -LiteralPath $c) { $file = $c; break }
  }

  if (-not $file) {
    Write-Host ("❌ Missing file locally: {0}" -f $name) -ForegroundColor Red
    $fail++; continue
  }

  $actual = Get-FileSha256 $file
  if (-not $actual) {
    Write-Host ("❌ Could not hash: {0}" -f $file) -ForegroundColor Red
    $fail++; continue
  }

  if ($actual -ne $expected) {
    Write-Host ("❌ Hash mismatch: {0}`n     expected {1}`n     got      {2}" -f $name, $expected, $actual) -ForegroundColor Red
    $fail++
  } else {
    Write-Host ("✅ {0}" -f $name) -ForegroundColor Green
    $ok++
  }
}

Write-Host ("`nSummary: {0} checked | {1} ok | {2} failed" -f $seen,$ok,$fail) -ForegroundColor Cyan
if ($fail -gt 0) { exit 1 } else { exit 0 }
