import 'package:flutter/material.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/academics/presentation/widgets/homework_list_view.dart';
import 'package:school_erp/features/academics/presentation/widgets/results_list_view.dart';
import 'package:school_erp/features/academics/presentation/widgets/timetable_view.dart';

/// Tabs of the Academics section. The name is used in the `?tab=` route parameter.
enum AcademicsTab { timetable, homework, results }

class AcademicsScreen extends StatelessWidget {
  const AcademicsScreen({this.initialTab = AcademicsTab.timetable, super.key});

  final AcademicsTab initialTab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      // Re-create the controller when a link asks for a different tab.
      key: ValueKey(initialTab),
      length: AcademicsTab.values.length,
      initialIndex: initialTab.index,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navAcademics),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.quickTimetable),
              Tab(text: l10n.quickHomework),
              Tab(text: l10n.quickResults),
            ],
          ),
        ),
        body: const TabBarView(
          children: [TimetableView(), HomeworkListView(), ResultsListView()],
        ),
      ),
    );
  }
}
