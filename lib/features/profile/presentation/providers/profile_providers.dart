import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/config/environment_config.dart';
import 'package:school_erp/core/errors/app_exception.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/session/session_controller.dart';
import 'package:school_erp/core/storage/app_preferences.dart';
import 'package:school_erp/features/profile/data/repositories/api_student_profile_repository.dart';
import 'package:school_erp/features/profile/data/repositories/mock_student_profile_repository.dart';
import 'package:school_erp/features/profile/domain/entities/student_profile.dart';
import 'package:school_erp/features/profile/domain/repositories/student_profile_repository.dart';

final studentProfileRepositoryProvider = Provider<StudentProfileRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  if (client == null) return const MockStudentProfileRepository();
  final preferences = ref.watch(appPreferencesProvider);
  return ApiStudentProfileRepository(
    client: client,
    studentId: () async => preferences.getString(PreferenceKey.studentId),
    fileUrl: ref.watch(environmentConfigProvider).fileUrl,
  );
});

/// The signed-in student. Reloads whenever the session changes; nothing is
/// fetched while signed out.
final currentStudentProvider = FutureProvider<StudentProfile>((ref) {
  if (ref.watch(sessionProvider) == SessionStatus.signedOut) {
    throw const UnauthorizedException('Not signed in');
  }
  return ref.watch(studentProfileRepositoryProvider).getCurrentStudent();
});
