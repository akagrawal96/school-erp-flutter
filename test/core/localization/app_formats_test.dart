import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:school_erp/core/localization/app_formats.dart';

void main() {
  setUpAll(initializeDateFormatting);

  final en = AppFormats('en');
  final hi = AppFormats('hi');

  test('rupees use Indian digit grouping and drop zero paise', () {
    expect(en.rupees(1250000), '₹12,500');
    expect(en.rupees(12500000), '₹1,25,000');
    expect(en.rupees(12500050), '₹1,25,000.50');
  });

  test('dates follow Indian English order', () {
    final date = DateTime(2026, 10, 15);
    expect(en.date(date), '15 Oct 2026');
    expect(en.monthYear(date), 'October 2026');
  });

  test('Hindi month names', () {
    expect(hi.monthYear(DateTime(2026, 10)), contains('अक्टूबर'));
  });

  test('percent rounds to a whole number', () {
    expect(en.percent(91.6), '92%');
  });

  test('marks drop trailing zeros; file sizes use KB and MB', () {
    expect(en.number(68), '68');
    expect(en.number(68.5), '68.5');
    expect(en.fileSize(248000), '243 KB');
    expect(en.fileSize(1830000), '1.7 MB');
  });
}
