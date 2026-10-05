import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/features/dashboard/presentation/providers/dashboard_providers.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('shows greeting, key figures, current class and notices', (tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpTestApp(tester, location: AppRoutes.home);

    expect(find.text('Good morning, Aarav'), findsOneWidget);
    expect(find.text('Class 8 · Section A · Roll no. 14'), findsOneWidget);
    expect(find.text('Green Valley Public School'), findsOneWidget);
    expect(find.text('Fees paid'), findsOneWidget);
    expect(find.text('₹32,900'), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('Now'), findsOneWidget, reason: '9:30 AM is during period 3');
    expect(find.text('Latest notices'), findsOneWidget);
    expect(find.text('Annual Sports Day'), findsOneWidget);
  });

  testWidgets('a latest notice opens its detail', (tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpTestApp(tester, location: AppRoutes.home);

    await tester.tap(find.text('School closed for Dussehra'));
    await tester.pumpAndSettle();

    expect(find.text('Notice'), findsOneWidget);
    expect(find.text('Holiday'), findsOneWidget);
    expect(find.textContaining('Classes resume on Monday'), findsOneWidget);
  });

  testWidgets('shows loading skeleton before data arrives', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.home, settle: false);
    expect(find.text('Good morning, Aarav'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('Good morning, Aarav'), findsOneWidget);
  });

  testWidgets('today card opens attendance', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.home);

    await tester.tap(find.text("Today's attendance"));
    await tester.pumpAndSettle();

    expect(find.text('Overall attendance'), findsOneWidget);
  });

  test('greeting period follows the time of day', () {
    expect(GreetingPeriod.of(DateTime(2026, 1, 1, 6)), GreetingPeriod.morning);
    expect(GreetingPeriod.of(DateTime(2026, 1, 1, 12)), GreetingPeriod.afternoon);
    expect(GreetingPeriod.of(DateTime(2026, 1, 1, 17)), GreetingPeriod.evening);
  });
}
