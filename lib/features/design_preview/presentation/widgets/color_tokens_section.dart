import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Grid of the semantic color tokens with their current values.
class ColorTokensSection extends StatelessWidget {
  const ColorTokensSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final app = context.appColors;
    // Token names are code identifiers, so they are intentionally not localized.
    final tokens = <_ColorToken>[
      _ColorToken('primary', scheme.primary, scheme.onPrimary),
      _ColorToken('primaryContainer', scheme.primaryContainer, scheme.onPrimaryContainer),
      _ColorToken('secondary', scheme.secondary, scheme.onSecondary),
      _ColorToken('secondaryContainer', scheme.secondaryContainer, scheme.onSecondaryContainer),
      _ColorToken('surface', scheme.surface, scheme.onSurface),
      _ColorToken('surfaceContainer', scheme.surfaceContainer, scheme.onSurface),
      _ColorToken('surfaceContainerHigh', scheme.surfaceContainerHigh, scheme.onSurface),
      _ColorToken('textSecondary', app.textSecondary, scheme.surface),
      _ColorToken('border', app.border, scheme.onSurface),
      _ColorToken('success', app.success, app.onSuccess),
      _ColorToken('warning', app.warning, app.onWarning),
      _ColorToken('error', scheme.error, scheme.onError),
      _ColorToken('info', app.info, app.onInfo),
    ];
    final columns = switch (context.windowSize) {
      WindowSize.compact => 2,
      WindowSize.medium => 3,
      WindowSize.expanded => 4,
    };

    return AppSection(
      title: context.l10n.colorsSectionTitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileWidth = (constraints.maxWidth - AppSpacing.sm * (columns - 1)) / columns;
          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final token in tokens) SizedBox(width: tileWidth, child: _Swatch(token)),
            ],
          );
        },
      ),
    );
  }
}

final class _ColorToken {
  const _ColorToken(this.name, this.color, this.onColor);

  final String name;
  final Color color;
  final Color onColor;
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.token);

  final _ColorToken token;

  @override
  Widget build(BuildContext context) {
    final hex = (token.color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: token.color,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: context.appColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              token.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.labelMedium?.copyWith(color: token.onColor),
            ),
            AppGap.xs,
            Text(
              '#${hex.toUpperCase()}',
              style: context.textStyles.bodySmall?.copyWith(color: token.onColor),
            ),
          ],
        ),
      ),
    );
  }
}
