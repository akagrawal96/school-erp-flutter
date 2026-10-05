import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/features/notices/data/mappers/notice_mapper.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';
import 'package:school_erp/features/notices/domain/repositories/notice_repository.dart';

/// Notices from `StudentApi/NoticeBoard` (paginated, 10 per page).
///
/// The server decides which notices the student may see (institution, class,
/// section or the student alone) and in which order.
final class ApiNoticeRepository implements NoticeRepository {
  const ApiNoticeRepository({required this.client, required this.fileUrl});

  final ApiClient client;
  final Uri? Function(String? path) fileUrl;

  static const _path = 'StudentApi/NoticeBoard';

  @override
  Future<NoticePage> getNotices({int page = 1}) async {
    final result = await client.getPage(_path, page: page);
    return NoticePage(
      notices: [
        for (final item in result.items)
          if (item is Json) ?NoticeMapper.fromJson(item, fileUrl: fileUrl),
      ],
      page: result.pageNo,
      hasMore: result.hasNextPage,
    );
  }
}
