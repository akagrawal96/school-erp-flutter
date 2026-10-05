import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_icon_sizes.dart';
import 'package:school_erp/app/theme/app_radius.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';

/// A notice in the list: cover image, title, a preview of the text and what is attached.
class NoticeCard extends StatelessWidget {
  const NoticeCard({required this.notice, super.key});

  final Notice notice;

  static const double _coverAspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    final cover = notice.coverImageUrl;
    final muted = context.appColors.textTertiary;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.notice(notice.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (cover != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              child: AspectRatio(
                aspectRatio: _coverAspectRatio,
                child: NoticeImage(url: cover),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NoticeIcon(isHoliday: notice.isHoliday),
                AppGap.md,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.titleSmall,
                      ),
                      if (notice.body.isNotEmpty) ...[
                        AppGap.xxs,
                        Text(
                          notice.body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      ],
                      AppGap.sm,
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            formats.date(notice.postedOn),
                            style: context.textStyles.labelMedium?.copyWith(color: muted),
                          ),
                          if (notice.isHoliday)
                            StatusChip(label: l10n.noticeHoliday, tone: StatusTone.success),
                          if (notice.attachmentUrl != null)
                            Icon(
                              Icons.attach_file_rounded,
                              size: AppIconSize.sm,
                              color: muted,
                              semanticLabel: l10n.noticeAttachment,
                            ),
                          if (notice.videoUrl != null)
                            Icon(
                              Icons.play_circle_outline_rounded,
                              size: AppIconSize.sm,
                              color: muted,
                              semanticLabel: l10n.noticeVideo,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Megaphone for notices, calendar for holidays.
class NoticeIcon extends StatelessWidget {
  const NoticeIcon({required this.isHoliday, super.key});

  final bool isHoliday;

  @override
  Widget build(BuildContext context) {
    final app = context.appColors;
    final (background, foreground) = isHoliday
        ? (app.successContainer, app.onSuccessContainer)
        : (app.infoContainer, app.onInfoContainer);
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(color: background, borderRadius: AppRadius.mdAll),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            isHoliday ? Icons.event_available_outlined : Icons.campaign_outlined,
            size: AppIconSize.md,
            color: foreground,
          ),
        ),
      ),
    );
  }
}

/// A notice image from the server; a plain placeholder if it cannot load.
class NoticeImage extends StatelessWidget {
  const NoticeImage({required this.url, super.key});

  final Uri url;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: context.colors.surfaceContainerHigh,
      child: Icon(Icons.image_outlined, color: context.appColors.textTertiary),
    );
    return Image.network(
      url.toString(),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
      loadingBuilder: (_, child, progress) => progress == null ? child : placeholder,
    );
  }
}
