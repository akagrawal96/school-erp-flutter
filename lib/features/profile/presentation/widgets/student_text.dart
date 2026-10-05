import 'package:school_erp/features/profile/domain/entities/student_profile.dart';
import 'package:school_erp/l10n/generated/app_localizations.dart';

/// "Class 8 · Section A · Roll no. 14", leaving out whatever is unknown.
String studentSubtitle(AppLocalizations l10n, StudentProfile student) => [
  if (student.className.isNotEmpty)
    student.section.isEmpty
        ? student.className
        : l10n.studentClassSection(student.className, student.section),
  if (student.rollNo case final rollNo?) l10n.studentRollNo(rollNo),
].join(' · ');
