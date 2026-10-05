import 'package:school_erp/core/errors/app_exception.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/domain/repositories/attendance_repository.dart';

/// Attendance from `StudentApi/GetStudentAttendence`.
///
/// The API returns every marked day of the session as `{AttDate, AttStatus}`;
/// months and the yearly summary are derived here. Requests to extend the API
/// (status codes, holidays, remarks, policy) are in
/// docs/api/data-needs/module-01-dashboard-attendance.md.
final class ApiAttendanceRepository implements AttendanceRepository {
  const ApiAttendanceRepository({required this.client, required this.clock});

  final ApiClient client;
  final Clock clock;

  static const _path = 'StudentApi/GetStudentAttendence';

  /// Institution policy is not in the API yet; 75% is the common CBSE rule.
  static const _defaultRequiredPercentage = 75.0;

  /// Known `AttStatus` codes. Unknown codes are kept as "not marked" and are
  /// not counted, rather than guessed.
  // TODO(step-4): confirm the full code list with the backend team.
  static const _statusCodes = {1: AttendanceStatus.present, 2: AttendanceStatus.absent};

  @override
  Future<AttendanceOverview> getOverview() async {
    final days = await _fetchAll();
    final latest = days.isEmpty ? clock().dateOnly : days.last.date;
    final start = DateTime(latest.month >= 4 ? latest.year : latest.year - 1, 4);
    final end = DateTime(start.year + 1, 3, 31);
    final inYear = days.where((d) => !d.date.isBefore(start) && !d.date.isAfter(end));
    return AttendanceOverview(
      academicYearLabel: '${start.year}–${((start.year + 1) % 100).toString().padLeft(2, '0')}',
      academicYearStart: start,
      academicYearEnd: end,
      summary: AttendanceSummary.fromDays(inYear),
      requiredPercentage: _defaultRequiredPercentage,
      lastRecordedOn: days.isEmpty ? null : days.last.date,
    );
  }

  @override
  Future<AttendanceMonth> getMonth(DateTime month) async {
    final days = await _fetchAll();
    final start = month.monthStart;
    return AttendanceMonth(
      month: start,
      days: [
        for (final day in days)
          if (day.date.year == start.year && day.date.month == start.month) day,
      ],
    );
  }

  /// All marked days in date order.
  Future<List<AttendanceDay>> _fetchAll() async {
    final data = await client.get(_path);
    if (data is! List) throw const ParsingException('Attendance data is not a list');
    final days = <AttendanceDay>[];
    for (final item in data) {
      if (item is! Json) continue;
      final date = DateTime.tryParse('${item['AttDate']}');
      final code = item['AttStatus'];
      if (date == null) continue;
      days.add(
        AttendanceDay(
          date: date.dateOnly,
          status:
              _statusCodes[code is int ? code : int.tryParse('$code')] ??
              AttendanceStatus.notMarked,
        ),
      );
    }
    return days..sort((a, b) => a.date.compareTo(b.date));
  }
}
