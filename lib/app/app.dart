import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';
import 'package:school_erp/app/router/app_router.dart';
import 'package:school_erp/app/theme/app_theme.dart';
import 'package:school_erp/app/theme/theme_mode_controller.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';

/// Root widget: wires routing, theme and language.
class SchoolErpApp extends ConsumerWidget {
  const SchoolErpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(appFlavorProvider);
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: !flavor.environment.isProduction,
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: ref.watch(themeModeProvider),
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
