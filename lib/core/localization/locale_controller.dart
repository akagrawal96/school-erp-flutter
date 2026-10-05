import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/core/storage/app_preferences.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';

/// The user's chosen app language. `null` follows the device language.
final localeProvider = NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.watch(appPreferencesProvider).getString(PreferenceKey.locale);
    return _supportedLocale(code);
  }

  /// Sets the app language; pass `null` to follow the device language.
  Future<void> setLocale(Locale? locale) async {
    final supported = _supportedLocale(locale?.languageCode);
    state = supported;
    final preferences = ref.read(appPreferencesProvider);
    if (supported == null) {
      await preferences.remove(PreferenceKey.locale);
    } else {
      await preferences.setString(PreferenceKey.locale, supported.languageCode);
    }
  }

  static Locale? _supportedLocale(String? languageCode) {
    if (languageCode == null) return null;
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == languageCode) return locale;
    }
    return null;
  }
}

extension AppLocalizationsContext on BuildContext {
  /// Localized strings for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
