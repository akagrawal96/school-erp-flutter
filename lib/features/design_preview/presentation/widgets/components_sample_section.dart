import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

/// Plain Material widgets styled only by the app theme, to verify component
/// themes. Reusable app components (with behavior) arrive in step 3.
class ComponentsSampleSection extends StatelessWidget {
  const ComponentsSampleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final app = context.appColors;

    return AppSection(
      title: l10n.componentsSectionTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.sampleCardTitle, style: context.textStyles.titleMedium)),
              _StatusBadge(
                label: l10n.statusDue,
                background: app.warningContainer,
                foreground: app.onWarningContainer,
              ),
            ],
          ),
          AppGap.xs,
          Text(
            l10n.sampleCardBody,
            style: context.textStyles.bodyMedium?.copyWith(color: app.textSecondary),
          ),
          AppGap.lg,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _StatusBadge(
                label: l10n.statusPaid,
                background: app.successContainer,
                foreground: app.onSuccessContainer,
              ),
              _StatusBadge(
                label: l10n.statusOverdue,
                background: context.colors.errorContainer,
                foreground: context.colors.onErrorContainer,
              ),
              _StatusBadge(
                label: l10n.statusNew,
                background: app.infoContainer,
                foreground: app.onInfoContainer,
              ),
            ],
          ),
          AppGap.lg,
          TextField(
            decoration: InputDecoration(
              labelText: l10n.sampleFieldLabel,
              hintText: l10n.sampleFieldHint,
            ),
          ),
          AppGap.lg,
          FilledButton(onPressed: () {}, child: Text(l10n.samplePrimaryAction)),
          AppGap.sm,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: () {}, child: Text(l10n.sampleSecondaryAction)),
              ),
              AppGap.sm,
              TextButton(onPressed: () {}, child: Text(l10n.sampleTextAction)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Preview-only status label. A shared `StatusChip` component replaces it in step 3.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.background, required this.foreground});

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: AppRadius.smAll),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
        child: Text(
          label,
          style: context.textStyles.labelMedium?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
