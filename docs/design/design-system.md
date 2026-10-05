# Design system — usage guide

Decisions and reasoning: [ADR-0004](../architecture/decisions/0004-design-system-and-branding.md).
Live preview: run the staging app — the home screen is the design preview
(`lib/features/design_preview/`).

## Reading theme values

```dart
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';

Text(
  context.l10n.sampleCardTitle,
  style: context.textStyles.titleMedium,
);
Text(
  subtitle,
  style: context.textStyles.bodySmall?.copyWith(color: context.appColors.textSecondary),
);
Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: ...);
```

| Need | Use | Never |
|---|---|---|
| Brand / surface color | `context.colors.primary`, `.surface`, `.surfaceContainer`… | `Colors.blue`, `Color(0xFF…)` |
| Text, border, status color | `context.appColors.textSecondary`, `.border`, `.success`… | `Colors.grey` |
| Text style | `context.textStyles.bodyMedium` | `TextStyle(fontSize: 14)` |
| Padding / gaps | `AppSpacing.md`, `AppGap.sm` | `EdgeInsets.all(13)` |
| Corners | `AppRadius.mdAll` | `BorderRadius.circular(9)` |
| Animation | `AppMotion.normal`, `AppMotion.standard` | `Duration(milliseconds: 450)` |
| Phone vs tablet | `context.windowSize` | `MediaQuery.of(context).size.width > 600` |
| Strings | `context.l10n.someKey` | `'Submit'` |

## Tokens

| Category | File | Values |
|---|---|---|
| Colors | `app_color_scheme.dart`, `app_colors.dart` | Material roles + text (primary/secondary/tertiary/disabled), border, divider, success, warning, info (each with on/container variants) |
| Typography | `app_typography.dart` | Roboto; display 48/40/34, headline 30/26/22, title 20/16/14, body 16/14/12, label 14/12/11 |
| Spacing | `app_spacing.dart` | xxs 2, xs 4, sm 8, md 12, lg 16, xl 24, xxl 32, xxxl 48 |
| Radius | `app_radius.dart` | sm 6, md 10, lg 14, xl 20, pill |
| Elevation | `app_elevation.dart` | level0 0, level1 1, level2 3, level3 6; soft floating shadows |
| Motion | `app_motion.dart` | fast 120 ms, normal 200 ms, slow 300 ms |
| Breakpoints | `app_breakpoints.dart` | compact < 600, medium 600–839, expanded ≥ 840 |
| Icon sizes | `app_icon_sizes.dart` | sm 16, md 20, lg 24, xl 32 |
| Components | `app_component_themes.dart` | Buttons (48 dp), inputs, cards, chips, dialogs, sheets, snack bars, lists, navigation |

## Localization

- Strings live in `lib/l10n/arb/app_en.arb` (template) and `app_hi.arb`.
- After editing ARB files, run `flutter gen-l10n` (also runs automatically on
  `flutter run`/`flutter test`). Generated files in `lib/l10n/generated/` are
  committed and never edited by hand.
- Add a description (`@key`) for strings whose meaning is not obvious.
