import 'package:flutter/material.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';
import 'package:school_erp/shared/components/content/status_chip.dart';

extension HomeworkStatusStyle on HomeworkStatus {
  String label(AppLocalizations l10n) => switch (this) {
    HomeworkStatus.pending => l10n.homeworkStatusPending,
    HomeworkStatus.overdue => l10n.homeworkStatusOverdue,
    HomeworkStatus.submitted => l10n.homeworkStatusSubmitted,
    HomeworkStatus.reviewed => l10n.homeworkStatusReviewed,
  };

  StatusTone get tone => switch (this) {
    HomeworkStatus.pending => StatusTone.warning,
    HomeworkStatus.overdue => StatusTone.error,
    HomeworkStatus.submitted => StatusTone.info,
    HomeworkStatus.reviewed => StatusTone.success,
  };
}

extension AttachmentKindStyle on AttachmentKind {
  IconData get icon => switch (this) {
    AttachmentKind.image => Icons.image_outlined,
    AttachmentKind.pdf => Icons.picture_as_pdf_outlined,
    AttachmentKind.document => Icons.description_outlined,
  };
}

/// Tone for a grade on the CBSE-style scale (A1 … E). Unknown grades are neutral.
StatusTone gradeTone(String grade) => switch (grade.toUpperCase()) {
  final g when g.startsWith('A') => StatusTone.success,
  final g when g.startsWith('B') => StatusTone.info,
  final g when g.startsWith('C') => StatusTone.warning,
  'D' || 'E' || 'F' => StatusTone.error,
  _ => StatusTone.neutral,
};
