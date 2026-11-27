# gno_dart

Pure Dart SDK for [gno.land](https://gno.land): reads chain state over RPC,
derives keys and addresses, builds amino-encoded transactions, signs them and
broadcasts them, with no Go runtime.

It does not import Flutter, so it runs in apps, on servers and in CLIs.

## Key storage

The SDK never stores or loads keys. Callers pass signing in through a
`TransactionSigner` so key storage stays with the app.

## Testing

```bash
dart test
```

Signatures are checked byte for byte against golden vectors produced by
`gnokey` (see `test/fixtures/`).
