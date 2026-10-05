import 'package:flutter/painting.dart';

/// WCAG 2.x contrast ratio between two opaque colors, from 1 (none) to 21.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Minimum WCAG AA contrast for normal-size text.
const double wcagAaNormalText = 4.5;

/// Minimum WCAG AA contrast for large text and UI component boundaries.
const double wcagAaLargeText = 3;
