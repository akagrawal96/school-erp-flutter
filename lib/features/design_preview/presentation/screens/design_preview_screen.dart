import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/design_preview/presentation/widgets/branding_section.dart';
import 'package:school_erp/features/design_preview/presentation/widgets/color_tokens_section.dart';
import 'package:school_erp/features/design_preview/presentation/widgets/components_sample_section.dart';
import 'package:school_erp/features/design_preview/presentation/widgets/spacing_radius_section.dart';
import 'package:school_erp/features/design_preview/presentation/widgets/typography_section.dart';
import 'package:school_erp/shared/components/settings/appearance_settings.dart';

/// Developer-facing preview of the design system: theme mode, language,
/// institution branding, color tokens, typography and themed components.
///
/// Not an ERP feature. It stays available in staging builds for design review.
class DesignPreviewScreen extends ConsumerWidget {
  const DesignPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final flavor = ref.watch(appFlavorProvider);
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.designPreviewTitle)),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
              children: [
                Text(
                  l10n.designPreviewSubtitle,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
                if (!flavor.environment.isProduction) ...[
                  AppGap.xs,
                  Text(
                    l10n.buildFlavorLabel(flavor.name),
                    style: context.textStyles.labelMedium?.copyWith(
                      color: context.appColors.textTertiary,
                    ),
                  ),
                ],
                AppGap.xl,
                const AppearanceSection(),
                AppGap.lg,
                const BrandingSection(),
                AppGap.lg,
                const ComponentsSampleSection(),
                AppGap.lg,
                const ColorTokensSection(),
                AppGap.lg,
                const TypographySection(),
                AppGap.lg,
                const SpacingRadiusSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
