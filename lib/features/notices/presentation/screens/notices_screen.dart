import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/notices/presentation/providers/notice_providers.dart';
import 'package:school_erp/features/notices/presentation/widgets/notice_card.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/states/skeleton.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// All notices and announcements, newest first, with older pages on request.
class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final feed = ref.watch(noticeFeedProvider);
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;
    final padding = EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreNotices)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(noticeFeedProvider.future),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: switch (feed) {
              AsyncValue(:final value?) when value.notices.isEmpty => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: padding,
                children: [
                  AppCard(
                    child: EmptyStateView(
                      icon: Icons.campaign_outlined,
                      title: l10n.noticesEmptyTitle,
                      message: l10n.noticesEmptyMessage,
                    ),
                  ),
                ],
              ),
              AsyncValue(:final value?) => ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: padding,
                itemCount: value.notices.length + (value.hasMore ? 1 : 0),
                separatorBuilder: (_, _) => AppGap.md,
                itemBuilder: (context, index) => index < value.notices.length
                    ? NoticeCard(notice: value.notices[index])
                    : _LoadMore(isLoading: value.isLoadingMore, failed: value.loadMoreFailed),
              ),
              AsyncError() => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: padding,
                children: [
                  AppCard(
                    child: ErrorStateView(onRetry: () => ref.invalidate(noticeFeedProvider)),
                  ),
                ],
              ),
              _ => ListView(
                padding: padding,
                children: const [AppCard(child: SkeletonList(itemCount: 4))],
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _LoadMore extends ConsumerWidget {
  const _LoadMore({required this.isLoading, required this.failed});

  final bool isLoading;
  final bool failed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Center(
      child: TextButton.icon(
        onPressed: () => ref.read(noticeFeedProvider.notifier).loadMore(),
        icon: Icon(failed ? Icons.refresh : Icons.expand_more),
        label: Text(failed ? l10n.noticesLoadMoreFailed : l10n.noticesLoadMore),
      ),
    );
  }
}
