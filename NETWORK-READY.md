# ChePay Bootstrap + DuckDNS Runtime

This repo now includes a Dockerized DuckDNS updater and a bootstrap launcher script.

## What was set
- Seed hostname in code: `chepay-node1.duckdns.org`
- DuckDNS updater compose file: `docker/duckdns/compose.yaml`
- DuckDNS token env file: `docker/duckdns/.env`
- Bootstrap launcher: `scripts/start-network.ps1`
- Local auto-miner helper: `scripts/auto-mine-local.ps1`

## Start everything
From repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-network.ps1
```

That command:
1. Starts DuckDNS updater in Docker (if compose/env files are present).
2. Writes `%APPDATA%\ChePay\chepay.conf` with local bootstrap settings.
3. Tries to resolve `chepay-node1.duckdns.org`.
4. Launches `bitcoin-qt.exe` automatically if it exists.
5. Starts local auto-mining so the chain can advance from block 0 without waiting on external peers.

## Check DuckDNS container
```powershell
docker ps --filter "name=chepay-duckdns"
docker logs chepay-duckdns --tail 50
```

## Stop DuckDNS updater
```powershell
docker compose -f .\docker\duckdns\compose.yaml --env-file .\docker\duckdns\.env down
```
