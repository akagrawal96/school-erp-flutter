import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/router/not_found_screen.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/session/session_controller.dart';
import 'package:school_erp/features/academics/presentation/screens/academics_screen.dart';
import 'package:school_erp/features/academics/presentation/screens/homework_detail_screen.dart';
import 'package:school_erp/features/academics/presentation/screens/report_card_screen.dart';
import 'package:school_erp/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:school_erp/features/authentication/presentation/screens/login_screen.dart';
import 'package:school_erp/features/component_gallery/presentation/screens/component_gallery_screen.dart';
import 'package:school_erp/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:school_erp/features/design_preview/presentation/screens/design_preview_screen.dart';
import 'package:school_erp/features/fees/presentation/screens/fees_screen.dart';
import 'package:school_erp/features/fees/presentation/screens/receipt_screen.dart';
import 'package:school_erp/features/home/presentation/screens/home_shell.dart';
import 'package:school_erp/features/home/presentation/screens/module_placeholder_screen.dart';
import 'package:school_erp/features/more/presentation/screens/more_screen.dart';
import 'package:school_erp/features/notices/presentation/screens/notice_detail_screen.dart';
import 'package:school_erp/features/notices/presentation/screens/notices_screen.dart';
import 'package:school_erp/features/profile/presentation/screens/profile_screen.dart';
import 'package:school_erp/features/settings/presentation/screens/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// The app router. Created once per [ProviderScope].
///
/// Signed-out users can only see the login screen; signed-in users skip it.
/// Permission-based guards arrive with the permissions model.
final routerProvider = Provider<GoRouter>((ref) {
  final sessionChanges = ValueNotifier<SessionStatus>(ref.read(sessionProvider));
  ref
    ..listen(sessionProvider, (_, status) => sessionChanges.value = status)
    ..onDispose(sessionChanges.dispose);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    refreshListenable: sessionChanges,
    redirect: (context, state) {
      final signedIn = sessionChanges.value == SessionStatus.signedIn;
      final atLogin = state.matchedLocation == AppRoutes.login;
      if (!signedIn && !atLogin) return AppRoutes.login;
      if (signedIn && atLogin) return AppRoutes.home;
      return null;
    },
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(path: '/', redirect: (_, _) => AppRoutes.login),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.notices,
        builder: (_, _) => const NoticesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => NoticeDetailScreen(noticeId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, _) => ModulePlaceholderScreen(title: context.l10n.notificationsTooltip),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.home, builder: (_, _) => const DashboardScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: AppRoutes.attendance, builder: (_, _) => const AttendanceScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.academics,
                builder: (_, state) => AcademicsScreen(
                  initialTab:
                      AcademicsTab.values
                          .asNameMap()[state.uri.queryParameters[AppRoutes.academicsTabParam]] ??
                      AcademicsTab.timetable,
                ),
                routes: [
                  GoRoute(
                    path: 'homework/:id',
                    builder: (_, state) =>
                        HomeworkDetailScreen(homeworkId: state.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: 'results/:examId',
                    builder: (_, state) =>
                        ReportCardScreen(examId: state.pathParameters['examId']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.fees,
                builder: (_, _) => const FeesScreen(),
                routes: [
                  GoRoute(
                    path: 'receipts/:id',
                    builder: (_, state) => ReceiptScreen(receiptId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (_, _) => const MoreScreen(),
                routes: [
                  GoRoute(path: 'profile', builder: (_, _) => const ProfileScreen()),
                  GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen()),
                  GoRoute(path: 'components', builder: (_, _) => const ComponentGalleryScreen()),
                  GoRoute(path: 'design', builder: (_, _) => const DesignPreviewScreen()),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
