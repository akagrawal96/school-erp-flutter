import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/academics/domain/entities/class_period.dart';
import 'package:school_erp/features/academics/presentation/providers/academics_providers.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:school_erp/features/dashboard/data/repositories/mock_dashboard_repository.dart';
import 'package:school_erp/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:school_erp/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/presentation/providers/fees_providers.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';
import 'package:school_erp/features/notices/presentation/providers/notice_providers.dart';
import 'package:school_erp/features/profile/domain/entities/student_profile.dart';
import 'package:school_erp/features/profile/presentation/providers/profile_providers.dart';

// TODO(step-4): replace with the API-backed repository once the dashboard API exists.
final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => const MockDashboardRepository(),
);

/// Everything the dashboard screen shows, combined from several sources.
final class DashboardData {
  const DashboardData({
    required this.student,
    required this.snapshot,
    required this.attendance,
    required this.todayStatus,
    required this.todayClasses,
    required this.fees,
    required this.latestNotices,
  });

  final StudentProfile student;
  final DashboardSnapshot snapshot;
  final AttendanceOverview attendance;

  /// Today's attendance, or [AttendanceStatus.notMarked] before it is taken.
  final AttendanceStatus todayStatus;
  final List<ClassPeriod> todayClasses;
  final FeesSummary fees;
  final List<Notice> latestNotices;

  static const latestNoticeCount = 3;
}

final dashboardProvider = AsyncNotifierProvider<DashboardController, DashboardData>(
  DashboardController.new,
);

class DashboardController extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    final now = ref.watch(clockProvider)();
    final attendanceRepository = ref.watch(attendanceRepositoryProvider);

    final studentFuture = ref.watch(currentStudentProvider.future);
    final snapshotFuture = ref.watch(dashboardRepositoryProvider).getSnapshot(now);
    final overviewFuture = attendanceRepository.getOverview();
    final monthFuture = attendanceRepository.getMonth(now);
    final classesFuture = ref.watch(timetableRepositoryProvider).getDay(now);
    final feesFuture = ref.watch(feesRepositoryProvider).getReceipts();
    // Notices are secondary on the dashboard: if they fail, the rest still shows.
    final noticesFuture = ref
        .watch(noticeRepositoryProvider)
        .getNotices()
        .then((page) => page.notices, onError: (Object _) => const <Notice>[]);

    final (student, snapshot, overview, month, classes, receipts, notices) = await (
      studentFuture,
      snapshotFuture,
      overviewFuture,
      monthFuture,
      classesFuture,
      feesFuture,
      noticesFuture,
    ).wait;

    return DashboardData(
      student: student,
      snapshot: snapshot,
      attendance: overview,
      todayStatus: month.dayOf(now)?.status ?? AttendanceStatus.notMarked,
      todayClasses: classes,
      fees: FeesSummary(receipts: receipts),
      latestNotices: notices.take(DashboardData.latestNoticeCount).toList(),
    );
  }

  /// Reloads all dashboard data (pull to refresh).
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// Time-of-day greeting bucket for the dashboard header.
enum GreetingPeriod {
  morning,
  afternoon,
  evening;

  static GreetingPeriod of(DateTime time) => switch (time.hour) {
    < 12 => GreetingPeriod.morning,
    < 17 => GreetingPeriod.afternoon,
    _ => GreetingPeriod.evening,
  };
}
