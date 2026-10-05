import 'package:school_erp/features/academics/domain/entities/class_period.dart';
import 'package:school_erp/features/academics/domain/entities/exam_result.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';

abstract interface class TimetableRepository {
  /// Periods on [date] in order; empty on holidays and Sundays.
  Future<List<ClassPeriod>> getDay(DateTime date);
}

abstract interface class HomeworkRepository {
  /// Homework of the current term, newest due date first.
  Future<List<Homework>> getAll();

  Future<Homework> getById(String id);

  /// Submits the student's work. Returns the updated homework.
  Future<Homework> submit(
    String id, {
    required String? answer,
    required List<HomeworkAttachment> attachments,
  });
}

abstract interface class ResultsRepository {
  /// Published exams, most recent first.
  Future<List<ExamSummary>> getExams();

  Future<ReportCard> getReportCard(String examId);
}
