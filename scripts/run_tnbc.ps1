# Launch the TNBC pipeline runner
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
& powershell -ExecutionPolicy Bypass -File (Join-Path $here "run_all.ps1") -Root $root
