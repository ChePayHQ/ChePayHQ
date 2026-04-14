# Seeds

Utility to generate the seed list that is compiled into the client
(see [src/chainparamsseeds.h](/src/chainparamsseeds.h) and other utilities in [contrib/seeds](/contrib/seeds)).

The seed files are bootstrap data only. They are not part of consensus. Use
them to ship a small set of always-on ChePay peers that new nodes can discover
on startup.

Recommended workflow:

1. Run at least 2 to 3 stable seed nodes on public IPs or DNS names you control.
2. Put one endpoint per line in `nodes_main.txt` and, if you want testnet
   bootstrapping, `nodes_test.txt`.
3. Regenerate `src/chainparamsseeds.h` from this directory.

Example line formats:

```text
203.0.113.10:28333
[2001:db8::10]:28333
seed1.chepay.example:28333
```

If you do not have seed nodes yet, keep the lists empty and use `-addnode` or
`-connect` while bringing the network up.

## Dependencies

Ubuntu:

    sudo apt-get install python3-dnspython
