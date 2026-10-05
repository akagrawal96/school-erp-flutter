import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_colors.dart';
import 'package:school_erp/app/theme/app_elevation.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';

/// Material component themes derived from the color scheme and type scale.
///
/// Styling lives here so that plain Material widgets already look on-brand;
/// shared components (step 3) add behavior, not ad-hoc styling.
final class AppComponentThemes {
  const AppComponentThemes(this.scheme, this.text, this.colors);

  final ColorScheme scheme;
  final TextTheme text;
  final AppColors colors;

  /// Minimum height of buttons and inputs; also the minimum touch target.
  static const double controlHeight = 48;

  static const _controlShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
  static const _buttonPadding = EdgeInsets.symmetric(horizontal: AppSpacing.xl);
  static const _minButtonSize = Size(64, controlHeight);

  AppBarTheme get appBar => AppBarTheme(
    backgroundColor: scheme.surface,
    foregroundColor: scheme.onSurface,
    elevation: AppElevation.level0,
    scrolledUnderElevation: AppElevation.level1,
    centerTitle: false,
    titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
  );

  FilledButtonThemeData get filledButton => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: _minButtonSize,
      padding: _buttonPadding,
      shape: _controlShape,
      textStyle: text.labelLarge,
    ),
  );

  OutlinedButtonThemeData get outlinedButton => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: _minButtonSize,
      padding: _buttonPadding,
      shape: _controlShape,
      textStyle: text.labelLarge,
      side: BorderSide(color: colors.borderStrong),
    ),
  );

  TextButtonThemeData get textButton => TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: _minButtonSize,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shape: _controlShape,
      textStyle: text.labelLarge,
    ),
  );

  SegmentedButtonThemeData get segmentedButton => SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(
      minimumSize: const Size(0, controlHeight),
      textStyle: text.labelLarge,
      side: BorderSide(color: colors.border),
      shape: _controlShape,
    ),
  );

  InputDecorationThemeData get inputDecoration {
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: color, width: width),
    );
    return InputDecorationThemeData(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: text.bodyLarge?.copyWith(color: colors.textTertiary),
      labelStyle: text.bodyLarge?.copyWith(color: colors.textSecondary),
      floatingLabelStyle: text.bodyMedium?.copyWith(color: scheme.primary),
      helperStyle: text.bodySmall?.copyWith(color: colors.textSecondary),
      errorStyle: text.bodySmall?.copyWith(color: scheme.error),
      border: border(colors.border),
      enabledBorder: border(colors.border),
      focusedBorder: border(scheme.primary, 2),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, 2),
      disabledBorder: border(colors.border.withValues(alpha: 0.5)),
    );
  }

  CardThemeData get card => CardThemeData(
    color: scheme.surfaceContainerLowest,
    elevation: AppElevation.level0,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.lgAll,
      side: BorderSide(color: colors.border),
    ),
  );

  ChipThemeData get chip => ChipThemeData(
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
    side: BorderSide(color: colors.border),
    labelStyle: text.labelMedium,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
  );

  DialogThemeData get dialog => DialogThemeData(
    backgroundColor: scheme.surfaceContainerLow,
    elevation: AppElevation.level3,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
    titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
    contentTextStyle: text.bodyMedium?.copyWith(color: colors.textSecondary),
  );

  BottomSheetThemeData get bottomSheet => BottomSheetThemeData(
    backgroundColor: scheme.surfaceContainerLow,
    elevation: AppElevation.level3,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
  );

  SnackBarThemeData get snackBar => SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: scheme.inverseSurface,
    contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
    actionTextColor: scheme.inversePrimary,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    elevation: AppElevation.level2,
  );

  DividerThemeData get divider => DividerThemeData(color: colors.divider, thickness: 1, space: 1);

  ListTileThemeData get listTile => ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    titleTextStyle: text.bodyLarge?.copyWith(color: colors.textPrimary),
    subtitleTextStyle: text.bodyMedium?.copyWith(color: colors.textSecondary),
    iconColor: colors.textSecondary,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
  );

  NavigationBarThemeData get navigationBar => NavigationBarThemeData(
    backgroundColor: scheme.surfaceContainerLow,
    indicatorColor: scheme.secondaryContainer,
    elevation: AppElevation.level0,
    labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
  );

  NavigationRailThemeData get navigationRail => NavigationRailThemeData(
    backgroundColor: scheme.surfaceContainerLow,
    indicatorColor: scheme.secondaryContainer,
    selectedLabelTextStyle: text.labelMedium?.copyWith(color: scheme.onSurface),
    unselectedLabelTextStyle: text.labelMedium?.copyWith(color: colors.textSecondary),
  );

  TabBarThemeData get tabBar => TabBarThemeData(
    labelColor: scheme.primary,
    unselectedLabelColor: colors.textSecondary,
    labelStyle: text.titleSmall,
    unselectedLabelStyle: text.titleSmall,
    indicatorColor: scheme.primary,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: colors.divider,
  );
}
