import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';
import 'package:school_erp/features/academics/presentation/widgets/academics_styles.dart';

/// A file row with type icon, name and size; optionally removable.
class AttachmentTile extends StatelessWidget {
  const AttachmentTile({required this.attachment, this.onRemove, super.key});

  final HomeworkAttachment attachment;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final onRemove = this.onRemove;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: context.appColors.border),
          borderRadius: AppRadius.mdAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(
                attachment.kind.icon,
                size: AppIconSize.lg,
                color: context.appColors.onBrandTint,
              ),
              AppGap.md,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodyMedium,
                    ),
                    Text(
                      AppFormats.of(context).fileSize(attachment.sizeBytes),
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.appColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onRemove != null)
                IconButton(
                  tooltip: context.l10n.homeworkRemoveAttachment(attachment.name),
                  onPressed: onRemove,
                  icon: const Icon(Icons.close, size: AppIconSize.md),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
