import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/branding/app_branding.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Simulates institutions applying their own brand color at runtime.
class BrandingSection extends ConsumerWidget {
  const BrandingSection({super.key});

  // Sample institution brand colors. In the real app these arrive from the
  // backend; they are data, not design tokens, so raw colors are acceptable here.
  static final List<(String Function(AppLocalizations), AppBranding)> _samples = [
    ((l10n) => l10n.brandingDefault, AppBranding.erpDefault),
    ((l10n) => l10n.brandingSampleGreenValley, const AppBranding(primarySeed: Color(0xFF0F766E))),
    ((l10n) => l10n.brandingSampleRoyalPublic, const AppBranding(primarySeed: Color(0xFF9F1239))),
    ((l10n) => l10n.brandingSampleSunrise, const AppBranding(primarySeed: Color(0xFFD97706))),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(brandingProvider);

    return AppSection(
      title: l10n.brandingSectionTitle,
      description: l10n.brandingSectionDescription,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final (label, branding) in _samples)
            ChoiceChip(
              avatar: _BrandDot(color: branding.primarySeed),
              label: Text(label(l10n)),
              selected: branding == current,
              showCheckmark: false,
              onSelected: (_) => ref.read(brandingProvider.notifier).apply(branding),
            ),
        ],
      ),
    );
  }
}

class _BrandDot extends StatelessWidget {
  const _BrandDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.pillAll,
        border: Border.all(color: context.appColors.border),
      ),
      child: const SizedBox.square(dimension: AppIconSize.sm),
    );
  }
}
