import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/color_contrast.dart';

/// Semantic colors that Material's [ColorScheme] does not provide.
///
/// Read them with `context.appColors`. Feature code never uses raw colors:
/// brand and surface roles come from `context.colors` (the [ColorScheme]),
/// everything else from here.
@immutable
final class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.brandTint,
    required this.onBrandTint,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  /// Derives text and border roles from [scheme] and adds fixed status colors.
  factory AppColors.fromScheme(ColorScheme scheme) {
    final status = scheme.brightness == Brightness.light ? _lightStatus : _darkStatus;
    final brandTint = Color.alphaBlend(
      scheme.primary.withValues(alpha: scheme.brightness == Brightness.light ? 0.08 : 0.16),
      scheme.surfaceContainerLowest,
    );
    return AppColors(
      textPrimary: scheme.onSurface,
      textSecondary: scheme.onSurfaceVariant,
      textTertiary: Color.lerp(scheme.onSurfaceVariant, scheme.surface, 0.22)!,
      textDisabled: scheme.onSurface.withValues(alpha: 0.38),
      border: scheme.outlineVariant,
      borderStrong: scheme.outline,
      divider: scheme.outlineVariant.withValues(alpha: 0.7),
      brandTint: brandTint,
      // Brand color when readable on the tint; otherwise the most readable fallback.
      onBrandTint: [scheme.primary, scheme.onPrimaryContainer, scheme.onSurface].firstWhere(
        (color) => contrastRatio(color, brandTint) >= wcagAaNormalText,
        orElse: () => scheme.onSurface,
      ),
      success: status.success,
      onSuccess: status.onSuccess,
      successContainer: status.successContainer,
      onSuccessContainer: status.onSuccessContainer,
      warning: status.warning,
      onWarning: status.onWarning,
      warningContainer: status.warningContainer,
      onWarningContainer: status.onWarningContainer,
      info: status.info,
      onInfo: status.onInfo,
      infoContainer: status.infoContainer,
      onInfoContainer: status.onInfoContainer,
    );
  }

  final Color textPrimary;
  final Color textSecondary;

  /// Hints, captions, timestamps.
  final Color textTertiary;
  final Color textDisabled;

  /// Card and input outlines.
  final Color border;

  /// Focused/hovered outlines and table headers.
  final Color borderStrong;
  final Color divider;

  /// Soft brand-colored background for icon tiles, avatars and highlights.
  final Color brandTint;

  /// Icons and text on [brandTint].
  final Color onBrandTint;

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  // Status colors are not brand-configurable: "paid", "absent" or "overdue"
  // must look the same in every institution. Values checked for WCAG AA in tests.
  static const _lightStatus = _StatusPalette(
    success: Color(0xFF15803D),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFDCFCE7),
    onSuccessContainer: Color(0xFF14532D),
    warning: Color(0xFFB45309),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFEF3C7),
    onWarningContainer: Color(0xFF78350F),
    info: Color(0xFF0369A1),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFE0F2FE),
    onInfoContainer: Color(0xFF0C4A6E),
  );

  static const _darkStatus = _StatusPalette(
    success: Color(0xFF4ADE80),
    onSuccess: Color(0xFF052E16),
    successContainer: Color(0xFF14532D),
    onSuccessContainer: Color(0xFFDCFCE7),
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFF451A03),
    warningContainer: Color(0xFF78350F),
    onWarningContainer: Color(0xFFFEF3C7),
    info: Color(0xFF38BDF8),
    onInfo: Color(0xFF082F49),
    infoContainer: Color(0xFF0C4A6E),
    onInfoContainer: Color(0xFFE0F2FE),
  );

  @override
  AppColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? border,
    Color? borderStrong,
    Color? divider,
    Color? brandTint,
    Color? onBrandTint,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      brandTint: brandTint ?? this.brandTint,
      onBrandTint: onBrandTint ?? this.onBrandTint,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textTertiary: mix(textTertiary, other.textTertiary),
      textDisabled: mix(textDisabled, other.textDisabled),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      divider: mix(divider, other.divider),
      brandTint: mix(brandTint, other.brandTint),
      onBrandTint: mix(onBrandTint, other.onBrandTint),
      success: mix(success, other.success),
      onSuccess: mix(onSuccess, other.onSuccess),
      successContainer: mix(successContainer, other.successContainer),
      onSuccessContainer: mix(onSuccessContainer, other.onSuccessContainer),
      warning: mix(warning, other.warning),
      onWarning: mix(onWarning, other.onWarning),
      warningContainer: mix(warningContainer, other.warningContainer),
      onWarningContainer: mix(onWarningContainer, other.onWarningContainer),
      info: mix(info, other.info),
      onInfo: mix(onInfo, other.onInfo),
      infoContainer: mix(infoContainer, other.infoContainer),
      onInfoContainer: mix(onInfoContainer, other.onInfoContainer),
    );
  }
}

final class _StatusPalette {
  const _StatusPalette({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;
}
