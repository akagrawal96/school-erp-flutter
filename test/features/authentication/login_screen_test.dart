import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/features/authentication/domain/entities/saved_login.dart';

import '../../helpers/in_memory_saved_login_store.dart';
import '../../helpers/test_app.dart';

void main() {
  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('empty submit shows validation errors and does not sign in', (tester) async {
    await pumpTestApp(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your login ID'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('invalid credentials show an error and stay on login', (tester) async {
    await pumpTestApp(tester);

    await tester.enterText(field('Login ID'), 'SCH-0001');
    await tester.enterText(field('Password'), 'wrong');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget, reason: 'loading state');

    await tester.pumpAndSettle();
    expect(find.text('Login ID or password is incorrect.'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('valid credentials open the home shell', (tester) async {
    await pumpTestApp(tester);

    await tester.enterText(field('Login ID'), 'SCH-0001');
    await tester.enterText(field('Password'), 'secret');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Good morning, Aarav'), findsOneWidget);
  });

  testWidgets('password visibility can be toggled', (tester) async {
    await pumpTestApp(tester);

    EditableText passwordText() => tester.widget<EditableText>(
      find.descendant(of: field('Password'), matching: find.byType(EditableText)),
    );

    expect(passwordText().obscureText, isTrue);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(passwordText().obscureText, isFalse);
  });

  testWidgets('language toggle switches the login screen to Hindi', (tester) async {
    await pumpTestApp(tester);

    await tester.ensureVisible(find.text('हिन्दी'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();

    expect(find.text('फिर से स्वागत है'), findsOneWidget);
  });

  testWidgets('remember me saves the login and pre-fills it next time', (tester) async {
    final store = InMemorySavedLoginStore();
    await pumpTestApp(tester, savedLoginStore: store);

    await tester.enterText(field('Login ID'), ' SCH-0001 ');
    await tester.enterText(field('Password'), 'secret');
    await tester.tap(find.text('Remember me'));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(store.login?.loginId, 'SCH-0001');
    expect(store.login?.password, 'secret');

    // Start the app again (new provider scope) with the same secure store.
    await tester.pumpWidget(const SizedBox());
    await pumpTestApp(tester, savedLoginStore: store, signedIn: false);
    expect(find.text('SCH-0001'), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });

  testWidgets('signing in without remember me forgets saved details', (tester) async {
    final store = InMemorySavedLoginStore(
      const SavedLogin(loginId: 'SCH-0001', password: 'secret'),
    );
    await pumpTestApp(tester, savedLoginStore: store);
    expect(find.text('SCH-0001'), findsOneWidget);

    await tester.tap(find.text('Remember me'));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(store.login, isNull);
  });

  testWidgets('an ended session is explained on the login screen', (tester) async {
    await pumpTestApp(tester, sessionExpired: true);

    expect(find.text('Your session has ended. Please sign in again.'), findsOneWidget);
  });
}
