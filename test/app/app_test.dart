import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/config/app_flavor.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('app starts on the login screen when signed out', (tester) async {
    await pumpTestApp(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Build: erpStaging'), findsOneWidget);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).debugShowCheckedModeBanner, isTrue);
  });

  testWidgets('production hides the debug banner and build label', (tester) async {
    await pumpTestApp(
      tester,
      flavor: const AppFlavor(variant: AppVariant.erp, environment: AppEnvironment.prod),
    );

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).debugShowCheckedModeBanner,
      isFalse,
    );
    expect(find.textContaining('Build:'), findsNothing);
  });
}
