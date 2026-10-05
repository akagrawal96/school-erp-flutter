import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/profile/domain/entities/student_profile.dart';
import 'package:school_erp/features/profile/presentation/widgets/student_text.dart';
import 'package:school_erp/shared/components/content/app_avatar.dart';
import 'package:school_erp/shared/components/content/app_card.dart';

/// Brand-colored identity card: photo, name, class and school.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.student, super.key});

  final StudentProfile student;

  static const double _avatarSize = AppSpacing.xxxl * 2;
  static const double _ringWidth = AppSpacing.xs;
  static const double _logoSize = AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colors.onPrimary;
    final status = student.status;
    final logo = student.institutionLogoUrl;

    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.primary, borderRadius: AppRadius.xlAll),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: onPrimary, width: _ringWidth),
              ),
              child: AppAvatar(name: student.name, imageUrl: student.photoUrl, size: _avatarSize),
            ),
            AppGap.md,
            Text(
              student.name,
              textAlign: TextAlign.center,
              style: context.textStyles.headlineSmall?.copyWith(color: onPrimary),
            ),
            AppGap.xs,
            Text(
              studentSubtitle(context.l10n, student),
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(
                color: onPrimary.withValues(alpha: 0.85),
              ),
            ),
            AppGap.md,
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                _HeaderChip(icon: Icons.badge_outlined, label: student.registrationNo),
                if (status != null) _HeaderChip(icon: Icons.verified_outlined, label: status),
              ],
            ),
            AppGap.lg,
            Divider(color: onPrimary.withValues(alpha: 0.2), height: 1),
            AppGap.md,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (logo != null) ...[
                  ClipOval(
                    child: ColoredBox(
                      color: onPrimary,
                      child: Image.network(
                        logo.toString(),
                        width: _logoSize,
                        height: _logoSize,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.account_balance_outlined,
                          size: AppIconSize.md,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ),
                  AppGap.sm,
                ] else ...[
                  Icon(Icons.account_balance_outlined, size: AppIconSize.md, color: onPrimary),
                  AppGap.sm,
                ],
                Flexible(
                  child: Text(
                    student.institutionName,
                    style: context.textStyles.titleSmall?.copyWith(color: onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colors.onPrimary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.14),
        borderRadius: AppRadius.pillAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppIconSize.sm, color: onPrimary),
            AppGap.xs,
            Text(label, style: context.textStyles.labelMedium?.copyWith(color: onPrimary)),
          ],
        ),
      ),
    );
  }
}

/// Class, section and session at a glance.
class ProfileQuickFacts extends StatelessWidget {
  const ProfileQuickFacts({required this.student, super.key});

  final StudentProfile student;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final facts = [
      (l10n.profileClass, student.className),
      (l10n.profileSection, student.section),
      (l10n.profileSession, student.sessionLabel),
    ].where((fact) => fact.$2.isNotEmpty).toList();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, (label, value)) in facts.indexed) ...[
            if (index > 0) AppGap.sm,
            Expanded(
              child: AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: MergeSemantics(
                  child: Column(
                    children: [
                      Text(
                        value,
                        textAlign: TextAlign.center,
                        style: context.textStyles.titleMedium?.copyWith(
                          color: context.appColors.onBrandTint,
                        ),
                      ),
                      AppGap.xxs,
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: context.textStyles.labelMedium?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
