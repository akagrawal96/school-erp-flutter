import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SessionStatus { signedOut, signedIn }

/// Whether a valid session existed when the app started. Set in bootstrap.
final initialSessionProvider = Provider<SessionStatus>((ref) => SessionStatus.signedOut);

/// Whether the stored session had expired when the app started. Set in bootstrap.
final initialSessionExpiredProvider = Provider<bool>((ref) => false);

/// Current session state. The router redirects to login whenever this is
/// [SessionStatus.signedOut].
final sessionProvider = NotifierProvider<SessionController, SessionStatus>(SessionController.new);

class SessionController extends Notifier<SessionStatus> {
  @override
  SessionStatus build() => ref.watch(initialSessionProvider);

  void signedIn() {
    ref.read(sessionExpiredProvider.notifier).clear();
    state = SessionStatus.signedIn;
  }

  /// The user signed out.
  void signedOut() => state = SessionStatus.signedOut;

  /// The server rejected the token or it expired: back to login, which asks
  /// the user to sign in again.
  void expired() {
    if (state == SessionStatus.signedIn) ref.read(sessionExpiredProvider.notifier).show();
    state = SessionStatus.signedOut;
  }
}

/// `true` while the login screen should explain that the session ended.
final sessionExpiredProvider = NotifierProvider<SessionExpiredController, bool>(
  SessionExpiredController.new,
);

class SessionExpiredController extends Notifier<bool> {
  @override
  bool build() => ref.watch(initialSessionExpiredProvider);

  void show() => state = true;

  void clear() => state = false;
}
