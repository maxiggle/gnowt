# vault realm

Gno realm deployed to onyx-1 at `gno.land/r/gnowt/vault/v1`. It holds funds
with a daily spend limit, and withdrawals above the limit need approval from
a guardian.

## Versioning

Deployed Gno code cannot be changed in place, so a breaking change ships as a
new package path (`gno.land/r/gnowt/vault/v2`) and the old one stays live.
The current version is in `VERSION`; tags look like `vault-realm-v0.1.0`.

## Testing

```bash
gno test .
```

Integration tests deploy and call the realm on a local `gnodev` chain.

## Deploying

The `gnowt` namespace must be registered to the deploying address on onyx-1
first. Deploy with `gnokey maketx addpkg` and record the transaction hash in
this module's changelog entry.
