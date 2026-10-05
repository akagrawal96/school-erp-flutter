import 'package:school_erp/features/academics/domain/entities/exam_result.dart';
import 'package:school_erp/features/academics/domain/repositories/academics_repositories.dart';

/// Sample exam results for UI design until the results API exists.
///
/// Grades follow the CBSE 8-point scale; real grades come from the institution.
final class MockResultsRepository implements ResultsRepository {
  const MockResultsRepository({this.latency = const Duration(milliseconds: 500)});

  final Duration latency;

  static const _passPercentage = 33.0;

  /// (subject, max marks, marks obtained) per exam.
  static const _marks = {
    'half-yearly': [
      ('English', 80.0, 68.0),
      ('Hindi', 80.0, 71.0),
      ('Mathematics', 80.0, 74.0),
      ('Science', 80.0, 65.0),
      ('Social Science', 80.0, 62.0),
      ('Sanskrit', 80.0, 70.0),
      ('Computer', 50.0, 46.0),
    ],
    'unit-test-1': [
      ('English', 25.0, 21.0),
      ('Hindi', 25.0, 22.0),
      ('Mathematics', 25.0, 24.0),
      ('Science', 25.0, 19.0),
      ('Social Science', 25.0, 20.0),
    ],
  };

  static final _exams = {
    'half-yearly': ('Half-Yearly Examination', DateTime(2026, 9, 12), 4, 42),
    'unit-test-1': ('Unit Test 1', DateTime(2026, 7, 20), 7, 42),
  };

  static const _remarks = {
    'half-yearly':
        'Aarav is attentive in class and performs well in Mathematics. '
        'Needs more practice in Social Science map work.',
    'unit-test-1': 'Good start to the session. Keep it up!',
  };

  static String _grade(double percentage) => switch (percentage) {
    > 90 => 'A1',
    > 80 => 'A2',
    > 70 => 'B1',
    > 60 => 'B2',
    > 50 => 'C1',
    > 40 => 'C2',
    >= 33 => 'D',
    _ => 'E',
  };

  static ReportCard _card(String id) {
    final (name, publishedOn, rank, classSize) = _exams[id]!;
    final subjects = [
      for (final (subject, max, obtained) in _marks[id]!)
        SubjectResult(
          subject: subject,
          marksObtained: obtained,
          maxMarks: max,
          grade: _grade(obtained / max * 100),
        ),
    ];
    final obtained = subjects.fold<double>(0, (sum, s) => sum + s.marksObtained);
    final max = subjects.fold<double>(0, (sum, s) => sum + s.maxMarks);
    final percentage = obtained / max * 100;
    return ReportCard(
      exam: ExamSummary(
        id: id,
        name: name,
        publishedOn: publishedOn,
        percentage: percentage,
        grade: _grade(percentage),
        passed: percentage >= _passPercentage,
      ),
      subjects: subjects,
      rank: rank,
      classSize: classSize,
      remark: _remarks[id],
    );
  }

  @override
  Future<List<ExamSummary>> getExams() async {
    await Future<void>.delayed(latency);
    return [for (final id in _exams.keys) _card(id).exam];
  }

  @override
  Future<ReportCard> getReportCard(String examId) async {
    await Future<void>.delayed(latency);
    return _card(examId);
  }
}
