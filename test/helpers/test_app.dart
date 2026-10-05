import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/app/app.dart';
import 'package:school_erp/app/config/app_flavor.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';
import 'package:school_erp/app/config/environment_config.dart';
import 'package:school_erp/app/router/app_router.dart';
import 'package:school_erp/app/router/app_routes.dart';
import 'package:school_erp/app/theme/app_theme.dart';
import 'package:school_erp/app/theme/branding/app_branding.dart';
import 'package:school_erp/core/session/session_controller.dart';
import 'package:school_erp/core/storage/app_preferences.dart';
import 'package:school_erp/core/storage/token_storage.dart';
import 'package:school_erp/core/time/clock.dart';
import 'package:school_erp/features/authentication/data/repositories/demo_auth_repository.dart';
import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:school_erp/features/authentication/domain/repositories/saved_login_store.dart';
import 'package:school_erp/features/authentication/presentation/providers/auth_providers.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';

import 'in_memory_app_preferences.dart';
import 'in_memory_saved_login_store.dart';
import 'in_memory_token_storage.dart';

const stagingFlavor = AppFlavor(variant: AppVariant.erp, environment: AppEnvironment.staging);

/// Fixed "now" for tests: Wednesday 14 October 2026, 9:30 AM (during period 3).
final testNow = DateTime(2026, 10, 14, 9, 30);

/// Provider overrides every test needs in place of bootstrap.
List<Override> testOverrides({
  AppFlavor flavor = stagingFlavor,
  AppPreferences? preferences,
  AuthRepository? authRepository,
  DateTime? now,
  TokenStorage? tokenStorage,
  bool signedIn = false,
  bool sessionExpired = false,
  SavedLoginStore? savedLoginStore,
}) => [
  // No server in tests: every feature uses its mock repository.
  environmentConfigProvider.overrideWithValue(const EnvironmentConfig()),
  tokenStorageProvider.overrideWithValue(tokenStorage ?? InMemoryTokenStorage()),
  initialSessionProvider.overrideWithValue(
    signedIn ? SessionStatus.signedIn : SessionStatus.signedOut,
  ),
  initialSessionExpiredProvider.overrideWithValue(sessionExpired),
  savedLoginStoreProvider.overrideWithValue(savedLoginStore ?? InMemorySavedLoginStore()),
  clockProvider.overrideWithValue(() => now ?? testNow),
  appFlavorProvider.overrideWithValue(flavor),
  appPreferencesProvider.overrideWithValue(preferences ?? InMemoryAppPreferences()),
  authRepositoryProvider.overrideWithValue(
    authRepository ?? const DemoAuthRepository(latency: Duration(milliseconds: 300)),
  ),
];

/// Pumps the full app, optionally opening [location] first.
///
/// Set [settle] to false for screens with endless animations (spinners, skeletons).
Future<void> pumpTestApp(
  WidgetTester tester, {
  AppFlavor flavor = stagingFlavor,
  AppPreferences? preferences,
  String? location,
  bool settle = true,
  bool? signedIn,
  bool sessionExpired = false,
  SavedLoginStore? savedLoginStore,
  List<Override> overrides = const [],
}) async {
  // Opening a signed-in page implies a signed-in session unless stated otherwise.
  final isSignedIn = signedIn ?? (location != null && location != AppRoutes.login);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...testOverrides(
          flavor: flavor,
          preferences: preferences,
          signedIn: isSignedIn,
          sessionExpired: sessionExpired,
          savedLoginStore: savedLoginStore,
        ),
        ...overrides,
      ],
      child: const SchoolErpApp(),
    ),
  );
  if (location != null) {
    ProviderScope.containerOf(
      tester.element(find.byType(SchoolErpApp)),
    ).read(routerProvider).go(location);
  }
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }
}

/// Pumps a single widget with the app theme and English localizations.
Future<void> pumpTestWidget(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: testOverrides(),
      child: MaterialApp(
        theme: AppTheme.build(branding: AppBranding.erpDefault, brightness: Brightness.light),
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump();
}
