# Build flavors

See [ADR-0002](decisions/0002-build-flavors.md) for the reasoning.

## Two dimensions

| Dimension | Values today | Controls |
|---|---|---|
| `app` | `erp` | Product identity: application ID, app name, icon, Firebase app, default branding, default tenant (for white-label) |
| `env` | `staging`, `prod` | Backend environment, ID suffix, name suffix |

Flutter flavor name = `<app><Env>` → `erpStaging`, `erpProd`.

The Dart side reads the flavor through `AppFlavor.parse(appFlavor)`
(`lib/app/config/app_flavor.dart`). Add an enum value there for every new
`app` flavor — the unit test verifies all combinations parse.

## Adding a white-label app (example: "Sunrise Public School")

1. **Android** — in `android/app/build.gradle.kts` add to `productFlavors`:
   ```kotlin
   create("sunrise") {
       dimension = "app"
       applicationId = "com.schoolerp.sunrise"
       manifestPlaceholders["appName"] = "Sunrise School"
   }
   ```
2. **Resources** — launcher icons and splash in `android/app/src/sunrise/res/`.
   Resources in a flavor source set override `src/main`.
3. **Dart** — add `sunrise` to `AppVariant`. Its default branding and fixed
   tenant (skipping institution selection) are configured in `lib/app/config/`
   (from step 3/7).
4. **Firebase** — register `com.schoolerp.sunrise` and `com.schoolerp.sunrise.staging` apps and
   place `google-services.json` in `android/app/src/sunrise<Env>/` (step 8).
5. **Run** — `flutter run --flavor sunriseStaging`.

Runtime branding still applies on top: the default app downloads the
institution's branding after login; a white-label app ships it as the default.

## Audience-specific apps (future)

A "Parent & Student" app vs a "Staff" app is also an `app` flavor value
(e.g. `erpParent`), combined with an allow-list of modules. Not built yet.

## iOS

The bundle ID is `com.schoolerp.app` with deployment target iOS 15. iOS
schemes and `xcconfig` files for each flavor must be created and verified on a
Mac (roadmap: deferred). Until then `flutter build ios` without flavors is
unsupported.
