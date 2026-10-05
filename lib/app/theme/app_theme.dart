import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_color_scheme.dart';
import 'package:school_erp/app/theme/app_colors.dart';
import 'package:school_erp/app/theme/app_component_themes.dart';
import 'package:school_erp/app/theme/app_typography.dart';
import 'package:school_erp/app/theme/branding/app_branding.dart';

/// Assembles [ThemeData] from branding and design tokens.
abstract final class AppTheme {
  static ThemeData build({required AppBranding branding, required Brightness brightness}) {
    final scheme = AppColorScheme.build(branding, brightness);
    final colors = AppColors.fromScheme(scheme);
    final textTheme = AppTypography.textTheme.apply(
      fontFamily: AppTypography.fontFamily,
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );
    final components = AppComponentThemes(scheme, textTheme, colors);

    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      dividerColor: colors.divider,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      extensions: [colors],
      appBarTheme: components.appBar,
      filledButtonTheme: components.filledButton,
      outlinedButtonTheme: components.outlinedButton,
      textButtonTheme: components.textButton,
      segmentedButtonTheme: components.segmentedButton,
      inputDecorationTheme: components.inputDecoration,
      cardTheme: components.card,
      chipTheme: components.chip,
      dialogTheme: components.dialog,
      bottomSheetTheme: components.bottomSheet,
      snackBarTheme: components.snackBar,
      dividerTheme: components.divider,
      listTileTheme: components.listTile,
      navigationBarTheme: components.navigationBar,
      navigationRailTheme: components.navigationRail,
      tabBarTheme: components.tabBar,
    );
  }
}

/// Light theme for the current branding. Rebuilt only when branding changes.
final lightThemeProvider = Provider<ThemeData>(
  (ref) => AppTheme.build(branding: ref.watch(brandingProvider), brightness: Brightness.light),
);

/// Dark theme for the current branding. Rebuilt only when branding changes.
final darkThemeProvider = Provider<ThemeData>(
  (ref) => AppTheme.build(branding: ref.watch(brandingProvider), brightness: Brightness.dark),
);
