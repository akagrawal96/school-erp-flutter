/// Reads loosely typed values from backend JSON.
///
/// The backend sends numbers as numbers or strings, blanks as `""` or `null`,
/// and text in capitals with stray spaces. Mappers use these helpers so the
/// UI never has to deal with that.
abstract final class ApiValues {
  /// Trimmed, whitespace-collapsed text; `null` for missing or blank values.
  static String? text(Object? value) {
    if (value == null) return null;
    final text = '$value'.trim().replaceAll(RegExp(r'\s+'), ' ');
    return text.isEmpty ? null : text;
  }

  static int? integer(Object? value) => switch (value) {
    final int number => number,
    final num number => number.round(),
    _ => int.tryParse('${value ?? ''}'.trim()),
  };

  /// An amount in rupees (`4600` or `"4600.50"`) as paise; `0` when missing.
  static int paise(Object? value) {
    final rupees = switch (value) {
      final num number => number,
      _ => num.tryParse('${value ?? ''}'.trim()),
    };
    return rupees == null ? 0 : (rupees * 100).round();
  }

  /// Parses ISO dates (`2026-09-21T00:00:00`) and `dd-MM-yyyy` dates
  /// (`01-12-2025`, also with `/`). Returns `null` when neither matches.
  static DateTime? date(Object? value) {
    final text = ApiValues.text(value);
    if (text == null) return null;
    final dayFirst = RegExp(r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})').firstMatch(text);
    if (dayFirst != null) {
      final day = int.parse(dayFirst[1]!);
      final month = int.parse(dayFirst[2]!);
      final year = int.parse(dayFirst[3]!);
      final date = DateTime(year, month, day);
      // Reject impossible dates such as 31-02-2025 instead of rolling over.
      return date.month == month && date.day == day ? date : null;
    }
    return DateTime.tryParse(text);
  }

  /// "DELHI  PUBLIC SCHOOL " → "Delhi Public School".
  static String titleCase(String value) => value
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
