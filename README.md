# gnowt

A mobile wallet for [gno.land](https://gno.land) whose key is protected by the
phone's secure hardware, built for the Gnome Tavern Hackathon.

## Threat model

The gno.land key is **hardware-protected, not hardware-signed**.

The Secure Enclave cannot sign secp256k1, so the secp256k1 seed is encrypted
(wrapped) by a key that lives in secure hardware: a Secure Enclave P-256 key on
iOS, an AndroidKeyStore AES-GCM key in StrongBox (TEE as fallback) on Android.
Every signature needs its own biometric approval to unwrap the seed. The
plaintext seed then exists only in app memory, as bytes, for the time it takes
to sign, and is overwritten with zeros right after.

This protects the seed at rest and gates every signature on the device owner's
biometrics. It does not protect against an attacker who controls the running
app process at the moment of signing.

## Modules

| Module | Path | Language | Depends on | Published to |
|---|---|---|---|---|

Dependencies run one way: the app depends on the packages, and no package
depends on the app.

## Getting started

Requirements: Flutter (with its Dart SDK), Node.js, gno (`gno`, `gnokey`,
`gnodev`), `swift-format` (ships with Xcode), `ktlint` and `gitleaks`.

```bash
dart pub global activate melos
dart pub get
npm install
git config core.hooksPath tools/git-hooks
```

Copy `.env.example` to `.env` for local tooling. `.env` is gitignored.

Common tasks:

```bash
melos run format        # format Dart, Swift, Kotlin and Gno
melos run format:check  # what the pre-commit hook and CI run
melos run analyze
melos run test:dart
melos run test:flutter
```

## Contributing

Read [CLAUDE.md](CLAUDE.md) for the engineering rules: atomic Conventional
Commits with a required scope, rebase-only merges, naming rules, per-module
versioning and key-handling rules. The `commit-msg` hook and CI enforce the
commit format.
