import 'package:school_erp/core/errors/app_exception.dart';
import 'package:school_erp/core/network/api_values.dart';
import 'package:school_erp/features/profile/domain/entities/student_profile.dart';

/// Maps the `StudentApi/getProfile` response to [StudentProfile].
///
/// The backend returns names in capitals with stray spaces; they are
/// normalised here so the UI never has to.
abstract final class StudentProfileMapper {
  static StudentProfile fromJson(
    Map<String, dynamic> json, {
    required String studentId,
    required Uri? Function(String? path) fileUrl,
  }) {
    final name = _text(json['SName']);
    final registrationNo = _text(json['RegNo']);
    if (name == null || registrationNo == null) {
      throw const ParsingException('Profile is missing SName or RegNo');
    }
    final session = json['SessionCode'];
    return StudentProfile(
      studentId: studentId,
      name: titleCase(name),
      registrationNo: registrationNo,
      admissionNo: _text(json['AdmissionNo']),
      className: titleCase(_text(json['CourseName']) ?? ''),
      section: _text(json['BatchName']) ?? '',
      sessionLabel: sessionLabel(session is int ? session : int.tryParse('$session')),
      institutionName: titleCase(_text(json['BranchName']) ?? ''),
      gender: _text(json['GenderName']),
      category: _text(json['SocialCategoryName']),
      religion: _text(json['ReligionName']),
      nationality: _text(json['NationalityName']),
      fatherName: _person(json['FName']),
      motherName: _person(json['MName']),
      contactNumber: _text(json['PrimaryContactNo']),
      emergencyContactNumber: _text(json['EmergencyContactNo']),
      address: _text(json['StudentAddress']),
      city: _titleOrNull(json['CityName']),
      state: _titleOrNull(json['StateName']),
      status: _text(json['StudentStatusName']),
      photoUrl: fileUrl(_text(json['StudentPhotoPath'])),
      institutionLogoUrl: fileUrl(_text(json['BranchLogo'])),
    );
  }

  /// "2025" → "2025–26". Empty when unknown.
  static String sessionLabel(int? startYear) =>
      startYear == null ? '' : '$startYear–${((startYear + 1) % 100).toString().padLeft(2, '0')}';

  static String titleCase(String value) => ApiValues.titleCase(value);

  /// "MR.RAVI KUMAR " → "Mr. Ravi Kumar".
  static String? _person(Object? value) {
    final text = _text(value);
    if (text == null) return null;
    return titleCase(text.replaceAllMapped(RegExp(r'\.(?=\S)'), (_) => '. '));
  }

  static String? _titleOrNull(Object? value) {
    final text = _text(value);
    return text == null ? null : titleCase(text);
  }

  static String? _text(Object? value) => ApiValues.text(value);
}
