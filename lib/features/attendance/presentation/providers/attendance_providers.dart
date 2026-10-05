import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/attendance/data/repositories/api_attendance_repository.dart';
import 'package:school_erp/features/attendance/data/repositories/mock_attendance_repository.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/domain/repositories/attendance_repository.dart';

/// Real attendance when the environment has an API; sample data otherwise.
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final clock = ref.watch(clockProvider);
  if (client == null) return MockAttendanceRepository(clock: clock);
  return ApiAttendanceRepository(client: client, clock: clock);
});

final attendanceOverviewProvider = FutureProvider.autoDispose<AttendanceOverview>(
  (ref) => ref.watch(attendanceRepositoryProvider).getOverview(),
);

final attendanceMonthProvider = FutureProvider.autoDispose.family<AttendanceMonth, DateTime>(
  (ref, month) => ref.watch(attendanceRepositoryProvider).getMonth(month),
);

/// The month shown in the attendance calendar.
final selectedAttendanceMonthProvider =
    NotifierProvider.autoDispose<SelectedAttendanceMonthController, DateTime>(
      SelectedAttendanceMonthController.new,
    );

class SelectedAttendanceMonthController extends Notifier<DateTime> {
  @override
  DateTime build() {
    final current = ref.watch(clockProvider)().monthStart;
    final lastRecorded = ref.watch(attendanceOverviewProvider).value?.lastRecordedOn;
    // Open on the latest month with data when nothing is recorded this month yet
    // (e.g. the session has ended or the backend returns an earlier session).
    return lastRecorded != null && lastRecorded.monthStart.isBefore(current)
        ? lastRecorded.monthStart
        : current;
  }

  AttendanceOverview? get _overview => ref.read(attendanceOverviewProvider).value;

  /// The last month that can be shown: this month, or the session end if earlier.
  DateTime get _lastMonth {
    final current = ref.read(clockProvider)().monthStart;
    final end = _overview?.academicYearEnd.monthStart;
    return end != null && end.isBefore(current) ? end : current;
  }

  bool get canGoNext => state.isBefore(_lastMonth);

  /// Months before the academic year are not available.
  bool get canGoPrevious {
    final first = _overview?.academicYearStart;
    return first == null || state.isAfter(first.monthStart);
  }

  void next() {
    if (canGoNext) state = DateTime(state.year, state.month + 1);
  }

  void previous() {
    if (canGoPrevious) state = DateTime(state.year, state.month - 1);
  }
}
