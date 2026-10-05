import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/academics/data/repositories/mock_homework_repository.dart';
import 'package:school_erp/features/academics/data/repositories/mock_results_repository.dart';
import 'package:school_erp/features/academics/data/repositories/mock_timetable_repository.dart';
import 'package:school_erp/features/academics/domain/entities/class_period.dart';
import 'package:school_erp/features/academics/domain/entities/exam_result.dart';
import 'package:school_erp/features/academics/domain/entities/homework.dart';
import 'package:school_erp/features/academics/domain/repositories/academics_repositories.dart';

// TODO(step-4): replace the mock repositories with API-backed ones.
final timetableRepositoryProvider = Provider<TimetableRepository>(
  (ref) => const MockTimetableRepository(),
);

final homeworkRepositoryProvider = Provider<HomeworkRepository>(
  (ref) => MockHomeworkRepository(clock: ref.watch(clockProvider)),
);

final resultsRepositoryProvider = Provider<ResultsRepository>(
  (ref) => const MockResultsRepository(),
);

// ---------------------------------------------------------------------------
// Timetable
// ---------------------------------------------------------------------------

/// The school days (Monday–Saturday) of the week shown in the timetable.
/// On Sunday this is the coming week.
final timetableWeekProvider = Provider.autoDispose<List<DateTime>>((ref) {
  final today = ref.watch(clockProvider)().dateOnly;
  final monday = today.weekday == DateTime.sunday
      ? today.add(const Duration(days: 1))
      : today.subtract(Duration(days: today.weekday - 1));
  return [for (var i = 0; i < 6; i++) monday.add(Duration(days: i))];
});

final selectedTimetableDayProvider =
    NotifierProvider.autoDispose<SelectedTimetableDayController, DateTime>(
      SelectedTimetableDayController.new,
    );

class SelectedTimetableDayController extends Notifier<DateTime> {
  @override
  DateTime build() {
    final today = ref.watch(clockProvider)().dateOnly;
    final week = ref.watch(timetableWeekProvider);
    return week.firstWhere((day) => day == today, orElse: () => week.first);
  }

  void select(DateTime day) => state = day.dateOnly;
}

final timetableDayProvider = FutureProvider.autoDispose.family<List<ClassPeriod>, DateTime>(
  (ref, day) => ref.watch(timetableRepositoryProvider).getDay(day),
);

// ---------------------------------------------------------------------------
// Homework
// ---------------------------------------------------------------------------

enum HomeworkFilter { open, submitted, all }

final homeworkFilterProvider =
    NotifierProvider.autoDispose<HomeworkFilterController, HomeworkFilter>(
      HomeworkFilterController.new,
    );

class HomeworkFilterController extends Notifier<HomeworkFilter> {
  @override
  HomeworkFilter build() => HomeworkFilter.open;

  void select(HomeworkFilter filter) => state = filter;
}

final homeworkListProvider = FutureProvider.autoDispose<List<Homework>>(
  (ref) => ref.watch(homeworkRepositoryProvider).getAll(),
);

/// Homework matching the selected filter, in the order students need it:
/// open items by due date (overdue first), submitted items newest first.
final filteredHomeworkProvider = Provider.autoDispose<AsyncValue<List<Homework>>>((ref) {
  final filter = ref.watch(homeworkFilterProvider);
  final today = ref.watch(clockProvider)();
  return ref.watch(homeworkListProvider).whenData((items) {
    bool matches(Homework item) => switch (filter) {
      HomeworkFilter.open => item.statusOn(today).isOpen,
      HomeworkFilter.submitted => !item.statusOn(today).isOpen,
      HomeworkFilter.all => true,
    };
    return items.where(matches).toList()..sort((a, b) {
      final aOpen = a.statusOn(today).isOpen;
      final bOpen = b.statusOn(today).isOpen;
      if (aOpen != bOpen) return aOpen ? -1 : 1;
      return aOpen ? a.dueDate.compareTo(b.dueDate) : b.dueDate.compareTo(a.dueDate);
    });
  });
});

final homeworkByIdProvider = FutureProvider.autoDispose.family<Homework, String>(
  (ref, id) => ref.watch(homeworkRepositoryProvider).getById(id),
);

final homeworkSubmitControllerProvider =
    NotifierProvider.autoDispose<HomeworkSubmitController, AsyncValue<void>>(
      HomeworkSubmitController.new,
    );

class HomeworkSubmitController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Submits the work; returns `true` on success.
  Future<bool> submit(
    String homeworkId, {
    required String answer,
    required List<HomeworkAttachment> attachments,
  }) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final trimmed = answer.trim();
    state = await AsyncValue.guard(
      () => ref
          .read(homeworkRepositoryProvider)
          .submit(homeworkId, answer: trimmed.isEmpty ? null : trimmed, attachments: attachments),
    );
    if (!ref.mounted) return false;
    ref
      ..invalidate(homeworkListProvider)
      ..invalidate(homeworkByIdProvider(homeworkId));
    return !state.hasError;
  }
}

// ---------------------------------------------------------------------------
// Results
// ---------------------------------------------------------------------------

final examsProvider = FutureProvider.autoDispose<List<ExamSummary>>(
  (ref) => ref.watch(resultsRepositoryProvider).getExams(),
);

final reportCardProvider = FutureProvider.autoDispose.family<ReportCard, String>(
  (ref, examId) => ref.watch(resultsRepositoryProvider).getReportCard(examId),
);
