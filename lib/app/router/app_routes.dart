/// Route paths. Navigate with `context.go(AppRoutes.home)` — never string literals.
abstract final class AppRoutes {
  static const login = '/login';

  // Bottom navigation tabs.
  static const home = '/home';
  static const attendance = '/attendance';
  static const academics = '/academics';
  static const fees = '/fees';
  static const more = '/more';

  // Academics tabs and details.
  static const academicsTabParam = 'tab';
  static String academicsTab(String tab) => '$academics?$academicsTabParam=$tab';
  static String homeworkDetail(String id) => '$academics/homework/$id';
  static String reportCard(String examId) => '$academics/results/$examId';

  // Fees pages.
  static String feeReceipt(String receiptId) => '$fees/receipts/$receiptId';

  // Pages under "More".
  static const profile = '/more/profile';
  static const settings = '/more/settings';
  static const components = '/more/components';
  static const design = '/more/design';

  // Full-screen pages opened on top of the tabs.
  static const notices = '/notices';
  static String notice(String id) => '$notices/$id';
  static const notifications = '/notifications';
}
