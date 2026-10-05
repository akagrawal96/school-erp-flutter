import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Keys for non-sensitive user preferences.
///
/// Only keys listed here can be stored, which keeps preference storage
/// discoverable and prevents stray string keys across the codebase.
/// Tokens and other secrets never go here — they use secure storage (step 4).
enum PreferenceKey {
  themeMode('app.theme_mode'),
  locale('app.locale'),

  /// ID of the signed-in student. Not secret; the session token is in secure storage.
  studentId('session.student_id');

  const PreferenceKey(this.storageKey);

  final String storageKey;
}

/// Non-sensitive key-value preferences (theme mode, language, …).
///
/// Reads are synchronous so startup preferences are available on the first
/// frame; implementations load their cache before the app starts.
abstract interface class AppPreferences {
  String? getString(PreferenceKey key);

  Future<void> setString(PreferenceKey key, String value);

  Future<void> remove(PreferenceKey key);
}

/// Provides [AppPreferences]. Overridden with a real implementation in bootstrap
/// and with an in-memory fake in tests.
final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => throw UnimplementedError('appPreferencesProvider must be overridden in bootstrap.'),
);
