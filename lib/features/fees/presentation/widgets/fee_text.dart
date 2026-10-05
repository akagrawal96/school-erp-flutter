import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';

/// What a receipt paid for: "November 2025", "May – Jul 2025",
/// "Dec 2025 – Jan 2026", or the institution's own labels ("Term 1").
String feePeriodsText(AppLocalizations l10n, AppFormats formats, List<FeePeriod> periods) {
  if (periods.isEmpty) return l10n.feesFeePayment;
  final months = [for (final period in periods) period.month];
  if (months.any((month) => month == null)) {
    return periods.map((period) => period.label).join(', ');
  }
  final sorted = months.nonNulls.toList()..sort();
  if (sorted.length == 1) return formats.monthYear(sorted.single);

  final consecutive = [
    for (var i = 1; i < sorted.length; i++)
      DateTime(sorted[i - 1].year, sorted[i - 1].month + 1) == sorted[i],
  ].every((isNext) => isNext);
  if (!consecutive) return sorted.map(formats.monthYearShort).join(', ');

  final first = sorted.first;
  final last = sorted.last;
  final start = first.year == last.year ? formats.monthShort(first) : formats.monthYearShort(first);
  return '$start – ${formats.monthYearShort(last)}';
}
