import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';
import 'package:school_erp/features/notices/domain/repositories/notice_repository.dart';

/// Sample notices for builds without a server, in two pages. Fictional data.
final class MockNoticeRepository implements NoticeRepository {
  const MockNoticeRepository({
    required this.clock,
    this.latency = const Duration(milliseconds: 500),
  });

  final Clock clock;
  final Duration latency;

  static const pageSize = 4;

  @override
  Future<NoticePage> getNotices({int page = 1}) async {
    await Future<void>.delayed(latency);
    final all = _notices(clock().dateOnly);
    final start = (page - 1) * pageSize;
    return NoticePage(
      notices: all.skip(start).take(pageSize).toList(),
      page: page,
      hasMore: start + pageSize < all.length,
    );
  }

  static List<Notice> _notices(DateTime today) {
    DateTime daysAgo(int days) => today.subtract(Duration(days: days));
    return [
      Notice(
        id: '106',
        title: 'Annual Sports Day',
        body:
            'Annual Sports Day will be held next month.\n\n'
            'Students who want to take part must give their name and event to '
            'their sports teacher by Friday.',
        postedOn: daysAgo(1),
        videoUrl: Uri.parse('https://example.com/sports-day'),
      ),
      Notice(
        id: '105',
        title: 'Parent-teacher meeting on Saturday',
        body: 'The parent-teacher meeting is on Saturday from 10 AM to 1 PM in the classrooms.',
        postedOn: daysAgo(3),
        attachmentUrl: Uri.parse('https://example.com/ptm-schedule.pdf'),
      ),
      Notice(
        id: '104',
        title: 'School closed for Dussehra',
        body: 'The school will remain closed for Dussehra. Classes resume on Monday.',
        postedOn: daysAgo(6),
        isHoliday: true,
      ),
      Notice(
        id: '103',
        title: 'Half-yearly exam date sheet',
        body: 'The half-yearly exam date sheet is attached. Exams start at 9 AM.',
        postedOn: daysAgo(10),
        attachmentUrl: Uri.parse('https://example.com/date-sheet.pdf'),
      ),
      Notice(
        id: '102',
        title: 'Library books due',
        body: 'Please return all library books issued last term by the end of this week.',
        postedOn: daysAgo(18),
      ),
      Notice(
        id: '101',
        title: 'Winter uniform from next month',
        body: 'Students should wear the winter uniform from the first of next month.',
        postedOn: daysAgo(25),
      ),
    ];
  }
}
