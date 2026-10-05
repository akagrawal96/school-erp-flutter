# Development setup

## Toolchain

| Tool | Version | Notes |
|---|---|---|
| Flutter | 3.47.2 (stable) | Same version as CI. Upgrade only via a `chore/` PR that updates CI and this table. |
| Dart | 3.13.2 | Bundled with Flutter |
| JDK | 17+ | Android Studio's bundled JDK works |
| Android SDK | compileSdk from Flutter, minSdk 24 | |
| Xcode | Latest stable | iOS only, macOS required |

Check your setup:

```bash
flutter --version
flutter doctor -v
```

## First run

```bash
git clone <repo-url>
cd schoolrepsolution
flutter pub get
flutter run --flavor erpStaging
```

### IDE run configurations

- **Android Studio / IntelliJ:** shared run configurations `erpStaging`, `erpProd`
  are committed in `.idea/runConfigurations/`.
- **VS Code:** the same configurations are in `.vscode/launch.json`.

## Commands

| Task | Command |
|---|---|
| Install dependencies | `flutter pub get` |
| Run (staging) | `flutter run --flavor erpStaging` |
| Format | `dart format .` |
| Analyze | `flutter analyze --fatal-infos` |
| Unit + widget tests | `flutter test` |
| Tests with coverage | `flutter test --coverage` |
| Debug APK | `flutter build apk --flavor erpStaging --debug` |
| Release bundle (Play Store) | `flutter build appbundle --flavor erpProd --release --obfuscate --split-debug-info=debug-info/` |

## Code generation

**Localizations** are generated from `lib/l10n/arb/*.arb` into
`lib/l10n/generated/` (committed):

```bash
flutter gen-l10n
```

This also runs automatically on `flutter run` and `flutter test`.

**Models** (`freezed`/`json_serializable` with `build_runner`) are added in
step 4; their workflow will be documented here.

Generated files must never be edited by hand.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Gradle: `Could not close incremental caches` | Already mitigated by `kotlin.incremental=false` in `android/gradle.properties` (project and pub cache on different Windows drives). If it reappears: `cd android && ./gradlew --stop`, delete `build/`, rebuild. |
