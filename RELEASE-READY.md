# Release Readiness (ChePay)

This repository contains bootstrap and runtime updates for first-network launch.

## Included in this update
- Mainnet DNS seed in code: `chepay-node1.duckdns.org`
- Generated fixed seed header updated
- Dockerized DuckDNS updater for seed host IP maintenance
- Runtime scripts:
  - `scripts/start-network.ps1`
  - `scripts/test-network.ps1`
  - `scripts/package-release.ps1`

## Production preflight checklist
1. Bootstrap host is online 24/7.
2. Router forwards TCP `28333` to the seed host machine.
3. Windows firewall allows inbound TCP `28333`.
4. DuckDNS updater container is running.
5. `scripts/test-network.ps1` shows `OPEN` for `chepay-node1.duckdns.org:28333`.
6. Binaries are built from this commit.
7. Package created with `scripts/package-release.ps1` and SHA256 file distributed.

## Build + package flow (Windows)
```powershell
# build via Visual Studio/MSBuild toolchain
cd build_msvc
py -3 msvc-autogen.py
msbuild /m bitcoin.sln /p:Platform=x64 /p:Configuration=Release /t:build

# package artifacts
cd ..
powershell -ExecutionPolicy Bypass -File .\scripts\package-release.ps1 -Version "0.21.3-chepay"
```

## Push flow
```powershell
git add .
git commit -m "Bootstrap + DuckDNS automation + release packaging"
git push -u origin main
```
