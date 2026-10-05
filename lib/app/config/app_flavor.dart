import 'package:flutter/foundation.dart';

/// Backend environment the build talks to. Mirrors the Android `env` flavor dimension.
///
/// `staging` is used for development and testing; `prod` serves real users.
/// See ADR-0002 for why there is no separate `dev` environment.
enum AppEnvironment {
  staging,
  prod;

  bool get isProduction => this == AppEnvironment.prod;
}

/// Which product is being built. Mirrors the Android `app` flavor dimension.
///
/// `erp` is the default multi-institution app. White-label apps for a single
/// institution, or audience-specific apps (e.g. parent/student), are added here
/// alongside a matching Android flavor. See docs/architecture/flavors.md.
enum AppVariant { erp }

/// The build flavor, parsed from the native `--flavor` value (e.g. `erpStaging`).
@immutable
final class AppFlavor {
  const AppFlavor({required this.variant, required this.environment});

  /// Parses a Flutter flavor name of the form `<variant><Environment>`.
  ///
  /// Throws a [FormatException] when [raw] is missing or unknown, so a
  /// misconfigured build fails at startup instead of silently using the wrong
  /// backend.
  factory AppFlavor.parse(String? raw) {
    if (raw == null || raw.isEmpty) {
      throw const FormatException(
        'No build flavor set. Run with --flavor, e.g. `flutter run --flavor erpStaging`.',
      );
    }
    for (final variant in AppVariant.values) {
      if (!raw.startsWith(variant.name)) continue;
      final envName = raw.substring(variant.name.length).toLowerCase();
      for (final environment in AppEnvironment.values) {
        if (environment.name == envName) {
          return AppFlavor(variant: variant, environment: environment);
        }
      }
    }
    throw FormatException('Unknown build flavor "$raw".');
  }

  final AppVariant variant;
  final AppEnvironment environment;

  /// The native flavor name, e.g. `erpStaging`.
  String get name {
    final env = environment.name;
    return '${variant.name}${env[0].toUpperCase()}${env.substring(1)}';
  }

  @override
  bool operator ==(Object other) =>
      other is AppFlavor && other.variant == variant && other.environment == environment;

  @override
  int get hashCode => Object.hash(variant, environment);

  @override
  String toString() => 'AppFlavor($name)';
}
