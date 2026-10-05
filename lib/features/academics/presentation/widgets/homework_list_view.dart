import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';
import 'package:school_erp/features/academics/presentation/providers/academics_providers.dart';
import 'package:school_erp/features/academics/presentation/widgets/academics_styles.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/states/skeleton.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// Filterable homework list.
class HomeworkListView extends ConsumerWidget {
  const HomeworkListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(homeworkFilterProvider);
    final items = ref.watch(filteredHomeworkProvider);
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return RefreshIndicator(
      onRefresh: () => ref.refresh(homeworkListProvider.future),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, AppSpacing.xxl),
            children: [
              SegmentedButton<HomeworkFilter>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: HomeworkFilter.open, label: Text(l10n.homeworkFilterOpen)),
                  ButtonSegment(
                    value: HomeworkFilter.submitted,
                    label: Text(l10n.homeworkFilterSubmitted),
                  ),
                  ButtonSegment(value: HomeworkFilter.all, label: Text(l10n.homeworkFilterAll)),
                ],
                selected: {filter},
                onSelectionChanged: (selection) =>
                    ref.read(homeworkFilterProvider.notifier).select(selection.single),
              ),
              AppGap.lg,
              switch (items) {
                AsyncData(:final value) when value.isEmpty => AppCard(
                  child: filter == HomeworkFilter.open
                      ? EmptyStateView(
                          icon: Icons.task_alt,
                          title: l10n.homeworkEmptyOpen,
                          message: l10n.homeworkEmptyOpenMessage,
                        )
                      : EmptyStateView(icon: Icons.assignment_outlined, title: l10n.homeworkEmpty),
                ),
                AsyncData(:final value) => Column(
                  children: [
                    for (final item in value) ...[HomeworkCard(homework: item), AppGap.sm],
                  ],
                ),
                AsyncError() => AppCard(
                  child: ErrorStateView(onRetry: () => ref.invalidate(homeworkListProvider)),
                ),
                _ => const AppCard(child: SkeletonList(itemCount: 4)),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class HomeworkCard extends ConsumerWidget {
  const HomeworkCard({required this.homework, super.key});

  final Homework homework;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = ref.watch(clockProvider)().dateOnly;
    final status = homework.statusOn(today);
    final dueText = dueLabel(context, homework.dueDate, today, status);
    final urgent =
        status == HomeworkStatus.overdue ||
        (status == HomeworkStatus.pending &&
            !homework.dueDate.isAfter(today.add(const Duration(days: 1))));

    return AppCard(
      onTap: () => context.go(AppRoutes.homeworkDetail(homework.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  homework.subject,
                  style: context.textStyles.labelLarge?.copyWith(
                    color: context.appColors.onBrandTint,
                  ),
                ),
              ),
              StatusChip(label: status.label(l10n), tone: status.tone),
            ],
          ),
          AppGap.xs,
          Text(
            homework.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.titleSmall,
          ),
          AppGap.sm,
          Row(
            children: [
              Icon(
                Icons.event_outlined,
                size: AppIconSize.sm,
                color: urgent ? context.colors.error : context.appColors.textTertiary,
              ),
              AppGap.xs,
              Expanded(
                child: Text(
                  dueText,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: urgent ? context.colors.error : context.appColors.textSecondary,
                  ),
                ),
              ),
              if (homework.attachments.isNotEmpty)
                Icon(
                  Icons.attach_file,
                  size: AppIconSize.sm,
                  color: context.appColors.textTertiary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// "Due today", "Due tomorrow", "Due 20 Sept", "Was due 16 Sept" or "Submitted 15 Sept".
  static String dueLabel(
    BuildContext context,
    DateTime dueDate,
    DateTime today,
    HomeworkStatus status,
  ) {
    final l10n = context.l10n;
    final date = AppFormats.of(context).dayMonth(dueDate);
    return switch (status) {
      HomeworkStatus.overdue => l10n.homeworkWasDue(date),
      HomeworkStatus.submitted || HomeworkStatus.reviewed => l10n.homeworkDueOn(date),
      HomeworkStatus.pending when dueDate == today => l10n.homeworkDueToday,
      HomeworkStatus.pending when dueDate == today.add(const Duration(days: 1)) =>
        l10n.homeworkDueTomorrow,
      HomeworkStatus.pending => l10n.homeworkDueOn(date),
    };
  }
}
