import 'package:school_erp/features/notices/domain/entities/notice.dart';

abstract interface class NoticeRepository {
  /// Notices for the signed-in student; [page] 1 has the newest.
  Future<NoticePage> getNotices({int page = 1});
}
