import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';

enum AppButtonVariant {
  /// The main action of a screen or section. One per view.
  primary,

  /// Alternative actions next to a primary one.
  secondary,

  /// Low-emphasis actions (skip, cancel, "forgot password").
  text,

  /// Irreversible actions such as delete. Pair with a confirmation dialog.
  destructive,
}

/// The app's button. Styling comes from the theme; this adds variants,
/// an optional icon, a loading state and full-width layout.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// Shows a spinner and ignores taps, e.g. while a form submits.
  final bool isLoading;

  /// Stretches the button to the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final callback = isLoading ? null : onPressed;
    final child = _ButtonContent(label: label, icon: icon, isLoading: isLoading);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(onPressed: callback, child: child),
      AppButtonVariant.secondary => OutlinedButton(onPressed: callback, child: child),
      AppButtonVariant.text => TextButton(onPressed: callback, child: child),
      AppButtonVariant.destructive => FilledButton(
        onPressed: callback,
        style: FilledButton.styleFrom(
          backgroundColor: context.colors.error,
          foregroundColor: context.colors.onError,
        ),
        child: child,
      ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.label, required this.icon, required this.isLoading});

  final String label;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final Widget? leading = isLoading
        ? Semantics(
            label: context.l10n.loadingLabel,
            child: const SizedBox.square(
              dimension: AppIconSize.sm,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        : icon == null
        ? null
        : Icon(icon, size: AppIconSize.md);

    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
    if (leading == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading,
        AppGap.sm,
        Flexible(child: text),
      ],
    );
  }
}
