# ChePay Release Package

This release includes prebuilt binaries so users do not need to compile from source.

## Included binaries

- `bitcoin-qt` (GUI wallet/node)
- `bitcoind` (daemon node)
- `bitcoin-cli` (RPC CLI)
- `bitcoin-wallet` (wallet tool)
- `bitcoin-tx` (raw transaction tool)

## Quick start (GUI)

1. Unzip the release package.
2. Run `bitcoin-qt`.
3. Let the node sync.

## Quick start (headless node)

1. Create config folder:
   - Windows: `%APPDATA%\ChePay`
   - Linux: `~/.chepay`
   - macOS: `~/Library/Application Support/ChePay`
2. Create `chepay.conf` with:

```ini
server=1
listen=1
txindex=1
rpcuser=chepayrpc
rpcpassword=change-this-password
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
addnode=chepay-node1.duckdns.org
port=28333
```

3. Start daemon:
   - `bitcoind -daemon` (Linux/macOS)
   - `bitcoind.exe` (Windows)
4. Check status:
   - `bitcoin-cli getblockchaininfo`

## Start CPU mining (testing)

CPU mining is for local testing only.

- Single-thread:
  - `bitcoin-cli generatetoaddress 101 "<your_address>"`
- Continuous generation via RPC (if enabled in your build config):
  - `bitcoin-cli -deprecatedrpc=generate setgenerate true 1`

## Stop node

- `bitcoin-cli stop`

## Bootstrap/seed behavior

- This fork is configured to seed from `chepay-node1.duckdns.org`.
- Consensus deployment start heights have been set to `0` for genesis-era activation in this network.
