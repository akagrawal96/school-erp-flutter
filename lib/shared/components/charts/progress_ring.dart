import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_motion.dart';
import 'package:school_erp/app/theme/theme_context.dart';

/// Circular progress indicator for a single percentage, with content in the center.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.value,
    required this.semanticsLabel,
    this.color,
    this.size = 112,
    this.strokeWidth = 10,
    this.child,
    super.key,
  });

  /// Progress from 0 to 1.
  final double value;
  final String semanticsLabel;
  final Color? color;
  final double size;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? context.colors.primary;
    final trackColor = context.colors.surfaceContainerHighest;
    return Semantics(
      label: semanticsLabel,
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1)),
          duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : AppMotion.slow,
          curve: AppMotion.enter,
          builder: (context, animatedValue, child) => CustomPaint(
            painter: _RingPainter(
              value: animatedValue,
              color: progressColor,
              trackColor: trackColor,
              strokeWidth: strokeWidth,
            ),
            child: child,
          ),
          child: ExcludeSemantics(child: Center(child: child)),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, 0, math.pi * 2, false, paint..color = trackColor);
    if (value > 0) {
      canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2 * value, false, paint..color = color);
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}
