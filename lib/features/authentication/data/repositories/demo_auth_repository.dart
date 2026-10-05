import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';

/// Stand-in [AuthRepository] for reviewing the login UI before the API is
/// connected. Replaced by the API-backed repository in roadmap step 4.
///
/// Any login ID is accepted; the password `wrong` simulates invalid credentials.
final class DemoAuthRepository implements AuthRepository {
  const DemoAuthRepository({this.latency = const Duration(milliseconds: 900)});

  final Duration latency;

  static const invalidPassword = 'wrong';

  @override
  Future<void> signIn({required String loginId, required String password}) async {
    await Future<void>.delayed(latency);
    if (password == invalidPassword) {
      throw const AuthFailure(AuthFailureReason.invalidCredentials);
    }
  }

  @override
  Future<void> signOut() async {}
}
