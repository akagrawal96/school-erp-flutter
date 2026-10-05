import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/presentation/screens/academics_screen.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Shortcut grid to frequently used modules.
///
/// The list is fixed for the student app; later it is built from the
/// institution's enabled modules and the user's permissions.
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = [
      (Icons.fact_check_outlined, l10n.navAttendance, AppRoutes.attendance),
      (
        Icons.schedule_outlined,
        l10n.quickTimetable,
        AppRoutes.academicsTab(AcademicsTab.timetable.name),
      ),
      (
        Icons.assignment_outlined,
        l10n.quickHomework,
        AppRoutes.academicsTab(AcademicsTab.homework.name),
      ),
      (Icons.account_balance_wallet_outlined, l10n.navFees, AppRoutes.fees),
      (
        Icons.emoji_events_outlined,
        l10n.quickResults,
        AppRoutes.academicsTab(AcademicsTab.results.name),
      ),
      (Icons.campaign_outlined, l10n.quickNotices, AppRoutes.notices),
    ];
    final columns = context.windowSize.isCompact ? 3 : 6;

    return AppSection(
      title: l10n.quickActionsTitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - AppSpacing.sm * (columns - 1)) / columns;
          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (icon, label, route) in actions)
                SizedBox(
                  width: width,
                  child: _QuickActionTile(icon: icon, label: label, route: route),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.mdAll,
        onTap: () => route == AppRoutes.notices ? context.push(route) : context.go(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColors.brandTint,
                  borderRadius: AppRadius.lgAll,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Icon(icon, size: AppIconSize.lg, color: context.appColors.onBrandTint),
                ),
              ),
              AppGap.sm,
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
