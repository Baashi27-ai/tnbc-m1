param([string]$Root = "C:\TNBC_project")
$ErrorActionPreference = "Stop"

function Section([string]$m){ Write-Host "`n=== $m ===" -ForegroundColor Cyan }
function Ensure-NotEmpty([string]$p){
  if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Force -Path $p | Out-Null }
  if (-not (Get-ChildItem -LiteralPath $p -Recurse -Force -ErrorAction SilentlyContinue)) {
    New-Item -ItemType File -Force -Path (Join-Path $p '.keep') | Out-Null
  }
}
function Safe-Remove([string]$path){
  if (Test-Path -LiteralPath $path) {
    try { Remove-Item -LiteralPath $path -Force -ErrorAction Stop; Start-Sleep -Milliseconds 500 }
    catch { Start-Sleep -Seconds 1; Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 300 }
  }
}
function New-ZipSafe([string]$src,[string]$dst){
  # zip to temp first, then move with retries to avoid file-in-use races
  Safe-Remove $dst
  $tmp = Join-Path ([IO.Path]::GetTempPath()) (([IO.Path]::GetRandomFileName()) + '.zip')
  if (Test-Path $tmp) { Remove-Item $tmp -Force }
  $ok = $false; $tries = 0
  while(-not $ok -and $tries -lt 4){
    try {
      Compress-Archive -Path (Join-Path $src '*') -DestinationPath $tmp -Force -ErrorAction Stop
      $ok = $true
    } catch {
      $tries++
      Write-Host "⚠ Compress-Archive failed (try $tries). Retrying..." -ForegroundColor Yellow
      Start-Sleep -Seconds (1 + $tries)
      if ($tries -ge 4) { throw }
    }
  }
  $moved = $false; $mtries = 0
  while(-not $moved -and $mtries -lt 6){
    try {
      Move-Item -LiteralPath $tmp -Destination $dst -Force -ErrorAction Stop
      $moved = $true
    } catch {
      $mtries++
      Write-Host "⚠ Move-Item to $dst failed (try $mtries). Retrying..." -ForegroundColor Yellow
      Start-Sleep -Seconds (1 + $mtries)
      if ($mtries -ge 6) { throw "Could not move temp zip to $dst" }
    }
  }
}

Section "TNBC run_all.ps1 — start"
if (-not (Test-Path -LiteralPath $Root)) { throw "Root not found: $Root" }

# Paths
$Rep = Join-Path $Root 'results\REPORTS'
$M3  = Join-Path $Root 'results\m3'
New-Item -ItemType Directory -Force -Path $Rep | Out-Null
New-Item -ItemType Directory -Force -Path $M3  | Out-Null

# Optional R run
$mainR = Join-Path $Root 'scripts\main.R'
if (Test-Path -LiteralPath $mainR) {
  Section 'Running R (scripts\main.R)'
  & Rscript "$mainR"
} else {
  Write-Host 'No R main script found (scripts\main.R). Skipping pipeline execution…' -ForegroundColor Yellow
}

# Stage sources (exclude m3)
Section 'Packing bundles (staged, safe)'
$StageRoot   = Join-Path $Root '_stage_zip'
$StageMaster = Join-Path $StageRoot 'master'
$StageRepro  = Join-Path $StageRoot 'repro'
if (Test-Path $StageRoot) { Remove-Item -Recurse -Force $StageRoot }
New-Item -ItemType Directory -Force -Path $StageMaster,$StageRepro | Out-Null

Ensure-NotEmpty (Join-Path $Root 'results')
Ensure-NotEmpty $Rep

# Copy top-level files
$top = Get-ChildItem (Join-Path $Root 'results') -File -Force -ErrorAction SilentlyContinue
if ($top) { $top | Copy-Item -Destination $StageMaster -Force }

# Copy subdirs (except m3)
$dirs = Get-ChildItem (Join-Path $Root 'results') -Directory -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne 'm3' }
foreach ($d in $dirs) {
  if ($d -and $d.PSIsContainer -and (Test-Path -LiteralPath $d.FullName)) {
    Copy-Item -Recurse -Force -Path $d.FullName -Destination (Join-Path $StageMaster $d.Name)
  }
}

# Repro = exactly REPORTS content
$repItems = Get-ChildItem -Force -LiteralPath $Rep -ErrorAction SilentlyContinue
if ($repItems) { $repItems | Copy-Item -Recurse -Force -Destination $StageRepro -ErrorAction SilentlyContinue }

# Create archives via temp-zip + move
$MasterZip = Join-Path $M3 'TNBC_master_bundle.zip'
$ReproZip  = Join-Path $M3 'TNBC_repro_bundle.zip'
if (-not (Get-ChildItem $StageMaster -Recurse -Force -ErrorAction SilentlyContinue)) { New-Item -ItemType File (Join-Path $StageMaster '.keep') | Out-Null }
if (-not (Get-ChildItem $StageRepro  -Recurse -Force -ErrorAction SilentlyContinue)) { New-Item -ItemType File (Join-Path $StageRepro  '.keep') | Out-Null }

New-ZipSafe $StageMaster $MasterZip
New-ZipSafe $StageRepro  $ReproZip

Remove-Item -Recurse -Force $StageRoot

# Checksums + manifest
Section 'Checksums + manifest'
$sumPath      = Join-Path $Rep 'checksums_M3.sha256'
$manifestPath = Join-Path $Rep 'release_manifest_M3.tsv'
"file`tbytes`tsha256" | Set-Content -Path $manifestPath -Encoding UTF8

$names = @(
  'TNBC_Master_Report.docx','TNBC_Master_Report.pdf',
  'TNBC_Master_Dictionary.docx','TNBC_Master_Dictionary.pdf',
  'dict_tables.tsv','dict_images.tsv',
  'parameters_M3.json','deliverables_manifest_m3.tsv','sessionInfo_M3.txt'
)
$cand = @()
foreach($n in $names){ $p = Join-Path $Rep $n; if(Test-Path -LiteralPath $p){ $cand += $p } }
foreach($z in @($MasterZip,$ReproZip)){ if(Test-Path -LiteralPath $z){ $cand += $z } }

$checks = @()
foreach($p in $cand){
  $fi = Get-Item -LiteralPath $p
  $h  = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToUpper()
  "{0}`t{1}`t{2}" -f $fi.Name, [int64]$fi.Length, $h | Add-Content -Path $manifestPath -Encoding UTF8
  $checks += ("{0} *{1}" -f $h, $fi.Name)
}
$checks | Set-Content -Path $sumPath -Encoding UTF8

Section 'Summary (REPORTS)'; Get-ChildItem $Rep | Format-Table Name,Length -AutoSize
Section 'Summary (results\m3)'; Get-ChildItem $M3 | Format-Table Name,Length -AutoSize
Write-Host "`n✅ Done." -ForegroundColor Green
