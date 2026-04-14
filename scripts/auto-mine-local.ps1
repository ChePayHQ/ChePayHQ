param(
    [Parameter(Mandatory = $true)]
    [string]$CliPath,
    [int]$RpcPort = 28332,
    [int]$IntervalSeconds = 45,
    [string]$WalletName = ""
)

$ErrorActionPreference = "SilentlyContinue"

if (!(Test-Path $CliPath)) {
    Write-Host "Missing CLI binary: $CliPath"
    exit 1
}

$dataDir = Join-Path ([Environment]::GetFolderPath("ApplicationData")) "ChePay"
New-Item -ItemType Directory -Force $dataDir | Out-Null
$logFile = Join-Path $dataDir "auto-mine.log"

function Invoke-ChePayCli {
    param([string[]]$CliArgs)
    & $CliPath ("-rpcport=$RpcPort") @CliArgs 2>&1
}

function Get-LoadedWallet {
    $walletsRaw = Invoke-ChePayCli -CliArgs @("listwallets")
    $json = $walletsRaw -join "`n"
    if ([string]::IsNullOrWhiteSpace($json)) {
        return $null
    }

    try {
        $wallets = $json | ConvertFrom-Json
        if ($wallets -and $wallets.Count -gt 0) {
            return [string]$wallets[0]
        }
    } catch {}

    return $null
}

while ($true) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $info = Invoke-ChePayCli -CliArgs @("getblockchaininfo")
    if (($LASTEXITCODE -ne 0) -or -not $info) {
        Add-Content $logFile "$ts RPC not ready; retrying... $($info -join ' ')"
        Start-Sleep -Seconds 5
        continue
    }

    $wallet = $WalletName
    if ([string]::IsNullOrWhiteSpace($wallet)) {
        $wallet = Get-LoadedWallet
    }

    if ([string]::IsNullOrWhiteSpace($wallet)) {
        Invoke-ChePayCli -CliArgs @("createwallet", "wallet1") | Out-Null
        $wallet = Get-LoadedWallet
    }

    if ([string]::IsNullOrWhiteSpace($wallet)) {
        Add-Content $logFile "$ts No loaded wallet; retrying..."
        Start-Sleep -Seconds 10
        continue
    }

    $mine = Invoke-ChePayCli -CliArgs @("-rpcwallet=$wallet", "-generate", "1")
    if ($LASTEXITCODE -ne 0) {
        Add-Content $logFile "$ts Mining call failed on wallet '$wallet': $($mine -join ' ')"
        Start-Sleep -Seconds 10
        continue
    }

    $height = Invoke-ChePayCli -CliArgs @("getblockcount")
    Add-Content $logFile "$ts Mined 1 block on wallet '$wallet'. Height=$height Result=$($mine -join ' ')"

    Start-Sleep -Seconds $IntervalSeconds
}
