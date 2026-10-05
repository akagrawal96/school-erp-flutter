import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/domain/entities/class_period.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';

/// One period: times, subject, teacher, with the ongoing one highlighted.
class PeriodTile extends StatelessWidget {
  const PeriodTile({
    required this.period,
    required this.isCurrent,
    required this.isDone,
    super.key,
  });

  final ClassPeriod period;
  final bool isCurrent;
  final bool isDone;

  static const double _timeColumnWidth = AppSpacing.xxxl + AppSpacing.lg;
  static const double _accentWidth = AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final muted = isDone ? context.appColors.textTertiary : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: isCurrent ? context.appColors.brandTint : null,
        borderRadius: AppRadius.mdAll,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _timeColumnWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formats.time(period.start),
                    style: context.textStyles.labelLarge?.copyWith(color: muted),
                  ),
                  Text(
                    formats.time(period.end),
                    style: context.textStyles.labelSmall?.copyWith(
                      color: context.appColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: isCurrent ? context.colors.primary : context.appColors.border,
                borderRadius: AppRadius.pillAll,
              ),
              child: const SizedBox(width: _accentWidth),
            ),
            AppGap.md,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    period.subject,
                    style: context.textStyles.titleSmall?.copyWith(color: muted),
                  ),
                  Text(
                    [period.teacher, ?period.room].join(' · '),
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrent)
              Center(
                child: StatusChip(label: l10n.classNow, tone: StatusTone.info),
              )
            else if (isDone)
              Center(
                child: Icon(
                  Icons.check_circle_outline,
                  size: AppIconSize.md,
                  color: context.appColors.textTertiary,
                  semanticLabel: l10n.classDone,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
