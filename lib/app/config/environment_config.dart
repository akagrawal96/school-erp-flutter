import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/app_flavor.dart';
import 'package:school_erp/app/config/app_flavor_provider.dart';

/// Backend addresses for the active environment.
///
/// A developer can point a build at another server without code changes:
/// `flutter run --flavor erpStaging --dart-define=API_BASE_URL=http://10.0.2.2:5000/api/`
final class EnvironmentConfig {
  const EnvironmentConfig({this.apiBaseUrl, this.filesBaseUrl});

  factory EnvironmentConfig.forFlavor(AppFlavor flavor) {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      final api = Uri.parse(override);
      return EnvironmentConfig(
        apiBaseUrl: api,
        filesBaseUrl: api.replace(path: '/'),
      );
    }
    return switch (flavor.environment) {
      AppEnvironment.staging => EnvironmentConfig(
        apiBaseUrl: Uri.parse('http://staging.example.test/api/'),
        filesBaseUrl: Uri.parse('http://staging.example.test/'),
      ),
      // TODO(step-4): production URL not decided yet (docs/api/environments.md).
      AppEnvironment.prod => const EnvironmentConfig(),
    };
  }

  /// Base URL of the REST API, ending with `/`. `null` when not configured.
  final Uri? apiBaseUrl;

  /// Base URL for files the API references by relative path (photos, logos).
  final Uri? filesBaseUrl;

  bool get hasApi => apiBaseUrl != null;

  /// Resolves a server-relative file path such as `documents/photos/x.jpg`.
  Uri? fileUrl(String? path) {
    final base = filesBaseUrl;
    if (path == null || path.trim().isEmpty || base == null) return null;
    return base.resolve(path.trim());
  }
}

final environmentConfigProvider = Provider<EnvironmentConfig>(
  (ref) => EnvironmentConfig.forFlavor(ref.watch(appFlavorProvider)),
);
