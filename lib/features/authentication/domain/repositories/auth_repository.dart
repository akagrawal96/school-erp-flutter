/// Why a sign-in attempt failed. The UI maps each reason to a localized message.
enum AuthFailureReason {
  invalidCredentials,
  network,

  /// Sign-in is not possible in this build (no server configured).
  unavailable,
  unknown,
}

/// Thrown by [AuthRepository] when authentication fails.
///
/// Step 4 introduces the app-wide `Result`/`Failure` types; this will move onto them.
final class AuthFailure implements Exception {
  const AuthFailure(this.reason);

  final AuthFailureReason reason;

  @override
  String toString() => 'AuthFailure(${reason.name})';
}

/// Authentication operations. Pure domain contract: no HTTP or storage details.
abstract interface class AuthRepository {
  /// Signs in with the institution-issued login ID. Throws [AuthFailure].
  Future<void> signIn({required String loginId, required String password});

  Future<void> signOut();
}
