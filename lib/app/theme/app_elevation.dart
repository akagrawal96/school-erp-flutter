import 'dart:ui' show Brightness;

import 'package:flutter/painting.dart';

/// Elevation levels. Surfaces are separated mainly by tone and borders;
/// shadows are reserved for content that floats above the page.
abstract final class AppElevation {
  /// Page content, cards, app bars at rest.
  static const double level0 = 0;

  /// App bar when content scrolls underneath.
  static const double level1 = 1;

  /// Menus, dropdowns, snack bars.
  static const double level2 = 3;

  /// Dialogs, bottom sheets.
  static const double level3 = 6;
}

/// Soft shadows for floating content. Dark theme relies on surface tone
/// instead, so it uses fainter shadows.
abstract final class AppShadows {
  static List<BoxShadow> floating(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Color.fromRGBO(15, 23, 42, isDark ? 0.32 : 0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Color.fromRGBO(15, 23, 42, isDark ? 0.24 : 0.04),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ];
  }
}
