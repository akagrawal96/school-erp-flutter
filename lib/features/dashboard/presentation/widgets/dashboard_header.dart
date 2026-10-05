import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/attendance/presentation/widgets/attendance_status_style.dart';
import 'package:school_erp/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:school_erp/features/profile/presentation/widgets/student_text.dart';
import 'package:school_erp/shared/components/content/app_avatar.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';

/// Greeting with the student's identity and today's attendance.
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({required this.data, super.key});

  final DashboardData data;

  static const double _avatarSize = AppSpacing.xxxl + AppSpacing.xs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final now = ref.watch(clockProvider)();
    final student = data.student;
    final greeting = switch (GreetingPeriod.of(now)) {
      GreetingPeriod.morning => l10n.greetingMorning,
      GreetingPeriod.afternoon => l10n.greetingAfternoon,
      GreetingPeriod.evening => l10n.greetingEvening,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppAvatar(name: student.name, imageUrl: student.photoUrl, size: _avatarSize),
            AppGap.md,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashboardGreeting(greeting, student.firstName),
                    style: context.textStyles.titleLarge,
                  ),
                  Text(
                    studentSubtitle(l10n, student),
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppGap.lg,
        AppCard(
          onTap: () => context.go(AppRoutes.attendance),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColors.brandTint,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(
                    Icons.event_available_outlined,
                    size: AppIconSize.lg,
                    color: context.appColors.onBrandTint,
                  ),
                ),
              ),
              AppGap.md,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.todayAttendanceTitle, style: context.textStyles.titleSmall),
                    Text(
                      AppFormats.of(context).fullDate(now),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(label: data.todayStatus.label(l10n), tone: data.todayStatus.tone),
            ],
          ),
        ),
      ],
    );
  }
}
