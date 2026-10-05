import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_status_style.dart';
import 'package:school_erp/shared/components/charts/progress_ring.dart';
import 'package:school_erp/shared/components/content/app_card.dart';

/// Year-to-date attendance: percentage ring, day counts and policy warning.
class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({required this.overview, super.key});

  final AttendanceOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final summary = overview.summary;
    final percentage = summary.percentage ?? 0;
    final percentText = formats.percent(percentage);
    final requiredText = formats.percent(overview.requiredPercentage);
    final ringColor = overview.isBelowRequired ? context.colors.error : context.appColors.success;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.attendanceOverallTitle, style: context.textStyles.titleMedium),
          Text(
            l10n.attendanceAcademicYear(overview.academicYearLabel),
            style: context.textStyles.bodySmall?.copyWith(color: context.appColors.textSecondary),
          ),
          AppGap.lg,
          Row(
            children: [
              ProgressRing(
                value: percentage / 100,
                color: ringColor,
                semanticsLabel: '${l10n.attendanceOverallTitle}: $percentText',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(percentText, style: context.textStyles.headlineSmall),
                    Text(
                      l10n.attendanceRequired(requiredText),
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.appColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              AppGap.xl,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (status, count) in [
                      (AttendanceStatus.present, summary.present),
                      (AttendanceStatus.absent, summary.absent),
                      (AttendanceStatus.late, summary.late + summary.halfDay),
                      (AttendanceStatus.leave, summary.leave),
                    ])
                      _CountRow(status: status, count: count),
                    AppGap.xs,
                    Text(
                      l10n.attendanceWorkingDays(summary.workingDays),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.appColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (overview.isBelowRequired) ...[
            AppGap.lg,
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.errorContainer,
                borderRadius: AppRadius.mdAll,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: AppIconSize.md,
                      color: context.colors.onErrorContainer,
                    ),
                    AppGap.sm,
                    Expanded(
                      child: Text(
                        l10n.attendanceBelowRequired(requiredText),
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.colors.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({required this.status, required this.count});

  final AttendanceStatus status;
  final int count;

  static const double _dotSize = AppSpacing.sm + AppSpacing.xxs;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: status.indicatorColor(context),
              borderRadius: AppRadius.pillAll,
            ),
            child: const SizedBox.square(dimension: _dotSize),
          ),
          AppGap.sm,
          Expanded(child: Text(status.label(l10n), style: context.textStyles.bodyMedium)),
          Text(l10n.attendanceDaysCount(count), style: context.textStyles.labelLarge),
        ],
      ),
    );
  }
}
