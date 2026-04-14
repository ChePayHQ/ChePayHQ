param(
    [string]$Version = "v0.0.0-chepay",
    [string]$Configuration = "Release",
    [string]$Platform = "x64"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$stageDir = Join-Path $repoRoot "release\\ChePay-$Version-windows-$Platform"
$zipPath = Join-Path $repoRoot "release\\ChePay-$Version-windows-$Platform.zip"

New-Item -ItemType Directory -Force -Path $stageDir | Out-Null

$bins = @("bitcoin-qt.exe", "bitcoind.exe", "bitcoin-cli.exe", "bitcoin-wallet.exe", "bitcoin-tx.exe")
foreach ($bin in $bins) {
    $candidates = @(
        (Join-Path $repoRoot "build_msvc\\$Platform\\$Configuration\\$bin"),
        (Join-Path $repoRoot "build_msvc\\bitcoin-qt\\$Platform\\$Configuration\\$bin"),
        (Join-Path $repoRoot "build_msvc\\bitcoind\\$Platform\\$Configuration\\$bin"),
        (Join-Path $repoRoot "build_msvc\\bitcoin-cli\\$Platform\\$Configuration\\$bin"),
        (Join-Path $repoRoot "build_msvc\\bitcoin-wallet\\$Platform\\$Configuration\\$bin"),
        (Join-Path $repoRoot "build_msvc\\bitcoin-tx\\$Platform\\$Configuration\\$bin")
    )
    $src = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (!(Test-Path $src)) {
        throw "Missing binary: $bin"
    }
    Copy-Item $src $stageDir -Force
}

Copy-Item (Join-Path $repoRoot "RELEASE-INSTRUCTIONS.md") (Join-Path $stageDir "README.txt") -Force

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path (Join-Path $stageDir "*") -DestinationPath $zipPath -Force
Write-Host "Release package ready: $zipPath"
