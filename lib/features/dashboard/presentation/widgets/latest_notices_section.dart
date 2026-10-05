import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/notices/domain/entities/notice.dart';
import 'package:school_erp/features/notices/presentation/widgets/notice_card.dart';
import 'package:school_erp/shared/components/content/app_section.dart';

class LatestNoticesSection extends StatelessWidget {
  const LatestNoticesSection({required this.notices, super.key});

  final List<Notice> notices;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formats = AppFormats.of(context);
    if (notices.isEmpty) return const SizedBox.shrink();

    return AppSection(
      title: l10n.latestNoticesTitle,
      action: TextButton(
        onPressed: () => context.push(AppRoutes.notices),
        child: Text(l10n.viewAll),
      ),
      child: Column(
        children: [
          for (final notice in notices)
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => context.push(AppRoutes.notice(notice.id)),
              leading: NoticeIcon(isHoliday: notice.isHoliday),
              title: Text(notice.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(formats.dayMonth(notice.postedOn)),
            ),
        ],
      ),
    );
  }
}
