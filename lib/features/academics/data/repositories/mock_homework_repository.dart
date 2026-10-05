import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';
import 'package:school_erp/features/academics/domain/repositories/academics_repositories.dart';

/// Sample homework for UI design until the homework API exists.
///
/// Keeps submissions in memory so the submit flow can be tried end to end.
final class MockHomeworkRepository implements HomeworkRepository {
  MockHomeworkRepository({required Clock clock, this.latency = const Duration(milliseconds: 500)})
    : _items = _seed(clock().dateOnly),
      _clock = clock;

  final Duration latency;
  final Clock _clock;
  final List<Homework> _items;

  static List<Homework> _seed(DateTime today) {
    DateTime days(int offset) => today.add(Duration(days: offset));
    return [
      Homework(
        id: 'hw-math',
        subject: 'Mathematics',
        title: 'Exercise 5.2 — Linear equations (Q1 to Q10)',
        instructions:
            'Solve questions 1 to 10 in your notebook. Show all steps. '
            'Take a clear photo of each page and upload it.',
        teacher: 'Mrs. Kavita Rao',
        assignedOn: days(-2),
        dueDate: days(1),
        attachments: const [
          HomeworkAttachment(name: 'Exercise_5.2.pdf', sizeBytes: 248000, kind: AttachmentKind.pdf),
        ],
      ),
      Homework(
        id: 'hw-science',
        subject: 'Science',
        title: 'Draw and label the human digestive system',
        instructions: 'Use an A4 sheet. Label at least 8 parts and colour the diagram.',
        teacher: 'Dr. Meera Iyer',
        assignedOn: days(-1),
        dueDate: days(3),
      ),
      Homework(
        id: 'hw-english',
        subject: 'English',
        title: 'Letter to the editor on plastic pollution',
        instructions:
            'Write a formal letter (120–150 words) to the editor of a newspaper '
            'about the effects of single-use plastic in your city.',
        teacher: 'Mr. Daniel Thomas',
        assignedOn: days(-1),
        dueDate: days(5),
      ),
      Homework(
        id: 'hw-hindi',
        subject: 'Hindi',
        title: "कविता याद करें — 'पुष्प की अभिलाषा'",
        instructions: 'कविता याद करें और अपनी आवाज़ में रिकॉर्ड करके भेजें।',
        teacher: 'Mrs. Sunita Sharma',
        assignedOn: days(-5),
        dueDate: days(-1),
      ),
      Homework(
        id: 'hw-sst',
        subject: 'Social Science',
        title: 'Map work — major rivers of India',
        instructions: 'Mark the major rivers on the outline map given in class.',
        teacher: 'Mr. Arjun Singh',
        assignedOn: days(-6),
        dueDate: days(-2),
        submission: HomeworkSubmission(
          submittedAt: days(-3).add(const Duration(hours: 19)),
          attachments: const [
            HomeworkAttachment(
              name: 'rivers_map.jpg',
              sizeBytes: 1830000,
              kind: AttachmentKind.image,
            ),
          ],
        ),
      ),
      Homework(
        id: 'hw-computer',
        subject: 'Computer',
        title: 'Scratch project — animated greeting card',
        instructions: 'Create an animated greeting card in Scratch and upload the .sb3 file.',
        teacher: 'Ms. Priya Nair',
        assignedOn: days(-12),
        dueDate: days(-7),
        submission: HomeworkSubmission(
          submittedAt: days(-8).add(const Duration(hours: 18)),
          answer: 'I made a Diwali card with moving diyas and fireworks.',
          attachments: const [
            HomeworkAttachment(
              name: 'diwali_card.sb3',
              sizeBytes: 512000,
              kind: AttachmentKind.document,
            ),
          ],
          feedback: 'Good work! Try adding comments to explain each script.',
          marksObtained: 9,
          maxMarks: 10,
        ),
      ),
    ];
  }

  @override
  Future<List<Homework>> getAll() async {
    await Future<void>.delayed(latency);
    return List.unmodifiable(_items);
  }

  @override
  Future<Homework> getById(String id) async {
    await Future<void>.delayed(latency);
    return _items.firstWhere((item) => item.id == id);
  }

  @override
  Future<Homework> submit(
    String id, {
    required String? answer,
    required List<HomeworkAttachment> attachments,
  }) async {
    await Future<void>.delayed(latency);
    final index = _items.indexWhere((item) => item.id == id);
    final item = _items[index];
    final updated = Homework(
      id: item.id,
      subject: item.subject,
      title: item.title,
      instructions: item.instructions,
      teacher: item.teacher,
      assignedOn: item.assignedOn,
      dueDate: item.dueDate,
      attachments: item.attachments,
      submission: HomeworkSubmission(
        submittedAt: _clock(),
        answer: answer,
        attachments: attachments,
      ),
    );
    _items[index] = updated;
    return updated;
  }
}
