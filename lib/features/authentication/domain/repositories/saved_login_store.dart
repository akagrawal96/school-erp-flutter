import 'package:school_erp/features/authentication/domain/entities/saved_login.dart';

/// Keeps the login details for "Remember me". Implementations must use
/// encrypted storage (Keystore / Keychain), never plain preferences.
abstract interface class SavedLoginStore {
  Future<SavedLogin?> read();

  Future<void> save(SavedLogin login);

  Future<void> clear();
}
