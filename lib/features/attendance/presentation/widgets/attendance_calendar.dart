import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_status_style.dart';

/// Month grid with each day colored by attendance status.
class AttendanceCalendar extends StatelessWidget {
  const AttendanceCalendar({
    required this.month,
    required this.today,
    required this.onDayTap,
    super.key,
  });

  final AttendanceMonth month;
  final DateTime today;
  final ValueChanged<AttendanceDay> onDayTap;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final firstDayOfWeek = localizations.firstDayOfWeekIndex; // 0 = Sunday
    final weekdays = [
      for (var i = 0; i < 7; i++) localizations.narrowWeekdays[(firstDayOfWeek + i) % 7],
    ];
    final start = month.month;
    final daysInMonth = DateTime(start.year, start.month + 1, 0).day;
    final leadingBlanks = (start.weekday % 7 - firstDayOfWeek + 7) % 7;

    return Column(
      children: [
        Row(
          children: [
            for (final weekday in weekdays)
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    weekday,
                    textAlign: TextAlign.center,
                    style: context.textStyles.labelMedium?.copyWith(
                      color: context.appColors.textTertiary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        AppGap.sm,
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.xs,
          crossAxisSpacing: AppSpacing.xs,
          children: [
            for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
            for (var d = 1; d <= daysInMonth; d++)
              _DayCell(
                date: DateTime(start.year, start.month, d),
                record: month.dayOf(DateTime(start.year, start.month, d)),
                isToday: today.isSameDay(DateTime(start.year, start.month, d)),
                onTap: onDayTap,
              ),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.record,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final AttendanceDay? record;
  final bool isToday;
  final ValueChanged<AttendanceDay> onTap;

  @override
  Widget build(BuildContext context) {
    final record = this.record;
    final l10n = context.l10n;
    final (background, foreground) = record == null
        ? (Colors.transparent, context.appColors.textTertiary)
        : record.status.cellColors(context);
    final label = record == null
        ? AppFormats.of(context).fullDate(date)
        : '${AppFormats.of(context).fullDate(date)}, ${record.status.label(l10n)}';

    return Semantics(
      label: label,
      button: record != null,
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: isToday ? BorderSide(color: context.colors.primary, width: 2) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: record == null ? null : () => onTap(record),
          child: Center(
            child: Text(
              '${date.day}',
              style: context.textStyles.labelLarge?.copyWith(
                color: foreground,
                fontWeight: isToday ? FontWeight.w700 : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Explains the calendar colors.
class AttendanceLegend extends StatelessWidget {
  const AttendanceLegend({super.key});

  static const double _swatchSize = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        for (final status in const [
          AttendanceStatus.present,
          AttendanceStatus.absent,
          AttendanceStatus.late,
          AttendanceStatus.leave,
          AttendanceStatus.holiday,
        ])
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: status.cellColors(context).$1,
                  borderRadius: AppRadius.smAll,
                  border: Border.all(color: status.indicatorColor(context)),
                ),
                child: const SizedBox.square(dimension: _swatchSize),
              ),
              AppGap.xs,
              Text(
                status == AttendanceStatus.late
                    ? '${status.label(l10n)} / ${AttendanceStatus.halfDay.label(l10n)}'
                    : status.label(l10n),
                style: context.textStyles.labelMedium?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
