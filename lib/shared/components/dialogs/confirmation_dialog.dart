import 'package:flutter/material.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';

/// Asks the user to confirm an action. Resolves to `true` only when confirmed.
Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  bool isDestructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton(
            label: l10n.actionCancel,
            variant: AppButtonVariant.text,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton(
            label: confirmLabel ?? l10n.actionConfirm,
            variant: isDestructive ? AppButtonVariant.destructive : AppButtonVariant.primary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
