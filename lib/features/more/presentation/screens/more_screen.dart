import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/authentication/presentation/controllers/login_controller.dart';
import 'package:school_erp/features/profile/presentation/providers/profile_providers.dart';
import 'package:school_erp/features/profile/presentation/widgets/student_text.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';
import 'package:school_erp/shared/components/content/app_avatar.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/dialogs/confirmation_dialog.dart';

/// Secondary destinations: profile, notices, settings and sign out.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmationDialog(
      context,
      title: l10n.signOutConfirmTitle,
      message: l10n.signOutConfirmMessage,
      confirmLabel: l10n.signOut,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(signOutControllerProvider.notifier).signOut();
    if (context.mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final student = ref.watch(currentStudentProvider).value;
    final isProduction = ref.watch(appFlavorProvider).environment.isProduction;
    final signOutState = ref.watch(signOutControllerProvider);
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
            children: [
              if (student != null)
                AppCard(
                  onTap: () => context.go(AppRoutes.profile),
                  child: Row(
                    children: [
                      AppAvatar(
                        name: student.name,
                        imageUrl: student.photoUrl,
                        size: AppSpacing.xxxl,
                      ),
                      AppGap.md,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(student.name, style: context.textStyles.titleMedium),
                            Text(
                              studentSubtitle(l10n, student),
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              AppGap.lg,
              _MenuGroup(
                items: [
                  _MenuItem(Icons.person_outline, l10n.moreProfile, AppRoutes.profile),
                  _MenuItem(
                    Icons.campaign_outlined,
                    l10n.moreNotices,
                    AppRoutes.notices,
                    push: true,
                  ),
                  _MenuItem(
                    Icons.settings_outlined,
                    l10n.moreSettings,
                    AppRoutes.settings,
                    subtitle: l10n.moreSettingsSubtitle,
                  ),
                ],
              ),
              if (!isProduction) ...[
                AppGap.xl,
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
                  child: Text(
                    l10n.moreDeveloperSection,
                    style: context.textStyles.labelLarge?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ),
                _MenuGroup(
                  items: [
                    _MenuItem(Icons.widgets_outlined, l10n.navComponents, AppRoutes.components),
                    _MenuItem(Icons.palette_outlined, l10n.designPreviewTitle, AppRoutes.design),
                  ],
                ),
              ],
              AppGap.xl,
              AppButton(
                label: l10n.signOut,
                icon: Icons.logout,
                variant: AppButtonVariant.secondary,
                expand: true,
                isLoading: signOutState.isLoading,
                onPressed: () => _confirmSignOut(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _MenuItem {
  const _MenuItem(this.icon, this.title, this.route, {this.subtitle, this.push = false});

  final IconData icon;
  final String title;
  final String route;
  final String? subtitle;

  /// Opens on top of the tabs instead of inside the "More" tab.
  final bool push;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const Divider(indent: AppSpacing.xxxl + AppSpacing.lg),
            ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              subtitle: item.subtitle == null ? null : Text(item.subtitle!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => item.push ? context.push(item.route) : context.go(item.route),
            ),
          ],
        ],
      ),
    );
  }
}
