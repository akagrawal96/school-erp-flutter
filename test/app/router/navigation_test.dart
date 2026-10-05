import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';

import '../../helpers/test_app.dart';

/// A destination label inside the bottom bar or navigation rail.
Finder navItem(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is NavigationBar || w is NavigationRail),
  matching: find.text(label),
);

void main() {
  testWidgets('phone layout uses a bottom navigation bar with five tabs', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpTestApp(tester, location: AppRoutes.home);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });

  testWidgets('tablet layout uses a navigation rail', (tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpTestApp(tester, location: AppRoutes.home);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('tabs switch between attendance, fees and more', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.home);

    await tester.tap(navItem('Attendance'));
    await tester.pumpAndSettle();
    expect(find.text('Overall attendance'), findsOneWidget);

    await tester.tap(navItem('Fees'));
    await tester.pumpAndSettle();
    expect(find.text('Paid in 2026–27'), findsOneWidget);

    await tester.tap(navItem('More'));
    await tester.pumpAndSettle();
    expect(find.text('My profile'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);
  });

  testWidgets('sign out asks for confirmation and returns to login', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.more);

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Sign out'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('My profile'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('signed-out users are sent to login from any page', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.fees, signedIn: false);

    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('unknown routes show the not-found screen', (tester) async {
    await pumpTestApp(tester, location: '/does-not-exist');

    expect(find.text('Page not found'), findsOneWidget);
    await tester.tap(find.text('Go to home'));
    await tester.pumpAndSettle();
    expect(find.text('Good morning, Aarav'), findsOneWidget);
  });
}
