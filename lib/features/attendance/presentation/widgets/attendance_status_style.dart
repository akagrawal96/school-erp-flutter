import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';

/// How each attendance status is labelled and colored.
extension AttendanceStatusStyle on AttendanceStatus {
  String label(AppLocalizations l10n) => switch (this) {
    AttendanceStatus.present => l10n.attendanceStatusPresent,
    AttendanceStatus.absent => l10n.attendanceStatusAbsent,
    AttendanceStatus.late => l10n.attendanceStatusLate,
    AttendanceStatus.halfDay => l10n.attendanceStatusHalfDay,
    AttendanceStatus.leave => l10n.attendanceStatusLeave,
    AttendanceStatus.holiday => l10n.attendanceStatusHoliday,
    AttendanceStatus.notMarked => l10n.attendanceStatusNotMarked,
  };

  StatusTone get tone => switch (this) {
    AttendanceStatus.present => StatusTone.success,
    AttendanceStatus.absent => StatusTone.error,
    AttendanceStatus.late || AttendanceStatus.halfDay => StatusTone.warning,
    AttendanceStatus.leave => StatusTone.info,
    AttendanceStatus.holiday || AttendanceStatus.notMarked => StatusTone.neutral,
  };

  /// Solid indicator color (legend dots, summary markers).
  Color indicatorColor(BuildContext context) => switch (tone) {
    StatusTone.success => context.appColors.success,
    StatusTone.error => context.colors.error,
    StatusTone.warning => context.appColors.warning,
    StatusTone.info => context.appColors.info,
    StatusTone.neutral => context.appColors.textTertiary,
  };

  /// (background, foreground) for calendar day cells.
  ///
  /// Solid status colors so the month reads at a glance; each pair meets
  /// WCAG AA contrast (verified in the theme tests).
  (Color, Color) cellColors(BuildContext context) => switch (tone) {
    StatusTone.success => (context.appColors.success, context.appColors.onSuccess),
    StatusTone.error => (context.colors.error, context.colors.onError),
    StatusTone.warning => (context.appColors.warning, context.appColors.onWarning),
    StatusTone.info => (context.appColors.info, context.appColors.onInfo),
    StatusTone.neutral => (
      context.colors.surfaceContainerHighest,
      context.appColors.textSecondary,
    ),
  };
}
