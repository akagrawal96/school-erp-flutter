/// A notice or announcement published by the institution.
final class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.postedOn,
    this.isHoliday = false,
    this.attachmentUrl,
    this.videoUrl,
    this.coverImageUrl,
  });

  final String id;
  final String title;
  final String body;
  final DateTime postedOn;

  /// The notice announces a holiday.
  final bool isHoliday;
  final Uri? attachmentUrl;
  final Uri? videoUrl;
  final Uri? coverImageUrl;
}

/// One page of notices, newest first.
final class NoticePage {
  const NoticePage({required this.notices, required this.page, required this.hasMore});

  final List<Notice> notices;

  /// 1-based page number.
  final int page;
  final bool hasMore;
}
