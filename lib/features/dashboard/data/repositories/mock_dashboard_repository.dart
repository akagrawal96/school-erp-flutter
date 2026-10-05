import 'package:school_erp/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:school_erp/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Sample dashboard data for UI design until the dashboard API exists.
final class MockDashboardRepository implements DashboardRepository {
  const MockDashboardRepository({this.latency = const Duration(milliseconds: 700)});

  final Duration latency;

  @override
  Future<DashboardSnapshot> getSnapshot(DateTime date) async {
    await Future<void>.delayed(latency);
    return const DashboardSnapshot(
      // Matches the open items in the sample homework (3 pending + 1 overdue).
      pendingHomework: 4,
      unreadNotifications: 2,
    );
  }
}
