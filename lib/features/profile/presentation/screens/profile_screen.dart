import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_erp/app/theme/app_breakpoints.dart';
import 'package:school_erp/app/theme/app_spacing.dart';
import 'package:school_erp/core/localization/app_formats.dart';
import 'package:school_erp/core/localization/locale_controller.dart';
import 'package:school_erp/features/profile/domain/entities/student_profile.dart';
import 'package:school_erp/features/profile/presentation/providers/profile_providers.dart';
import 'package:school_erp/features/profile/presentation/widgets/profile_details.dart';
import 'package:school_erp/features/profile/presentation/widgets/profile_header.dart';
import 'package:school_erp/shared/states/loading_view.dart';
import 'package:school_erp/shared/states/state_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(currentStudentProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.moreProfile)),
      body: switch (student) {
        AsyncValue(:final value?) => RefreshIndicator(
          onRefresh: () => ref.refresh(currentStudentProvider.future),
          child: _ProfileContent(student: value),
        ),
        AsyncError() => ErrorStateView(onRetry: () => ref.invalidate(currentStudentProvider)),
        _ => const LoadingView(),
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.student});

  final StudentProfile student;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateOfBirth = student.dateOfBirth;
    final gutter = context.windowSize.isCompact
        ? AppSpacing.pageGutterCompact
        : AppSpacing.pageGutterExpanded;

    final sections = [
      ProfileDetailSection(
        title: l10n.profileAcademic,
        icon: Icons.school_outlined,
        rows: [
          ProfileDetail(l10n.profileRegistrationNo, student.registrationNo, copyable: true),
          ProfileDetail(l10n.profileAdmissionNo, student.admissionNo, copyable: true),
          ProfileDetail(l10n.profileClass, student.className),
          ProfileDetail(l10n.profileSection, student.section),
          ProfileDetail(l10n.profileRollNo, student.rollNo),
          ProfileDetail(l10n.profileSession, student.sessionLabel),
          ProfileDetail(l10n.profileInstitution, student.institutionName),
        ],
      ),
      ProfileDetailSection(
        title: l10n.profilePersonal,
        icon: Icons.person_outline,
        rows: [
          ProfileDetail(
            l10n.profileDateOfBirth,
            dateOfBirth == null ? null : AppFormats.of(context).date(dateOfBirth),
          ),
          ProfileDetail(l10n.profileGender, student.gender),
          ProfileDetail(l10n.profileCategory, student.category),
          ProfileDetail(l10n.profileReligion, student.religion),
          ProfileDetail(l10n.profileNationality, student.nationality),
        ],
      ),
      ProfileDetailSection(
        title: l10n.profileFamily,
        icon: Icons.family_restroom_outlined,
        rows: [
          ProfileDetail(l10n.profileFather, student.fatherName),
          ProfileDetail(l10n.profileMother, student.motherName),
        ],
      ),
      ProfileDetailSection(
        title: l10n.profileContact,
        icon: Icons.call_outlined,
        rows: [
          ProfileDetail(l10n.profilePhone, student.contactNumber, copyable: true),
          ProfileDetail(
            l10n.profileEmergencyContact,
            student.emergencyContactNumber,
            copyable: true,
          ),
          ProfileDetail(l10n.profileAddress, student.address),
          ProfileDetail(l10n.profileCity, student.city),
          ProfileDetail(l10n.profileState, student.state),
        ],
      ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(gutter, AppSpacing.sm, gutter, AppSpacing.xxl),
          children: [
            ProfileHeader(student: student),
            AppGap.lg,
            ProfileQuickFacts(student: student),
            for (final section in sections)
              if (section.hasContent) ...[AppGap.lg, section],
          ],
        ),
      ),
    );
  }
}
