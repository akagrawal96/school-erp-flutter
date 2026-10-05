import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('component gallery renders every section on a small phone', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Spinners and skeletons animate forever, so the tree never settles.
    await pumpTestApp(tester, location: AppRoutes.components, settle: false);

    for (final title in ['Buttons', 'Inputs', 'Content', 'Screen states', 'Dialogs']) {
      await tester.scrollUntilVisible(
        find.text(title),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(title), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}
