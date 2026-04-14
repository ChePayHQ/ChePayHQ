param(
    [string]$SeedHost = "chepay-node1.duckdns.org",
    [int]$P2PPort = 28333
)

$ErrorActionPreference = "Stop"

Write-Host "== DuckDNS container =="
$container = docker ps -a --filter "name=chepay-duckdns" --format "{{.Names}}|{{.Status}}"
if (-not $container) {
    Write-Host "MISSING: chepay-duckdns container"
} else {
    Write-Host $container
}

Write-Host "== DNS =="
try {
    $dns = Resolve-DnsName $SeedHost -ErrorAction Stop | Where-Object { $_.Type -eq 'A' } | Select-Object -First 1
    if ($dns) {
        Write-Host ("{0} -> {1}" -f $dns.Name, $dns.IPAddress)
    } else {
        Write-Host "No A record returned"
    }
} catch {
    Write-Host "DNS lookup failed: $($_.Exception.Message)"
}

Write-Host "== P2P Port Reachability =="
$client = New-Object System.Net.Sockets.TcpClient
$iar = $client.BeginConnect($SeedHost, $P2PPort, $null, $null)
$ok = $iar.AsyncWaitHandle.WaitOne(5000, $false)
if ($ok -and $client.Connected) {
    Write-Host ("OPEN: {0}:{1}" -f $SeedHost, $P2PPort)
} else {
    Write-Host ("CLOSED/UNREACHABLE: {0}:{1}" -f $SeedHost, $P2PPort)
}
$client.Close()

Write-Host "== Local Config =="
$confPath = Join-Path ([Environment]::GetFolderPath("ApplicationData")) "ChePay\\chepay.conf"
if (Test-Path $confPath) {
    Write-Host "Found $confPath"
    Get-Content $confPath
} else {
    Write-Host "Missing $confPath"
}
