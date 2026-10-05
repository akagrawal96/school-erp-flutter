// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'School ERP';

  @override
  String buildFlavorLabel(String flavor) {
    return 'Build: $flavor';
  }

  @override
  String get designPreviewTitle => 'Design system';

  @override
  String get designPreviewSubtitle => 'Colors, typography and components used across the app.';

  @override
  String get appearanceSectionTitle => 'Appearance';

  @override
  String get themeModeLabel => 'Theme';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get brandingSectionTitle => 'Institution branding';

  @override
  String get brandingSectionDescription =>
      'Each institution can apply its own brand color. Text contrast stays readable automatically.';

  @override
  String get brandingDefault => 'Default';

  @override
  String get brandingSampleGreenValley => 'Green Valley School';

  @override
  String get brandingSampleRoyalPublic => 'Royal Public School';

  @override
  String get brandingSampleSunrise => 'Sunrise Coaching';

  @override
  String get colorsSectionTitle => 'Colors';

  @override
  String get typographySectionTitle => 'Typography';

  @override
  String get typographySampleText => 'Attendance marked for Class 8-A';

  @override
  String get spacingSectionTitle => 'Spacing & corners';

  @override
  String get spacingLabel => 'Spacing';

  @override
  String get radiusLabel => 'Corner radius';

  @override
  String get componentsSectionTitle => 'Components';

  @override
  String get sampleCardTitle => 'Fee reminder';

  @override
  String get sampleCardBody =>
      'Term 2 fees are due on 15 October. Pay online to avoid late charges.';

  @override
  String get samplePrimaryAction => 'Pay now';

  @override
  String get sampleSecondaryAction => 'View details';

  @override
  String get sampleTextAction => 'Later';

  @override
  String get sampleFieldLabel => 'Student name';

  @override
  String get sampleFieldHint => 'Enter full name';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusDue => 'Due';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusNew => 'New';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionGoHome => 'Go to home';

  @override
  String get loadingLabel => 'Loading';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage =>
      'Please try again. If the problem continues, contact your institution.';

  @override
  String get errorOfflineTitle => 'You\'re offline';

  @override
  String get errorOfflineMessage => 'Check your internet connection and try again.';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundMessage => 'The page you opened doesn\'t exist or has moved.';

  @override
  String get loginWelcomeTitle => 'Welcome back';

  @override
  String get loginWelcomeSubtitle => 'Sign in with the login ID provided by your institution.';

  @override
  String get loginIdLabel => 'Login ID';

  @override
  String get loginIdHint => 'e.g. registration number';

  @override
  String get loginIdRequired => 'Enter your login ID';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginForgotPasswordHelp =>
      'Contact your institution\'s office to reset your password.';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginInvalidCredentials => 'Login ID or password is incorrect.';

  @override
  String get navHome => 'Home';

  @override
  String get navComponents => 'Components';

  @override
  String get navDesign => 'Design';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeEmptyTitle => 'Your dashboard will appear here';

  @override
  String get homeEmptyMessage =>
      'Modules enabled for your institution and role will show on this screen.';

  @override
  String get profileDemoUserName => 'Demo User';

  @override
  String get profileDemoUserRole => 'Staging preview account';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmMessage => 'You will need your login ID and password to sign in again.';

  @override
  String get galleryButtons => 'Buttons';

  @override
  String get galleryInputs => 'Inputs';

  @override
  String get galleryContent => 'Content';

  @override
  String get galleryStates => 'Screen states';

  @override
  String get galleryDialogs => 'Dialogs';

  @override
  String get galleryPrimary => 'Save';

  @override
  String get gallerySecondary => 'Export';

  @override
  String get galleryText => 'Skip';

  @override
  String get galleryDestructive => 'Delete record';

  @override
  String get galleryDisabled => 'Disabled';

  @override
  String get galleryToggleLoading => 'Show loading';

  @override
  String get galleryFieldErrorExample => 'This field is required';

  @override
  String get galleryShowDialog => 'Show confirmation dialog';

  @override
  String get galleryDialogTitle => 'Delete this record?';

  @override
  String get galleryDialogMessage => 'This action cannot be undone.';

  @override
  String get galleryDeleted => 'Record deleted';

  @override
  String get galleryEmptyTitle => 'No records yet';

  @override
  String get galleryEmptyMessage => 'Records you add will appear here.';

  @override
  String get galleryAddRecord => 'Add record';

  @override
  String get gallerySampleName => 'Ananya Sharma';

  @override
  String get galleryStatLabel => 'Attendance today';

  @override
  String get galleryStatSupporting => '+3% from yesterday';

  @override
  String get galleryCardTitle => 'Tappable card';

  @override
  String get galleryCardBody => 'Cards group related information and can open details.';

  @override
  String get navAttendance => 'Attendance';

  @override
  String get navAcademics => 'Academics';

  @override
  String get navFees => 'Fees';

  @override
  String get navMore => 'More';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String dashboardGreeting(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String studentClassRoll(String className, String section, String rollNo) {
    return 'Class $className-$section · Roll no. $rollNo';
  }

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get todayAttendanceTitle => 'Today\'s attendance';

  @override
  String get statAttendanceThisYear => 'Attendance';

  @override
  String get statAttendanceSupporting => 'This academic year';

  @override
  String get statHomeworkPending => 'Homework';

  @override
  String get statHomeworkSupporting => 'Pending this week';

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get quickTimetable => 'Timetable';

  @override
  String get quickHomework => 'Homework';

  @override
  String get quickResults => 'Results';

  @override
  String get quickNotices => 'Notices';

  @override
  String get todayClassesTitle => 'Today\'s classes';

  @override
  String get todayClassesEmpty => 'No classes today';

  @override
  String get classNow => 'Now';

  @override
  String get classDone => 'Done';

  @override
  String get latestNoticesTitle => 'Latest notices';

  @override
  String get viewAll => 'View all';

  @override
  String get comingSoonTitle => 'Designing next';

  @override
  String get comingSoonMessage =>
      'Screens for this module are being designed and will appear in an upcoming update.';

  @override
  String get attendanceStatusPresent => 'Present';

  @override
  String get attendanceStatusAbsent => 'Absent';

  @override
  String get attendanceStatusLate => 'Late';

  @override
  String get attendanceStatusHalfDay => 'Half day';

  @override
  String get attendanceStatusLeave => 'Leave';

  @override
  String get attendanceStatusHoliday => 'Holiday';

  @override
  String get attendanceStatusNotMarked => 'Not marked yet';

  @override
  String get attendanceOverallTitle => 'Overall attendance';

  @override
  String attendanceAcademicYear(String year) {
    return 'Academic year $year';
  }

  @override
  String attendanceDaysCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String attendanceWorkingDays(int count) {
    return '$count working days';
  }

  @override
  String attendanceBelowRequired(String percent) {
    return 'Below the required $percent. Regular attendance is needed to appear in exams.';
  }

  @override
  String attendanceRequired(String percent) {
    return 'Required: $percent';
  }

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get attendanceAbsencesTitle => 'Absences and late arrivals';

  @override
  String get attendanceNoAbsences => 'Full attendance this month. Well done!';

  @override
  String get attendanceMonthNoData => 'No attendance recorded';

  @override
  String get attendanceMonthNoDataMessage => 'Attendance for this month hasn\'t been marked yet.';

  @override
  String get attendanceRemarkLabel => 'Remark';

  @override
  String attendanceMarkedBy(String name) {
    return 'Marked by $name';
  }

  @override
  String get moreNotices => 'Notices & announcements';

  @override
  String get moreProfile => 'My profile';

  @override
  String get moreSettings => 'Settings';

  @override
  String get moreSettingsSubtitle => 'Theme and language';

  @override
  String get moreDeveloperSection => 'Developer tools (staging only)';

  @override
  String get profileStudentDetails => 'Student details';

  @override
  String get profileContactDetails => 'Parent & contact';

  @override
  String get profileAdmissionNo => 'Admission no.';

  @override
  String get profileClass => 'Class';

  @override
  String get profileRollNo => 'Roll no.';

  @override
  String get profileDateOfBirth => 'Date of birth';

  @override
  String get profileGuardian => 'Parent / guardian';

  @override
  String get profilePhone => 'Contact number';

  @override
  String get profileAddress => 'Address';

  @override
  String get profileInstitution => 'School';

  @override
  String get timetableNoClasses => 'No classes on this day';

  @override
  String get timetableNoClassesMessage => 'Enjoy your holiday!';

  @override
  String get homeworkFilterOpen => 'To do';

  @override
  String get homeworkFilterSubmitted => 'Submitted';

  @override
  String get homeworkFilterAll => 'All';

  @override
  String get homeworkStatusPending => 'Pending';

  @override
  String get homeworkStatusOverdue => 'Overdue';

  @override
  String get homeworkStatusSubmitted => 'Submitted';

  @override
  String get homeworkStatusReviewed => 'Reviewed';

  @override
  String get homeworkDueToday => 'Due today';

  @override
  String get homeworkDueTomorrow => 'Due tomorrow';

  @override
  String homeworkDueOn(String date) {
    return 'Due $date';
  }

  @override
  String homeworkWasDue(String date) {
    return 'Was due $date';
  }

  @override
  String get homeworkEmptyOpen => 'Nothing to do';

  @override
  String get homeworkEmptyOpenMessage => 'You\'re all caught up. New homework will appear here.';

  @override
  String get homeworkEmpty => 'No homework yet';

  @override
  String homeworkAssignedBy(String teacher, String date) {
    return 'By $teacher · Assigned $date';
  }

  @override
  String get homeworkInstructions => 'Instructions';

  @override
  String get homeworkTeacherFiles => 'Attached by teacher';

  @override
  String get homeworkYourSubmission => 'Your submission';

  @override
  String get homeworkAnswerLabel => 'Your answer (optional)';

  @override
  String get homeworkAnswerHint => 'Write your answer or a note for your teacher';

  @override
  String get homeworkAddAttachment => 'Add photo or file';

  @override
  String get homeworkAttachmentCamera => 'Take photo';

  @override
  String get homeworkAttachmentGallery => 'Choose from gallery';

  @override
  String get homeworkAttachmentDocument => 'Choose document';

  @override
  String get homeworkAttachmentDemoNote =>
      'Demo mode: a sample file is attached. Real camera and file picking arrive with the homework API.';

  @override
  String homeworkRemoveAttachment(String name) {
    return 'Remove $name';
  }

  @override
  String get homeworkSubmit => 'Submit homework';

  @override
  String get homeworkSubmitConfirmTitle => 'Submit homework?';

  @override
  String get homeworkSubmitConfirmMessage => 'You can\'t edit your submission after submitting.';

  @override
  String get homeworkSubmitNeedsContent => 'Add an answer or at least one file.';

  @override
  String get homeworkSubmitted => 'Homework submitted';

  @override
  String homeworkSubmittedOn(String date) {
    return 'Submitted $date';
  }

  @override
  String get homeworkTeacherFeedback => 'Teacher\'s feedback';

  @override
  String homeworkMarks(String marks) {
    return 'Marks: $marks';
  }

  @override
  String get resultsEmpty => 'No results published yet';

  @override
  String get resultsEmptyMessage => 'Results appear here once your school publishes them.';

  @override
  String resultGrade(String grade) {
    return 'Grade $grade';
  }

  @override
  String get resultPassed => 'Passed';

  @override
  String get resultNeedsImprovement => 'Needs improvement';

  @override
  String resultRank(int rank, int total) {
    return 'Rank $rank of $total';
  }

  @override
  String resultPublishedOn(String date) {
    return 'Published $date';
  }

  @override
  String get reportCardTitle => 'Report card';

  @override
  String get reportCardSubjects => 'Subject-wise marks';

  @override
  String get reportCardSubject => 'Subject';

  @override
  String get reportCardMarks => 'Marks';

  @override
  String get reportCardGrade => 'Grade';

  @override
  String get reportCardTotal => 'Total';

  @override
  String get reportCardRemark => 'Class teacher\'s remark';

  @override
  String get reportCardDownload => 'Download report card';

  @override
  String get reportCardDownloadPending =>
      'Download will be available once the results API is connected.';

  @override
  String get feesStatusPaid => 'Paid';

  @override
  String get feesNoPaymentsYet => 'No payments yet';

  @override
  String get feesReceipt => 'Receipt';

  @override
  String get feesReceiptNo => 'Receipt no.';

  @override
  String get feesPaidOn => 'Paid on';

  @override
  String get feesPaymentMode => 'Payment mode';

  @override
  String get feesStudent => 'Student';

  @override
  String get feesAmountPaid => 'Amount paid';

  @override
  String get feesModeCheque => 'Cheque';

  @override
  String studentClassSection(String className, String section) {
    return '$className · Section $section';
  }

  @override
  String studentRollNo(String rollNo) {
    return 'Roll no. $rollNo';
  }

  @override
  String get loginUnavailable => 'Sign-in isn\'t available in this build yet.';

  @override
  String get loginTagline => 'Attendance, homework, fees and results — all in one place.';

  @override
  String get loginSignInTitle => 'Sign in to continue';

  @override
  String get loginIdHintRegistration => 'Registration number, e.g. ABC-123';

  @override
  String get loginHelp => 'Trouble signing in? Contact your school office.';

  @override
  String get profileAcademic => 'Academic details';

  @override
  String get profilePersonal => 'Personal details';

  @override
  String get profileFamily => 'Family';

  @override
  String get profileContact => 'Contact';

  @override
  String get profileRegistrationNo => 'Registration no.';

  @override
  String get profileSection => 'Section';

  @override
  String get profileSession => 'Session';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileCategory => 'Category';

  @override
  String get profileReligion => 'Religion';

  @override
  String get profileNationality => 'Nationality';

  @override
  String get profileFather => 'Father\'s name';

  @override
  String get profileMother => 'Mother\'s name';

  @override
  String get profileEmergencyContact => 'Emergency contact';

  @override
  String get profileCity => 'City';

  @override
  String get profileState => 'State';

  @override
  String profileCopy(String label) {
    return 'Copy $label';
  }

  @override
  String profileCopied(String label) {
    return '$label copied';
  }

  @override
  String feesPaidInSession(String session) {
    return 'Paid in $session';
  }

  @override
  String get feesTotalFee => 'Total fee';

  @override
  String get feesConcession => 'Concession';

  @override
  String get feesBalance => 'Balance';

  @override
  String feesLastPayment(String amount, String date) {
    return 'Last payment $amount on $date';
  }

  @override
  String feesBalanceWarning(String amount) {
    return '$amount is still to be paid. Please contact the school office.';
  }

  @override
  String get feesDishonouredWarning =>
      'A cheque was returned by the bank. It is not counted as paid.';

  @override
  String get feesMonthsPaid => 'Months paid';

  @override
  String feesMonthsPaidCount(String paid, String total) {
    return '$paid of $total months';
  }

  @override
  String feesMonthPaid(String month) {
    return '$month: paid';
  }

  @override
  String feesMonthNotPaid(String month) {
    return '$month: no payment';
  }

  @override
  String get feesPayments => 'Payments';

  @override
  String get feesNoPaymentsMessage =>
      'Fee payments recorded by the school office will appear here.';

  @override
  String feesReceiptNumber(String number) {
    return 'Receipt $number';
  }

  @override
  String get feesFeePayment => 'Fee payment';

  @override
  String feesBalanceChip(String amount) {
    return '$amount balance';
  }

  @override
  String get feesDishonoured => 'Cheque returned';

  @override
  String get feesFeeReceipt => 'Fee receipt';

  @override
  String get feesRecordedOn => 'Recorded on';

  @override
  String get feesPeriod => 'For';

  @override
  String get feesFeeAmount => 'Fee amount';

  @override
  String get feesSettlesEarlier =>
      'This payment clears the remaining amount of an earlier receipt for the same period.';

  @override
  String feesChequeDetails(String number, String date) {
    return '$number, dated $date';
  }

  @override
  String get feesRemarks => 'Remarks';

  @override
  String get feesReceiptNotFound => 'This receipt is not available.';

  @override
  String get feesOfficeNote =>
      'Payments are recorded by the school office. For any correction, please contact the office.';

  @override
  String get statFeesPaid => 'Fees paid';

  @override
  String get statFeesBalance => 'Fee balance';

  @override
  String statFeesLastPaid(String date) {
    return 'Last paid $date';
  }

  @override
  String statFeesPaidSoFar(String amount) {
    return '$amount paid so far';
  }

  @override
  String get noticesEmptyTitle => 'No notices yet';

  @override
  String get noticesEmptyMessage => 'Notices and announcements from the school will appear here.';

  @override
  String get noticeHoliday => 'Holiday';

  @override
  String get noticeAttachment => 'Open attachment';

  @override
  String get noticeVideo => 'Watch video';

  @override
  String get noticeNotFound => 'This notice is no longer available.';

  @override
  String get noticesLoadMore => 'Show older notices';

  @override
  String get noticesLoadMoreFailed => 'Couldn\'t load older notices. Tap to try again.';

  @override
  String get noticeDetailTitle => 'Notice';

  @override
  String get linkOpenFailed => 'Couldn\'t open the link.';

  @override
  String get loginRememberMe => 'Remember me';

  @override
  String get loginSessionExpired => 'Your session has ended. Please sign in again.';

  @override
  String get feesBreakdown => 'Fee details';

  @override
  String get feesBreakdownFailed => 'Couldn\'t load the fee details.';

  @override
  String feesHeadConcession(String amount) {
    return '$amount concession';
  }

  @override
  String feesHeadCharged(String amount) {
    return 'Fee $amount';
  }

  @override
  String get feesTotal => 'Total';
}
