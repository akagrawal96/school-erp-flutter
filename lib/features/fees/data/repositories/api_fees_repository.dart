import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/features/fees/data/mappers/fee_receipt_mapper.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/domain/repositories/fees_repository.dart';

/// Fee receipts from `StudentApi/GetFee` (paginated, 20 per page).
///
/// The API lists deposits only; what is still due needs the fee dues API
/// requested in docs/api/change-requests-2026-09.md.
final class ApiFeesRepository implements FeesRepository {
  const ApiFeesRepository({required this.client});

  final ApiClient client;

  static const _path = 'StudentApi/GetFee';
  static const _itemsPath = 'StudentApi/GetFeeData';

  /// Safety stop in case the server keeps reporting another page.
  static const _maxPages = 25;

  @override
  Future<List<FeeReceipt>> getReceipts() async {
    // A student has at most a few dozen receipts, and the totals need all of
    // them, so every page is loaded.
    final receipts = <FeeReceipt>[];
    for (var page = 1; page <= _maxPages; page++) {
      final result = await client.getPage(_path, page: page);
      for (final item in result.items) {
        if (item is Json) {
          if (FeeReceiptMapper.fromJson(item) case final receipt?) receipts.add(receipt);
        }
      }
      if (!result.hasNextPage) break;
    }
    return receipts;
  }

  @override
  Future<List<FeeReceiptItem>> getReceiptItems(String receiptId) async {
    // 10 rows per page: one per fee head and month, so a receipt for three
    // months spans several pages.
    final items = <FeeReceiptItem>[];
    for (var page = 1; page <= _maxPages; page++) {
      final result = await client.getPage(_itemsPath, page: page, query: {'FLID': receiptId});
      for (final item in result.items) {
        if (item is Json) {
          if (FeeReceiptMapper.itemFromJson(item) case final mapped?) items.add(mapped);
        }
      }
      if (!result.hasNextPage) break;
    }
    return items;
  }
}
