import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';

/// Brand-colored card with the session's paid amount, fee, concession and balance.
class FeesSummaryCard extends StatelessWidget {
  const FeesSummaryCard({required this.summary, required this.sessionLabel, super.key});

  final FeesSummary summary;

  /// "2025–26".
  final String sessionLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final onPrimary = context.colors.onPrimary;
    final muted = onPrimary.withValues(alpha: 0.8);
    final last = summary.lastPayment;

    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.primary, borderRadius: AppRadius.xlAll),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.feesPaidInSession(sessionLabel),
              style: context.textStyles.labelLarge?.copyWith(color: muted),
            ),
            AppGap.xs,
            Text(
              formats.rupees(summary.paidInPaise),
              style: context.textStyles.displaySmall?.copyWith(color: onPrimary),
            ),
            AppGap.lg,
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _Figure(
                      label: l10n.feesTotalFee,
                      value: formats.rupees(summary.feeInPaise),
                    ),
                  ),
                  AppGap.sm,
                  Expanded(
                    child: _Figure(
                      label: l10n.feesConcession,
                      value: formats.rupees(summary.concessionInPaise),
                    ),
                  ),
                  AppGap.sm,
                  Expanded(
                    child: _Figure(
                      label: l10n.feesBalance,
                      value: formats.rupees(summary.balanceInPaise),
                      highlight: summary.balanceInPaise > 0,
                    ),
                  ),
                ],
              ),
            ),
            if (last != null) ...[
              AppGap.lg,
              Row(
                children: [
                  Icon(Icons.check_circle_outline, size: AppIconSize.sm, color: muted),
                  AppGap.sm,
                  Expanded(
                    child: Text(
                      l10n.feesLastPayment(
                        formats.rupees(last.paidInPaise),
                        formats.date(last.depositedOn),
                      ),
                      style: context.textStyles.bodySmall?.copyWith(color: muted),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;

  /// Draws attention to an unpaid balance.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colors.onPrimary;
    final background = highlight ? context.appColors.warning : onPrimary.withValues(alpha: 0.14);
    final foreground = highlight ? context.appColors.onWarning : onPrimary;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(color: background, borderRadius: AppRadius.mdAll),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelSmall?.copyWith(
                  color: foreground.withValues(alpha: 0.85),
                ),
              ),
              AppGap.xxs,
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  value,
                  style: context.textStyles.titleSmall?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
