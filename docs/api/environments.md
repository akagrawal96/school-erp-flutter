# API environments

| App flavor | Base URL | Notes |
|---|---|---|
| `erpStaging` | `http://staging.example.test/api/` (placeholder) | Replace with your own staging server, or pass `--dart-define=API_BASE_URL=...`. Plain HTTP. |
| `erpProd` | _TBD — must be HTTPS_ | To be provided by the backend team |

Wired into the app in roadmap step 2 (`lib/app/config/`).

## Staging over plain HTTP

Android 9+ blocks cleartext HTTP by default. The staging flavor will get a
network security config (`android/app/src/staging/res/xml/`) that allows
cleartext **only for the staging host**. Production never allows cleartext.

If staging moves to a public or HTTPS host, update this table and remove the
exception.
