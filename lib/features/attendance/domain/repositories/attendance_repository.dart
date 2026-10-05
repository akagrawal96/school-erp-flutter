import 'package:school_erp/features/attendance/domain/entities/attendance.dart';

/// Attendance of the signed-in student.
abstract interface class AttendanceRepository {
  /// Year-to-date summary and attendance policy for the current academic year.
  Future<AttendanceOverview> getOverview();

  /// Recorded days of the month containing [month].
  Future<AttendanceMonth> getMonth(DateTime month);
}
