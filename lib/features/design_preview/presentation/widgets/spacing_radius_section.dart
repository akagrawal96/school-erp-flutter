import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Visualizes the spacing scale and corner radius tokens.
class SpacingRadiusSection extends StatelessWidget {
  const SpacingRadiusSection({super.key});

  static const double _labelWidth = AppSpacing.xxxl + AppSpacing.lg;
  static const double _radiusBoxSize = AppSpacing.xxxl + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelStyle = context.textStyles.labelMedium?.copyWith(
      color: context.appColors.textSecondary,
    );

    return AppSection(
      title: l10n.spacingSectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionLabel(l10n.spacingLabel),
          for (final MapEntry(key: name, value: size) in AppSpacing.scale.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  SizedBox(
                    width: _labelWidth,
                    child: Text('$name ${size.toStringAsFixed(0)}', style: labelStyle),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: SizedBox(width: size, height: AppSpacing.md),
                  ),
                ],
              ),
            ),
          AppGap.lg,
          AppSectionLabel(l10n.radiusLabel),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              for (final MapEntry(key: name, value: radius) in AppRadius.scale.entries)
                Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.primaryContainer,
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(color: context.colors.primary),
                      ),
                      child: const SizedBox.square(dimension: _radiusBoxSize),
                    ),
                    AppGap.xs,
                    Text('$name ${radius.toStringAsFixed(0)}', style: labelStyle),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
