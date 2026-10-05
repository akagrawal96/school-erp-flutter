import 'package:school_erp/features/academics/domain/entities/class_period.dart';
import 'package:school_erp/features/academics/domain/repositories/academics_repositories.dart';

/// Sample weekly timetable for UI design until the timetable API exists.
final class MockTimetableRepository implements TimetableRepository {
  const MockTimetableRepository({this.latency = const Duration(milliseconds: 400)});

  final Duration latency;

  static const _firstPeriodHour = 8;
  static const _periodMinutes = 40;
  static const _breakAfterPeriod = 3;
  static const _breakMinutes = 20;

  /// Subjects by weekday (Monday = index 0). Sunday has no classes.
  static const _week = [
    ['Mathematics', 'English', 'Science', 'Hindi', 'Social Science', 'Computer'],
    ['English', 'Mathematics', 'Hindi', 'Science', 'Art', 'Physical Education'],
    ['Science', 'Mathematics', 'English', 'Social Science', 'Sanskrit', 'Library'],
    ['Hindi', 'Science', 'Mathematics', 'English', 'Computer', 'Music'],
    ['Mathematics', 'Social Science', 'Science', 'English', 'Hindi', 'Games'],
    ['English', 'Hindi', 'Mathematics', 'General Knowledge', 'Art', 'Club Activity'],
  ];

  static const _teachers = {
    'Mathematics': 'Mrs. Kavita Rao',
    'English': 'Mr. Daniel Thomas',
    'Science': 'Dr. Meera Iyer',
    'Hindi': 'Mrs. Sunita Sharma',
    'Social Science': 'Mr. Arjun Singh',
    'Computer': 'Ms. Priya Nair',
    'Sanskrit': 'Mr. Ved Prakash',
  };

  @override
  Future<List<ClassPeriod>> getDay(DateTime date) async {
    await Future<void>.delayed(latency);
    final day = DateTime(date.year, date.month, date.day);
    if (day.weekday == DateTime.sunday) return const [];

    DateTime at(int periodIndex) {
      final breakOffset = periodIndex >= _breakAfterPeriod ? _breakMinutes : 0;
      return day.add(
        Duration(hours: _firstPeriodHour, minutes: _periodMinutes * periodIndex + breakOffset),
      );
    }

    return [
      for (final (index, subject) in _week[day.weekday - 1].indexed)
        ClassPeriod(
          number: index + 1,
          subject: subject,
          teacher: _teachers[subject] ?? 'Mr. Rakesh Verma',
          start: at(index),
          end: at(index).add(const Duration(minutes: _periodMinutes)),
          room: subject == 'Computer' ? 'Computer Lab' : 'Room 8A',
        ),
    ];
  }
}
