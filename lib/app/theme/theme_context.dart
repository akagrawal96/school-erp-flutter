import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_colors.dart';

/// Short, consistent access to theme values from widgets.
extension ThemeContext on BuildContext {
  /// Material color roles (primary, surface, error, …).
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Semantic colors not covered by [ColorScheme] (text, borders, status).
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;

  /// The app type scale.
  TextTheme get textStyles => Theme.of(this).textTheme;
}
