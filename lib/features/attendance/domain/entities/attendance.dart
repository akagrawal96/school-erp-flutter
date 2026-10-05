/// Attendance status of one school day.
enum AttendanceStatus {
  present,
  absent,
  late,
  halfDay,
  leave,
  holiday,
  notMarked;

  /// Whether the day counts toward working days.
  bool get isWorkingDay => this != holiday && this != notMarked;
}

final class AttendanceDay {
  const AttendanceDay({required this.date, required this.status, this.remark, this.markedBy});

  /// Local date (time part is midnight).
  final DateTime date;
  final AttendanceStatus status;

  /// Teacher's note, e.g. reason for absence.
  final String? remark;
  final String? markedBy;
}

/// Counts of attendance statuses over a period.
final class AttendanceSummary {
  const AttendanceSummary({
    this.present = 0,
    this.absent = 0,
    this.late = 0,
    this.halfDay = 0,
    this.leave = 0,
  });

  factory AttendanceSummary.fromDays(Iterable<AttendanceDay> days) {
    var present = 0, absent = 0, late = 0, halfDay = 0, leave = 0;
    for (final day in days) {
      switch (day.status) {
        case AttendanceStatus.present:
          present++;
        case AttendanceStatus.absent:
          absent++;
        case AttendanceStatus.late:
          late++;
        case AttendanceStatus.halfDay:
          halfDay++;
        case AttendanceStatus.leave:
          leave++;
        case AttendanceStatus.holiday:
        case AttendanceStatus.notMarked:
          break;
      }
    }
    return AttendanceSummary(
      present: present,
      absent: absent,
      late: late,
      halfDay: halfDay,
      leave: leave,
    );
  }

  final int present;
  final int absent;
  final int late;
  final int halfDay;
  final int leave;

  int get workingDays => present + absent + late + halfDay + leave;

  /// Late arrivals count as attended; half days count as half.
  double get attendedDays => present + late + halfDay * 0.5;

  /// Attendance percentage (0–100), or `null` when there are no working days.
  double? get percentage => workingDays == 0 ? null : attendedDays / workingDays * 100;
}

/// Attendance records of one calendar month.
final class AttendanceMonth {
  const AttendanceMonth({required this.month, required this.days});

  /// First day of the month.
  final DateTime month;

  /// Recorded days in date order. Days not yet reached are omitted.
  final List<AttendanceDay> days;

  AttendanceSummary get summary => AttendanceSummary.fromDays(days);

  AttendanceDay? dayOf(DateTime date) {
    for (final day in days) {
      if (day.date.year == date.year && day.date.month == date.month && day.date.day == date.day) {
        return day;
      }
    }
    return null;
  }
}

/// Attendance for the whole academic year and the institution's policy.
final class AttendanceOverview {
  const AttendanceOverview({
    required this.academicYearLabel,
    required this.academicYearStart,
    required this.academicYearEnd,
    required this.summary,
    required this.requiredPercentage,
    this.lastRecordedOn,
  });

  /// e.g. "2026–27".
  final String academicYearLabel;
  final DateTime academicYearStart;
  final DateTime academicYearEnd;
  final AttendanceSummary summary;

  /// Minimum attendance the institution requires (e.g. 75).
  final double requiredPercentage;

  /// Most recent day with attendance, if any. The calendar opens on its month.
  final DateTime? lastRecordedOn;

  bool get isBelowRequired {
    final percentage = summary.percentage;
    return percentage != null && percentage < requiredPercentage;
  }
}
