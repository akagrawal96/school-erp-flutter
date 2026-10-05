import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/branding/app_branding.dart';

/// Builds the Material [ColorScheme] from brand colors.
///
/// - Brand roles (primary, secondary, tertiary) use the `fidelity` variant so the
///   primary color stays close to the institution's actual brand color.
/// - Surfaces, text and outlines use the `neutral` variant: near-neutral greys
///   with only a hint of brand hue, which keeps dense ERP screens calm.
/// Both variants come from Material's tonal system, which guarantees readable
/// on-color contrast for any seed color.
abstract final class AppColorScheme {
  static ColorScheme build(AppBranding branding, Brightness brightness) {
    final brand = ColorScheme.fromSeed(
      seedColor: branding.primarySeed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final neutral = ColorScheme.fromSeed(
      seedColor: branding.primarySeed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    );

    var scheme = brand.copyWith(
      surface: neutral.surface,
      onSurface: neutral.onSurface,
      onSurfaceVariant: neutral.onSurfaceVariant,
      surfaceDim: neutral.surfaceDim,
      surfaceBright: neutral.surfaceBright,
      surfaceContainerLowest: neutral.surfaceContainerLowest,
      surfaceContainerLow: neutral.surfaceContainerLow,
      surfaceContainer: neutral.surfaceContainer,
      surfaceContainerHigh: neutral.surfaceContainerHigh,
      surfaceContainerHighest: neutral.surfaceContainerHighest,
      outline: neutral.outline,
      outlineVariant: neutral.outlineVariant,
      inverseSurface: neutral.inverseSurface,
      onInverseSurface: neutral.onInverseSurface,
      // Flat surfaces: no brand-colored tint when elevated.
      surfaceTint: Colors.transparent,
    );

    final secondarySeed = branding.secondarySeed;
    if (secondarySeed != null) {
      final accent = ColorScheme.fromSeed(
        seedColor: secondarySeed,
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      );
      scheme = scheme.copyWith(
        secondary: accent.primary,
        onSecondary: accent.onPrimary,
        secondaryContainer: accent.primaryContainer,
        onSecondaryContainer: accent.onPrimaryContainer,
      );
    }
    return scheme;
  }
}
