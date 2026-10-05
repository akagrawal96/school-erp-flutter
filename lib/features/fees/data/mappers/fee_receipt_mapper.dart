import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/network/api_values.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';

/// Maps a `StudentApi/GetFee` row to [FeeReceipt].
abstract final class FeeReceiptMapper {
  /// Returns `null` for rows without a receipt number or deposit date.
  static FeeReceipt? fromJson(Json json) {
    final id = ApiValues.text(json['FLID']);
    final depositedOn = ApiValues.date(json['DepositDate']);
    if (id == null || depositedOn == null) return null;
    final recordedOn = ApiValues.date(json['EntryDate']);
    return FeeReceipt(
      id: id,
      depositedOn: depositedOn,
      recordedOn: recordedOn == depositedOn ? null : recordedOn,
      periods: periods(ApiValues.text(json['DepositedTerms']), paidOn: depositedOn),
      feeInPaise: ApiValues.paise(json['TotalConfiguredAmount']),
      concessionInPaise: ApiValues.paise(json['TotalConcessionAmount']),
      paidInPaise: ApiValues.paise(json['TotalDepositedAmount']),
      chequeNo: ApiValues.text(json['ChequeNo']),
      chequeDate: ApiValues.date(json['ChequeDate']),
      remarks: ApiValues.text(json['DepositRemarks']),
      isDishonoured: _dishonouredValues.contains(
        ApiValues.text(json['IsDishonouredStatus'])?.toLowerCase(),
      ),
    );
  }

  /// Maps a `StudentApi/GetFeeData` row (one fee head for one period).
  static FeeReceiptItem? itemFromJson(Json json) {
    final name = ApiValues.text(json['FeeParticularsName']);
    if (name == null) return null;
    final paidOn = ApiValues.date(json['DepositDate']);
    final term = ApiValues.text(json['FeeTermName']);
    return FeeReceiptItem(
      name: ApiValues.titleCase(name),
      period: paidOn == null || term == null ? null : periods(term, paidOn: paidOn).firstOrNull,
      feeInPaise: ApiValues.paise(json['ConfiguredFeeAmount']),
      concessionInPaise: ApiValues.paise(json['ConcessionAmount']),
      paidInPaise: ApiValues.paise(json['DepositedFeeAmount']),
    );
  }

  /// `IsDishonouredStatus` is `""` for normal receipts. Only clear "yes"
  /// values mark a bounced cheque; anything else is treated as paid.
  // TODO(step-4): confirm the possible values with the backend team.
  static const _dishonouredValues = {'y', 'yes', '1', 'true', 'd', 'dishonoured', 'dishonored'};

  /// "MAY,JUNE,JULY" → May, June and July, placed in a year.
  ///
  /// The API sends month names without a year. A month is placed in the
  /// academic session of [paidOn] (April–March); if that is more than three
  /// months after the payment, it was a late payment for the previous
  /// session. Other names ("TERM 1") are kept as labels.
  static List<FeePeriod> periods(String? terms, {required DateTime paidOn}) {
    if (terms == null) return const [];
    return [
      for (final raw in terms.split(','))
        if (raw.trim() case final name when name.isNotEmpty)
          switch (_months[name.toLowerCase()]) {
            final month? => FeePeriod(
              label: ApiValues.titleCase(name),
              month: _placeInYear(month, paidOn),
            ),
            null => FeePeriod(label: ApiValues.titleCase(name)),
          },
    ];
  }

  static DateTime _placeInYear(int month, DateTime paidOn) {
    const sessionStart = FeesSummary.sessionStartMonth;
    final sessionYear = paidOn.month >= sessionStart ? paidOn.year : paidOn.year - 1;
    final placed = DateTime(month >= sessionStart ? sessionYear : sessionYear + 1, month);
    final latest = DateTime(paidOn.year, paidOn.month + 3);
    return placed.isAfter(latest) ? DateTime(placed.year - 1, month) : placed;
  }

  static const _months = {
    'january': 1,
    'jan': 1,
    'february': 2,
    'feb': 2,
    'march': 3,
    'mar': 3,
    'april': 4,
    'apr': 4,
    'may': 5,
    'june': 6,
    'jun': 6,
    'july': 7,
    'jul': 7,
    'august': 8,
    'aug': 8,
    'september': 9,
    'sep': 9,
    'sept': 9,
    'october': 10,
    'oct': 10,
    'november': 11,
    'nov': 11,
    'december': 12,
    'dec': 12,
  };
}
