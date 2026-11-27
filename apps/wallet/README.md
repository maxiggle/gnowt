# wallet

The gnowt Flutter app for iOS and Android: a gno.land wallet whose key is
protected by the phone's secure hardware.

It joins the two packages: `gnowt_store` unwraps the seed after a biometric
approval, and `gno_dart` builds, signs and broadcasts the transaction. Before
every biometric prompt the app shows a readable preview of the transaction
(realm, function, arguments, amount, fee). No blind signing.

Identifiers: `app.gnowt.xyz` (iOS bundle ID and Android application ID).

## Testing

```bash
flutter test                    # view models
flutter test integration_test   # end-to-end flow on a device
```
