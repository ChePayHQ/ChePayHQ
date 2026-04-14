ChePay Core integration/staging tree
====================================

ChePay is a Litecoin-derived memecoin with utility. The codebase keeps the
Litecoin-derived core architecture, but the chain parameters, branding,
network ports, and installer assets are set for ChePay.

Project home: <https://github.com/ChePayHQ/ChePayHQ>

## Fork Parameters

### Network Summary

| Parameter | Value |
| --- | --- |
| Coin name | ChePay |
| Ticker / unit | CPY |
| Slogan | the memcoin with utility |
| Genesis message | `CheyPay was born 4/13/2026` |
| Proof of work | Scrypt |
| SegWit | Enabled |
| Max block size | 2 MB base / 8 MWU weight limit |
| Block time | 45 seconds |
| Difficulty adjustment | Every block |
| Transaction confirmations | 6 confirmations |
| Base block reward | 150 CPY/block |
| Halving interval | 2,800,000 blocks |
| Max supply | 840,000,000 CPY |
| Transaction fee | 0.00000001 CPY per byte, adjustable |
| P2P port | 28333 |
| RPC port | 28332 |
| Base58 pubkey prefix | `C` |
| Base58 script prefix | `P` |
| Bech32 prefix | `p1...` |
| Premine | None |

### Economics

ChePay uses a fixed-supply, reward-halving model that starts at 150 CPY per
block and halves every 2,800,000 blocks, or roughly every 4 years at the
45-second block target.

That is 35 halvings over roughly 140 years, which is long enough to create a
slow tail of issuance without turning the chain into a perpetual inflation
model.

That schedule yields:

* 420,000,000 CPY in the first era
* 630,000,000 CPY after the first halving
* 735,000,000 CPY after the second halving
* a long-tail emission curve that asymptotically approaches 840,000,000 CPY

The economics are intentionally simple:

* The 45-second block target gives faster settlement than Litecoin while still
  leaving room for network propagation and confirmation safety.
* The 2 MB base block limit with SegWit-style weight accounting lets the chain
  carry more transaction volume without relying on a premine or inflationary
  subsidy.
* 6 confirmations keep wallet maturity and payment finality aligned with the
  faster block cadence.
* The reward schedule creates a large initial distribution window, then tapers
  into a long-lived, low-inflation tail.
* The network ports are dedicated to ChePay so the fork can run independently
  from Litecoin defaults.

### Issuance Schedule

The block subsidy starts at 150 CPY and halves every 2,800,000 blocks. The
first few eras are:

| Era | Block reward | Blocks in era | Issued in era | Cumulative supply |
| --- | --- | --- | --- | --- |
| 1 | 150 CPY | 2,800,000 | 420,000,000 | 420,000,000 |
| 2 | 75 CPY | 2,800,000 | 210,000,000 | 630,000,000 |
| 3 | 37.5 CPY | 2,800,000 | 105,000,000 | 735,000,000 |
| 4 | 18.75 CPY | 2,800,000 | 52,500,000 | 787,500,000 |
| 5 | 9.375 CPY | 2,800,000 | 26,250,000 | 813,750,000 |
| 6 | 4.6875 CPY | 2,800,000 | 13,125,000 | 826,875,000 |
| 7 | 2.34375 CPY | 2,800,000 | 6,562,500 | 833,437,500 |
| 8 | 1.171875 CPY | 2,800,000 | 3,281,250 | 836,718,750 |
| 9 | 0.5859375 CPY | 2,800,000 | 1,640,625 | 838,359,375 |
| 10 | 0.29296875 CPY | 2,800,000 | 820,312.5 | 839,179,687.5 |

The same halving pattern continues until the 840,000,000 CPY cap is reached.

### Throughput

The fork is tuned for higher transaction throughput than Litecoin's default
settings. In ideal transaction mixes, the 2 MB base block limit and 45-second
block cadence give an upper target of roughly 400 TPS. Real-world throughput
will vary with transaction size, script complexity, and network conditions.

## Development

The `main` branch is built and tested regularly, but it is not guaranteed to be
stable. Follow the build instructions in `doc/build-*.md`.

See `CONTRIBUTING.md` and `doc/developer-notes.md` for the contribution flow
and development guidance.

## Testing

Run unit tests with:

```sh
make check
```

Run functional tests with:

```sh
test/functional/test_runner.py
```

## License

ChePay Core is released under the terms of the MIT license. See [COPYING](COPYING)
or <https://opensource.org/licenses/MIT>.
