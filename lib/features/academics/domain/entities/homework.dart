/// Where a homework item stands for the student.
enum HomeworkStatus {
  /// Not submitted and the due date has not passed.
  pending,

  /// Not submitted and the due date has passed.
  overdue,

  /// Submitted, waiting for the teacher.
  submitted,

  /// Checked by the teacher (feedback and/or marks available).
  reviewed;

  bool get isOpen => this == pending || this == overdue;
}

enum AttachmentKind { image, pdf, document }

final class HomeworkAttachment {
  const HomeworkAttachment({required this.name, required this.sizeBytes, required this.kind});

  final String name;
  final int sizeBytes;
  final AttachmentKind kind;
}

final class HomeworkSubmission {
  const HomeworkSubmission({
    required this.submittedAt,
    this.answer,
    this.attachments = const [],
    this.feedback,
    this.marksObtained,
    this.maxMarks,
  });

  final DateTime submittedAt;
  final String? answer;
  final List<HomeworkAttachment> attachments;

  /// Teacher's comment after review.
  final String? feedback;
  final double? marksObtained;
  final double? maxMarks;
}

final class Homework {
  const Homework({
    required this.id,
    required this.subject,
    required this.title,
    required this.instructions,
    required this.teacher,
    required this.assignedOn,
    required this.dueDate,
    this.attachments = const [],
    this.submission,
  });

  final String id;
  final String subject;
  final String title;
  final String instructions;
  final String teacher;
  final DateTime assignedOn;

  /// Last day to submit (date only).
  final DateTime dueDate;

  /// Files attached by the teacher.
  final List<HomeworkAttachment> attachments;
  final HomeworkSubmission? submission;

  HomeworkStatus statusOn(DateTime today) {
    final submission = this.submission;
    if (submission != null) {
      return submission.feedback != null || submission.marksObtained != null
          ? HomeworkStatus.reviewed
          : HomeworkStatus.submitted;
    }
    final day = DateTime(today.year, today.month, today.day);
    return day.isAfter(dueDate) ? HomeworkStatus.overdue : HomeworkStatus.pending;
  }
}
