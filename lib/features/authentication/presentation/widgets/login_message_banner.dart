import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';

/// Inline notice above the login form (demo hint or sign-in error).
class LoginMessageBanner extends StatelessWidget {
  const LoginMessageBanner.info({required this.message, super.key}) : _isError = false;

  const LoginMessageBanner.error({required this.message, super.key}) : _isError = true;

  final String message;
  final bool _isError;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, icon) = _isError
        ? (context.colors.errorContainer, context.colors.onErrorContainer, Icons.error_outline)
        : (context.appColors.infoContainer, context.appColors.onInfoContainer, Icons.info_outline);

    return Semantics(
      liveRegion: _isError,
      child: DecoratedBox(
        decoration: BoxDecoration(color: background, borderRadius: AppRadius.mdAll),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: AppIconSize.md, color: foreground),
              AppGap.sm,
              Expanded(
                child: Text(
                  message,
                  style: context.textStyles.bodyMedium?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
