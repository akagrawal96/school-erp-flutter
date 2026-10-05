import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/domain/repositories/attendance_repository.dart';

/// Deterministic sample attendance for UI design until the attendance API exists.
///
/// The academic year runs April–March. Sundays and a few fixed dates are
/// holidays; other days get a stable, realistic mix of statuses.
final class MockAttendanceRepository implements AttendanceRepository {
  const MockAttendanceRepository({
    required this.clock,
    this.latency = const Duration(milliseconds: 600),
  });

  final Clock clock;
  final Duration latency;

  static const _teacher = 'Mrs. Kavita Rao';
  static const _requiredPercentage = 75.0;

  /// (month, day) of fixed holidays.
  static const _holidays = {(8, 15), (10, 2), (10, 20), (10, 21), (11, 8), (12, 25), (1, 26)};

  @override
  Future<AttendanceOverview> getOverview() async {
    await Future<void>.delayed(latency);
    final (start, end) = _academicYear(clock());
    final days = <AttendanceDay>[];
    for (var month = start; !month.isAfter(end); month = DateTime(month.year, month.month + 1)) {
      days.addAll(_daysOf(month));
    }
    return AttendanceOverview(
      academicYearLabel: '${start.year}–${(start.year + 1) % 100}',
      academicYearStart: start,
      academicYearEnd: end,
      summary: AttendanceSummary.fromDays(days),
      requiredPercentage: _requiredPercentage,
      lastRecordedOn: days.isEmpty ? null : days.last.date,
    );
  }

  @override
  Future<AttendanceMonth> getMonth(DateTime month) async {
    await Future<void>.delayed(latency);
    return AttendanceMonth(month: month.monthStart, days: _daysOf(month.monthStart));
  }

  static (DateTime, DateTime) _academicYear(DateTime now) {
    final startYear = now.month >= 4 ? now.year : now.year - 1;
    return (DateTime(startYear, 4), DateTime(startYear + 1, 3, 31));
  }

  List<AttendanceDay> _daysOf(DateTime month) {
    final today = clock().dateOnly;
    final (yearStart, yearEnd) = _academicYear(today);
    final days = <AttendanceDay>[];
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(month.year, month.month, d);
      if (date.isAfter(today) || date.isBefore(yearStart) || date.isAfter(yearEnd)) continue;
      days.add(_dayOf(date));
    }
    return days;
  }

  static AttendanceDay _dayOf(DateTime date) {
    if (date.weekday == DateTime.sunday || _holidays.contains((date.month, date.day))) {
      return AttendanceDay(date: date, status: AttendanceStatus.holiday);
    }
    // Stable pseudo-random bucket per date.
    final bucket = ((date.year * 400 + date.month * 32 + date.day) * 2654435761) % 100;
    return switch (bucket) {
      < 4 => AttendanceDay(
        date: date,
        status: AttendanceStatus.absent,
        remark: bucket.isEven ? 'Absent without prior information' : 'Unwell (informed by parent)',
        markedBy: _teacher,
      ),
      < 8 => AttendanceDay(
        date: date,
        status: AttendanceStatus.late,
        remark: 'Arrived at 8:20 AM',
        markedBy: _teacher,
      ),
      < 9 => AttendanceDay(
        date: date,
        status: AttendanceStatus.halfDay,
        remark: 'Left after 4th period (approved)',
        markedBy: _teacher,
      ),
      < 11 => AttendanceDay(
        date: date,
        status: AttendanceStatus.leave,
        remark: 'Family function (leave approved)',
        markedBy: _teacher,
      ),
      _ => AttendanceDay(date: date, status: AttendanceStatus.present, markedBy: _teacher),
    };
  }
}
