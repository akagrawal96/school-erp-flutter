import 'package:school_erp/core/storage/token_storage.dart';

/// In-memory [TokenStorage] for tests.
final class InMemoryTokenStorage implements TokenStorage {
  InMemoryTokenStorage([this.token]);

  AuthToken? token;

  @override
  Future<AuthToken?> read() async => token;

  @override
  Future<void> write(AuthToken token) async => this.token = token;

  @override
  Future<void> clear() async => token = null;
}
