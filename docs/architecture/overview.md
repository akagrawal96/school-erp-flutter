# Architecture overview

Feature-first + Clean Architecture. See
[ADR-0001](decisions/0001-feature-first-clean-architecture.md) for the reasoning.

## Layers and the dependency rule

```
presentation ──► domain ◄── data ◄── external (Dio, secure storage, Firebase, Drift…)
```

- **domain** — entities, repository interfaces, use cases. Pure Dart. Must not
  import Flutter, Riverpod, Dio, Firebase or any storage package.
- **data** — DTOs, mappers, data sources, repository implementations. Knows
  about infrastructure; converts it into domain types and `Failure`s.
- **presentation** — screens, widgets, controllers (Riverpod `Notifier` /
  `AsyncNotifier`). Talks to domain only; never to data sources directly.

Request flow:

```
Widget ─► Controller ─► (UseCase) ─► Repository (interface) ─► RepositoryImpl ─► DataSource ─► ApiClient ─► Dio
```

**Use cases are optional.** A controller may call a repository directly when
the use case would only forward the call. Create a use case when logic
combines several repositories, enforces a business rule, or is shared by
several controllers.

**Models.** API DTOs (`data/dto`) are mapped to domain entities
(`domain/entities`) through `data/mappers`. UI never sees DTOs, so backend
changes stay inside the data layer.

**Errors.** Data sources throw typed exceptions; repositories catch them and
return `Result<T>` holding a `Failure`. Widgets never use `try/catch` for
business operations. (Implemented in step 2.)

## Target folder structure

Folders are created only when the roadmap step that needs them is built — no
empty placeholder folders. ✅ = exists today.

```
lib/
├── main.dart                     ✅ entry point → bootstrap
├── app/                          app-wide composition
│   ├── app.dart                  ✅ root widget: theme, language, (routing in step 3)
│   ├── config/                   ✅ flavor (+ environment config in step 4)
│   ├── bootstrap/                ✅ startup services & provider overrides (+ Firebase in step 6)
│   ├── router/                   ✅ GoRouter, route paths, not-found screen (+ guards in step 5)
│   └── theme/                    ✅ tokens split by concern: colors, typography, spacing, radius,
│       └── branding/             ✅ elevation, motion, breakpoints, component themes; branding
├── core/                         feature-agnostic infrastructure (no UI)
│   ├── storage/                  ✅ preferences (+ secure storage in step 4)
│   ├── localization/             ✅ language choice (+ INR/date formatters)
│   ├── result/                   Result & Failure                                 (step 4)
│   ├── errors/                   exception types, error mapping                   (step 4)
│   ├── logging/                  logger interface                                 (step 4)
│   ├── network/                  ApiClient, interceptors, token refresh           (step 4)
│   ├── session/                  session, tenant/branch context                   (step 5)
│   ├── permissions/              permission & entitlement checks                  (step 5)
│   └── analytics/, crash/, notifications/   Firebase-backed services              (step 6)
├── shared/                       reusable UI used by 2+ features
│   ├── components/               ✅ buttons, inputs, cards, section, status chip, avatar, stat card, dialogs
│   ├── layouts/                  ✅ adaptive scaffold (bottom bar / navigation rail)
│   └── states/                   ✅ loading, skeleton, empty, error, offline views
├── l10n/                         ✅ ARB files (arb/) + generated localizations (generated/)
└── features/
    ├── authentication/           ✅ login UI, login controller, demo repository (API in step 4)
    ├── home/                     ✅ signed-in shell, module placeholders
    ├── dashboard/                ✅ student home (mock data)
    ├── attendance/               ✅ year summary, month calendar, day details (mock data)
    ├── academics/                ✅ timetable, homework with submission, results and report cards (mock data)
    ├── fees/                     ✅ dues, installments, online payment (demo), receipts (mock data)
    ├── profile/                  ✅ student profile (mock data)
    ├── more/                     ✅ secondary menu and sign out
    ├── settings/                 ✅ theme and language
    ├── component_gallery/        ✅ developer gallery of shared components (staging)
    ├── design_preview/           ✅ developer preview of the design system (staging)
    └── <feature>/
        ├── data/        datasources/  dto/  mappers/  repositories/
        ├── domain/      entities/  repositories/  usecases/
        └── presentation/ controllers/  screens/  widgets/
```

`test/` mirrors `lib/`.

## Cross-cutting principles

- **Multi-tenant:** no institution, branch, role or permission is hardcoded.
  All of it arrives from the backend after login.
- **Permissions, not roles:** UI checks capabilities such as `attendance.create`.
  Module visibility = institution entitlement × user permission.
- **Backend is the security boundary:** client checks only shape the UI.
- **Responsive:** one layout decision point (breakpoints) — no scattered
  `MediaQuery` width checks.
- **Performance:** lazy lists, server-side pagination, no heavy work in `build`.
