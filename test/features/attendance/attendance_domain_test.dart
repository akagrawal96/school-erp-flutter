import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/features/attendance/data/repositories/mock_attendance_repository.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';

void main() {
  group('AttendanceSummary', () {
    test('late counts as attended, half day as half, holidays are ignored', () {
      final days = [
        for (final status in [
          AttendanceStatus.present,
          AttendanceStatus.present,
          AttendanceStatus.late,
          AttendanceStatus.halfDay,
          AttendanceStatus.absent,
          AttendanceStatus.leave,
          AttendanceStatus.holiday,
          AttendanceStatus.notMarked,
        ])
          AttendanceDay(date: DateTime(2026, 10), status: status),
      ];
      final summary = AttendanceSummary.fromDays(days);

      expect(summary.workingDays, 6);
      expect(summary.attendedDays, 3.5);
      expect(summary.percentage, closeTo(58.33, 0.01));
    });

    test('percentage is null without working days', () {
      expect(const AttendanceSummary().percentage, isNull);
    });
  });

  test('overview flags attendance below the required percentage', () {
    AttendanceOverview overview(AttendanceSummary summary) => AttendanceOverview(
      academicYearLabel: '2026–27',
      academicYearStart: DateTime(2026, 4),
      academicYearEnd: DateTime(2027, 3, 31),
      summary: summary,
      requiredPercentage: 75,
    );

    expect(overview(const AttendanceSummary(present: 7, absent: 3)).isBelowRequired, isTrue);
    expect(overview(const AttendanceSummary(present: 8, absent: 2)).isBelowRequired, isFalse);
    expect(overview(const AttendanceSummary()).isBelowRequired, isFalse);
  });

  group('MockAttendanceRepository', () {
    final now = DateTime(2026, 10, 14, 9, 30);
    final repository = MockAttendanceRepository(clock: () => now, latency: Duration.zero);

    test('uses the April–March academic year containing today', () async {
      final overview = await repository.getOverview();

      expect(overview.academicYearStart, DateTime(2026, 4));
      expect(overview.academicYearEnd, DateTime(2027, 3, 31));
      expect(overview.academicYearLabel, '2026–27');
      expect(overview.summary.workingDays, greaterThan(100));
    });

    test('months stop at today and Sundays are holidays', () async {
      final month = await repository.getMonth(DateTime(2026, 10));

      expect(month.days.last.date, DateTime(2026, 10, 14));
      final sunday = month.dayOf(DateTime(2026, 10, 11))!;
      expect(sunday.status, AttendanceStatus.holiday);
      expect(month.dayOf(DateTime(2026, 10, 2))!.status, AttendanceStatus.holiday);
    });

    test('future months and months before the academic year are empty', () async {
      expect((await repository.getMonth(DateTime(2026, 11))).days, isEmpty);
      expect((await repository.getMonth(DateTime(2026, 3))).days, isEmpty);
    });

    test('data is stable between calls', () async {
      final a = await repository.getMonth(DateTime(2026, 9));
      final b = await repository.getMonth(DateTime(2026, 9));
      expect([for (final d in a.days) d.status], [for (final d in b.days) d.status]);
    });
  });
}
