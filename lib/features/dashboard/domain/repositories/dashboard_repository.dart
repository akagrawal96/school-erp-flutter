import 'package:school_erp/features/dashboard/domain/entities/dashboard_snapshot.dart';

abstract interface class DashboardRepository {
  /// Dashboard summary for the signed-in student for [date].
  Future<DashboardSnapshot> getSnapshot(DateTime date);
}
