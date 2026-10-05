import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/core/storage/app_preferences.dart';

import '../../helpers/in_memory_app_preferences.dart';
import '../../helpers/test_app.dart';

void main() {
  ThemeMode themeModeOf(WidgetTester tester) =>
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;

  testWidgets('switching to dark mode updates the app theme and is saved', (tester) async {
    final preferences = InMemoryAppPreferences();
    await pumpTestApp(tester, preferences: preferences, location: AppRoutes.design);
    expect(themeModeOf(tester), ThemeMode.system);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(themeModeOf(tester), ThemeMode.dark);
    expect(Theme.of(tester.element(find.text('Appearance'))).brightness, Brightness.dark);
    expect(preferences.values[PreferenceKey.themeMode], 'dark');
  });

  testWidgets('switching to Hindi translates the screen', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.design);

    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();

    expect(find.text('डिज़ाइन सिस्टम'), findsOneWidget);
    expect(find.text('Appearance'), findsNothing);
  });

  testWidgets('selecting an institution applies its brand color', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.design);
    final primaryBefore = Theme.of(tester.element(find.text('Appearance'))).colorScheme.primary;

    await tester.tap(find.text('Royal Public School'));
    await tester.pumpAndSettle();

    final primaryAfter = Theme.of(tester.element(find.text('Appearance'))).colorScheme.primary;
    expect(primaryAfter, isNot(primaryBefore));
  });

  testWidgets('renders without overflow on a small phone and a tablet', (tester) async {
    for (final size in const [Size(320, 640), Size(1024, 768)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pumpTestApp(tester, location: AppRoutes.design);
      await tester.scrollUntilVisible(
        find.text('Spacing & corners'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'layout error at $size');
    }
  });
}
