param(
    [string]$Version = "0.21.3-chepay",
    [string]$Configuration = "Release",
    [string]$Platform = "x64"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $repoRoot "dist"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$packageRoot = Join-Path $outDir ("ChePay-{0}-windows-{1}" -f $Version, $stamp)
$binDir = Join-Path $packageRoot "bin"
New-Item -ItemType Directory -Force $binDir | Out-Null

$candidates = @(
    (Join-Path $repoRoot (("build_msvc\\{0}\\{1}\\chepay-qt.exe") -f $Platform, $Configuration)),
    (Join-Path $repoRoot (("build_msvc\\{0}\\{1}\\chepayd.exe") -f $Platform, $Configuration)),
    (Join-Path $repoRoot (("build_msvc\\{0}\\{1}\\chepay-cli.exe") -f $Platform, $Configuration)),
    (Join-Path $repoRoot (("build_msvc\\{0}\\{1}\\chepay-tx.exe") -f $Platform, $Configuration)),
    (Join-Path $repoRoot (("build_msvc\\{0}\\{1}\\chepay-wallet.exe") -f $Platform, $Configuration))
)

$found = @()
foreach ($f in $candidates) {
    if (Test-Path $f) {
        Copy-Item $f -Destination $binDir -Force
        $found += $f
    }
}

if ($found.Count -eq 0) {
    throw "No binaries found under build_msvc/$Platform/$Configuration. Build first, then package."
}

$readme = @"
ChePay Windows Package

Version: $Version
Built on: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz")

Included binaries:
$((Get-ChildItem $binDir -File | ForEach-Object { "- " + $_.Name }) -join "`n")

Bootstrap defaults:
- DNS seed: chepay-node1.duckdns.org
- Fixed seed fallback: 70.170.144.22:28333
"@
$readme | Set-Content (Join-Path $packageRoot "README.txt")

$zipPath = "$packageRoot.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path "$packageRoot\\*" -DestinationPath $zipPath

$hash = Get-FileHash -Algorithm SHA256 $zipPath
"$($hash.Hash) *$(Split-Path $zipPath -Leaf)" | Set-Content "$zipPath.sha256"

Write-Host "Package created: $zipPath"
Write-Host "Checksum file: $zipPath.sha256"

