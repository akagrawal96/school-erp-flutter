import 'package:school_erp/core/storage/app_preferences.dart';

/// In-memory [AppPreferences] for tests.
final class InMemoryAppPreferences implements AppPreferences {
  InMemoryAppPreferences([Map<PreferenceKey, String>? initial]) : values = {...?initial};

  final Map<PreferenceKey, String> values;

  @override
  String? getString(PreferenceKey key) => values[key];

  @override
  Future<void> setString(PreferenceKey key, String value) async => values[key] = value;

  @override
  Future<void> remove(PreferenceKey key) async => values.remove(key);
}
