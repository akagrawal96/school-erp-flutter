/// One period of a school day.
final class ClassPeriod {
  const ClassPeriod({
    required this.number,
    required this.subject,
    required this.teacher,
    required this.start,
    required this.end,
    this.room,
  });

  final int number;
  final String subject;
  final String teacher;
  final DateTime start;
  final DateTime end;
  final String? room;

  bool isOngoing(DateTime now) => !now.isBefore(start) && now.isBefore(end);

  bool isOver(DateTime now) => !now.isBefore(end);
}
