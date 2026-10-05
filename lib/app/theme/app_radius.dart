import 'package:flutter/widgets.dart';

/// Corner radius tokens. Corners are deliberately restrained so data-heavy
/// screens look precise rather than playful.
abstract final class AppRadius {
  /// Chips, tags, small indicators.
  static const double sm = 6;

  /// Buttons, inputs.
  static const double md = 10;

  /// Cards, list containers.
  static const double lg = 14;

  /// Dialogs, bottom sheets.
  static const double xl = 20;

  /// Fully rounded (pills, avatars).
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));

  static const Map<String, double> scale = {'sm': sm, 'md': md, 'lg': lg, 'xl': xl};
}
