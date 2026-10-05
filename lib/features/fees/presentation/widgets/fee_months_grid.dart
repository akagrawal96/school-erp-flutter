import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// The 12 months of the session; months with a payment are filled in.
class FeeMonthsGrid extends StatelessWidget {
  const FeeMonthsGrid({required this.summary, super.key});

  final FeesSummary summary;

  static const int _columns = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final months = summary.sessionMonths;
    final paid = summary.paidMonths;
    final paidCount = months.where(paid.contains).length;

    return AppSection(
      title: l10n.feesMonthsPaid,
      action: Text(
        l10n.feesMonthsPaidCount('$paidCount', '${months.length}'),
        style: context.textStyles.labelLarge?.copyWith(color: context.appColors.textSecondary),
      ),
      child: Column(
        children: [
          for (var row = 0; row < months.length; row += _columns) ...[
            if (row > 0) AppGap.sm,
            Row(
              children: [
                for (var i = row; i < row + _columns; i++) ...[
                  if (i > row) AppGap.sm,
                  Expanded(
                    child: i < months.length
                        ? _MonthCell(month: months[i], isPaid: paid.contains(months[i]))
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({required this.month, required this.isPaid});

  final DateTime month;
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final app = context.appColors;
    final foreground = isPaid ? app.onSuccess : app.textTertiary;

    return Semantics(
      label: isPaid
          ? l10n.feesMonthPaid(formats.monthYear(month))
          : l10n.feesMonthNotPaid(formats.monthYear(month)),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isPaid ? app.success : context.colors.surfaceContainerHigh,
          borderRadius: AppRadius.mdAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              Text(
                formats.monthShort(month),
                style: context.textStyles.titleSmall?.copyWith(color: foreground),
              ),
              AppGap.xxs,
              Icon(
                isPaid ? Icons.check_rounded : Icons.remove_rounded,
                size: AppIconSize.sm,
                color: foreground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
