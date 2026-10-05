import 'package:school_erp/features/profile/domain/entities/student_profile.dart';

abstract interface class StudentProfileRepository {
  /// Profile of the signed-in student.
  Future<StudentProfile> getCurrentStudent();
}
