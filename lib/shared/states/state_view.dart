import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';

/// Centered icon, title, message and optional action. Base for empty, error
/// and offline states — use those wrappers in feature code.
class StateView extends StatelessWidget {
  const StateView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconBackground,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final Color? iconBackground;

  static const double _iconContainerSize = AppSpacing.xxxl + AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    final actionLabel = this.actionLabel;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: iconBackground ?? context.colors.surfaceContainerHigh,
                  borderRadius: AppRadius.pillAll,
                ),
                child: SizedBox.square(
                  dimension: _iconContainerSize,
                  child: Icon(
                    icon,
                    size: AppIconSize.xl,
                    color: iconColor ?? context.appColors.textSecondary,
                  ),
                ),
              ),
            ),
            AppGap.lg,
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textStyles.titleMedium,
            ),
            if (message != null) ...[
              AppGap.xs,
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppGap.lg,
              AppButton(
                label: actionLabel,
                variant: AppButtonVariant.secondary,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Nothing to show yet. Explain what will appear and, if possible, how to add it.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return StateView(
      icon: icon,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// Something failed. Defaults to a generic, non-technical message.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({this.title, this.message, this.onRetry, super.key});

  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StateView(
      icon: Icons.error_outline,
      iconColor: context.colors.onErrorContainer,
      iconBackground: context.colors.errorContainer,
      title: title ?? l10n.errorGenericTitle,
      message: message ?? l10n.errorGenericMessage,
      actionLabel: l10n.actionRetry,
      onAction: onRetry,
    );
  }
}

/// No internet connection.
class OfflineStateView extends StatelessWidget {
  const OfflineStateView({this.onRetry, super.key});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StateView(
      icon: Icons.wifi_off_outlined,
      iconColor: context.appColors.onWarningContainer,
      iconBackground: context.appColors.warningContainer,
      title: l10n.errorOfflineTitle,
      message: l10n.errorOfflineMessage,
      actionLabel: l10n.actionRetry,
      onAction: onRetry,
    );
  }
}
