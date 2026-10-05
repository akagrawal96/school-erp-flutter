import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/features/fees/data/mappers/fee_receipt_mapper.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/presentation/widgets/fee_text.dart';
import 'package:school_erp/l10n/generated/app_localizations_en.dart';

// All data below is fictional.
void main() {
  setUpAll(initializeDateFormatting);

  FeeReceipt receipt({
    required String id,
    required DateTime on,
    required List<DateTime> months,
    int fee = 530000,
    int concession = 70000,
    int paid = 460000,
    bool dishonoured = false,
  }) => FeeReceipt(
    id: id,
    depositedOn: on,
    periods: [for (final m in months) FeePeriod(label: 'M', month: m)],
    feeInPaise: fee,
    concessionInPaise: concession,
    paidInPaise: paid,
    isDishonoured: dishonoured,
  );

  group('FeesSummary', () {
    test('totals, balance and paid months; a later deposit settles an earlier balance', () {
      final summary = FeesSummary(
        receipts: [
          receipt(
            id: '1',
            on: DateTime(2025, 4, 7),
            months: [DateTime(2025, 4)],
            fee: 1030000,
            concession: 30000,
            paid: 600000,
          ),
          receipt(
            id: '3',
            on: DateTime(2025, 5, 30),
            months: [DateTime(2025, 5)],
          ),
          receipt(
            id: '2',
            on: DateTime(2025, 4, 20),
            months: [DateTime(2025, 4)],
            fee: 0,
            concession: 40000,
            paid: 360000,
          ),
        ],
      );

      expect(summary.receipts.map((r) => r.id), ['3', '2', '1'], reason: 'newest first');
      expect(summary.receipts.last.balanceInPaise, 400000);
      expect(summary.feeInPaise, 1560000);
      expect(summary.concessionInPaise, 140000);
      expect(summary.paidInPaise, 1420000);
      expect(summary.balanceInPaise, 0);
      expect(summary.lastPayment!.id, '3');
      expect(summary.paidMonths, {DateTime(2025, 4), DateTime(2025, 5)});
      expect(summary.sessionStart, DateTime(2025, 4));
      expect(summary.sessionMonths.first, DateTime(2025, 4));
      expect(summary.sessionMonths.last, DateTime(2026, 3));
    });

    test('a dishonoured cheque is not counted as paid', () {
      final summary = FeesSummary(
        receipts: [
          receipt(id: '1', on: DateTime(2025, 8, 30), months: [DateTime(2025, 8)]),
          receipt(
            id: '2',
            on: DateTime(2025, 9, 30),
            months: [DateTime(2025, 9)],
            dishonoured: true,
          ),
        ],
      );

      expect(summary.hasDishonoured, isTrue);
      expect(summary.paidInPaise, 460000);
      expect(summary.paidMonths, {DateTime(2025, 8)});
      expect(summary.lastPayment!.id, '1');
    });

    test('a January payment belongs to the session that started the April before', () {
      final summary = FeesSummary(
        receipts: [
          receipt(id: '1', on: DateTime(2026, 1, 5), months: [DateTime(2026)]),
        ],
      );
      expect(summary.sessionStart, DateTime(2025, 4));
    });
  });

  group('FeeReceiptMapper.periods', () {
    List<DateTime?> months(String terms, DateTime paidOn) => [
      for (final p in FeeReceiptMapper.periods(terms, paidOn: paidOn)) p.month,
    ];

    test('months are placed in the session of the payment', () {
      expect(months('MAY,JUNE,JULY', DateTime(2025, 7, 18)), [
        DateTime(2025, 5),
        DateTime(2025, 6),
        DateTime(2025, 7),
      ]);
      expect(months('JANUARY', DateTime(2025, 12, 20)), [DateTime(2026)], reason: 'advance');
      expect(months('MARCH', DateTime(2025, 12, 20)), [DateTime(2026, 3)]);
      expect(months('APRIL', DateTime(2026, 1, 10)), [DateTime(2025, 4)], reason: 'late');
      expect(
        months('MARCH', DateTime(2026, 4, 5)),
        [DateTime(2026, 3)],
        reason: 'paid after the session ended',
      );
    });

    test('other period names are kept as labels', () {
      final periods = FeeReceiptMapper.periods('TERM 1, Sept', paidOn: DateTime(2025, 9));
      expect(periods.first.label, 'Term 1');
      expect(periods.first.month, isNull);
      expect(periods.last.month, DateTime(2025, 9));
    });
  });

  test('feePeriodsText describes months compactly', () {
    final l10n = AppLocalizationsEn();
    final formats = AppFormats('en');
    List<FeePeriod> of(List<DateTime> months) => [
      for (final m in months) FeePeriod(label: 'x', month: m),
    ];

    expect(feePeriodsText(l10n, formats, const []), 'Fee payment');
    expect(feePeriodsText(l10n, formats, of([DateTime(2025, 11)])), 'November 2025');
    expect(
      feePeriodsText(l10n, formats, of([DateTime(2025, 5), DateTime(2025, 6), DateTime(2025, 7)])),
      'May – Jul 2025',
    );
    expect(
      feePeriodsText(l10n, formats, of([DateTime(2025, 12), DateTime(2026)])),
      'Dec 2025 – Jan 2026',
    );
    expect(
      feePeriodsText(l10n, formats, of([DateTime(2025, 5), DateTime(2025, 7)])),
      'May 2025, Jul 2025',
    );
    expect(feePeriodsText(l10n, formats, const [FeePeriod(label: 'Term 1')]), 'Term 1');
  });
}
