import 'package:school_erp/features/authentication/domain/entities/saved_login.dart';
import 'package:school_erp/features/authentication/domain/repositories/saved_login_store.dart';

final class InMemorySavedLoginStore implements SavedLoginStore {
  InMemorySavedLoginStore([this.login]);

  SavedLogin? login;

  @override
  Future<SavedLogin?> read() async => login;

  @override
  Future<void> save(SavedLogin login) async => this.login = login;

  @override
  Future<void> clear() async => login = null;
}
