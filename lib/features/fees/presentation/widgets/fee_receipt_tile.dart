import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/presentation/widgets/fee_text.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';

/// A payment in the list: deposit date, what it paid for and the amount.
class FeeReceiptTile extends StatelessWidget {
  const FeeReceiptTile({required this.receipt, super.key});

  final FeeReceipt receipt;

  static const double _dateBadgeSize = AppSpacing.xxxl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final balance = receipt.balanceInPaise;
    final amountStyle = context.textStyles.titleMedium?.copyWith(
      decoration: receipt.isDishonoured ? TextDecoration.lineThrough : null,
    );

    return InkWell(
      onTap: () => context.go(AppRoutes.feeReceipt(receipt.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColors.brandTint,
                  borderRadius: AppRadius.mdAll,
                ),
                child: SizedBox.square(
                  dimension: _dateBadgeSize,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formats.day(receipt.depositedOn),
                        style: context.textStyles.titleMedium?.copyWith(
                          color: context.appColors.onBrandTint,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        formats.monthShort(receipt.depositedOn),
                        style: context.textStyles.labelSmall?.copyWith(
                          color: context.appColors.onBrandTint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppGap.md,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feePeriodsText(l10n, formats, receipt.periods),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.titleSmall,
                  ),
                  AppGap.xxs,
                  Text(
                    '${l10n.feesReceiptNumber(receipt.id)} · ${formats.date(receipt.depositedOn)}',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  if (receipt.isDishonoured || balance > 0) ...[
                    AppGap.xs,
                    if (receipt.isDishonoured)
                      StatusChip(label: l10n.feesDishonoured, tone: StatusTone.error)
                    else
                      StatusChip(
                        label: l10n.feesBalanceChip(formats.rupees(balance)),
                        tone: StatusTone.warning,
                      ),
                  ],
                ],
              ),
            ),
            AppGap.md,
            Text(formats.rupees(receipt.paidInPaise), style: amountStyle),
            Icon(Icons.chevron_right, color: context.appColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
