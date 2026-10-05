import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/presentation/providers/fees_providers.dart';
import 'package:school_erp/shared/states/skeleton.dart';

/// Fee heads paid by a receipt ("Tuition fee ₹1,600"), grouped by month when
/// the receipt covers several months.
class FeeBreakdown extends ConsumerWidget {
  const FeeBreakdown({required this.receiptId, super.key});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(feeReceiptItemsProvider(receiptId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.feesBreakdown, style: context.textStyles.titleSmall),
        ),
        AppGap.sm,
        ...switch (items) {
          AsyncValue(:final value?) => _groups(context, value),
          AsyncError() => [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.feesBreakdownFailed,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(feeReceiptItemsProvider(receiptId)),
                  child: Text(l10n.actionRetry),
                ),
              ],
            ),
          ],
          _ => const [SkeletonList(itemCount: 2)],
        },
      ],
    );
  }

  List<Widget> _groups(BuildContext context, List<FeeReceiptItem> items) {
    final formats = AppFormats.of(context);
    final byPeriod = <DateTime?, List<FeeReceiptItem>>{};
    for (final item in items) {
      (byPeriod[item.period?.month] ??= []).add(item);
    }
    final showPeriods = byPeriod.length > 1;
    return [
      for (final MapEntry(key: month, value: group) in byPeriod.entries) ...[
        if (showPeriods)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xxs),
            child: Text(
              month == null ? (group.first.period?.label ?? '') : formats.monthYear(month),
              style: context.textStyles.labelLarge?.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ),
        for (final item in group) _ItemRow(item: item),
      ],
    ];
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final FeeReceiptItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final details = [
      if (item.feeInPaise != item.paidInPaise)
        l10n.feesHeadCharged(formats.rupees(item.feeInPaise)),
      if (item.concessionInPaise > 0)
        l10n.feesHeadConcession(formats.rupees(item.concessionInPaise)),
    ];

    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: context.textStyles.bodyMedium),
                  if (details.isNotEmpty)
                    Text(
                      details.join(' · '),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.appColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            AppGap.md,
            Text(formats.rupees(item.paidInPaise), style: context.textStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
