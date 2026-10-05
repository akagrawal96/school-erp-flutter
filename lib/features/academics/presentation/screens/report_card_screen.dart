import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/domain/entities/exam_result.dart';
import 'package:school_erp/features/academics/presentation/providers/academics_providers.dart';
import 'package:school_erp/features/academics/presentation/widgets/academics_styles.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';
import 'package:school_erp/shared/components/charts/progress_ring.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/app_section.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/states/loading_view.dart';
import 'package:school_erp/shared/states/state_view.dart';

class ReportCardScreen extends ConsumerWidget {
  const ReportCardScreen({required this.examId, super.key});

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(reportCardProvider(examId));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reportCardTitle)),
      body: switch (card) {
        AsyncData(:final value) => _ReportCardContent(card: value),
        AsyncError() => ErrorStateView(onRetry: () => ref.invalidate(reportCardProvider(examId))),
        _ => const LoadingView(),
      },
    );
  }
}

class _ReportCardContent extends StatelessWidget {
  const _ReportCardContent({required this.card});

  final ReportCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final exam = card.exam;
    final rank = card.rank;
    final classSize = card.classSize;
    final remark = card.remark;
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
          children: [
            AppCard(
              child: Row(
                children: [
                  ProgressRing(
                    value: exam.percentage / 100,
                    color: exam.passed ? context.appColors.success : context.colors.error,
                    semanticsLabel: '${exam.name}: ${formats.percent(exam.percentage)}',
                    child: Text(
                      formats.percent(exam.percentage),
                      style: context.textStyles.headlineSmall,
                    ),
                  ),
                  AppGap.xl,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exam.name, style: context.textStyles.titleMedium),
                        AppGap.xs,
                        Text(
                          '${formats.number(card.totalObtained)} / ${formats.number(card.totalMax)}',
                          style: context.textStyles.bodyLarge,
                        ),
                        if (rank != null && classSize != null)
                          Text(
                            l10n.resultRank(rank, classSize),
                            style: context.textStyles.bodySmall?.copyWith(
                              color: context.appColors.textSecondary,
                            ),
                          ),
                        AppGap.sm,
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          children: [
                            StatusChip(
                              label: l10n.resultGrade(exam.grade),
                              tone: gradeTone(exam.grade),
                            ),
                            StatusChip(
                              label: exam.passed ? l10n.resultPassed : l10n.resultNeedsImprovement,
                              tone: exam.passed ? StatusTone.success : StatusTone.error,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppGap.lg,
            AppSection(
              title: l10n.reportCardSubjects,
              child: Column(
                children: [
                  _HeaderRow(),
                  const Divider(),
                  for (final subject in card.subjects) _SubjectRow(result: subject),
                  const Divider(),
                  _TotalRow(card: card),
                ],
              ),
            ),
            if (remark != null) ...[
              AppGap.lg,
              AppSection(
                title: l10n.reportCardRemark,
                child: Text(remark, style: context.textStyles.bodyLarge),
              ),
            ],
            AppGap.xl,
            AppButton(
              label: l10n.reportCardDownload,
              icon: Icons.download_outlined,
              variant: AppButtonVariant.secondary,
              expand: true,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.reportCardDownloadPending)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const double _marksColumnWidth = AppSpacing.xxxl + AppSpacing.xl;
const double _gradeColumnWidth = AppSpacing.xxxl + AppSpacing.sm;

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = context.textStyles.labelMedium?.copyWith(color: context.appColors.textTertiary);
    return ExcludeSemantics(
      child: Row(
        children: [
          Expanded(child: Text(l10n.reportCardSubject, style: style)),
          SizedBox(
            width: _marksColumnWidth,
            child: Text(l10n.reportCardMarks, textAlign: TextAlign.end, style: style),
          ),
          SizedBox(
            width: _gradeColumnWidth,
            child: Text(l10n.reportCardGrade, textAlign: TextAlign.end, style: style),
          ),
        ],
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.result});

  final SubjectResult result;

  static const double _barHeight = AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    final formats = AppFormats.of(context);
    final l10n = context.l10n;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(result.subject, style: context.textStyles.bodyLarge)),
                SizedBox(
                  width: _marksColumnWidth,
                  child: Text(
                    '${formats.number(result.marksObtained)}/${formats.number(result.maxMarks)}',
                    textAlign: TextAlign.end,
                    style: context.textStyles.labelLarge,
                  ),
                ),
                SizedBox(
                  width: _gradeColumnWidth,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Semantics(
                      label: l10n.resultGrade(result.grade),
                      excludeSemantics: true,
                      child: StatusChip(label: result.grade, tone: gradeTone(result.grade)),
                    ),
                  ),
                ),
              ],
            ),
            AppGap.xs,
            ClipRRect(
              borderRadius: AppRadius.pillAll,
              child: LinearProgressIndicator(
                value: result.percentage / 100,
                minHeight: _barHeight,
                backgroundColor: context.colors.surfaceContainerHighest,
                color: context.appColors.onBrandTint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.card});

  final ReportCard card;

  @override
  Widget build(BuildContext context) {
    final formats = AppFormats.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(context.l10n.reportCardTotal, style: context.textStyles.titleSmall)),
          SizedBox(
            width: _marksColumnWidth,
            child: Text(
              '${formats.number(card.totalObtained)}/${formats.number(card.totalMax)}',
              textAlign: TextAlign.end,
              style: context.textStyles.titleSmall,
            ),
          ),
          SizedBox(
            width: _gradeColumnWidth,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: StatusChip(label: card.exam.grade, tone: gradeTone(card.exam.grade)),
            ),
          ),
        ],
      ),
    );
  }
}
