import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/fees/data/repositories/api_fees_repository.dart';
import 'package:school_erp/features/fees/data/repositories/mock_fees_repository.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/domain/repositories/fees_repository.dart';

/// Real receipts when the environment has an API; sample data otherwise.
final feesRepositoryProvider = Provider<FeesRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  if (client == null) return MockFeesRepository(clock: ref.watch(clockProvider));
  return ApiFeesRepository(client: client);
});

final feesSummaryProvider = FutureProvider.autoDispose<FeesSummary>(
  (ref) async => FeesSummary(receipts: await ref.watch(feesRepositoryProvider).getReceipts()),
);

/// One receipt, looked up in the loaded list (the API has no single-receipt
/// endpoint). `null` when no receipt has this number.
final feeReceiptProvider = FutureProvider.autoDispose.family<FeeReceipt?, String>((
  ref,
  receiptId,
) async {
  final summary = await ref.watch(feesSummaryProvider.future);
  return summary.receipts.where((receipt) => receipt.id == receiptId).firstOrNull;
});

/// Fee heads of one receipt; uncharged heads are left out.
final feeReceiptItemsProvider = FutureProvider.autoDispose.family<List<FeeReceiptItem>, String>(
  (ref, receiptId) async => [
    for (final item in await ref.watch(feesRepositoryProvider).getReceiptItems(receiptId))
      if (!item.isEmpty) item,
  ],
);
