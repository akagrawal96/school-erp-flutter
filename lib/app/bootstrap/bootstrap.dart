import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/app.dart';
import 'package:school_erp/app/config/app_flavor.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';
import 'package:school_erp/core/session/session_controller.dart';
import 'package:school_erp/core/storage/app_preferences.dart';
import 'package:school_erp/core/storage/shared_preferences_app_preferences.dart';
import 'package:school_erp/core/storage/token_storage.dart';

/// Initializes platform services and starts the app.
///
/// Everything that must exist before the first frame is created here and
/// injected through provider overrides, so tests can substitute fakes.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final flavor = AppFlavor.parse(appFlavor);
  final preferences = await SharedPreferencesAppPreferences.create();
  final tokenStorage = SecureTokenStorage();
  final token = await tokenStorage.read();
  final hasValidSession = token != null && !token.isExpiredAt(DateTime.now());
  final sessionExpired = token != null && !hasValidSession;
  if (sessionExpired) await tokenStorage.clear();

  runApp(
    ProviderScope(
      overrides: [
        appFlavorProvider.overrideWithValue(flavor),
        appPreferencesProvider.overrideWithValue(preferences),
        tokenStorageProvider.overrideWithValue(tokenStorage),
        initialSessionProvider.overrideWithValue(
          hasValidSession ? SessionStatus.signedIn : SessionStatus.signedOut,
        ),
        initialSessionExpiredProvider.overrideWithValue(sessionExpired),
      ],
      child: const SchoolErpApp(),
    ),
  );
}
