import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/shared/components/content/app_card.dart';

/// A single key figure for dashboards ("Attendance today · 92%").
class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    this.icon,
    this.supportingText,
    this.onTap,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final String? supportingText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final supportingText = this.supportingText;
    return AppCard(
      onTap: onTap,
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: context.textStyles.labelLarge?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ),
                if (icon != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColors.brandTint,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: Icon(
                        icon,
                        size: AppIconSize.md,
                        color: context.appColors.onBrandTint,
                      ),
                    ),
                  ),
              ],
            ),
            AppGap.sm,
            Text(value, style: context.textStyles.headlineMedium),
            if (supportingText != null) ...[
              AppGap.xs,
              Text(
                supportingText,
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.appColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
