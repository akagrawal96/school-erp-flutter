import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/core/links/link_opener.dart';

import '../../helpers/test_app.dart';

/// Records opened links; opening succeeds only when [succeeds] is true.
final class _FakeLinkOpener implements LinkOpener {
  _FakeLinkOpener({this.succeeds = true});

  final bool succeeds;
  final opened = <Uri>[];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return succeeds;
  }
}

// Uses the sample notices of MockNoticeRepository (4 per page, 6 in total).
void main() {
  Future<void> useTallPhone(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('lists notices and loads older ones on request', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(tester, location: AppRoutes.notices);

    expect(find.text('Annual Sports Day'), findsOneWidget);
    expect(find.text('Half-yearly exam date sheet'), findsOneWidget);
    expect(find.text('Library books due'), findsNothing);

    await tester.tap(find.text('Show older notices'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('Library books due'), findsOneWidget);
    expect(find.text('Winter uniform from next month'), findsOneWidget);
    expect(find.text('Show older notices'), findsNothing);
  });

  testWidgets('notice detail opens its attachment', (tester) async {
    await useTallPhone(tester);
    final opener = _FakeLinkOpener();
    await pumpTestApp(
      tester,
      location: AppRoutes.notices,
      overrides: [linkOpenerProvider.overrideWithValue(opener)],
    );

    await tester.tap(find.text('Parent-teacher meeting on Saturday'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open attachment'));
    await tester.pump();

    expect(opener.opened.single.toString(), 'https://example.com/ptm-schedule.pdf');
  });

  testWidgets('a link that cannot be opened shows a message', (tester) async {
    await useTallPhone(tester);
    await pumpTestApp(
      tester,
      location: AppRoutes.notice('106'),
      overrides: [linkOpenerProvider.overrideWithValue(_FakeLinkOpener(succeeds: false))],
    );

    await tester.tap(find.text('Watch video'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't open the link."), findsOneWidget);
  });

  testWidgets('an unknown notice shows a message', (tester) async {
    await pumpTestApp(tester, location: AppRoutes.notice('999'));

    expect(find.text('This notice is no longer available.'), findsOneWidget);
  });
}
