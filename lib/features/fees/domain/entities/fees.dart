import 'dart:math' as math;

/// What a payment was for: usually a calendar month, sometimes a term or
/// another period named by the institution.
final class FeePeriod {
  const FeePeriod({required this.label, this.month});

  /// The institution's name for the period, e.g. "November" or "Term 1".
  final String label;

  /// First day of the month when the period is a calendar month.
  final DateTime? month;
}

/// One fee deposit (a receipt) recorded by the school.
final class FeeReceipt {
  const FeeReceipt({
    required this.id,
    required this.depositedOn,
    required this.periods,
    required this.feeInPaise,
    required this.concessionInPaise,
    required this.paidInPaise,
    this.recordedOn,
    this.chequeNo,
    this.chequeDate,
    this.remarks,
    this.isDishonoured = false,
  });

  /// Receipt number.
  final String id;
  final DateTime depositedOn;

  /// When the office entered the deposit, if different from [depositedOn].
  final DateTime? recordedOn;
  final List<FeePeriod> periods;

  /// Fee charged for [periods]. `0` when this deposit settles the rest of an
  /// earlier, partly paid receipt for the same period.
  final int feeInPaise;
  final int concessionInPaise;
  final int paidInPaise;

  final String? chequeNo;
  final DateTime? chequeDate;

  /// Office note, typically the UPI/bank transaction reference.
  final String? remarks;

  /// The cheque bounced; the amount does not count as paid.
  final bool isDishonoured;

  /// Unpaid part of [feeInPaise] after concession and payment.
  int get balanceInPaise => math.max(0, feeInPaise - concessionInPaise - paidInPaise);
}

/// One fee head of a receipt for one period, e.g. "Tuition fee, November".
final class FeeReceiptItem {
  const FeeReceiptItem({
    required this.name,
    required this.period,
    required this.feeInPaise,
    required this.concessionInPaise,
    required this.paidInPaise,
  });

  /// Fee head as named by the institution ("Tuition fee", "Late fee").
  final String name;
  final FeePeriod? period;
  final int feeInPaise;
  final int concessionInPaise;
  final int paidInPaise;

  /// Heads that are configured for the institution but not charged.
  bool get isEmpty => feeInPaise == 0 && concessionInPaise == 0 && paidInPaise == 0;
}

/// All fee receipts of the student, with the figures the Fees screen shows.
final class FeesSummary {
  FeesSummary({required List<FeeReceipt> receipts})
    : receipts = [...receipts]..sort((a, b) => b.depositedOn.compareTo(a.depositedOn));

  /// The academic session starts in April.
  static const sessionStartMonth = DateTime.april;

  /// Newest first.
  final List<FeeReceipt> receipts;

  Iterable<FeeReceipt> get _counted => receipts.where((r) => !r.isDishonoured);

  int get feeInPaise => _counted.fold(0, (sum, r) => sum + r.feeInPaise);

  int get concessionInPaise => _counted.fold(0, (sum, r) => sum + r.concessionInPaise);

  int get paidInPaise => _counted.fold(0, (sum, r) => sum + r.paidInPaise);

  /// Fee charged but neither paid nor waived. Later deposits for the same
  /// period (with a fee of 0) settle earlier balances, so this is summed over
  /// all receipts rather than per receipt.
  int get balanceInPaise => math.max(0, feeInPaise - concessionInPaise - paidInPaise);

  FeeReceipt? get lastPayment => _counted.firstOrNull;

  bool get hasDishonoured => receipts.any((r) => r.isDishonoured);

  /// Months covered by a (not dishonoured) payment.
  Set<DateTime> get paidMonths => {
    for (final receipt in _counted)
      for (final period in receipt.periods) ?period.month,
  };

  /// First month of the session of the latest paid month (or latest deposit).
  DateTime? get sessionStart {
    final months = paidMonths;
    final latest = months.isEmpty
        ? lastPayment?.depositedOn
        : months.reduce((a, b) => a.isAfter(b) ? a : b);
    if (latest == null) return null;
    final year = latest.month >= sessionStartMonth ? latest.year : latest.year - 1;
    return DateTime(year, sessionStartMonth);
  }

  /// The 12 months of [sessionStart]'s session.
  List<DateTime> get sessionMonths {
    final start = sessionStart;
    if (start == null) return const [];
    return [for (var i = 0; i < 12; i++) DateTime(start.year, start.month + i)];
  }
}
