import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/core/session/session_controller.dart';

import '../../helpers/test_app.dart';

void main() {
  test('an expired session signs out and asks to sign in again until the next sign-in', () {
    final container = ProviderContainer.test(overrides: testOverrides(signedIn: true));
    final session = container.read(sessionProvider.notifier)..expired();

    expect(container.read(sessionProvider), SessionStatus.signedOut);
    expect(container.read(sessionExpiredProvider), isTrue);

    session.signedIn();
    expect(container.read(sessionExpiredProvider), isFalse);
  });

  test('a normal sign-out shows no session message', () {
    final container = ProviderContainer.test(overrides: testOverrides(signedIn: true));
    container.read(sessionProvider.notifier).signedOut();

    expect(container.read(sessionProvider), SessionStatus.signedOut);
    expect(container.read(sessionExpiredProvider), isFalse);
  });
}
