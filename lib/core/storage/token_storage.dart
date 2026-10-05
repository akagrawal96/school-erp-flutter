import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Access token of the signed-in user.
final class AuthToken {
  const AuthToken({required this.value, required this.expiresAt});

  final String value;
  final DateTime expiresAt;

  bool isExpiredAt(DateTime now) => !now.isBefore(expiresAt);
}

/// Stores the session token. Tokens never go to SharedPreferences.
abstract interface class TokenStorage {
  Future<AuthToken?> read();

  Future<void> write(AuthToken token);

  Future<void> clear();
}

/// [TokenStorage] in the Android Keystore / iOS Keychain.
final class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'auth.token';

  @override
  Future<AuthToken?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AuthToken(
        value: json['value'] as String,
        expiresAt: DateTime.parse(json['expiresAt'] as String),
      );
    } on FormatException {
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthToken token) => _storage.write(
    key: _key,
    value: jsonEncode({'value': token.value, 'expiresAt': token.expiresAt.toIso8601String()}),
  );

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// Overridden in bootstrap with [SecureTokenStorage] and in tests with a fake.
final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => throw UnimplementedError('tokenStorageProvider must be overridden in bootstrap.'),
);
