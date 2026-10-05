import 'package:flutter/material.dart';

/// Type scale based on Roboto, tuned for data-dense mobile ERP screens:
/// slightly smaller display sizes than Material defaults and medium-weight
/// titles for clear hierarchy.
///
/// Line heights are generous enough for Devanagari (Hindi), whose glyphs are
/// taller than Latin text.
abstract final class AppTypography {
  static const String fontFamily = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 48,
      height: 56 / 48,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 40,
      height: 48 / 40,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displaySmall: TextStyle(fontSize: 34, height: 42 / 34, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(
      fontSize: 30,
      height: 38 / 30,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.25,
    ),
    headlineMedium: TextStyle(fontSize: 26, height: 34 / 26, fontWeight: FontWeight.w500),
    headlineSmall: TextStyle(fontSize: 22, height: 30 / 22, fontWeight: FontWeight.w500),
    titleLarge: TextStyle(fontSize: 20, height: 28 / 20, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 18 / 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.4,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      height: 16 / 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  /// Names of the text styles in display order, for previews and tests.
  static Map<String, TextStyle?> named(TextTheme theme) => {
    'displayLarge': theme.displayLarge,
    'displayMedium': theme.displayMedium,
    'displaySmall': theme.displaySmall,
    'headlineLarge': theme.headlineLarge,
    'headlineMedium': theme.headlineMedium,
    'headlineSmall': theme.headlineSmall,
    'titleLarge': theme.titleLarge,
    'titleMedium': theme.titleMedium,
    'titleSmall': theme.titleSmall,
    'bodyLarge': theme.bodyLarge,
    'bodyMedium': theme.bodyMedium,
    'bodySmall': theme.bodySmall,
    'labelLarge': theme.labelLarge,
    'labelMedium': theme.labelMedium,
    'labelSmall': theme.labelSmall,
  };
}
