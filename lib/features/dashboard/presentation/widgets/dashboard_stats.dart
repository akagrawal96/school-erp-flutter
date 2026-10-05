import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/presentation/screens/academics_screen.dart';
import 'package:school_erp/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:school_erp/shared/components/content/stat_card.dart';

/// Key figures: fees (full width), attendance and pending homework.
class DashboardStats extends ConsumerWidget {
  const DashboardStats({required this.data, super.key});

  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final percentage = data.attendance.summary.percentage;
    final fees = data.fees;
    final balance = fees.balanceInPaise;
    final lastPayment = fees.lastPayment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (balance > 0)
          StatCard(
            label: l10n.statFeesBalance,
            icon: Icons.account_balance_wallet_outlined,
            value: formats.rupees(balance),
            supportingText: l10n.statFeesPaidSoFar(formats.rupees(fees.paidInPaise)),
            onTap: () => context.go(AppRoutes.fees),
          )
        else
          StatCard(
            label: l10n.statFeesPaid,
            icon: Icons.account_balance_wallet_outlined,
            value: lastPayment == null ? '—' : formats.rupees(fees.paidInPaise),
            supportingText: lastPayment == null
                ? l10n.feesNoPaymentsYet
                : l10n.statFeesLastPaid(formats.dayMonth(lastPayment.depositedOn)),
            onTap: () => context.go(AppRoutes.fees),
          ),
        AppGap.sm,
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatCard(
                  label: l10n.statAttendanceThisYear,
                  icon: Icons.fact_check_outlined,
                  value: percentage == null ? '—' : formats.percent(percentage),
                  supportingText: l10n.statAttendanceSupporting,
                  onTap: () => context.go(AppRoutes.attendance),
                ),
              ),
              AppGap.sm,
              Expanded(
                child: StatCard(
                  label: l10n.statHomeworkPending,
                  icon: Icons.assignment_outlined,
                  value: '${data.snapshot.pendingHomework}',
                  supportingText: l10n.statHomeworkSupporting,
                  onTap: () => context.go(AppRoutes.academicsTab(AcademicsTab.homework.name)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
