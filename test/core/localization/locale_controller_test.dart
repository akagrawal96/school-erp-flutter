import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/core/storage/app_preferences.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';

import '../../helpers/in_memory_app_preferences.dart';
import '../../helpers/test_app.dart';

void main() {
  test('supports English and Hindi', () {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode),
      containsAll(<String>['en', 'hi']),
    );
  });

  test('follows the device language by default', () {
    final container = ProviderContainer.test(overrides: testOverrides());
    expect(container.read(localeProvider), isNull);
  });

  test('persists and restores the chosen language', () async {
    final preferences = InMemoryAppPreferences();
    final container = ProviderContainer.test(overrides: testOverrides(preferences: preferences));

    await container.read(localeProvider.notifier).setLocale(const Locale('hi'));
    expect(container.read(localeProvider), const Locale('hi'));
    expect(preferences.values[PreferenceKey.locale], 'hi');

    final restarted = ProviderContainer.test(overrides: testOverrides(preferences: preferences));
    expect(restarted.read(localeProvider), const Locale('hi'));
  });

  test('choosing system language clears the stored choice', () async {
    final preferences = InMemoryAppPreferences({PreferenceKey.locale: 'hi'});
    final container = ProviderContainer.test(overrides: testOverrides(preferences: preferences));

    await container.read(localeProvider.notifier).setLocale(null);

    expect(container.read(localeProvider), isNull);
    expect(preferences.values.containsKey(PreferenceKey.locale), isFalse);
  });

  test('unsupported languages fall back to the device language', () async {
    final preferences = InMemoryAppPreferences({PreferenceKey.locale: 'fr'});
    final container = ProviderContainer.test(overrides: testOverrides(preferences: preferences));
    expect(container.read(localeProvider), isNull);

    await container.read(localeProvider.notifier).setLocale(const Locale('de'));
    expect(container.read(localeProvider), isNull);
  });
}
