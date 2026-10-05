import 'package:school_erp/features/fees/domain/entities/fees.dart';

abstract interface class FeesRepository {
  /// Every fee receipt of the signed-in student.
  Future<List<FeeReceipt>> getReceipts();

  /// Fee heads paid by one receipt, per period.
  Future<List<FeeReceiptItem>> getReceiptItems(String receiptId);
}
