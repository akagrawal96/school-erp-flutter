/// Summary data shown on the student dashboard, loaded in one request.
///
/// Classes, attendance, fees and notices come from their own modules, so every
/// screen always shows the same data.
final class DashboardSnapshot {
  const DashboardSnapshot({required this.pendingHomework, required this.unreadNotifications});

  final int pendingHomework;
  final int unreadNotifications;
}
