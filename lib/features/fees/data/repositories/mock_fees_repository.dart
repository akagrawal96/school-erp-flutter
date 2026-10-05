import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/domain/repositories/fees_repository.dart';

/// Sample receipts for builds without a server. Shaped like `StudentApi/GetFee`:
/// monthly fees of the current session paid up to last month, one month
/// settled in two deposits, one payment by cheque. All data is fictional.
final class MockFeesRepository implements FeesRepository {
  const MockFeesRepository({
    required this.clock,
    this.latency = const Duration(milliseconds: 600),
  });

  final Clock clock;
  final Duration latency;

  @override
  Future<List<FeeReceipt>> getReceipts() async {
    await Future<void>.delayed(latency);
    final now = clock();
    const startMonth = FeesSummary.sessionStartMonth;
    final year = now.month >= startMonth ? now.year : now.year - 1;
    DateTime month(int offset) => DateTime(year, startMonth + offset);
    DateTime day(int offset, int day) => DateTime(year, startMonth + offset, day);
    FeePeriod period(int offset) =>
        FeePeriod(label: _monthNames[month(offset).month - 1], month: month(offset));

    return [
      FeeReceipt(
        id: '10231',
        depositedOn: day(0, 7),
        recordedOn: day(0, 9),
        periods: [period(0)],
        feeInPaise: 1030000,
        concessionInPaise: 30000,
        paidInPaise: 600000,
      ),
      FeeReceipt(
        id: '10388',
        depositedOn: day(0, 21),
        periods: [period(0)],
        feeInPaise: 0,
        concessionInPaise: 40000,
        paidInPaise: 360000,
        remarks: 'UPI ref 000000000001',
      ),
      FeeReceipt(
        id: '10912',
        depositedOn: day(3, 18),
        periods: [period(1), period(2), period(3)],
        feeInPaise: 1590000,
        concessionInPaise: 210000,
        paidInPaise: 1380000,
        remarks: 'UPI ref 000000000002',
      ),
      FeeReceipt(
        id: '11270',
        depositedOn: day(4, 30),
        periods: [period(4)],
        feeInPaise: 530000,
        concessionInPaise: 70000,
        paidInPaise: 460000,
        remarks: 'UPI ref 000000000003',
      ),
      FeeReceipt(
        id: '11655',
        depositedOn: day(6, 6),
        periods: [period(5)],
        feeInPaise: 560000,
        concessionInPaise: 70000,
        paidInPaise: 490000,
        chequeNo: '000123',
        chequeDate: day(6, 5),
      ),
    ].where((receipt) => !receipt.depositedOn.isAfter(now)).toList();
  }

  /// Splits a receipt into tuition and transport per month, plus an uncharged
  /// exam fee row (the API lists every configured head).
  @override
  Future<List<FeeReceiptItem>> getReceiptItems(String receiptId) async {
    final receipt = (await getReceipts()).where((r) => r.id == receiptId).firstOrNull;
    if (receipt == null) return const [];
    final periods = receipt.periods.isEmpty ? const <FeePeriod?>[null] : receipt.periods;
    final count = periods.length;
    const transport = 100000;
    if (receipt.feeInPaise == 0) {
      return [
        FeeReceiptItem(
          name: 'Tuition Fee',
          period: periods.first,
          feeInPaise: 0,
          concessionInPaise: receipt.concessionInPaise,
          paidInPaise: receipt.paidInPaise,
        ),
      ];
    }
    return [
      for (final period in periods) ...[
        FeeReceiptItem(
          name: 'Tuition Fee',
          period: period,
          feeInPaise: receipt.feeInPaise ~/ count - transport,
          concessionInPaise: receipt.concessionInPaise ~/ count,
          paidInPaise: receipt.paidInPaise ~/ count - transport,
        ),
        FeeReceiptItem(
          name: 'Transport Fee',
          period: period,
          feeInPaise: transport,
          concessionInPaise: 0,
          paidInPaise: transport,
        ),
        FeeReceiptItem(
          name: 'Exam Fee',
          period: period,
          feeInPaise: 0,
          concessionInPaise: 0,
          paidInPaise: 0,
        ),
      ],
    ];
  }

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June', //
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
}
