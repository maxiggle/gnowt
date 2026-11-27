# gnowt_store (GNS)

Flutter plugin that keeps a secret seed encrypted by a key held in the
phone's secure hardware, and releases it only after a biometric approval.

- **iOS:** the seed is wrapped with a Secure Enclave P-256 key created with
  `.biometryCurrentSet`.
- **Android:** the seed is wrapped with an AndroidKeyStore AES-GCM key with
  `setUserAuthenticationRequired(true)`, in StrongBox when available and the
  TEE otherwise.

It encrypts, decrypts and wipes secrets, nothing chain-specific: it does not
know about gno.land, addresses or signing.

## Threat model

Hardware-protected, not hardware-signed. The secure hardware wraps the seed;
the caller unwraps it after biometrics, signs in app memory and overwrites the
seed bytes with zeros right after.

## Testing

```bash
flutter test                 # Dart API with a fake platform
cd example && flutter test integration_test   # on a device or simulator
```
