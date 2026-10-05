# Rules for AI agents and contributors

These rules apply to every change, whether written by a person or an AI agent.
When a rule blocks a task, stop and ask — do not work around it.

## Before you change anything

1. Read [docs/architecture/overview.md](docs/architecture/overview.md) and the
   [ADRs](docs/architecture/decisions/README.md).
2. Check [docs/roadmap.md](docs/roadmap.md): only work on the current step.
3. Look for an existing component, provider or abstraction before creating one.

## Never

- Change the architecture, add a layer, or replace a core package without an approved ADR.
- Introduce a second state-management approach (Riverpod only — no Bloc, GetX, Provider, MobX).
- Call Dio/HTTP, storage or Firebase directly from widgets, screens, routes or UI callbacks.
- Put business logic in `build` methods or widget callbacks.
- Hardcode colors, text styles, spacing, radii, user-facing strings, tenant data, permissions,
  API URLs or feature flags in feature code.
- Check roles by name (`if (role == 'admin')`). Check permissions/capabilities.
- Store tokens or secrets in SharedPreferences, source code, or committed files.
- Add a dependency without updating [docs/architecture/dependencies.md](docs/architecture/dependencies.md).
- Edit generated files (`*.g.dart`, `*.freezed.dart`, `lib/l10n/generated/`). Regenerate them.
- Suppress a lint without a comment explaining why.
- Create catch-all files (`utils.dart`, `helpers.dart`, `constants.dart` holding everything).
- Modify, reformat or "clean up" files unrelated to the task.
- Delete working code or tests without explaining why.
- Leave the analyzer, formatter or tests failing.

## Always

- Follow the folder structure and dependency rule in the architecture overview.
- Keep files focused on one responsibility; split when a file mixes concerns.
- Use package imports (`package:school_erp/...`).
- Write unit tests for domain/data logic and widget tests for shared components.
- Run the quality gate before finishing:
  ```bash
  dart format .
  flutter analyze --fatal-infos
  flutter test
  ```
- Reference the roadmap step or issue in any `TODO` comment: `// TODO(step-6): ...`.
- Explain architectural changes in the PR description; record significant ones as an ADR.
- Use Conventional Commits and the branch naming in [git-workflow.md](docs/development/git-workflow.md).

## Backend contract

The backend team builds APIs to the contract we define. If a screen needs data
in a shape the API does not provide, propose a contract change in
`docs/api/` instead of reshaping data in the UI layer.
