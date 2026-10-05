# Dependencies

Every package in `pubspec.yaml` is listed here with the reason it exists.
Before adding one, ask: does it solve a real problem, is it stable and
maintained, and can it be hidden behind our own interface so it can be
replaced later?

## Runtime

| Package | Version | Why |
|---|---|---|
| `flutter` | SDK | Framework |
| `flutter_localizations` | SDK | Material/Cupertino translations and locale delegates for English and Hindi |
| `flutter_riverpod` | ^3.4.3 | State management and dependency injection ([ADR-0003](decisions/0003-riverpod.md)) |
| `dio` | ^5.11.1 | HTTP client behind `ApiClient` (auth header, session expiry, redacted dev logs) |
| `flutter_secure_storage` | ^11.2.0 | Session token in Android Keystore / iOS Keychain, behind `TokenStorage` |
| `intl` | ^0.20.3 | Required by generated localizations; date/number formatting |
| `go_router` | ^18.0.1 | Declarative routing, tab shell, deep links ([ADR-0005](decisions/0005-go-router.md)) |
| `url_launcher` | ^6.3.2 | Opens notice attachments and videos in the browser or a matching app, behind `LinkOpener` (web links only) |
| `shared_preferences` | ^2.5.5 | Non-sensitive preferences (theme mode, language), used only behind `AppPreferences` |

## Development

| Package | Why |
|---|---|
| `flutter_test` | Unit and widget tests |
| `flutter_lints` | Official lint baseline; stricter rules added in `analysis_options.yaml` |

## Assets

| Asset | License | Why |
|---|---|---|
| Roboto (`assets/fonts/roboto/`) | Apache 2.0 | Consistent typography on all devices ([ADR-0004](decisions/0004-design-system-and-branding.md)) |

## Planned (added in the roadmap step that needs them)

| Package | Step | Why |
|---|---|---|
| `freezed`, `freezed_annotation`, `json_serializable`, `json_annotation`, `build_runner` | 4 | Immutable models, unions, JSON mapping |
| `connectivity_plus` | 4 | Offline detection |
| `mocktail` | 4 | Test doubles without code generation |
| `firebase_core`, `firebase_crashlytics`, `firebase_analytics`, `firebase_messaging`, `flutter_local_notifications` | 6 | Crash reporting, analytics, push notifications |

`riverpod_generator` is intentionally **not** used (see ADR-0003).
`drift` is **not** planned until the first offline feature is designed.
