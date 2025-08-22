# Verifies all files in checksums_M3.sha256 against the local copies in results/REPORTS and results/m3
param(
  [string]\C:\TNBC_project = 'C:\TNBC_project'
)
\C:\TNBC_project\results\REPORTS = Join-Path \C:\TNBC_project 'results\REPORTS'
\ = Join-Path \C:\TNBC_project\results\REPORTS 'checksums_M3.sha256'
if (!(Test-Path \)) { Write-Error "Missing: \"; exit 2 }

\ = Get-Content \ | Where-Object { \ -match '\*' }
\ = 0
foreach (\ in \) {
  # Format: HASH *FILENAME
  \ = \ -split '\s+\*'
  if (\.Count -lt 2) { continue }
  \ = \[0].Trim()
  \ = \[1].Trim()

  # Search both REPORTS and m3
  \ = @(
    Join-Path \C:\TNBC_project\results\REPORTS \,
    Join-Path (Join-Path \C:\TNBC_project 'results\m3') \
  ) | Where-Object { Test-Path \ }

  if (-not \) {
    Write-Host ("❌ Missing file locally: {0}" -f \) -ForegroundColor Red
    \++
    continue
  }
  # Prefer the first match
  \ = \[0]
  \ = (Get-FileHash -Algorithm SHA256 -Path \).Hash
  if (\ -ne \) {
    Write-Host ("❌ Hash mismatch: {0}
     expected {1}
     got      {2}" -f \, \, \) -ForegroundColor Red
    \++
  } else {
    Write-Host ("✅ {0}" -f \) -ForegroundColor Green
  }
}
if (\ -gt 0) { exit 1 } else { exit 0 }
