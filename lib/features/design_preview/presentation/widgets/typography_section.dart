import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/app_typography.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Every text style rendered with localized sample text.
class TypographySection extends StatelessWidget {
  const TypographySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final styles = AppTypography.named(context.textStyles);

    return AppSection(
      title: l10n.typographySectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final MapEntry(key: name, value: style) in styles.entries) ...[
            Text(
              '$name · ${style?.fontSize?.toStringAsFixed(0)}',
              style: context.textStyles.labelSmall?.copyWith(
                color: context.appColors.textTertiary,
              ),
            ),
            Text(l10n.typographySampleText, style: style),
            AppGap.md,
          ],
        ],
      ),
    );
  }
}
