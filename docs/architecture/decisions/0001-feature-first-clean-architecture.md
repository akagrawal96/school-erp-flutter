# 0001. Feature-first Clean Architecture

- **Status:** Accepted
- **Date:** 2026-09-17

## Context

The app will grow to dozens of ERP modules (attendance, fees, examinations,
communication, …) built over years by a small team plus AI agents. It must
support multiple institutions, roles and backend changes without large
rewrites. Code must be easy to locate, test and change in isolation.

## Decision

- Organize code **by feature first** (`lib/features/<feature>/`), then by layer
  (`data`, `domain`, `presentation`).
- Shared infrastructure lives in `lib/core/` (no UI) and reusable UI in
  `lib/shared/`.
- Dependency rule: `presentation → domain ← data`. The domain layer is pure
  Dart and depends on no framework or infrastructure package.
- DTOs are mapped to domain entities; UI never consumes DTOs.
- Use cases are **optional**: added only when they hold real logic, combine
  repositories, or are reused. Pass-through use cases are not created.

## Alternatives considered

| Option | Why not chosen |
|---|---|
| Layer-first (`lib/models`, `lib/screens`, `lib/services`) | One feature is scattered across the tree; boundaries erode as the app grows. |
| Strict Clean Architecture with a use case per call | Large amounts of boilerplate that forwards calls without adding value. |
| Separate Dart packages per feature (monorepo) | Strong boundaries, but too much tooling overhead at this stage. Can be revisited if boundaries are violated in practice. |

## Consequences

- Each feature can be developed, tested and removed as a unit.
- Backend response changes stay in the data layer (DTO + mapper).
- More files per feature (DTO, entity, mapper) — accepted for long-term stability.
- Boundaries are enforced by review and AGENTS.md rules; an import-lint check
  may be added later if violations appear.
