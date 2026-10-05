import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/content/app_card.dart';

/// One labelled value. Rows without a value are not shown.
final class ProfileDetail {
  const ProfileDetail(this.label, this.value, {this.copyable = false});

  final String label;
  final String? value;

  /// Shows a copy button (IDs and phone numbers).
  final bool copyable;

  bool get hasValue => value != null && value!.trim().isNotEmpty;
}

/// A card of related details with an icon header.
class ProfileDetailSection extends StatelessWidget {
  const ProfileDetailSection({
    required this.title,
    required this.icon,
    required this.rows,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<ProfileDetail> rows;

  bool get hasContent => rows.any((row) => row.hasValue);

  @override
  Widget build(BuildContext context) {
    final visible = rows.where((row) => row.hasValue).toList();
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColors.brandTint,
                  borderRadius: AppRadius.smAll,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Icon(icon, size: AppIconSize.md, color: context.appColors.onBrandTint),
                ),
              ),
              AppGap.md,
              Semantics(
                header: true,
                child: Text(title, style: context.textStyles.titleMedium),
              ),
            ],
          ),
          AppGap.sm,
          for (final (index, row) in visible.indexed) ...[
            if (index > 0) const Divider(indent: AppSpacing.xxxl - AppSpacing.sm),
            _DetailRow(detail: row),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.detail});

  final ProfileDetail detail;

  void _copy(BuildContext context) {
    final l10n = context.l10n;
    unawaited(Clipboard.setData(ClipboardData(text: detail.value!)));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.profileCopied(detail.label))));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxxl - AppSpacing.sm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.xxxl),
        child: Row(
          children: [
            Expanded(
              child: MergeSemantics(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.label,
                        style: context.textStyles.labelMedium?.copyWith(
                          color: context.appColors.textTertiary,
                        ),
                      ),
                      AppGap.xxs,
                      Text(detail.value!, style: context.textStyles.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
            if (detail.copyable)
              IconButton(
                tooltip: context.l10n.profileCopy(detail.label),
                onPressed: () => _copy(context),
                icon: Icon(
                  Icons.copy_rounded,
                  size: AppIconSize.md,
                  color: context.appColors.textTertiary,
                ),
              )
            else
              AppGap.sm,
          ],
        ),
      ),
    );
  }
}
