# 0002. Build flavors: app × environment

- **Status:** Accepted
- **Date:** 2026-09-17

## Context

We need separate staging and production builds installable side by side.
The business also plans white-label apps for individual institutions (own
store listing, name, icon) and possibly separate apps per audience
(parent/student vs staff) from the same codebase.

## Decision

- Use native build flavors with **two dimensions**: `app` (product identity)
  and `env` (backend environment). Flutter flavor name is `<app><Env>`.
- The default product is `erp` with application ID `com.schoolerp.app`;
  `staging` adds a `.staging` ID suffix and an app-name suffix.
- The flavor is the **single source of truth** for environment selection.
  Dart parses it via `AppFlavor.parse(appFlavor)` and fails fast when it is
  missing or unknown.
- Runtime institution branding (downloaded after login) is layered on top of
  the flavor's default branding.
- Only **two environments**: `staging` (development and testing) and `prod`.

## Alternatives considered

| Option | Why not chosen |
|---|---|
| Single dimension (`staging`/`prod`) | Adding white-label later would rename every flavor and break CI and run configs. |
| Separate `dev` environment | The project has a single developer; a third environment adds build, backend and Firebase setup without benefit. A `dev` flavor can be added later without renaming existing flavors. |
| Separate `main_staging.dart` / `main_prod.dart` entry points | Easy to run the wrong entry point with the wrong native flavor; duplicates bootstrap code. |
| Environment only via `--dart-define-from-file` | Cannot change application ID, app name, icon or Firebase config. |
| Separate repositories per white-label client | Fixes and features would have to be ported across copies. |

## Consequences

- Every build/run command must pass `--flavor`.
- Adding a white-label app = one Gradle flavor + resources + enum value (see
  `docs/architecture/flavors.md`).
- iOS needs matching schemes/xcconfigs per flavor; this requires a Mac and is
  deferred.
- Firebase needs one registered app per application ID (step 8).
