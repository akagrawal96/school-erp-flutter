# Environment configuration & secrets

## Principle: the app contains configuration, never secrets

Anything shipped inside an APK/IPA — Dart constants, `--dart-define` values,
bundled asset files — can be extracted by anyone who downloads the app. So:

- **Allowed in the repo:** API base URLs, feature defaults, public Firebase config
  (`google-services.json`), analytics IDs.
- **Never in the repo or the app:** server API keys, database credentials,
  signing keys, keystore passwords, service-account JSON. These live on the
  backend or in CI secrets.

## How the environment is selected

The native build flavor (`--flavor erpStaging`) is the single source of truth.
`AppFlavor.parse(appFlavor)` reads it at startup and the app refuses to start
with a missing or unknown flavor. Environment-specific values (API URLs, etc.)
are resolved from the flavor in `lib/app/config/` — added in roadmap step 2.

## Local overrides

Per-developer overrides (e.g. pointing at a local backend) will use
`config/local.json` passed via `--dart-define-from-file`. That file is
git-ignored; a committed `config/local.example.json` documents the keys.

## Git-ignored secret files

See the "Secrets & credentials" block at the top of `.gitignore`:
`.env*`, `key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.p8`, `*.pem`,
provisioning profiles and service-account JSON.
