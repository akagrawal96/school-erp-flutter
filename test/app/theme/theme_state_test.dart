import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/theme/app_theme.dart';
import 'package:school_erp/app/theme/branding/app_branding.dart';
import 'package:school_erp/app/theme/theme_mode_controller.dart';
import 'package:school_erp/core/storage/app_preferences.dart';

import '../../helpers/in_memory_app_preferences.dart';
import '../../helpers/test_app.dart';

void main() {
  group('ThemeModeController', () {
    test('defaults to system', () {
      final container = ProviderContainer.test(overrides: testOverrides());
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('persists and restores the choice', () async {
      final preferences = InMemoryAppPreferences();
      final container = ProviderContainer.test(overrides: testOverrides(preferences: preferences));

      await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);

      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(preferences.values[PreferenceKey.themeMode], 'dark');

      final restarted = ProviderContainer.test(overrides: testOverrides(preferences: preferences));
      expect(restarted.read(themeModeProvider), ThemeMode.dark);
    });

    test('ignores an unknown stored value', () {
      final preferences = InMemoryAppPreferences({PreferenceKey.themeMode: 'sepia'});
      final container = ProviderContainer.test(overrides: testOverrides(preferences: preferences));
      expect(container.read(themeModeProvider), ThemeMode.system);
    });
  });

  group('BrandingController', () {
    const institution = AppBranding(primarySeed: Color(0xFF0F766E));

    test('starts with the app variant default', () {
      final container = ProviderContainer.test(overrides: testOverrides());
      expect(container.read(brandingProvider), AppBranding.erpDefault);
    });

    test('applying institution branding rebuilds the themes; reset restores default', () {
      final container = ProviderContainer.test(overrides: testOverrides());
      final defaultPrimary = container.read(lightThemeProvider).colorScheme.primary;

      container.read(brandingProvider.notifier).apply(institution);
      expect(container.read(brandingProvider), institution);
      expect(container.read(lightThemeProvider).colorScheme.primary, isNot(defaultPrimary));

      container.read(brandingProvider.notifier).reset();
      expect(container.read(lightThemeProvider).colorScheme.primary, defaultPrimary);
    });
  });
}
