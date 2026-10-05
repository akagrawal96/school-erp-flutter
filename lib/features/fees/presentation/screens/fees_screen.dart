import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/fees/domain/entities/fees.dart';
import 'package:school_erp/features/fees/presentation/providers/fees_providers.dart';
import 'package:school_erp/features/fees/presentation/widgets/fee_months_grid.dart';
import 'package:school_erp/features/fees/presentation/widgets/fee_receipt_tile.dart';
import 'package:school_erp/features/fees/presentation/widgets/fees_summary_card.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/states/skeleton.dart';
import 'package:school_erp/shared/states/state_view.dart';

/// Fees tab: what has been paid this session, month by month, and every receipt.
class FeesScreen extends ConsumerWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final summary = ref.watch(feesSummaryProvider);
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navFees)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(feesSummaryProvider.future),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
              children: switch (summary) {
                AsyncValue(:final value?) when value.receipts.isEmpty => [
                  AppCard(
                    child: EmptyStateView(
                      icon: Icons.receipt_long_outlined,
                      title: l10n.feesNoPaymentsYet,
                      message: l10n.feesNoPaymentsMessage,
                    ),
                  ),
                ],
                AsyncValue(:final value?) => _content(context, value),
                AsyncError() => [
                  AppCard(
                    child: ErrorStateView(onRetry: () => ref.invalidate(feesSummaryProvider)),
                  ),
                ],
                _ => const [
                  Skeleton(
                    child: SkeletonBox(height: AppSpacing.xxxl * 4, radius: AppRadius.xlAll),
                  ),
                  AppGap.lg,
                  AppCard(child: SkeletonList(itemCount: 4)),
                ],
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, FeesSummary summary) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final sessionStart = summary.sessionStart;
    return [
      FeesSummaryCard(
        summary: summary,
        sessionLabel: sessionStart == null ? '' : formats.academicYear(sessionStart.year),
      ),
      if (summary.balanceInPaise > 0) ...[
        AppGap.md,
        _Banner(
          icon: Icons.info_outline,
          tone: _BannerTone.warning,
          text: l10n.feesBalanceWarning(formats.rupees(summary.balanceInPaise)),
        ),
      ],
      if (summary.hasDishonoured) ...[
        AppGap.md,
        _Banner(
          icon: Icons.error_outline,
          tone: _BannerTone.error,
          text: l10n.feesDishonouredWarning,
        ),
      ],
      AppGap.lg,
      FeeMonthsGrid(summary: summary),
      AppGap.xl,
      Semantics(
        header: true,
        child: Text(
          '${l10n.feesPayments} (${summary.receipts.length})',
          style: context.textStyles.titleMedium,
        ),
      ),
      AppGap.md,
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final (index, receipt) in summary.receipts.indexed) ...[
              if (index > 0) const Divider(height: 1, indent: AppSpacing.lg),
              FeeReceiptTile(receipt: receipt),
            ],
          ],
        ),
      ),
      AppGap.lg,
      Text(
        l10n.feesOfficeNote,
        textAlign: TextAlign.center,
        style: context.textStyles.bodySmall?.copyWith(color: context.appColors.textTertiary),
      ),
    ];
  }
}

enum _BannerTone { warning, error }

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.tone, required this.text});

  final IconData icon;
  final _BannerTone tone;
  final String text;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      _BannerTone.warning => (
        context.appColors.warningContainer,
        context.appColors.onWarningContainer,
      ),
      _BannerTone.error => (context.colors.errorContainer, context.colors.onErrorContainer),
    };
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: AppRadius.mdAll),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppIconSize.md, color: foreground),
            AppGap.sm,
            Expanded(
              child: Text(
                text,
                style: context.textStyles.bodySmall?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
