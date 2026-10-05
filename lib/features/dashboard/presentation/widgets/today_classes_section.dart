import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/academics/domain/entities/class_period.dart';
import 'package:school_erp/features/academics/presentation/screens/academics_screen.dart';
import 'package:school_erp/features/academics/presentation/widgets/period_tile.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Today's periods with the current one highlighted.
class TodayClassesSection extends ConsumerWidget {
  const TodayClassesSection({required this.periods, super.key});

  final List<ClassPeriod> periods;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final now = ref.watch(clockProvider)();

    return AppSection(
      title: l10n.todayClassesTitle,
      action: TextButton(
        onPressed: () => context.go(AppRoutes.academicsTab(AcademicsTab.timetable.name)),
        child: Text(l10n.viewAll),
      ),
      child: periods.isEmpty
          ? Row(
              children: [
                Icon(
                  Icons.weekend_outlined,
                  size: AppIconSize.md,
                  color: context.appColors.textTertiary,
                ),
                AppGap.sm,
                Text(l10n.todayClassesEmpty, style: context.textStyles.bodyMedium),
              ],
            )
          : Column(
              children: [
                for (final period in periods)
                  PeriodTile(
                    period: period,
                    isCurrent: period.isOngoing(now),
                    isDone: period.isOver(now),
                  ),
              ],
            ),
    );
  }
}
