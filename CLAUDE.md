# gnowt

Mobile wallet for gno.land whose secp256k1 key is protected by the phone's secure
hardware (Secure Enclave on iOS, StrongBox/TEE on Android), unlocked by biometrics
for every signature. Built for the Gnome Tavern Hackathon.

Source of truth: "gnowt: project spec and engineering rules" (Nov 25, 2026). This file
condenses it; when they disagree, the spec wins — flag the conflict.

## How to work

Use the `andrej-karpathy-skills:karpathy-guidelines` skill whenever writing, reviewing or
refactoring code in this repo. In short:

- **Think before coding.** State assumptions; if something is ambiguous, ask instead of
  picking silently. Push back when a simpler approach exists.
- **Simplicity first.** Minimum code for the request. No speculative features,
  abstractions or configurability. Respect the hackathon non-goals below.
- **Surgical changes.** Every changed line traces to the request. Don't touch adjacent
  code or formatting; mention unrelated dead code, don't delete it.
- **Goal-driven execution.** Turn tasks into verifiable checks (a failing test, a golden
  vector to match), then loop until they pass.

## Scope

Goals:
- Pure Dart SDK (`gno_dart`) that reads from gno.land, builds, signs and broadcasts
  transactions, with no Go runtime.
- Key protected by secure hardware, biometric approval per signature.
- Vault realm on onyx-1 with a daily spend limit and a guardian approving larger
  withdrawals.
- Demo: Face ID approval on a phone → confirmed transaction visible on gnoweb.

Non-goals (do not build): gas estimation, event subscriptions, message types beyond
`MsgCall` and `MsgSend`, signing inside secure hardware (key is hardware-*wrapped*, not
hardware-*signed*), Ethereum or other chains, Bazel.

Milestones: first phone-signed tx confirmed on onyx-1 by **Dec 7**. If SDK signatures
don't match gnokey by **Dec 1**, fall back to binding `gnoclient` via gomobile.
Internal submit **Dec 15**, hackathon deadline Dec 18, 2026.

## Repo layout

```
apps/wallet/                  Flutter app (iOS + Android)          scope: wallet-app
packages/gno_dart/            Pure Dart Gno SDK                    scope: gno-dart
packages/variance_keystore/   Flutter plugin, hardware-wrapped keys scope: keystore
contracts/vault/              Gno realm on onyx-1                  scope: vault-realm
tools/format/                 format.sh, format_check.sh           scope: tools
tools/git-hooks/              pre-commit, commit-msg               scope: tools
tools/golden-vectors/         gnokey scripts producing test vectors scope: tools
.github/workflows/ci.yml                                           scope: ci
pubspec.yaml                  Dart workspace root (Melos)          scope: repo
```

Structure rules:
- `gno_dart` never imports Flutter.
- `variance_keystore` knows nothing about gno.land: it encrypts, decrypts and wipes
  secrets only.
- The app joins them. Signing reaches the SDK through a `TransactionSigner` interface;
  the SDK never touches key storage.
- Dependencies point one way: app → packages. No package depends on the app.
- Directories are kebab-case, except Dart packages (snake_case, matching the pub name).
- Workspace packages link via the Dart workspace + Melos, never by copying code.
- Every module has its own `README.md`, `CHANGELOG.md` and tests folder.
- A new module is added to the spec's module table, CI and the format scripts in the
  same change that creates it.

## Git rules

Commits are atomic Conventional Commits 1.0.0 and every commit builds and passes its
module's tests.

```
<type>(<scope>): <description>

<body: why, wrapped at 72>

<footers: BREAKING CHANGE:, Refs:, Co-authored-by:>
```

- Scope is required: `gno-dart`, `keystore`, `vault-realm`, `wallet-app`, `tools`,
  `repo`, `ci` (`release` only for the release commit).
- Types: `feat` (minor), `fix`/`perf` (patch), `refactor`, `test`, `docs`, `build`,
  `ci`, `chore`, `style`, `revert`. Breaking: `!` after scope + `BREAKING CHANGE:` footer.
- Description: imperative, lowercase, no trailing period, ≤ 72 chars.
- One logical change per commit — if the message needs "and", split it.
- One module per commit unless genuinely cross-cutting (then scope `repo`).
- Formatting, renames and moves get their own commits, never mixed with logic.
- Tests ship in the same commit as the code they cover.
- Stage deliberately (review the diff); never blindly `git add .`.
- New module = its own commit first: generator output, README, empty CHANGELOG,
  version `0.0.0`, its CI wiring and module-table row. Message:
  `chore(<scope>): scaffold <module name>`. Lint/analysis setup follows as a separate
  `build(<scope>): ...` commit.
- Branches: `<type>/<scope>-<short-description>`, e.g. `feat/gno-dart-amino-sign-doc`.
  Clean up with `--fixup` + autosquash; merge by rebase only (no squash, no merge
  commits). Never force-push `main`; never rewrite history after a tag.
- Hooks: `git config core.hooksPath tools/git-hooks`. pre-commit runs
  `tools/format/format_check.sh`; commit-msg runs commitlint.
- Commit or push only when the user asks.

## Naming and code style

Every name says what it is or does without reading its body.

- Functions: verb phrases naming the effect — `deriveAddressFromPublicKey`,
  `fetchAccountSequence`.
- Types: noun phrases — `AminoSignDocument`, `HardwareWrappedSeed`.
- Booleans: yes/no questions — `isBiometricAvailable`, `hasGuardianApproved`.
- Units/encodings in the name when the type doesn't carry them — `gasFeeInUgnot`,
  `timeoutInMilliseconds`, `signatureHex`.
- No single letters (except short loop indices). No abbreviations: `transaction` not
  `tx`, `sequence` not `seq`. Allowed: `rpc`, `id`, `url`, `json`, `ugnot`.
- No generic names: `data`, `info`, `manager`, `helper`, `util`, `temp`, `result`,
  `handle`.
- Collections are plural nouns: `pendingWithdrawals`.
- Use gno.land terms consistently: realm, package path, `MsgCall`, ugnot, guardian.
- Comments explain why, never what. A name that needs a comment is the wrong name.

| Language | Files | Types | Functions/vars | Constants |
|---|---|---|---|---|
| Dart | `snake_case.dart` | UpperCamelCase | lowerCamelCase | lowerCamelCase |
| Swift | `UpperCamelCase.swift` | UpperCamelCase | lowerCamelCase | lowerCamelCase |
| Kotlin | `UpperCamelCase.kt` | UpperCamelCase | lowerCamelCase | UPPER_SNAKE_CASE |
| Gno | `snake_case.gno` | Go export rules | Go export rules | Upper/lowerCamelCase |

- Formatters are law: `dart format`, `swift-format`, `ktlint`, `gno fmt`, all through
  `tools/format/format.sh` / `format_check.sh`.
- Dart: `very_good_analysis` (fall back to `lints` recommended if too strict), zero
  warnings.
- Functions do one thing; past ~40 lines, extract the second thing.
- Public APIs in `gno_dart` and `variance_keystore` have doc comments with one usage
  example each.
- Errors are typed, never bare strings: `AccountNotFoundException`,
  `BiometricCancelledException`, `SequenceMismatchError`.

## Versioning

- Per-module semver, changelog and tags. Computed from commits by `melos version`,
  never edited by hand.
- Start at `0.0.0` in the scaffold commit, `0.1.0` on first `feat`. Before `1.0.0`, a
  breaking change bumps minor. No `1.0.0` during the hackathon.
- Only commits scoped to a module bump that module.
- Tags: `gno_dart-v0.1.0`, `variance_keystore-v0.1.0`, `vault-realm-v0.1.0`,
  `wallet-v0.1.0`. Wallet version is `0.1.0+1` (build number after `+`).
- Realm: deployed code is immutable, so breaking changes ship as a new package path
  (`gno.land/r/<namespace>/vault/v2`); version also in `contracts/vault/VERSION`.
- Release commit: `chore(release): publish packages`, version files and changelogs
  only; push with `git push --follow-tags`.

## Testing and quality gates

| Module | Unit | Integration | Tooling |
|---|---|---|---|
| gno_dart | address derivation, amino JSON, signing | read + broadcast on local `gnodev` | `dart test` |
| variance_keystore | Dart API with fake platform | encrypt/decrypt/wipe on device or simulator | `flutter test`, XCTest, JUnit |
| vault realm | limits, guardian approval, `Render()` | deploy + call on `gnodev` | `gno test` |
| wallet app | view models | one end-to-end flow on device | `flutter test`, `integration_test` |

Golden vectors: `tools/golden-vectors` uses `gnokey maketx` (no `-broadcast`) and
`gnokey sign` with fixed test mnemonics. JSON fixtures live in
`packages/gno_dart/test/fixtures/` and record the gnokey version. `gno_dart` must
reproduce every vector byte for byte; a mismatch blocks merging.

Done means: atomic Conventional Commits; commitlint, format and analysis clean; tests of
every changed module pass at each commit; golden vectors match; naming rules followed;
public API changes documented with an example; module README updated if usage changed;
CI green.

## Security rules for key handling

The plaintext seed exists only in memory, only after biometric approval, and only for
the time it takes to sign.

1. Never store the seed unencrypted, log, print or send it, or hold it in a Dart
   `String`. Use `Uint8List` and zero it right after signing.
2. iOS: wrap with a Secure Enclave P-256 key created with `.biometryCurrentSet`.
   Android: AndroidKeyStore AES-GCM key with `setUserAuthenticationRequired(true)`,
   StrongBox first, TEE fallback.
3. Every signature needs its own biometric approval. No session caching of the seed.
4. Show a readable transaction preview (realm, function, arguments, amount, fee)
   before the biometric prompt. No blind signing.
5. Test mnemonics are the only secrets allowed in the repo: in `test/fixtures/`,
   marked `TEST ONLY`, never holding real funds.
6. Keys, `.env` files and keystores are gitignored; gitleaks runs in CI.
7. Security-sensitive changes (keystore native code, signing in `gno_dart`) get a
   second read before merging — point them out to the user explicitly.
8. The README states the threat model: hardware-protected, not hardware-signed.
