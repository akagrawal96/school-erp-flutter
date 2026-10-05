import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_calendar.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_day_details.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_status_style.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_summary_card.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/app_section.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/states/skeleton.dart';
import 'package:school_erp/shared/states/state_view.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    final month = ref.read(selectedAttendanceMonthProvider);
    ref
      ..invalidate(attendanceOverviewProvider)
      ..invalidate(attendanceMonthProvider(month));
    await ref.read(attendanceMonthProvider(month).future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;
    final overview = ref.watch(attendanceOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navAttendance)),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
              children: [
                switch (overview) {
                  AsyncData(:final value) => AttendanceSummaryCard(overview: value),
                  AsyncError() => AppCard(
                    child: ErrorStateView(
                      onRetry: () => ref.invalidate(attendanceOverviewProvider),
                    ),
                  ),
                  _ => const _SummarySkeleton(),
                },
                AppGap.lg,
                const _MonthCard(),
                AppGap.lg,
                const _AbsencesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthCard extends ConsumerWidget {
  const _MonthCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selected = ref.watch(selectedAttendanceMonthProvider);
    final controller = ref.watch(selectedAttendanceMonthProvider.notifier);
    // Rebuild when the overview loads so the "previous" bound is known.
    ref.watch(attendanceOverviewProvider);
    final month = ref.watch(attendanceMonthProvider(selected));
    final today = ref.watch(clockProvider)();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.previousMonth,
                onPressed: controller.canGoPrevious ? controller.previous : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  AppFormats.of(context).monthYear(selected),
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleMedium,
                ),
              ),
              IconButton(
                tooltip: l10n.nextMonth,
                onPressed: controller.canGoNext ? controller.next : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          AppGap.md,
          switch (month) {
            AsyncData(:final value) when value.days.isEmpty => EmptyStateView(
              icon: Icons.event_busy_outlined,
              title: l10n.attendanceMonthNoData,
              message: l10n.attendanceMonthNoDataMessage,
            ),
            AsyncData(:final value) => AttendanceCalendar(
              month: value,
              today: today,
              onDayTap: (day) => showAttendanceDayDetails(context, day),
            ),
            AsyncError() => ErrorStateView(
              onRetry: () => ref.invalidate(attendanceMonthProvider(selected)),
            ),
            _ => const _CalendarSkeleton(),
          },
          AppGap.lg,
          const AttendanceLegend(),
        ],
      ),
    );
  }
}

class _AbsencesSection extends ConsumerWidget {
  const _AbsencesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final month = ref.watch(attendanceMonthProvider(ref.watch(selectedAttendanceMonthProvider)));
    final value = month.value;
    if (value == null || value.days.isEmpty) return const SizedBox.shrink();

    final exceptions = [
      for (final day in value.days.reversed)
        if (day.status.isWorkingDay && day.status != AttendanceStatus.present) day,
    ];
    final formats = AppFormats.of(context);

    return AppSection(
      title: l10n.attendanceAbsencesTitle,
      child: exceptions.isEmpty
          ? Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: AppIconSize.md,
                  color: context.appColors.success,
                ),
                AppGap.sm,
                Expanded(
                  child: Text(l10n.attendanceNoAbsences, style: context.textStyles.bodyMedium),
                ),
              ],
            )
          : Column(
              children: [
                for (final day in exceptions)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => showAttendanceDayDetails(context, day),
                    title: Text(formats.weekdayDayMonth(day.date)),
                    subtitle: day.remark == null
                        ? null
                        : Text(day.remark!, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: StatusChip(label: day.status.label(l10n), tone: day.status.tone),
                  ),
              ],
            ),
    );
  }
}

class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();

  static const double _ringSize = 112;

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Skeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 160, height: AppSpacing.lg),
            AppGap.sm,
            SkeletonBox(width: 120),
            AppGap.lg,
            Row(
              children: [
                SkeletonBox(width: _ringSize, height: _ringSize, radius: AppRadius.pillAll),
                AppGap.xl,
                Expanded(
                  child: Column(
                    children: [
                      SkeletonBox(width: double.infinity),
                      AppGap.md,
                      SkeletonBox(width: double.infinity),
                      AppGap.md,
                      SkeletonBox(width: double.infinity),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarSkeleton extends StatelessWidget {
  const _CalendarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        children: [
          for (var i = 0; i < 35; i++)
            const SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              radius: AppRadius.mdAll,
            ),
        ],
      ),
    );
  }
}
