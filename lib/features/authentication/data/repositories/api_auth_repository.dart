import 'package:school_erp/core/errors/app_exception.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/storage/token_storage.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';

/// Signs in with `StudentApi/MemberLogin_Password` and stores the token securely.
///
/// The current API takes the password as a query parameter; moving it to a
/// JSON body is planned. Only this class changes when the backend does.
final class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository({
    required this.client,
    required this.tokenStorage,
    required this.clock,
    required this.saveStudentId,
  });

  final ApiClient client;
  final TokenStorage tokenStorage;
  final Clock clock;

  /// Remembers who signed in, for APIs that need the student ID.
  final Future<void> Function(String? studentId) saveStudentId;

  static const _loginPath = 'StudentApi/MemberLogin_Password';

  /// Used when the server does not say how long the token lives.
  static const _defaultLifetime = Duration(hours: 8);

  @override
  Future<void> signIn({required String loginId, required String password}) async {
    final Object? data;
    try {
      data = await client.post(_loginPath, query: {'LoginId': loginId, 'LoginPass': password});
    } on ServerException {
      throw const AuthFailure(AuthFailureReason.invalidCredentials);
    } on UnauthorizedException {
      throw const AuthFailure(AuthFailureReason.invalidCredentials);
    } on NetworkException {
      throw const AuthFailure(AuthFailureReason.network);
    } on AppException {
      throw const AuthFailure(AuthFailureReason.unknown);
    }

    if (data is! Json) throw const AuthFailure(AuthFailureReason.unknown);
    final token = data['token'];
    if (token is! String || token.isEmpty) throw const AuthFailure(AuthFailureReason.unknown);
    final expiresIn = data['expiresIn'];
    final lifetime = expiresIn is int ? Duration(seconds: expiresIn) : _defaultLifetime;

    await tokenStorage.write(AuthToken(value: token, expiresAt: clock().add(lifetime)));
    await saveStudentId(data['StudentID']?.toString());
  }

  @override
  Future<void> signOut() async {
    await tokenStorage.clear();
    await saveStudentId(null);
  }
}

/// Used when the environment has no API configured (production URL pending).
final class UnavailableAuthRepository implements AuthRepository {
  const UnavailableAuthRepository();

  @override
  Future<void> signIn({required String loginId, required String password}) async =>
      throw const AuthFailure(AuthFailureReason.unavailable);

  @override
  Future<void> signOut() async {}
}
