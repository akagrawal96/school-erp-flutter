import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/shared/components/content/app_card.dart';

/// A titled card grouping one section of a screen.
class AppSection extends StatelessWidget {
  const AppSection({
    required this.title,
    required this.child,
    this.description,
    this.action,
    super.key,
  });

  final String title;
  final String? description;

  /// Optional trailing header action, e.g. a "View all" text button.
  final Widget? action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    final action = this.action;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title, style: context.textStyles.titleMedium),
                ),
              ),
              ?action,
            ],
          ),
          if (description != null) ...[
            AppGap.xs,
            Text(
              description,
              style: context.textStyles.bodySmall?.copyWith(color: context.appColors.textSecondary),
            ),
          ],
          AppGap.lg,
          child,
        ],
      ),
    );
  }
}

/// A small caption above a group of controls inside a section.
class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: context.textStyles.labelLarge?.copyWith(color: context.appColors.textSecondary),
      ),
    );
  }
}
