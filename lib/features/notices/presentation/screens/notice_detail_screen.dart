import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/links/link_opener.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';
import 'package:school_erp/features/notices/presentation/providers/notice_providers.dart';
import 'package:school_erp/features/notices/presentation/widgets/notice_card.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/states/loading_view.dart';
import 'package:school_erp/shared/states/state_view.dart';

class NoticeDetailScreen extends ConsumerWidget {
  const NoticeDetailScreen({required this.noticeId, super.key});

  final String noticeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notice = ref.watch(noticeProvider(noticeId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.noticeDetailTitle)),
      body: switch (notice) {
        AsyncData(value: final value?) => _NoticeContent(notice: value),
        AsyncData() => EmptyStateView(icon: Icons.campaign_outlined, title: l10n.noticeNotFound),
        AsyncError() => ErrorStateView(onRetry: () => ref.invalidate(noticeFeedProvider)),
        _ => const LoadingView(),
      },
    );
  }
}

class _NoticeContent extends ConsumerWidget {
  const _NoticeContent({required this.notice});

  final Notice notice;

  static const double _coverAspectRatio = 16 / 9;

  Future<void> _open(BuildContext context, WidgetRef ref, Uri url) async {
    final messenger = ScaffoldMessenger.of(context);
    final failedMessage = context.l10n.linkOpenFailed;
    final opened = await ref.read(linkOpenerProvider).open(url);
    if (!opened) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failedMessage)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final cover = notice.coverImageUrl;
    final attachment = notice.attachmentUrl;
    final video = notice.videoUrl;
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
          children: [
            if (cover != null) ...[
              ClipRRect(
                borderRadius: AppRadius.lgAll,
                child: AspectRatio(
                  aspectRatio: _coverAspectRatio,
                  child: NoticeImage(url: cover),
                ),
              ),
              AppGap.lg,
            ],
            Row(
              children: [
                NoticeIcon(isHoliday: notice.isHoliday),
                AppGap.md,
                Expanded(
                  child: Text(
                    formats.fullDate(notice.postedOn),
                    style: context.textStyles.labelLarge?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ),
                if (notice.isHoliday)
                  StatusChip(label: l10n.noticeHoliday, tone: StatusTone.success),
              ],
            ),
            AppGap.lg,
            Semantics(
              header: true,
              child: SelectableText(notice.title, style: context.textStyles.headlineSmall),
            ),
            if (notice.body.isNotEmpty) ...[
              AppGap.md,
              SelectableText(notice.body, style: context.textStyles.bodyLarge),
            ],
            if (attachment != null || video != null) AppGap.xl,
            if (attachment != null) ...[
              AppButton(
                label: l10n.noticeAttachment,
                icon: Icons.attach_file_rounded,
                variant: AppButtonVariant.secondary,
                expand: true,
                onPressed: () => _open(context, ref, attachment),
              ),
              AppGap.sm,
            ],
            if (video != null)
              AppButton(
                label: l10n.noticeVideo,
                icon: Icons.play_circle_outline_rounded,
                variant: AppButtonVariant.secondary,
                expand: true,
                onPressed: () => _open(context, ref, video),
              ),
          ],
        ),
      ),
    );
  }
}
