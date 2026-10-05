# Git workflow

## Branches

| Branch | Purpose | Rules |
|---|---|---|
| `main` | Released / release-ready code | Protected. Only merged from `develop` or `hotfix/*` via PR. Tag releases `vX.Y.Z`. |
| `develop` | Integration branch | Protected. Only merged via reviewed PR with green CI. |
| `feature/<name>` | New functionality | From `develop` |
| `fix/<name>` | Bug fix | From `develop` |
| `hotfix/<name>` | Urgent production fix | From `main`, merged back to `main` **and** `develop` |
| `refactor/<area>` | Restructuring without behavior change | From `develop` |
| `chore/<task>` | Tooling, dependencies, config | From `develop` |
| `docs/<topic>` | Documentation only | From `develop` |

Names are lowercase kebab-case: `feature/design-system`, `fix/token-refresh`.

Never commit directly to `main` or `develop`. (The single initial scaffold
commit on `main` was the only exception.)

## Commits — Conventional Commits

```
<type>(<optional scope>): <imperative summary, max ~72 chars>

<optional body: why, not what>
```

Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, `chore`, `style`.

Examples:

```
feat(auth): add token refresh queue
build(android): add staging flavor
docs(adr): record navigation decision
```

## Pull requests

1. Keep PRs small and scoped to one step/feature.
2. CI (format, analyze, test, debug build) must be green.
3. Fill in the PR template, including screenshots for UI changes (light + dark, phone + tablet).
4. At least one reviewer approves before merge. Prefer **squash merge** into `develop`.

## Line endings

`.gitattributes` forces LF for all text files, so Windows and macOS developers
produce identical diffs. If a whole file shows as changed after checkout, run:

```bash
git add --renormalize .
```

## Remote setup (one-time)

Create an empty private repository on GitHub, then:

```bash
git remote add origin https://github.com/<org>/<repo>.git
git push -u origin main develop
```

Then enable branch protection on `main` and `develop` (require PR, require CI status check).
