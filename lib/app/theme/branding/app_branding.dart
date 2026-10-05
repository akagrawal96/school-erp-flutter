import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/app_flavor.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';

/// Brand identity applied to the theme.
///
/// The app ships a default per [AppVariant]; after login the backend can
/// supply an institution's branding, which replaces it at runtime. Only brand
/// colors are configurable — semantic colors (success, warning, error) are
/// fixed so status meaning stays consistent across institutions.
@immutable
final class AppBranding {
  const AppBranding({required this.primarySeed, this.secondarySeed});

  /// Main brand color. The theme derives an accessible tonal palette from it,
  /// so any color is safe to use.
  final Color primarySeed;

  /// Optional accent color. When absent it is derived from [primarySeed].
  final Color? secondarySeed;

  /// Default branding of the School ERP product: a deep, trustworthy indigo.
  static const erpDefault = AppBranding(primarySeed: Color(0xFF2D4BD1));

  static AppBranding defaultFor(AppVariant variant) => switch (variant) {
    AppVariant.erp => erpDefault,
  };

  @override
  bool operator ==(Object other) =>
      other is AppBranding &&
      other.primarySeed == primarySeed &&
      other.secondarySeed == secondarySeed;

  @override
  int get hashCode => Object.hash(primarySeed, secondarySeed);
}

/// The branding currently applied to the app theme.
final brandingProvider = NotifierProvider<BrandingController, AppBranding>(
  BrandingController.new,
);

class BrandingController extends Notifier<AppBranding> {
  @override
  AppBranding build() => AppBranding.defaultFor(ref.watch(appFlavorProvider).variant);

  /// Applies an institution's branding (e.g. received from the backend after login).
  void apply(AppBranding branding) => state = branding;

  /// Restores the app variant's default branding (e.g. on logout).
  void reset() => state = AppBranding.defaultFor(ref.read(appFlavorProvider).variant);
}
