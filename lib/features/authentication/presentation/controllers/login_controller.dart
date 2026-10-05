import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/core/session/session_controller.dart';
import 'package:school_erp/features/authentication/domain/entities/saved_login.dart';
import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:school_erp/features/authentication/presentation/providers/auth_providers.dart';

/// Sign-in state for the login screen: data (idle/success), loading or error
/// holding an [AuthFailure].
final loginControllerProvider = NotifierProvider.autoDispose<LoginController, AsyncValue<void>>(
  LoginController.new,
);

class LoginController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Returns `true` when sign-in succeeded. Ignores calls while one is running.
  ///
  /// With [remember], the login details are kept in encrypted storage to
  /// pre-fill the form next time; without it, saved details are removed.
  Future<bool> signIn({
    required String loginId,
    required String password,
    bool remember = false,
  }) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final id = loginId.trim();
    try {
      await ref.read(authRepositoryProvider).signIn(loginId: id, password: password);
      await _updateSavedLogin(remember ? SavedLogin(loginId: id, password: password) : null);
      if (!ref.mounted) return false;
      state = const AsyncData(null);
      // The router reacts to the session change and opens the home screen.
      ref.read(sessionProvider.notifier).signedIn();
      return true;
    } on AuthFailure catch (failure, stackTrace) {
      if (ref.mounted) state = AsyncError(failure, stackTrace);
      return false;
    }
  }

  /// A storage problem must not block sign-in; the form is simply not pre-filled.
  Future<void> _updateSavedLogin(SavedLogin? login) async {
    final store = ref.read(savedLoginStoreProvider);
    try {
      await (login == null ? store.clear() : store.save(login));
    } on Object {
      // Ignored on purpose, see above.
    }
  }
}

/// Signs the user out.
final signOutControllerProvider = NotifierProvider.autoDispose<SignOutController, AsyncValue<void>>(
  SignOutController.new,
);

class SignOutController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signOut() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).signOut();
    if (!ref.mounted) return;
    state = const AsyncData(null);
    ref.read(sessionProvider.notifier).signedOut();
  }
}
