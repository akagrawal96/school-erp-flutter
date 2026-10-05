import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:school_erp/features/academics/presentation/widgets/attachment_tile.dart';
import 'package:school_erp/features/academics/presentation/widgets/homework_list_view.dart';
import 'package:school_erp/features/academics/presentation/widgets/homework_submission_form.dart';
import 'package:school_erp/shared/components/content/app_section.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/states/loading_view.dart';
import 'package:school_erp/shared/states/state_view.dart';

class HomeworkDetailScreen extends ConsumerWidget {
  const HomeworkDetailScreen({required this.homeworkId, super.key});

  final String homeworkId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homework = ref.watch(homeworkByIdProvider(homeworkId));
    return Scaffold(
      appBar: AppBar(title: Text(homework.value?.subject ?? context.l10n.quickHomework)),
      // Keep showing the loaded homework while it refreshes (e.g. right after submitting).
      body: switch (homework) {
        AsyncValue(:final value?) => _HomeworkContent(homework: value),
        AsyncError() => ErrorStateView(
          onRetry: () => ref.invalidate(homeworkByIdProvider(homeworkId)),
        ),
        _ => const LoadingView(),
      },
    );
  }
}

class _HomeworkContent extends ConsumerWidget {
  const _HomeworkContent({required this.homework});

  final Homework homework;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final today = ref.watch(clockProvider)().dateOnly;
    final status = homework.statusOn(today);
    final submission = homework.submission;
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
          children: [
            Text(homework.title, style: context.textStyles.titleLarge),
            AppGap.xs,
            Text(
              l10n.homeworkAssignedBy(homework.teacher, formats.dayMonth(homework.assignedOn)),
              style: context.textStyles.bodySmall?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
            AppGap.md,
            Row(
              children: [
                StatusChip(label: status.label(l10n), tone: status.tone),
                AppGap.sm,
                Icon(
                  Icons.event_outlined,
                  size: AppIconSize.sm,
                  color: context.appColors.textTertiary,
                ),
                AppGap.xs,
                Expanded(
                  child: Text(
                    HomeworkCard.dueLabel(context, homework.dueDate, today, status),
                    style: context.textStyles.bodyMedium,
                  ),
                ),
              ],
            ),
            AppGap.lg,
            AppSection(
              title: l10n.homeworkInstructions,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(homework.instructions, style: context.textStyles.bodyLarge),
                  if (homework.attachments.isNotEmpty) ...[
                    AppGap.lg,
                    Text(
                      l10n.homeworkTeacherFiles,
                      style: context.textStyles.labelLarge?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    for (final file in homework.attachments) AttachmentTile(attachment: file),
                  ],
                ],
              ),
            ),
            AppGap.lg,
            if (submission == null)
              HomeworkSubmissionForm(homeworkId: homework.id)
            else
              _SubmissionView(submission: submission),
          ],
        ),
      ),
    );
  }
}

class _SubmissionView extends StatelessWidget {
  const _SubmissionView({required this.submission});

  final HomeworkSubmission submission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final answer = submission.answer;
    final feedback = submission.feedback;
    final marks = submission.marksObtained;
    final maxMarks = submission.maxMarks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSection(
          title: l10n.homeworkYourSubmission,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, size: AppIconSize.md, color: context.appColors.success),
                  AppGap.sm,
                  Expanded(
                    child: Text(
                      l10n.homeworkSubmittedOn(
                        '${formats.dayMonth(submission.submittedAt)}, ${formats.time(submission.submittedAt)}',
                      ),
                      style: context.textStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
              if (answer != null) ...[
                AppGap.md,
                Text(answer, style: context.textStyles.bodyLarge),
              ],
              if (submission.attachments.isNotEmpty) AppGap.sm,
              for (final file in submission.attachments) AttachmentTile(attachment: file),
            ],
          ),
        ),
        if (feedback != null || marks != null) ...[
          AppGap.lg,
          AppSection(
            title: l10n.homeworkTeacherFeedback,
            action: marks == null
                ? null
                : StatusChip(
                    label: l10n.homeworkMarks(
                      maxMarks == null
                          ? formats.number(marks)
                          : '${formats.number(marks)}/${formats.number(maxMarks)}',
                    ),
                    tone: StatusTone.success,
                  ),
            child: Text(feedback ?? '', style: context.textStyles.bodyLarge),
          ),
        ],
      ],
    );
  }
}
