import 'package:school_erp/core/storage/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [AppPreferences] backed by `shared_preferences` with an in-memory cache.
final class SharedPreferencesAppPreferences implements AppPreferences {
  SharedPreferencesAppPreferences._(this._preferences);

  /// Loads all known preference keys into memory.
  static Future<SharedPreferencesAppPreferences> create() async {
    final preferences = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: {for (final key in PreferenceKey.values) key.storageKey},
      ),
    );
    return SharedPreferencesAppPreferences._(preferences);
  }

  final SharedPreferencesWithCache _preferences;

  @override
  String? getString(PreferenceKey key) => _preferences.getString(key.storageKey);

  @override
  Future<void> setString(PreferenceKey key, String value) =>
      _preferences.setString(key.storageKey, value);

  @override
  Future<void> remove(PreferenceKey key) => _preferences.remove(key.storageKey);
}
