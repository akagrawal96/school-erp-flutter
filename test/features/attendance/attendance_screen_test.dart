import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/features/attendance/presentation/providers/attendance_providers.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('shows the year summary and the current month calendar', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.attendance);

    expect(find.text('Overall attendance'), findsOneWidget);
    expect(find.text('Academic year 2026–27'), findsOneWidget);
    expect(find.text('October 2026'), findsOneWidget);
    expect(find.byTooltip('Next month'), findsOneWidget);
    expect(
      tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.chevron_right)).onPressed,
      isNull,
      reason: 'cannot go past the current month',
    );
  });

  testWidgets('previous month button loads the earlier month', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.attendance);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();

    expect(find.text('September 2026'), findsOneWidget);
  });

  testWidgets('month selection stops at the start of the academic year', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.attendance);
    final container = ProviderScope.containerOf(tester.element(find.text('Overall attendance')));
    final controller = container.read(selectedAttendanceMonthProvider.notifier);

    for (var i = 0; i < 12; i++) {
      controller.previous();
    }
    expect(container.read(selectedAttendanceMonthProvider), DateTime(2026, 4));
    expect(controller.canGoPrevious, isFalse);
  });

  testWidgets('tapping a day opens its details', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.attendance);

    await tester.tap(find.bySemanticsLabel(RegExp(r'^Sunday, 11 October 2026')));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Holiday'), findsWidgets);
  });
}
