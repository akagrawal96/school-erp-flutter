import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_status_style.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';

/// Shows a day's status, remark and who marked it in a bottom sheet.
Future<void> showAttendanceDayDetails(BuildContext context, AttendanceDay day) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (context) => _AttendanceDayDetails(day: day),
  );
}

class _AttendanceDayDetails extends StatelessWidget {
  const _AttendanceDayDetails({required this.day});

  final AttendanceDay day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final remark = day.remark;
    final markedBy = day.markedBy;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppFormats.of(context).fullDate(day.date),
                    style: context.textStyles.titleMedium,
                  ),
                ),
                StatusChip(label: day.status.label(l10n), tone: day.status.tone),
              ],
            ),
            if (remark != null) ...[
              AppGap.lg,
              Text(
                l10n.attendanceRemarkLabel,
                style: context.textStyles.labelMedium?.copyWith(
                  color: context.appColors.textTertiary,
                ),
              ),
              AppGap.xs,
              Text(remark, style: context.textStyles.bodyLarge),
            ],
            if (markedBy != null) ...[
              AppGap.lg,
              Text(
                l10n.attendanceMarkedBy(markedBy),
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
