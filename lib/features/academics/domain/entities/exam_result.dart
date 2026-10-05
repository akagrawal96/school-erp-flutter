/// An exam whose results have been published.
final class ExamSummary {
  const ExamSummary({
    required this.id,
    required this.name,
    required this.publishedOn,
    required this.percentage,
    required this.grade,
    required this.passed,
  });

  final String id;

  /// e.g. "Half-Yearly Examination".
  final String name;
  final DateTime publishedOn;
  final double percentage;

  /// Overall grade as defined by the institution's grading scheme, e.g. "A2".
  final String grade;
  final bool passed;
}

final class SubjectResult {
  const SubjectResult({
    required this.subject,
    required this.marksObtained,
    required this.maxMarks,
    required this.grade,
  });

  final String subject;
  final double marksObtained;
  final double maxMarks;
  final String grade;

  double get percentage => maxMarks == 0 ? 0 : marksObtained / maxMarks * 100;
}

/// Full result of one exam.
final class ReportCard {
  const ReportCard({
    required this.exam,
    required this.subjects,
    this.rank,
    this.classSize,
    this.remark,
  });

  final ExamSummary exam;
  final List<SubjectResult> subjects;
  final int? rank;
  final int? classSize;

  /// Class teacher's remark.
  final String? remark;

  double get totalObtained => subjects.fold(0, (sum, s) => sum + s.marksObtained);

  double get totalMax => subjects.fold(0, (sum, s) => sum + s.maxMarks);
}
