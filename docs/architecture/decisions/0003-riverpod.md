# 0003. Riverpod for state management and dependency injection

- **Status:** Accepted
- **Date:** 2026-09-17

## Context

The app needs app-wide state (theme, language, branding, later session and
tenant), per-screen async state, and a way to swap real services for fakes in
tests — without a separate service locator.

## Decision

- Use **Riverpod 3** (`flutter_riverpod`) as the only state-management and DI
  mechanism.
- Use `Notifier` / `AsyncNotifier` with `NotifierProvider` /
  `AsyncNotifierProvider`; `Provider` for derived or injected values.
- Declare providers **manually, without `riverpod_generator`**. The manual
  syntax is short in Riverpod 3 and avoids a code-generation step for every
  provider change. Code generation remains in use for models (freezed/json)
  from step 4.
- Services created at startup (preferences, later secure storage and API
  client) are exposed as providers that throw by default and are overridden in
  `lib/app/bootstrap/bootstrap.dart`. Tests override the same providers with
  fakes (`test/helpers/test_app.dart`).
- Legacy APIs (`StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`)
  are not used.

## Alternatives considered

| Option | Why not chosen |
|---|---|
| Bloc/Cubit | More boilerplate per feature; DI would still need a separate solution. |
| Provider package | Superseded by Riverpod; tied to the widget tree. |
| GetX | Mixes routing, DI and state with global singletons; hard to test. |
| `riverpod_generator` | Extra build step and generated files for little gain with Riverpod 3's syntax. Can be adopted later without changing behavior. |

## Consequences

- Widgets that read state extend `ConsumerWidget` / `ConsumerStatefulWidget`.
- Every test that pumps the app uses `ProviderScope` with `testOverrides()`.
