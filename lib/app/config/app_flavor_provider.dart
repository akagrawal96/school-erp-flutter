import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/app_flavor.dart';

/// The active build flavor. Overridden in bootstrap with the parsed native flavor.
final appFlavorProvider = Provider<AppFlavor>(
  (ref) => throw UnimplementedError('appFlavorProvider must be overridden in bootstrap.'),
);
