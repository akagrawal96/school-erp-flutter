import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/features/academics/presentation/screens/academics_screen.dart';

import '../../helpers/test_app.dart';

void main() {
  Future<void> useTallPhone(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('timetable shows the week and highlights the ongoing period', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.academics);

    expect(find.text('Wednesday, 14 October 2026'), findsOneWidget);
    expect(find.text('Now'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Saturday, 17 October 2026'));
    await tester.pumpAndSettle();

    expect(find.text('Saturday, 17 October 2026'), findsOneWidget);
    expect(find.text('Club Activity'), findsOneWidget);
    expect(find.text('Now'), findsNothing);
  });

  testWidgets('homework filters show open and submitted work', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.academicsTab(AcademicsTab.homework.name));

    expect(find.text('Exercise 5.2 — Linear equations (Q1 to Q10)'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('Due tomorrow'), findsOneWidget);
    expect(find.text('Map work — major rivers of India'), findsNothing);

    await tester.tap(find.text('Submitted').first);
    await tester.pumpAndSettle();

    expect(find.text('Map work — major rivers of India'), findsOneWidget);
    expect(find.text('Reviewed'), findsOneWidget);
  });

  testWidgets('homework can be submitted with a file', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.homeworkDetail('hw-science'));

    await tester.tap(find.widgetWithText(FilledButton, 'Submit homework'));
    await tester.pumpAndSettle();
    expect(find.text('Add an answer or at least one file.'), findsOneWidget);

    await tester.tap(find.text('Add photo or file'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take photo'));
    await tester.pumpAndSettle();
    expect(find.text('photo_1.jpg'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Submit homework'));
    await tester.pumpAndSettle();
    expect(find.text('Submit homework?'), findsOneWidget);
    await tester.tap(
      find.descendant(of: find.byType(AlertDialog), matching: find.text('Submit homework')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Homework submitted'), findsOneWidget);
    expect(find.textContaining('Submitted 14 Oct'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Submit homework'), findsNothing);
  });

  testWidgets('results open a report card with marks and grades', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.academicsTab(AcademicsTab.results.name));

    expect(find.text('Half-Yearly Examination'), findsOneWidget);
    expect(find.text('Grade A2'), findsWidgets);

    await tester.tap(find.text('Half-Yearly Examination'));
    await tester.pumpAndSettle();

    expect(find.text('Report card'), findsOneWidget);
    expect(find.text('Subject-wise marks'), findsOneWidget);
    expect(find.text('456/530'), findsOneWidget);
    expect(find.text('Rank 4 of 42'), findsOneWidget);
  });

  testWidgets('dashboard quick action opens the homework tab', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.home);

    await tester.tap(find.descendant(of: find.byType(Wrap), matching: find.text('Homework')));
    await tester.pumpAndSettle();

    expect(find.text('To do'), findsOneWidget);
  });
}
