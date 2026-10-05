import 'package:flutter/widgets.dart';

/// Spacing scale on a 4 dp grid. Use these instead of literal numbers for
/// padding, margins and gaps.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal padding of page content on phones.
  static const double pageGutterCompact = lg;

  /// Horizontal padding of page content on tablets.
  static const double pageGutterExpanded = xl;

  /// Maximum width of reading/form content on wide screens.
  static const double maxContentWidth = 720;

  /// All scale values in ascending order, with their token names.
  static const Map<String, double> scale = {
    'xxs': xxs,
    'xs': xs,
    'sm': sm,
    'md': md,
    'lg': lg,
    'xl': xl,
    'xxl': xxl,
    'xxxl': xxxl,
  };
}

/// Vertical and horizontal gaps for use between children of Columns and Rows.
abstract final class AppGap {
  static const Widget xxs = SizedBox.square(dimension: AppSpacing.xxs);
  static const Widget xs = SizedBox.square(dimension: AppSpacing.xs);
  static const Widget sm = SizedBox.square(dimension: AppSpacing.sm);
  static const Widget md = SizedBox.square(dimension: AppSpacing.md);
  static const Widget lg = SizedBox.square(dimension: AppSpacing.lg);
  static const Widget xl = SizedBox.square(dimension: AppSpacing.xl);
  static const Widget xxl = SizedBox.square(dimension: AppSpacing.xxl);
}
