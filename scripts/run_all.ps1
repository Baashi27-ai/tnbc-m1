param(
  [string]$Root = "C:\TNBC_project"
)

$ErrorActionPreference = "Stop"

function Section($msg){ Write-Host "`n=== $msg ===" -ForegroundColor Cyan }

Section "TNBC run_all.ps1 — start"

# 0) Prechecks
if (-not (Test-Path -LiteralPath $Root)) { throw "Root not found: $Root" }

# 1) Optional: run R pipeline if present
$mainR = Join-Path $Root "scripts\main.R"
if (Test-Path -LiteralPath $mainR) {
  Section "Running R pipeline (scripts\main.R)"
  # Requires Rscript on PATH
  & Rscript "$mainR"
} else {
  Write-Host "No R main script found (scripts\main.R). Skipping pipeline execution..." -ForegroundColor Yellow
}

# 2) Ensure output structure
$Rep = Join-Path $Root "results\REPORTS"
$M3  = Join-Path $Root "results\m3"
New-Item -ItemType Directory -Force -Path $Rep | Out-Null
New-Item -ItemType Directory -Force -Path $M3  | Out-Null

# 3) Build bundles from whatever exists (never fail if empty)
Section "Packing bundles"
$MasterZip = Join-Path $M3  "TNBC_master_bundle.zip"
$ReproZip  = Join-Path $M3  "TNBC_repro_bundle.zip"

if (Test-Path -LiteralPath $MasterZip) { Remove-Item -Force $MasterZip }
if (Test-Path -LiteralPath $ReproZip)  { Remove-Item -Force $ReproZip  }

# Pack REPORTS into Repro zip; pack results into Master zip
# (If folders empty, create a small placeholder to avoid empty zip failure)
function Ensure-NotEmpty([string]$p){
  if (-not (Get-ChildItem -LiteralPath $p -Recurse -Force -ErrorAction SilentlyContinue)) {
    New-Item -ItemType File -Force -Path (Join-Path $p ".keep") | Out-Null
  }
}
Ensure-NotEmpty $Rep
Ensure-NotEmpty (Join-Path $Root "results")

Compress-Archive -Path (Join-Path $Root "results\*") -DestinationPath $MasterZip -Force
Compress-Archive -Path (Join-Path $Rep  "*")        -DestinationPath $ReproZip  -Force

# 4) Create checksums & manifest under REPORTS
Section "Checksums + manifest"
$sumPath      = Join-Path $Rep 'checksums_M3.sha256'
$manifestPath = Join-Path $Rep 'release_manifest_M3.tsv'

$cand = @()
$c1 = Join-Path $Rep 'TNBC_Master_Report.docx'
$c2 = Join-Path $Rep 'TNBC_Master_Report.pdf'
$c3 = Join-Path $Rep 'TNBC_Master_Dictionary.docx'
$c4 = Join-Path $Rep 'TNBC_Master_Dictionary.pdf'
$c5 = Join-Path $Rep 'dict_tables.tsv'
$c6 = Join-Path $Rep 'dict_images.tsv'
$c7 = Join-Path $Rep 'parameters_M3.json'
$c8 = Join-Path $Rep 'deliverables_manifest_m3.tsv'
$c9 = Join-Path $Rep 'sessionInfo_M3.txt'
foreach($x in @($c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9)){ if(Test-Path -LiteralPath $x){ $cand += $x } }
$cand += $MasterZip
$cand += $ReproZip
$cand = $cand | Where-Object { Test-Path -LiteralPath $_ }

"file`tbytes`tsha256" | Set-Content -Path $manifestPath -Encoding UTF8
$checks = @()
foreach($p in $cand){
  $fi = Get-Item -LiteralPath $p
  $h  = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToUpper()
  "{0}`t{1}`t{2}" -f $fi.Name, [int64]$fi.Length, $h | Add-Content -Path $manifestPath -Encoding UTF8
  $checks += ("{0} *{1}" -f $h, $fi.Name)
}
$checks | Set-Content -Path $sumPath -Encoding UTF8

Section "Done"
