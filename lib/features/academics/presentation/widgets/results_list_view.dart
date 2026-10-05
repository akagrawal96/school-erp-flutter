import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/domain/entities/exam_result.dart';
import 'package:school_erp/features/academics/presentation/providers/academics_providers.dart';
import 'package:school_erp/features/academics/presentation/widgets/academics_styles.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/states/skeleton.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// Published exams with overall percentage and grade.
class ResultsListView extends ConsumerWidget {
  const ResultsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final exams = ref.watch(examsProvider);
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.lg, gutter, AppSpacing.xxl),
          children: [
            switch (exams) {
              AsyncData(:final value) when value.isEmpty => AppCard(
                child: EmptyStateView(
                  icon: Icons.emoji_events_outlined,
                  title: l10n.resultsEmpty,
                  message: l10n.resultsEmptyMessage,
                ),
              ),
              AsyncData(:final value) => Column(
                children: [
                  for (final exam in value) ...[_ExamCard(exam: exam), AppGap.sm],
                ],
              ),
              AsyncError() => AppCard(
                child: ErrorStateView(onRetry: () => ref.invalidate(examsProvider)),
              ),
              _ => const AppCard(child: SkeletonList(itemCount: 2)),
            },
          ],
        ),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.exam});

  final ExamSummary exam;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    return AppCard(
      onTap: () => context.go(AppRoutes.reportCard(exam.id)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exam.name, style: context.textStyles.titleMedium),
                Text(
                  l10n.resultPublishedOn(formats.date(exam.publishedOn)),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
                AppGap.md,
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    StatusChip(label: l10n.resultGrade(exam.grade), tone: gradeTone(exam.grade)),
                    StatusChip(
                      label: exam.passed ? l10n.resultPassed : l10n.resultNeedsImprovement,
                      tone: exam.passed ? StatusTone.success : StatusTone.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppGap.md,
          Text(formats.percent(exam.percentage), style: context.textStyles.headlineMedium),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
