import 'package:flutter/material.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';
import 'package:school_erp/shared/components/content/app_avatar.dart';
import 'package:school_erp/shared/components/content/app_card.dart';
import 'package:school_erp/shared/components/content/app_section.dart';
import 'package:school_erp/shared/components/content/stat_card.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';
import 'package:school_erp/shared/components/dialogs/confirmation_dialog.dart';
import 'package:school_erp/shared/components/inputs/app_password_field.dart';
import 'package:school_erp/shared/components/inputs/app_text_field.dart';
import 'package:school_erp/shared/states/loading_view.dart';
import 'package:school_erp/shared/states/skeleton.dart';
import 'package:school_erp/shared/states/state_view.dart';

class ButtonsGallerySection extends StatefulWidget {
  const ButtonsGallerySection({super.key});

  @override
  State<ButtonsGallerySection> createState() => _ButtonsGallerySectionState();
}

class _ButtonsGallerySectionState extends State<ButtonsGallerySection> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppSection(
      title: l10n.galleryButtons,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: l10n.galleryPrimary,
            isLoading: _loading,
            expand: true,
            onPressed: () {},
          ),
          AppGap.sm,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.gallerySecondary,
                  icon: Icons.download_outlined,
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                ),
              ),
              AppGap.sm,
              AppButton(label: l10n.galleryText, variant: AppButtonVariant.text, onPressed: () {}),
            ],
          ),
          AppGap.sm,
          AppButton(
            label: l10n.galleryDestructive,
            icon: Icons.delete_outline,
            variant: AppButtonVariant.destructive,
            onPressed: () {},
          ),
          AppGap.sm,
          AppButton(label: l10n.galleryDisabled, onPressed: null),
          AppGap.xs,
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.galleryToggleLoading),
            value: _loading,
            onChanged: (value) => setState(() => _loading = value),
          ),
        ],
      ),
    );
  }
}

class InputsGallerySection extends StatelessWidget {
  const InputsGallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppSection(
      title: l10n.galleryInputs,
      child: Column(
        children: [
          AppTextField(
            label: l10n.sampleFieldLabel,
            hint: l10n.sampleFieldHint,
            prefixIcon: Icons.person_outline,
          ),
          AppGap.lg,
          AppTextField(label: l10n.loginIdLabel, errorText: l10n.galleryFieldErrorExample),
          AppGap.lg,
          AppPasswordField(label: l10n.passwordLabel),
        ],
      ),
    );
  }
}

class ContentGallerySection extends StatelessWidget {
  const ContentGallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppSection(
      title: l10n.galleryContent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusChip(label: l10n.statusPaid, tone: StatusTone.success),
              StatusChip(label: l10n.statusDue, tone: StatusTone.warning),
              StatusChip(label: l10n.statusOverdue, tone: StatusTone.error),
              StatusChip(label: l10n.statusNew, tone: StatusTone.info),
              StatusChip(label: l10n.galleryDisabled),
            ],
          ),
          AppGap.lg,
          Row(
            children: [
              AppAvatar(name: l10n.gallerySampleName),
              AppGap.md,
              Expanded(child: Text(l10n.gallerySampleName)),
            ],
          ),
          AppGap.lg,
          StatCard(
            label: l10n.galleryStatLabel,
            value: '92%',
            icon: Icons.fact_check_outlined,
            supportingText: l10n.galleryStatSupporting,
          ),
          AppGap.sm,
          AppCard(
            onTap: () {},
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.galleryCardTitle),
              subtitle: Text(l10n.galleryCardBody),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}

class StatesGallerySection extends StatelessWidget {
  const StatesGallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppSection(
      title: l10n.galleryStates,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SkeletonList(),
          const Divider(),
          const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: LoadingView()),
          const Divider(),
          EmptyStateView(
            title: l10n.galleryEmptyTitle,
            message: l10n.galleryEmptyMessage,
            actionLabel: l10n.galleryAddRecord,
            onAction: () {},
          ),
          const Divider(),
          ErrorStateView(onRetry: () {}),
          const Divider(),
          OfflineStateView(onRetry: () {}),
        ],
      ),
    );
  }
}

class DialogsGallerySection extends StatelessWidget {
  const DialogsGallerySection({super.key});

  Future<void> _showDialog(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmationDialog(
      context,
      title: l10n.galleryDialogTitle,
      message: l10n.galleryDialogMessage,
      confirmLabel: l10n.galleryDestructive,
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.galleryDeleted)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppSection(
      title: l10n.galleryDialogs,
      child: AppButton(
        label: l10n.galleryShowDialog,
        variant: AppButtonVariant.secondary,
        onPressed: () => _showDialog(context),
      ),
    );
  }
}
