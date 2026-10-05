# 0005. GoRouter for navigation

- **Status:** Accepted
- **Date:** 2026-09-17

## Context

The app needs declarative routes, a persistent signed-in shell with tab
navigation (each tab keeping its own history), deep links from push
notifications, and redirects based on session and permissions.

## Decision

- Use **go_router** (Flutter team maintained), exposed as `routerProvider` in
  `lib/app/router/app_router.dart`.
- Route paths live in `AppRoutes`; code navigates with `context.go(AppRoutes.x)`,
  never string literals.
- The signed-in area is a `StatefulShellRoute.indexedStack` rendered by
  `HomeShell` through the shared `AdaptiveScaffold` (bottom bar on phones,
  navigation rail on tablets).
- Unknown locations render `NotFoundScreen`.
- Session redirects and permission guards are added in roadmap step 5 via the
  router's `redirect` and `refreshListenable`, driven by Riverpod session state.

## Alternatives considered

| Option | Why not chosen |
|---|---|
| Navigator 1.0 (`Navigator.push`) | No URL/deep-link model; guards and nested tab stacks are manual. |
| auto_route | Requires code generation for routes. |
| Beamer | Smaller community; overlapping capabilities. |

## Consequences

- Tabs preserve their own navigation stacks.
- Feature screens stay unaware of navigation structure beyond `AppRoutes`.
