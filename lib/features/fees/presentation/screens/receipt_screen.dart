import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/presentation/providers/fees_providers.dart';
import 'package:school_erp/features/fees/presentation/widgets/fee_breakdown.dart';
import 'package:school_erp/features/fees/presentation/widgets/fee_text.dart';
import 'package:school_erp/features/profile/presentation/providers/profile_providers.dart';
import 'package:school_erp/features/profile/presentation/widgets/student_text.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/states/loading_view.dart';
import 'package:school_erp/shared/states/state_view.dart';

class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({required this.receiptId, super.key});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final receipt = ref.watch(feeReceiptProvider(receiptId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.feesReceipt)),
      body: switch (receipt) {
        AsyncData(value: final value?) => _ReceiptContent(receipt: value),
        AsyncData() => EmptyStateView(
          icon: Icons.receipt_long_outlined,
          title: l10n.feesReceiptNotFound,
        ),
        AsyncError() => ErrorStateView(
          onRetry: () => ref.invalidate(feeReceiptProvider(receiptId)),
        ),
        _ => const LoadingView(),
      },
    );
  }
}

class _ReceiptContent extends ConsumerWidget {
  const _ReceiptContent({required this.receipt});

  final FeeReceipt receipt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final student = ref.watch(currentStudentProvider).value;
    final recordedOn = receipt.recordedOn;
    final chequeNo = receipt.chequeNo;
    final chequeDate = receipt.chequeDate;
    final remarks = receipt.remarks;
    final settlesEarlier = receipt.feeInPaise == 0;
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (student != null) ...[
                    Text(student.institutionName, style: context.textStyles.titleMedium),
                    AppGap.xxs,
                  ],
                  Text(
                    l10n.feesFeeReceipt.toUpperCase(),
                    style: context.textStyles.labelMedium?.copyWith(
                      color: context.appColors.textTertiary,
                    ),
                  ),
                  AppGap.lg,
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColors.brandTint,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Text(l10n.feesAmountPaid, style: context.textStyles.labelLarge),
                          AppGap.xxs,
                          Text(
                            formats.rupees(receipt.paidInPaise),
                            style: context.textStyles.headlineMedium?.copyWith(
                              color: context.appColors.onBrandTint,
                            ),
                          ),
                          AppGap.xs,
                          Text(
                            feePeriodsText(l10n, formats, receipt.periods),
                            textAlign: TextAlign.center,
                            style: context.textStyles.bodyMedium,
                          ),
                          AppGap.sm,
                          if (receipt.isDishonoured)
                            StatusChip(label: l10n.feesDishonoured, tone: StatusTone.error)
                          else
                            StatusChip(label: l10n.feesStatusPaid, tone: StatusTone.success),
                        ],
                      ),
                    ),
                  ),
                  AppGap.lg,
                  _DetailRow(label: l10n.feesReceiptNo, value: receipt.id),
                  _DetailRow(label: l10n.feesPaidOn, value: formats.date(receipt.depositedOn)),
                  if (recordedOn != null)
                    _DetailRow(label: l10n.feesRecordedOn, value: formats.date(recordedOn)),
                  if (student != null) ...[
                    _DetailRow(label: l10n.feesStudent, value: student.name),
                    _DetailRow(label: l10n.profileRegistrationNo, value: student.registrationNo),
                    _DetailRow(label: l10n.profileClass, value: studentSubtitle(l10n, student)),
                  ],
                  _DetailRow(
                    label: l10n.feesPeriod,
                    value: receipt.periods.isEmpty
                        ? l10n.feesFeePayment
                        : receipt.periods
                              .map((p) => p.month == null ? p.label : formats.monthYear(p.month!))
                              .join(', '),
                  ),
                  const Divider(height: AppSpacing.xl),
                  FeeBreakdown(receiptId: receipt.id),
                  const Divider(height: AppSpacing.xl),
                  if (settlesEarlier)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        l10n.feesSettlesEarlier,
                        style: context.textStyles.bodySmall?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    _DetailRow(
                      label: l10n.feesFeeAmount,
                      value: formats.rupees(receipt.feeInPaise),
                    ),
                  if (receipt.concessionInPaise > 0)
                    _DetailRow(
                      label: l10n.feesConcession,
                      value: '− ${formats.rupees(receipt.concessionInPaise)}',
                    ),
                  _DetailRow(
                    label: l10n.feesAmountPaid,
                    value: formats.rupees(receipt.paidInPaise),
                    emphasized: true,
                  ),
                  if (!settlesEarlier)
                    _DetailRow(
                      label: l10n.feesBalance,
                      value: formats.rupees(receipt.balanceInPaise),
                    ),
                  if (chequeNo != null || remarks != null) const Divider(height: AppSpacing.xl),
                  if (chequeNo != null)
                    _DetailRow(
                      label: l10n.feesModeCheque,
                      value: chequeDate == null
                          ? chequeNo
                          : l10n.feesChequeDetails(chequeNo, formats.date(chequeDate)),
                    ),
                  if (remarks != null) _DetailRow(label: l10n.feesRemarks, value: remarks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.emphasized = false});

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final valueStyle = emphasized ? context.textStyles.titleMedium : context.textStyles.bodyMedium;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: emphasized
                    ? context.textStyles.titleMedium
                    : context.textStyles.bodyMedium?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
              ),
            ),
            AppGap.md,
            // Values (amounts, IDs) line up on the right edge.
            Expanded(
              flex: 4,
              child: SelectableText(value, textAlign: TextAlign.end, style: valueStyle),
            ),
          ],
        ),
      ),
    );
  }
}
