import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/features/academics/data/repositories/mock_homework_repository.dart';
import 'package:school_erp/features/academics/data/repositories/mock_results_repository.dart';
import 'package:school_erp/features/academics/data/repositories/mock_timetable_repository.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';

void main() {
  final today = DateTime(2026, 10, 14);

  group('Homework.statusOn', () {
    Homework homework({required DateTime due, HomeworkSubmission? submission}) => Homework(
      id: 'x',
      subject: 'Maths',
      title: 't',
      instructions: 'i',
      teacher: 'T',
      assignedOn: DateTime(2026, 10),
      dueDate: due,
      submission: submission,
    );

    test('open homework is pending until the due date passes', () {
      expect(homework(due: today).statusOn(today), HomeworkStatus.pending);
      expect(
        homework(due: today).statusOn(today.add(const Duration(hours: 20))),
        HomeworkStatus.pending,
        reason: 'still due on the same day',
      );
      expect(homework(due: DateTime(2026, 10, 13)).statusOn(today), HomeworkStatus.overdue);
    });

    test('submission without feedback is submitted; with feedback or marks it is reviewed', () {
      expect(
        homework(
          due: today,
          submission: HomeworkSubmission(submittedAt: today),
        ).statusOn(today),
        HomeworkStatus.submitted,
      );
      expect(
        homework(
          due: today,
          submission: HomeworkSubmission(submittedAt: today, marksObtained: 8),
        ).statusOn(today),
        HomeworkStatus.reviewed,
      );
    });
  });

  test('mock homework submission is kept and changes the status', () async {
    final repository = MockHomeworkRepository(clock: () => today, latency: Duration.zero);
    final before = await repository.getById('hw-math');
    expect(before.statusOn(today), HomeworkStatus.pending);

    await repository.submit(
      'hw-math',
      answer: 'Done',
      attachments: const [
        HomeworkAttachment(name: 'p.jpg', sizeBytes: 1, kind: AttachmentKind.image),
      ],
    );

    final after = await repository.getById('hw-math');
    expect(after.statusOn(today), HomeworkStatus.submitted);
    expect(after.submission!.answer, 'Done');
    expect(after.submission!.attachments, hasLength(1));
  });

  test('report card totals and CBSE grades', () async {
    const repository = MockResultsRepository(latency: Duration.zero);
    final exams = await repository.getExams();
    expect(exams.first.name, 'Half-Yearly Examination');

    final card = await repository.getReportCard('half-yearly');
    expect(card.totalMax, 530);
    expect(card.totalObtained, 456);
    expect(card.exam.percentage, closeTo(86.04, 0.01));
    expect(card.exam.grade, 'A2');
    expect(card.subjects.firstWhere((s) => s.subject == 'Computer').grade, 'A1');
    expect(card.exam.passed, isTrue);
  });

  test('timetable has six periods with a break after the third, none on Sunday', () async {
    const repository = MockTimetableRepository(latency: Duration.zero);

    final wednesday = await repository.getDay(today);
    expect(wednesday, hasLength(6));
    expect(wednesday[2].end, DateTime(2026, 10, 14, 10));
    expect(wednesday[3].start, DateTime(2026, 10, 14, 10, 20));
    expect(wednesday[2].isOngoing(DateTime(2026, 10, 14, 9, 30)), isTrue);

    expect(await repository.getDay(DateTime(2026, 10, 18)), isEmpty);
  });
}
