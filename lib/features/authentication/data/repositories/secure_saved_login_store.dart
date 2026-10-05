import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:school_erp/features/authentication/domain/entities/saved_login.dart';
import 'package:school_erp/features/authentication/domain/repositories/saved_login_store.dart';

/// [SavedLoginStore] in the Android Keystore / iOS Keychain.
final class SecureSavedLoginStore implements SavedLoginStore {
  SecureSavedLoginStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'auth.savedLogin';

  @override
  Future<SavedLogin?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return SavedLogin(loginId: json['loginId'] as String, password: json['password'] as String);
    } on Object {
      // Unreadable (e.g. keystore reset after a backup restore): start clean.
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(SavedLogin login) => _storage.write(
    key: _key,
    value: jsonEncode({'loginId': login.loginId, 'password': login.password}),
  );

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
