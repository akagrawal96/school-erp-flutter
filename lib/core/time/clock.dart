import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the current time. Inject this instead of calling `DateTime.now()`
/// so "today"-dependent logic is testable.
typedef Clock = DateTime Function();

final clockProvider = Provider<Clock>((ref) => DateTime.now);

extension DateOnly on DateTime {
  /// This date at midnight (local time).
  DateTime get dateOnly => DateTime(year, month, day);

  /// First day of this month.
  DateTime get monthStart => DateTime(year, month);

  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;
}
