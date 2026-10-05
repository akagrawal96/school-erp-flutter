import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/environment_config.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/notices/data/repositories/api_notice_repository.dart';
import 'package:school_erp/features/notices/data/repositories/mock_notice_repository.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';
import 'package:school_erp/features/notices/domain/repositories/notice_repository.dart';

/// Real notices when the environment has an API; sample data otherwise.
final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  if (client == null) return MockNoticeRepository(clock: ref.watch(clockProvider));
  return ApiNoticeRepository(client: client, fileUrl: ref.watch(environmentConfigProvider).fileUrl);
});

/// The notices loaded so far, and whether older ones can be loaded.
final class NoticeFeed {
  const NoticeFeed({
    required this.notices,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<Notice> notices;

  /// Last loaded page.
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;
}

final noticeFeedProvider = AsyncNotifierProvider.autoDispose<NoticeFeedController, NoticeFeed>(
  NoticeFeedController.new,
);

class NoticeFeedController extends AsyncNotifier<NoticeFeed> {
  @override
  Future<NoticeFeed> build() async {
    final first = await ref.watch(noticeRepositoryProvider).getNotices();
    return NoticeFeed(notices: first.notices, page: first.page, hasMore: first.hasMore);
  }

  /// Appends the next page. Failures are shown at the end of the list, not as
  /// a full-screen error, so the loaded notices stay visible.
  Future<void> loadMore() async {
    final feed = state.value;
    if (feed == null || !feed.hasMore || feed.isLoadingMore) return;
    state = AsyncData(_copy(feed, isLoadingMore: true));
    try {
      final next = await ref.read(noticeRepositoryProvider).getNotices(page: feed.page + 1);
      if (!ref.mounted) return;
      final known = {for (final notice in feed.notices) notice.id};
      state = AsyncData(
        NoticeFeed(
          // A notice published meanwhile can shift items to the next page.
          notices: [...feed.notices, ...next.notices.where((n) => !known.contains(n.id))],
          page: next.page,
          hasMore: next.hasMore,
        ),
      );
    } on Exception {
      if (!ref.mounted) return;
      state = AsyncData(_copy(feed, loadMoreFailed: true));
    }
  }

  static NoticeFeed _copy(
    NoticeFeed feed, {
    bool isLoadingMore = false,
    bool loadMoreFailed = false,
  }) => NoticeFeed(
    notices: feed.notices,
    page: feed.page,
    hasMore: feed.hasMore,
    isLoadingMore: isLoadingMore,
    loadMoreFailed: loadMoreFailed,
  );
}

/// A notice from the loaded feed (the API has no single-notice endpoint).
/// `null` when it is not in the feed.
final noticeProvider = FutureProvider.autoDispose.family<Notice?, String>((ref, id) async {
  final feed = await ref.watch(noticeFeedProvider.future);
  return feed.notices.where((notice) => notice.id == id).firstOrNull;
});
