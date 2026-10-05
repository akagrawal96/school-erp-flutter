import 'package:school_erp/core/errors/app_exception.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/features/profile/data/mappers/student_profile_mapper.dart';
import 'package:school_erp/features/profile/domain/entities/student_profile.dart';
import 'package:school_erp/features/profile/domain/repositories/student_profile_repository.dart';

/// Profile from `StudentApi/getProfile`.
final class ApiStudentProfileRepository implements StudentProfileRepository {
  const ApiStudentProfileRepository({
    required this.client,
    required this.studentId,
    required this.fileUrl,
  });

  final ApiClient client;

  /// Loads the signed-in student's ID (from the session).
  final Future<String?> Function() studentId;
  final Uri? Function(String? path) fileUrl;

  static const _path = 'StudentApi/getProfile';

  @override
  Future<StudentProfile> getCurrentStudent() async {
    final data = await client.get(_path);
    if (data is! Json) throw const ParsingException('Profile data is not an object');
    return StudentProfileMapper.fromJson(
      data,
      studentId: await studentId() ?? '',
      fileUrl: fileUrl,
    );
  }
}
