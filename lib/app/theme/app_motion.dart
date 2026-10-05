import 'package:flutter/animation.dart';

/// Motion tokens. ERP users value speed: keep transitions short and purposeful.
abstract final class AppMotion {
  /// Hover/press feedback, small state changes.
  static const Duration fast = Duration(milliseconds: 120);

  /// Most component transitions (expand, fade, theme change).
  static const Duration normal = Duration(milliseconds: 200);

  /// Page and dialog transitions.
  static const Duration slow = Duration(milliseconds: 300);

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
}
