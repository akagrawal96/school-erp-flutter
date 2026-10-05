import 'package:flutter/widgets.dart';

/// Window size classes. The single place where layout width thresholds live —
/// never compare raw `MediaQuery` widths in feature code.
enum WindowSize {
  /// Phones in portrait (< 600 dp).
  compact,

  /// Large phones in landscape, small tablets (600–839 dp).
  medium,

  /// Tablets in landscape and larger (≥ 840 dp).
  expanded;

  static WindowSize fromWidth(double width) {
    if (width < AppBreakpoints.medium) return WindowSize.compact;
    if (width < AppBreakpoints.expanded) return WindowSize.medium;
    return WindowSize.expanded;
  }

  bool get isCompact => this == WindowSize.compact;
}

abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 840;
}

extension WindowSizeContext on BuildContext {
  /// Window size class of the current screen. Rebuilds only when the size changes.
  WindowSize get windowSize => WindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}
