import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_motion.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';

/// Gently pulsing placeholder shown while content loads. Honors the system
/// "remove animations" setting.
class Skeleton extends StatefulWidget {
  const Skeleton({required this.child, super.key});

  /// Layout built from [SkeletonBox]es.
  final Widget child;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.slow * 3,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loadingLabel,
      child: ExcludeSemantics(
        child: FadeTransition(
          opacity: Tween<double>(
            begin: 0.45,
            end: 1,
          ).animate(CurvedAnimation(parent: _controller, curve: AppMotion.standard)),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A single placeholder block inside a [Skeleton].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    this.height = AppSpacing.md,
    this.radius = AppRadius.smAll,
    super.key,
  });

  final double? width;
  final double height;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: radius,
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}

/// Placeholder for a list of rows with an avatar and two text lines.
class SkeletonList extends StatelessWidget {
  const SkeletonList({this.itemCount = 3, super.key});

  final int itemCount;

  static const double _avatarSize = AppSpacing.xxl + AppSpacing.sm;
  static const double _secondLineWidthFactor = 0.6;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        children: [
          for (var i = 0; i < itemCount; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  const SkeletonBox(
                    width: _avatarSize,
                    height: _avatarSize,
                    radius: AppRadius.pillAll,
                  ),
                  AppGap.md,
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SkeletonBox(width: double.infinity),
                          AppGap.sm,
                          SkeletonBox(width: constraints.maxWidth * _secondLineWidthFactor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
