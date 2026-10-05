# Architecture Decision Records

An ADR records a significant decision that is expensive to reverse: a core
package, a layering rule, a cross-cutting convention. Trivial implementation
details do not get an ADR.

## Process

1. Copy [0000-template.md](0000-template.md) to `NNNN-short-title.md`.
2. Open a PR with status **Proposed**; merge as **Accepted** after review.
3. Never rewrite an accepted ADR. Supersede it with a new one and mark the old
   one **Superseded by NNNN**.

## Index

| ADR | Title | Status |
|---|---|---|
| [0001](0001-feature-first-clean-architecture.md) | Feature-first Clean Architecture | Accepted |
| [0002](0002-build-flavors.md) | Build flavors: app × environment | Accepted |
| [0003](0003-riverpod.md) | Riverpod for state management & DI | Accepted |
| [0004](0004-design-system-and-branding.md) | Design system & runtime institution branding | Accepted |
| [0005](0005-go-router.md) | GoRouter navigation (guards in step 5) | Accepted |
| — | Result/Failure error handling | Planned (step 4) |
| — | Dio networking & API contract | Planned (step 4) |
| — | Permission & entitlement model | Planned (step 5) |
