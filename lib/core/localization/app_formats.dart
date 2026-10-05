import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Locale-aware date, time, currency and percentage formatting.
///
/// English uses Indian conventions (`en_IN`): "15 Oct 2026", "₹1,25,000".
final class AppFormats {
  AppFormats(String languageCode) : _locale = languageCode == 'en' ? 'en_IN' : languageCode;

  factory AppFormats.of(BuildContext context) =>
      AppFormats(Localizations.localeOf(context).languageCode);

  final String _locale;

  /// "October 2026"
  String monthYear(DateTime date) => DateFormat.yMMMM(_locale).format(date);

  /// Academic session starting in [startYear]: "2026–27".
  String academicYear(int startYear) =>
      '$startYear–${((startYear + 1) % 100).toString().padLeft(2, '0')}';

  /// "Oct 2026"
  String monthYearShort(DateTime date) => DateFormat.yMMM(_locale).format(date);

  /// "Oct"
  String monthShort(DateTime date) => DateFormat.MMM(_locale).format(date);

  /// "15"
  String day(DateTime date) => DateFormat.d(_locale).format(date);

  /// "15 Oct"
  String dayMonth(DateTime date) => DateFormat.MMMd(_locale).format(date);

  /// "Wed, 15 Oct"
  String weekdayDayMonth(DateTime date) => DateFormat.MMMEd(_locale).format(date);

  /// "Wednesday, 15 October 2026"
  String fullDate(DateTime date) => DateFormat.yMMMMEEEEd(_locale).format(date);

  /// "15 Oct 2026"
  String date(DateTime date) => DateFormat.yMMMd(_locale).format(date);

  /// "9:40 am"
  String time(DateTime time) => DateFormat.jm(_locale).format(time);

  /// Formats an amount stored in paise as rupees: "₹12,500" or "₹12,500.50".
  String rupees(int paise) => NumberFormat.currency(
    locale: _locale,
    symbol: '₹',
    decimalDigits: paise % 100 == 0 ? 0 : 2,
  ).format(paise / 100);

  /// "92%" (rounded to a whole number).
  String percent(double value) => '${NumberFormat.decimalPattern(_locale).format(value.round())}%';

  /// Marks without trailing zeros: "68", "68.5".
  String number(double value) => NumberFormat('#,##0.##', _locale).format(value);

  /// Human-readable file size: "243 KB", "1.7 MB".
  String fileSize(int bytes) {
    const kb = 1024;
    const mb = kb * 1024;
    if (bytes >= mb) return '${NumberFormat('#,##0.#', _locale).format(bytes / mb)} MB';
    return '${NumberFormat('#,##0', _locale).format((bytes / kb).ceil())} KB';
  }
}
