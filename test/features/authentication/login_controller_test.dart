import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:school_erp/features/authentication/presentation/controllers/login_controller.dart';

import '../../helpers/test_app.dart';

final class _RecordingAuthRepository implements AuthRepository {
  _RecordingAuthRepository({this.failure});

  final AuthFailure? failure;
  final calls = <(String, String)>[];

  @override
  Future<void> signIn({required String loginId, required String password}) async {
    calls.add((loginId, password));
    if (failure case final failure?) throw failure;
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  ProviderContainer containerWith(AuthRepository repository) {
    final container = ProviderContainer.test(overrides: testOverrides(authRepository: repository));
    // Keep the auto-dispose controller alive for the duration of the test.
    return container..listen(loginControllerProvider, (_, _) {});
  }

  test('successful sign-in trims the login ID and ends in data state', () async {
    final repository = _RecordingAuthRepository();
    final container = containerWith(repository);

    final result = await container
        .read(loginControllerProvider.notifier)
        .signIn(loginId: '  SCH-0001 ', password: ' pass ');

    expect(result, isTrue);
    expect(repository.calls.single, ('SCH-0001', ' pass '), reason: 'password is not trimmed');
    expect(container.read(loginControllerProvider), isA<AsyncData<void>>());
  });

  test('failed sign-in exposes the AuthFailure', () async {
    const failure = AuthFailure(AuthFailureReason.invalidCredentials);
    final container = containerWith(_RecordingAuthRepository(failure: failure));

    final result = await container
        .read(loginControllerProvider.notifier)
        .signIn(loginId: 'SCH-0001', password: 'x');

    expect(result, isFalse);
    expect(container.read(loginControllerProvider).error, failure);
  });
}
