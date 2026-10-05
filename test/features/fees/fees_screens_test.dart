import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';

import '../../helpers/test_app.dart';

// Uses the sample receipts of MockFeesRepository (session 2026–27, test date 14 Oct 2026).
void main() {
  Future<void> useTallPhone(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Finder monthCell(String label) =>
      find.byWidgetPredicate((w) => w is Semantics && w.properties.label == label);

  testWidgets('fees screen shows totals, months paid and payments', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.fees);

    expect(find.text('Paid in 2026–27'), findsOneWidget);
    expect(find.text('₹32,900'), findsOneWidget);
    expect(find.text('₹37,100'), findsOneWidget);
    expect(find.text('₹4,200'), findsOneWidget);
    expect(find.text('6 of 12 months'), findsOneWidget);
    expect(monthCell('September 2026: paid'), findsOneWidget);
    expect(monthCell('October 2026: no payment'), findsOneWidget);
    expect(find.text('Payments (5)'), findsOneWidget);
    expect(find.text('May – Jul 2026'), findsOneWidget);
    expect(find.text('₹4,000 balance'), findsOneWidget, reason: 'first April deposit was partial');
    expect(find.textContaining('still to be paid'), findsNothing, reason: 'settled later');
  });

  testWidgets('a payment opens its receipt', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.fees);

    await tester.tap(find.text('September 2026'));
    await tester.pumpAndSettle();

    expect(find.text('FEE RECEIPT'), findsOneWidget);
    expect(find.text('11655'), findsOneWidget);
    expect(find.text('000123, dated 5 Oct 2026'), findsOneWidget);
    expect(find.text('− ₹700'), findsOneWidget);
    expect(find.text('Fee details'), findsOneWidget);
    expect(find.text('Tuition Fee'), findsOneWidget);
    expect(find.text('Fee ₹4,600 · ₹700 concession'), findsOneWidget);
    expect(find.text('Exam Fee'), findsNothing, reason: 'uncharged heads are hidden');
  });

  testWidgets('an unknown receipt number shows a message', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.feeReceipt('404'));

    expect(find.text('This receipt is not available.'), findsOneWidget);
  });
}
