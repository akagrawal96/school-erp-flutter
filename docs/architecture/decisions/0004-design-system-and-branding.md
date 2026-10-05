# 0004. Design system and runtime institution branding

- **Status:** Accepted
- **Date:** 2026-09-17

## Context

The product must look premium and consistent, support light/dark/system
themes, and let each institution apply its own brand color — without letting
a poor brand color break readability or change the meaning of status colors.

## Decision

- All visual values are **tokens** in `lib/app/theme/`: colors, typography,
  spacing, radius, elevation/shadows, motion, breakpoints, icon sizes and
  Material component themes. Feature code reads them through
  `context.colors`, `context.appColors`, `context.textStyles` and the token
  classes — never literal colors, sizes or text styles.
- The color scheme is generated from a **brand seed color** using Material's
  tonal system: `fidelity` variant for brand roles (stays close to the real
  brand color), `neutral` variant for surfaces, text and outlines (calm,
  near-neutral greys). This guarantees accessible on-color contrast for any seed.
- **Institution branding** (`AppBranding`) controls only the primary and
  optional secondary seed. Status colors (success, warning, info, error) are
  fixed so "paid"/"overdue" look the same in every institution.
- Branding is runtime state (`brandingProvider`): default per app variant,
  replaced after login with the institution's branding, reset on logout.
- Contrast is verified by unit tests across difficult brand colors (very light,
  very dark, saturated) in both light and dark themes against WCAG AA.
- **Typography:** Roboto, bundled as an asset so text renders identically on
  every Android OEM skin and on iOS. Devanagari text uses the platform font
  (Noto Sans Devanagari on Android, Kohinoor Devanagari on iOS); line heights
  leave room for it.
- Default brand color: deep indigo `#2D4BD1` (placeholder until final branding).

## Alternatives considered

| Option | Why not chosen |
|---|---|
| Hand-picked full palettes per institution | Every institution would need a designer; contrast mistakes likely. |
| Using the seed color directly as `primary` | Light or saturated brand colors produce unreadable buttons and text. |
| `google_fonts` runtime fetching | Needs network on first launch, privacy concerns, inconsistent offline. |
| Bundling Noto Sans Devanagari now | Adds size; platform fonts already render Hindi well. Revisit if a device renders poorly. |

## Consequences

- New components get their styling from component themes or tokens; reviews
  reject literal colors/sizes in feature code.
- The backend must provide the institution's brand color as a hex value
  (added to the API contract in step 5).
