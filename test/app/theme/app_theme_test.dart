import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/theme/app_colors.dart';
import 'package:school_erp/app/theme/app_theme.dart';
import 'package:school_erp/app/theme/app_typography.dart';
import 'package:school_erp/app/theme/branding/app_branding.dart';
import 'package:school_erp/app/theme/color_contrast.dart';

/// Brand colors an institution might realistically choose, including
/// difficult ones (very light, very dark, highly saturated).
const _brandSeeds = <String, Color>{
  'default indigo': Color(0xFF2D4BD1),
  'teal': Color(0xFF0F766E),
  'maroon': Color(0xFF9F1239),
  'amber': Color(0xFFD97706),
  'bright yellow': Color(0xFFFFEB3B),
  'light pink': Color(0xFFF8BBD0),
  'near black': Color(0xFF111111),
  'pure red': Color(0xFFFF0000),
  'lime': Color(0xFF76FF03),
};

void main() {
  for (final brightness in Brightness.values) {
    group('${brightness.name} theme', () {
      for (final MapEntry(key: name, value: seed) in _brandSeeds.entries) {
        test('stays readable with $name branding', () {
          final theme = AppTheme.build(
            branding: AppBranding(primarySeed: seed),
            brightness: brightness,
          );
          final scheme = theme.colorScheme;
          final colors = theme.extension<AppColors>()!;

          void expectReadable(String pair, Color foreground, Color background) {
            expect(
              contrastRatio(foreground, background),
              greaterThanOrEqualTo(wcagAaNormalText),
              reason: '$pair contrast with $name branding',
            );
          }

          expectReadable('onPrimary/primary', scheme.onPrimary, scheme.primary);
          expectReadable(
            'onPrimaryContainer/primaryContainer',
            scheme.onPrimaryContainer,
            scheme.primaryContainer,
          );
          expectReadable('onSecondary/secondary', scheme.onSecondary, scheme.secondary);
          expectReadable('textPrimary/surface', colors.textPrimary, scheme.surface);
          expectReadable('textSecondary/surface', colors.textSecondary, scheme.surface);
          expectReadable('textTertiary/surface', colors.textTertiary, scheme.surface);
          expectReadable(
            'textSecondary/card',
            colors.textSecondary,
            scheme.surfaceContainerLowest,
          );
          expectReadable('onError/error', scheme.onError, scheme.error);
          expectReadable('onBrandTint/brandTint', colors.onBrandTint, colors.brandTint);
        });
      }

      test('status colors meet WCAG AA', () {
        final theme = AppTheme.build(branding: AppBranding.erpDefault, brightness: brightness);
        final c = theme.extension<AppColors>()!;
        final surface = theme.colorScheme.surface;

        for (final (name, fg, bg) in [
          ('onSuccess/success', c.onSuccess, c.success),
          ('onSuccessContainer/successContainer', c.onSuccessContainer, c.successContainer),
          ('onWarning/warning', c.onWarning, c.warning),
          ('onWarningContainer/warningContainer', c.onWarningContainer, c.warningContainer),
          ('onInfo/info', c.onInfo, c.info),
          ('onInfoContainer/infoContainer', c.onInfoContainer, c.infoContainer),
        ]) {
          expect(contrastRatio(fg, bg), greaterThanOrEqualTo(wcagAaNormalText), reason: name);
        }
        for (final (name, color) in [
          ('success', c.success),
          ('warning', c.warning),
          ('info', c.info),
        ]) {
          expect(
            contrastRatio(color, surface),
            greaterThanOrEqualTo(wcagAaLargeText),
            reason: '$name on surface',
          );
        }
      });
    });
  }

  test('theme uses the bundled font, app color extension and requested brightness', () {
    final theme = AppTheme.build(branding: AppBranding.erpDefault, brightness: Brightness.dark);

    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.brightness, Brightness.dark);
    expect(theme.textTheme.bodyMedium?.fontFamily, AppTypography.fontFamily);
    expect(theme.extension<AppColors>(), isNotNull);
  });

  test('secondary seed overrides the secondary role only', () {
    const base = AppBranding(primarySeed: Color(0xFF2D4BD1));
    const withAccent = AppBranding(
      primarySeed: Color(0xFF2D4BD1),
      secondarySeed: Color(0xFFD97706),
    );
    final a = AppTheme.build(branding: base, brightness: Brightness.light).colorScheme;
    final b = AppTheme.build(branding: withAccent, brightness: Brightness.light).colorScheme;

    expect(b.primary, a.primary);
    expect(b.surface, a.surface);
    expect(b.secondary, isNot(a.secondary));
  });

  test('contrastRatio matches WCAG reference values', () {
    expect(contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)), closeTo(21, 0.01));
    expect(contrastRatio(const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)), closeTo(1, 0.01));
  });
}
