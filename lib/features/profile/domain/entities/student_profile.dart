/// The signed-in student and their institution context.
///
/// Only [studentId], [name], [registrationNo], [className], [section],
/// [sessionLabel] and [institutionName] are guaranteed; everything else
/// depends on what the institution has recorded.
final class StudentProfile {
  const StudentProfile({
    required this.studentId,
    required this.name,
    required this.registrationNo,
    required this.className,
    required this.section,
    required this.sessionLabel,
    required this.institutionName,
    this.admissionNo,
    this.rollNo,
    this.dateOfBirth,
    this.gender,
    this.category,
    this.religion,
    this.nationality,
    this.fatherName,
    this.motherName,
    this.contactNumber,
    this.emergencyContactNumber,
    this.address,
    this.city,
    this.state,
    this.status,
    this.photoUrl,
    this.institutionLogoUrl,
  });

  final String studentId;
  final String name;
  final String registrationNo;

  /// Class, grade or course as named by the institution, e.g. "Class 8", "B.Sc. I".
  final String className;

  /// Section or batch, e.g. "A".
  final String section;

  /// Academic session, e.g. "2025–26".
  final String sessionLabel;
  final String institutionName;

  final String? admissionNo;
  final String? rollNo;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? category;
  final String? religion;
  final String? nationality;
  final String? fatherName;
  final String? motherName;
  final String? contactNumber;
  final String? emergencyContactNumber;
  final String? address;
  final String? city;
  final String? state;

  /// Enrolment status, e.g. "Active".
  final String? status;
  final Uri? photoUrl;
  final Uri? institutionLogoUrl;

  /// First word of [name], used in greetings.
  String get firstName => name.trim().split(RegExp(r'\s+')).first;
}
