import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/storage/app_preferences.dart';
import 'package:school_erp/core/storage/token_storage.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/authentication/data/repositories/api_auth_repository.dart';
import 'package:school_erp/features/authentication/data/repositories/secure_saved_login_store.dart';
import 'package:school_erp/features/authentication/domain/entities/saved_login.dart';
import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:school_erp/features/authentication/domain/repositories/saved_login_store.dart';

/// Real sign-in when the environment has an API; otherwise sign-in is unavailable.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  if (client == null) return const UnavailableAuthRepository();
  final preferences = ref.watch(appPreferencesProvider);
  return ApiAuthRepository(
    client: client,
    tokenStorage: ref.watch(tokenStorageProvider),
    clock: ref.watch(clockProvider),
    saveStudentId: (id) => id == null
        ? preferences.remove(PreferenceKey.studentId)
        : preferences.setString(PreferenceKey.studentId, id),
  );
});

/// Encrypted store for "Remember me".
final savedLoginStoreProvider = Provider<SavedLoginStore>((ref) => SecureSavedLoginStore());

/// Login details to pre-fill the login form with, if the user chose "Remember me".
final savedLoginProvider = FutureProvider.autoDispose<SavedLogin?>(
  (ref) => ref.watch(savedLoginStoreProvider).read(),
);
