import 'package:school_erp/features/profile/domain/entities/student_profile.dart';
import 'package:school_erp/features/profile/domain/repositories/student_profile_repository.dart';

/// Sample student for UI design and tests. All data is fictional.
final class MockStudentProfileRepository implements StudentProfileRepository {
  const MockStudentProfileRepository({this.latency = const Duration(milliseconds: 400)});

  final Duration latency;

  @override
  Future<StudentProfile> getCurrentStudent() async {
    await Future<void>.delayed(latency);
    return StudentProfile(
      studentId: 'demo-student-1',
      name: 'Aarav Mehta',
      registrationNo: 'GVS-2019-0142',
      admissionNo: 'ADM-0142',
      className: 'Class 8',
      section: 'A',
      rollNo: '14',
      sessionLabel: '2026–27',
      institutionName: 'Green Valley Public School',
      dateOfBirth: DateTime(2013, 5, 21),
      gender: 'Male',
      category: 'General',
      fatherName: 'Mr. Rohit Mehta',
      motherName: 'Mrs. Neha Mehta',
      contactNumber: '9000000001',
      emergencyContactNumber: '9000000002',
      address: '12, Shanti Nagar',
      city: 'Jaipur',
      state: 'Rajasthan',
      status: 'Active',
    );
  }
}
