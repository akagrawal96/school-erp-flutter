import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:school_erp/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:school_erp/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:school_erp/features/dashboard/presentation/widgets/dashboard_stats.dart';
import 'package:school_erp/features/dashboard/presentation/widgets/latest_notices_section.dart';
import 'package:school_erp/features/dashboard/presentation/widgets/quick_actions_section.dart';
import 'package:school_erp/features/dashboard/presentation/widgets/today_classes_section.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// Student home: today's status, key figures, shortcuts, classes and notices.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dashboard = ref.watch(dashboardProvider);
    final unread = dashboard.value?.snapshot.unreadNotifications ?? 0;
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Scaffold(
      appBar: AppBar(
        title: Text(dashboard.value?.student.institutionName ?? l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.notificationsTooltip,
            onPressed: () => context.push(AppRoutes.notifications),
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          AppGap.xs,
        ],
      ),
      body: switch (dashboard) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
                children: [
                  DashboardHeader(data: value),
                  AppGap.lg,
                  DashboardStats(data: value),
                  AppGap.lg,
                  const QuickActionsSection(),
                  AppGap.lg,
                  TodayClassesSection(periods: value.todayClasses),
                  AppGap.lg,
                  LatestNoticesSection(notices: value.latestNotices),
                ],
              ),
            ),
          ),
        ),
        AsyncError() => ErrorStateView(onRetry: () => ref.invalidate(dashboardProvider)),
        _ => const DashboardSkeleton(),
      },
    );
  }
}
