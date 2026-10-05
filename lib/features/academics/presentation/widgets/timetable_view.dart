import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/academics/presentation/providers/academics_providers.dart';
import 'package:school_erp/features/academics/presentation/widgets/period_tile.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/states/skeleton.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// Week strip (Mon–Sat) and the periods of the selected day.
class TimetableView extends ConsumerWidget {
  const TimetableView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selected = ref.watch(selectedTimetableDayProvider);
    final periods = ref.watch(timetableDayProvider(selected));
    final now = ref.watch(clockProvider)();
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, AppSpacing.xxl),
          children: [
            const _WeekStrip(),
            AppGap.lg,
            Text(AppFormats.of(context).fullDate(selected), style: context.textStyles.titleSmall),
            AppGap.sm,
            switch (periods) {
              AsyncData(:final value) when value.isEmpty => AppCard(
                child: EmptyStateView(
                  icon: Icons.beach_access_outlined,
                  title: l10n.timetableNoClasses,
                  message: l10n.timetableNoClassesMessage,
                ),
              ),
              AsyncData(:final value) => AppCard(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  children: [
                    for (final period in value)
                      PeriodTile(
                        period: period,
                        isCurrent: period.isOngoing(now),
                        isDone: period.isOver(now),
                      ),
                  ],
                ),
              ),
              AsyncError() => AppCard(
                child: ErrorStateView(
                  onRetry: () => ref.invalidate(timetableDayProvider(selected)),
                ),
              ),
              _ => const AppCard(child: SkeletonList(itemCount: 6)),
            },
          ],
        ),
      ),
    );
  }
}

class _WeekStrip extends ConsumerWidget {
  const _WeekStrip();

  static const double _dayHeight = AppSpacing.xxxl + AppSpacing.lg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref.watch(timetableWeekProvider);
    final selected = ref.watch(selectedTimetableDayProvider);
    final today = ref.watch(clockProvider)().dateOnly;
    final localizations = MaterialLocalizations.of(context);
    final formats = AppFormats.of(context);

    return Row(
      children: [
        for (final (index, day) in week.indexed) ...[
          if (index > 0) AppGap.xs,
          Expanded(
            child: Semantics(
              selected: day == selected,
              button: true,
              label: formats.fullDate(day),
              excludeSemantics: true,
              child: Material(
                color: day == selected ? context.colors.primary : context.appColors.brandTint,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mdAll,
                  side: day == today && day != selected
                      ? BorderSide(color: context.colors.primary)
                      : BorderSide.none,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => ref.read(selectedTimetableDayProvider.notifier).select(day),
                  child: SizedBox(
                    height: _dayHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.narrowWeekdays[day.weekday % 7],
                          style: context.textStyles.labelMedium?.copyWith(
                            color: day == selected
                                ? context.colors.onPrimary
                                : context.appColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${day.day}',
                          style: context.textStyles.titleMedium?.copyWith(
                            color: day == selected
                                ? context.colors.onPrimary
                                : context.appColors.onBrandTint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
