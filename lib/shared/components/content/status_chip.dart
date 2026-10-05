import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';

/// Meaning of a status, mapped to fixed semantic colors.
enum StatusTone { neutral, success, warning, error, info }

/// Compact, non-interactive status label ("Paid", "Absent", "Overdue").
class StatusChip extends StatelessWidget {
  const StatusChip({required this.label, this.tone = StatusTone.neutral, super.key});

  final String label;
  final StatusTone tone;

  static const double _minHeight = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final app = context.appColors;
    final (background, foreground) = switch (tone) {
      StatusTone.neutral => (scheme.surfaceContainerHigh, app.textSecondary),
      StatusTone.success => (app.successContainer, app.onSuccessContainer),
      StatusTone.warning => (app.warningContainer, app.onWarningContainer),
      StatusTone.error => (scheme.errorContainer, scheme.onErrorContainer),
      StatusTone.info => (app.infoContainer, app.onInfoContainer),
    };

    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: AppRadius.smAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _minHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Align(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              // Natural line height with even leading keeps Devanagari and Latin
              // text vertically centered.
              style: context.textStyles.labelMedium?.copyWith(
                color: foreground,
                height: 1.25,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
