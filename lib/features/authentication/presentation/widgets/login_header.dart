import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';

/// Brand panel of the login screen: pattern, logo mark, product name and tagline.
///
/// [trailing] sits in the top-right corner (the language switch).
class LoginHero extends StatelessWidget {
  const LoginHero({this.trailing, this.expand = false, super.key});

  final Widget? trailing;

  /// Fills the available height (tablet side panel) instead of a fixed header.
  final bool expand;

  static const double _markSize = AppSpacing.xxxl + AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onPrimary = context.colors.onPrimary;
    final trailing = this.trailing;

    final content = SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: expand ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            if (trailing != null) Align(alignment: AlignmentDirectional.centerEnd, child: trailing),
            AppGap.lg,
            ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(color: onPrimary, borderRadius: AppRadius.lgAll),
                child: SizedBox.square(
                  dimension: _markSize,
                  child: Icon(
                    Icons.school_rounded,
                    size: AppIconSize.xl + AppSpacing.xs,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
            AppGap.lg,
            Text(
              l10n.appTitle,
              style: context.textStyles.headlineMedium?.copyWith(color: onPrimary),
            ),
            AppGap.xs,
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xl),
              child: Text(
                l10n.loginTagline,
                style: context.textStyles.bodyLarge?.copyWith(
                  color: onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: context.colors.primary,
      child: CustomPaint(
        painter: _PatternPainter(color: onPrimary.withValues(alpha: 0.07)),
        child: content,
      ),
    );
  }
}

/// Soft concentric rings in the top corner, clear of the text.
class _PatternPainter extends CustomPainter {
  const _PatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final ring = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;
    final center = Offset(size.width * 1.02, size.height * 0.08);
    final base = math.max(size.width, size.height) * 0.22;
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(center, base * (1 + i * 0.75), ring);
    }
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) => oldDelegate.color != color;
}
