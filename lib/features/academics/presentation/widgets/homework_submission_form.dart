import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/app/theme/theme_context.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';
import 'package:school_erp/features/academics/presentation/providers/academics_providers.dart';
import 'package:school_erp/features/academics/presentation/widgets/attachment_tile.dart';
import 'package:school_erp/shared/components/buttons/app_button.dart';
import 'package:school_erp/shared/components/content/app_section.dart';
import 'package:school_erp/shared/components/dialogs/confirmation_dialog.dart';
import 'package:school_erp/shared/components/inputs/app_text_field.dart';

/// Answer text, attachments and submit button for open homework.
class HomeworkSubmissionForm extends ConsumerStatefulWidget {
  const HomeworkSubmissionForm({required this.homeworkId, super.key});

  final String homeworkId;

  @override
  ConsumerState<HomeworkSubmissionForm> createState() => _HomeworkSubmissionFormState();
}

enum _AttachmentSource { camera, gallery, document }

class _HomeworkSubmissionFormState extends ConsumerState<HomeworkSubmissionForm> {
  final _answerController = TextEditingController();
  final _attachments = <HomeworkAttachment>[];
  String? _error;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _addAttachment() async {
    final l10n = context.l10n;
    // Otherwise focus returns to the answer field and reopens the keyboard.
    FocusManager.instance.primaryFocus?.unfocus();
    final source = await showModalBottomSheet<_AttachmentSource>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (source, icon, label) in [
              (
                _AttachmentSource.camera,
                Icons.photo_camera_outlined,
                l10n.homeworkAttachmentCamera,
              ),
              (
                _AttachmentSource.gallery,
                Icons.photo_library_outlined,
                l10n.homeworkAttachmentGallery,
              ),
              (
                _AttachmentSource.document,
                Icons.upload_file_outlined,
                l10n.homeworkAttachmentDocument,
              ),
            ])
              ListTile(
                leading: Icon(icon),
                title: Text(label),
                onTap: () => Navigator.of(context).pop(source),
              ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    // TODO(step-4): use image_picker / file_picker once uploads are backed by the API.
    final number = _attachments.length + 1;
    final sample = switch (source) {
      _AttachmentSource.camera => HomeworkAttachment(
        name: 'photo_$number.jpg',
        sizeBytes: 1240000,
        kind: AttachmentKind.image,
      ),
      _AttachmentSource.gallery => HomeworkAttachment(
        name: 'IMG_2026_$number.jpg',
        sizeBytes: 2110000,
        kind: AttachmentKind.image,
      ),
      _AttachmentSource.document => HomeworkAttachment(
        name: 'answer_sheet_$number.pdf',
        sizeBytes: 356000,
        kind: AttachmentKind.pdf,
      ),
    };
    setState(() {
      _attachments.add(sample);
      _error = null;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.homeworkAttachmentDemoNote)));
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_answerController.text.trim().isEmpty && _attachments.isEmpty) {
      setState(() => _error = l10n.homeworkSubmitNeedsContent);
      return;
    }
    final confirmed = await showConfirmationDialog(
      context,
      title: l10n.homeworkSubmitConfirmTitle,
      message: l10n.homeworkSubmitConfirmMessage,
      confirmLabel: l10n.homeworkSubmit,
    );
    if (!confirmed || !mounted) return;

    // The form is replaced by the submission once saved, so capture the messenger first.
    final messenger = ScaffoldMessenger.of(context);
    final submitted = await ref
        .read(homeworkSubmitControllerProvider.notifier)
        .submit(
          widget.homeworkId,
          answer: _answerController.text,
          attachments: List.of(_attachments),
        );
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(submitted ? l10n.homeworkSubmitted : l10n.errorGenericMessage)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSubmitting = ref.watch(homeworkSubmitControllerProvider).isLoading;
    final error = _error;

    return AppSection(
      title: l10n.homeworkYourSubmission,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: l10n.homeworkAnswerLabel,
            hint: l10n.homeworkAnswerHint,
            controller: _answerController,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 8,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          AppGap.md,
          for (final (index, file) in _attachments.indexed)
            AttachmentTile(
              attachment: file,
              onRemove: () => setState(() => _attachments.removeAt(index)),
            ),
          AppButton(
            label: l10n.homeworkAddAttachment,
            icon: Icons.attach_file,
            variant: AppButtonVariant.secondary,
            onPressed: isSubmitting ? null : () => unawaited(_addAttachment()),
          ),
          if (error != null) ...[
            AppGap.sm,
            Semantics(
              liveRegion: true,
              child: Text(
                error,
                style: context.textStyles.bodySmall?.copyWith(color: context.colors.error),
              ),
            ),
          ],
          AppGap.lg,
          AppButton(
            label: l10n.homeworkSubmit,
            icon: Icons.send_outlined,
            expand: true,
            isLoading: isSubmitting,
            onPressed: () => unawaited(_submit()),
          ),
        ],
      ),
    );
  }
}
