import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('hi')];

  /// Application name shown in the task switcher and title bars.
  ///
  /// In en, this message translates to:
  /// **'School ERP'**
  String get appTitle;

  /// Shows the active build flavor on non-production builds.
  ///
  /// In en, this message translates to:
  /// **'Build: {flavor}'**
  String buildFlavorLabel(String flavor);

  /// No description provided for @designPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Design system'**
  String get designPreviewTitle;

  /// No description provided for @designPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Colors, typography and components used across the app.'**
  String get designPreviewSubtitle;

  /// No description provided for @appearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSectionTitle;

  /// No description provided for @themeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeModeLabel;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// Language name, always written in its own script.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Language name, always written in its own script.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @brandingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Institution branding'**
  String get brandingSectionTitle;

  /// No description provided for @brandingSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Each institution can apply its own brand color. Text contrast stays readable automatically.'**
  String get brandingSectionDescription;

  /// No description provided for @brandingDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get brandingDefault;

  /// No description provided for @brandingSampleGreenValley.
  ///
  /// In en, this message translates to:
  /// **'Green Valley School'**
  String get brandingSampleGreenValley;

  /// No description provided for @brandingSampleRoyalPublic.
  ///
  /// In en, this message translates to:
  /// **'Royal Public School'**
  String get brandingSampleRoyalPublic;

  /// No description provided for @brandingSampleSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise Coaching'**
  String get brandingSampleSunrise;

  /// No description provided for @colorsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colorsSectionTitle;

  /// No description provided for @typographySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get typographySectionTitle;

  /// No description provided for @typographySampleText.
  ///
  /// In en, this message translates to:
  /// **'Attendance marked for Class 8-A'**
  String get typographySampleText;

  /// No description provided for @spacingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Spacing & corners'**
  String get spacingSectionTitle;

  /// No description provided for @spacingLabel.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get spacingLabel;

  /// No description provided for @radiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Corner radius'**
  String get radiusLabel;

  /// No description provided for @componentsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get componentsSectionTitle;

  /// No description provided for @sampleCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Fee reminder'**
  String get sampleCardTitle;

  /// No description provided for @sampleCardBody.
  ///
  /// In en, this message translates to:
  /// **'Term 2 fees are due on 15 October. Pay online to avoid late charges.'**
  String get sampleCardBody;

  /// No description provided for @samplePrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get samplePrimaryAction;

  /// No description provided for @sampleSecondaryAction.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get sampleSecondaryAction;

  /// No description provided for @sampleTextAction.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get sampleTextAction;

  /// No description provided for @sampleFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Student name'**
  String get sampleFieldLabel;

  /// No description provided for @sampleFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get sampleFieldHint;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get statusDue;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNew;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get actionGoHome;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loadingLabel;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try again. If the problem continues, contact your institution.'**
  String get errorGenericMessage;

  /// No description provided for @errorOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get errorOfflineTitle;

  /// No description provided for @errorOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get errorOfflineMessage;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The page you opened doesn\'t exist or has moved.'**
  String get notFoundMessage;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the login ID provided by your institution.'**
  String get loginWelcomeSubtitle;

  /// No description provided for @loginIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Login ID'**
  String get loginIdLabel;

  /// No description provided for @loginIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. registration number'**
  String get loginIdHint;

  /// No description provided for @loginIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your login ID'**
  String get loginIdRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordRequired;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginForgotPasswordHelp.
  ///
  /// In en, this message translates to:
  /// **'Contact your institution\'s office to reset your password.'**
  String get loginForgotPasswordHelp;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Login ID or password is incorrect.'**
  String get loginInvalidCredentials;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get navComponents;

  /// No description provided for @navDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get navDesign;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your dashboard will appear here'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Modules enabled for your institution and role will show on this screen.'**
  String get homeEmptyMessage;

  /// No description provided for @profileDemoUserName.
  ///
  /// In en, this message translates to:
  /// **'Demo User'**
  String get profileDemoUserName;

  /// No description provided for @profileDemoUserRole.
  ///
  /// In en, this message translates to:
  /// **'Staging preview account'**
  String get profileDemoUserRole;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need your login ID and password to sign in again.'**
  String get signOutConfirmMessage;

  /// No description provided for @galleryButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get galleryButtons;

  /// No description provided for @galleryInputs.
  ///
  /// In en, this message translates to:
  /// **'Inputs'**
  String get galleryInputs;

  /// No description provided for @galleryContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get galleryContent;

  /// No description provided for @galleryStates.
  ///
  /// In en, this message translates to:
  /// **'Screen states'**
  String get galleryStates;

  /// No description provided for @galleryDialogs.
  ///
  /// In en, this message translates to:
  /// **'Dialogs'**
  String get galleryDialogs;

  /// No description provided for @galleryPrimary.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get galleryPrimary;

  /// No description provided for @gallerySecondary.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get gallerySecondary;

  /// No description provided for @galleryText.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get galleryText;

  /// No description provided for @galleryDestructive.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get galleryDestructive;

  /// No description provided for @galleryDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get galleryDisabled;

  /// No description provided for @galleryToggleLoading.
  ///
  /// In en, this message translates to:
  /// **'Show loading'**
  String get galleryToggleLoading;

  /// No description provided for @galleryFieldErrorExample.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get galleryFieldErrorExample;

  /// No description provided for @galleryShowDialog.
  ///
  /// In en, this message translates to:
  /// **'Show confirmation dialog'**
  String get galleryShowDialog;

  /// No description provided for @galleryDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get galleryDialogTitle;

  /// No description provided for @galleryDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get galleryDialogMessage;

  /// No description provided for @galleryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get galleryDeleted;

  /// No description provided for @galleryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get galleryEmptyTitle;

  /// No description provided for @galleryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Records you add will appear here.'**
  String get galleryEmptyMessage;

  /// No description provided for @galleryAddRecord.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get galleryAddRecord;

  /// No description provided for @gallerySampleName.
  ///
  /// In en, this message translates to:
  /// **'Ananya Sharma'**
  String get gallerySampleName;

  /// No description provided for @galleryStatLabel.
  ///
  /// In en, this message translates to:
  /// **'Attendance today'**
  String get galleryStatLabel;

  /// No description provided for @galleryStatSupporting.
  ///
  /// In en, this message translates to:
  /// **'+3% from yesterday'**
  String get galleryStatSupporting;

  /// No description provided for @galleryCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Tappable card'**
  String get galleryCardTitle;

  /// No description provided for @galleryCardBody.
  ///
  /// In en, this message translates to:
  /// **'Cards group related information and can open details.'**
  String get galleryCardBody;

  /// No description provided for @navAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get navAttendance;

  /// No description provided for @navAcademics.
  ///
  /// In en, this message translates to:
  /// **'Academics'**
  String get navAcademics;

  /// No description provided for @navFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get navFees;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @dashboardGreeting.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String dashboardGreeting(String greeting, String name);

  /// No description provided for @studentClassRoll.
  ///
  /// In en, this message translates to:
  /// **'Class {className}-{section} · Roll no. {rollNo}'**
  String studentClassRoll(String className, String section, String rollNo);

  /// No description provided for @notificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// No description provided for @todayAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s attendance'**
  String get todayAttendanceTitle;

  /// No description provided for @statAttendanceThisYear.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get statAttendanceThisYear;

  /// No description provided for @statAttendanceSupporting.
  ///
  /// In en, this message translates to:
  /// **'This academic year'**
  String get statAttendanceSupporting;

  /// No description provided for @statHomeworkPending.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get statHomeworkPending;

  /// No description provided for @statHomeworkSupporting.
  ///
  /// In en, this message translates to:
  /// **'Pending this week'**
  String get statHomeworkSupporting;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActionsTitle;

  /// No description provided for @quickTimetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get quickTimetable;

  /// No description provided for @quickHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get quickHomework;

  /// No description provided for @quickResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get quickResults;

  /// No description provided for @quickNotices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get quickNotices;

  /// No description provided for @todayClassesTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s classes'**
  String get todayClassesTitle;

  /// No description provided for @todayClassesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No classes today'**
  String get todayClassesEmpty;

  /// No description provided for @classNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get classNow;

  /// No description provided for @classDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get classDone;

  /// No description provided for @latestNoticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest notices'**
  String get latestNoticesTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Designing next'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Screens for this module are being designed and will appear in an upcoming update.'**
  String get comingSoonMessage;

  /// No description provided for @attendanceStatusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attendanceStatusPresent;

  /// No description provided for @attendanceStatusAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendanceStatusAbsent;

  /// No description provided for @attendanceStatusLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get attendanceStatusLate;

  /// No description provided for @attendanceStatusHalfDay.
  ///
  /// In en, this message translates to:
  /// **'Half day'**
  String get attendanceStatusHalfDay;

  /// No description provided for @attendanceStatusLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get attendanceStatusLeave;

  /// No description provided for @attendanceStatusHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get attendanceStatusHoliday;

  /// No description provided for @attendanceStatusNotMarked.
  ///
  /// In en, this message translates to:
  /// **'Not marked yet'**
  String get attendanceStatusNotMarked;

  /// No description provided for @attendanceOverallTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall attendance'**
  String get attendanceOverallTitle;

  /// No description provided for @attendanceAcademicYear.
  ///
  /// In en, this message translates to:
  /// **'Academic year {year}'**
  String attendanceAcademicYear(String year);

  /// No description provided for @attendanceDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String attendanceDaysCount(num count);

  /// No description provided for @attendanceWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'{count} working days'**
  String attendanceWorkingDays(int count);

  /// No description provided for @attendanceBelowRequired.
  ///
  /// In en, this message translates to:
  /// **'Below the required {percent}. Regular attendance is needed to appear in exams.'**
  String attendanceBelowRequired(String percent);

  /// No description provided for @attendanceRequired.
  ///
  /// In en, this message translates to:
  /// **'Required: {percent}'**
  String attendanceRequired(String percent);

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @attendanceAbsencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Absences and late arrivals'**
  String get attendanceAbsencesTitle;

  /// No description provided for @attendanceNoAbsences.
  ///
  /// In en, this message translates to:
  /// **'Full attendance this month. Well done!'**
  String get attendanceNoAbsences;

  /// No description provided for @attendanceMonthNoData.
  ///
  /// In en, this message translates to:
  /// **'No attendance recorded'**
  String get attendanceMonthNoData;

  /// No description provided for @attendanceMonthNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Attendance for this month hasn\'t been marked yet.'**
  String get attendanceMonthNoDataMessage;

  /// No description provided for @attendanceRemarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get attendanceRemarkLabel;

  /// No description provided for @attendanceMarkedBy.
  ///
  /// In en, this message translates to:
  /// **'Marked by {name}'**
  String attendanceMarkedBy(String name);

  /// No description provided for @moreNotices.
  ///
  /// In en, this message translates to:
  /// **'Notices & announcements'**
  String get moreNotices;

  /// No description provided for @moreProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get moreProfile;

  /// No description provided for @moreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreSettings;

  /// No description provided for @moreSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme and language'**
  String get moreSettingsSubtitle;

  /// No description provided for @moreDeveloperSection.
  ///
  /// In en, this message translates to:
  /// **'Developer tools (staging only)'**
  String get moreDeveloperSection;

  /// No description provided for @profileStudentDetails.
  ///
  /// In en, this message translates to:
  /// **'Student details'**
  String get profileStudentDetails;

  /// No description provided for @profileContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Parent & contact'**
  String get profileContactDetails;

  /// No description provided for @profileAdmissionNo.
  ///
  /// In en, this message translates to:
  /// **'Admission no.'**
  String get profileAdmissionNo;

  /// No description provided for @profileClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get profileClass;

  /// No description provided for @profileRollNo.
  ///
  /// In en, this message translates to:
  /// **'Roll no.'**
  String get profileRollNo;

  /// No description provided for @profileDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get profileDateOfBirth;

  /// No description provided for @profileGuardian.
  ///
  /// In en, this message translates to:
  /// **'Parent / guardian'**
  String get profileGuardian;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get profilePhone;

  /// No description provided for @profileAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddress;

  /// No description provided for @profileInstitution.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get profileInstitution;

  /// No description provided for @timetableNoClasses.
  ///
  /// In en, this message translates to:
  /// **'No classes on this day'**
  String get timetableNoClasses;

  /// No description provided for @timetableNoClassesMessage.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your holiday!'**
  String get timetableNoClassesMessage;

  /// No description provided for @homeworkFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get homeworkFilterOpen;

  /// No description provided for @homeworkFilterSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get homeworkFilterSubmitted;

  /// No description provided for @homeworkFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get homeworkFilterAll;

  /// No description provided for @homeworkStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get homeworkStatusPending;

  /// No description provided for @homeworkStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get homeworkStatusOverdue;

  /// No description provided for @homeworkStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get homeworkStatusSubmitted;

  /// No description provided for @homeworkStatusReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get homeworkStatusReviewed;

  /// No description provided for @homeworkDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get homeworkDueToday;

  /// No description provided for @homeworkDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due tomorrow'**
  String get homeworkDueTomorrow;

  /// No description provided for @homeworkDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String homeworkDueOn(String date);

  /// No description provided for @homeworkWasDue.
  ///
  /// In en, this message translates to:
  /// **'Was due {date}'**
  String homeworkWasDue(String date);

  /// No description provided for @homeworkEmptyOpen.
  ///
  /// In en, this message translates to:
  /// **'Nothing to do'**
  String get homeworkEmptyOpen;

  /// No description provided for @homeworkEmptyOpenMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up. New homework will appear here.'**
  String get homeworkEmptyOpenMessage;

  /// No description provided for @homeworkEmpty.
  ///
  /// In en, this message translates to:
  /// **'No homework yet'**
  String get homeworkEmpty;

  /// No description provided for @homeworkAssignedBy.
  ///
  /// In en, this message translates to:
  /// **'By {teacher} · Assigned {date}'**
  String homeworkAssignedBy(String teacher, String date);

  /// No description provided for @homeworkInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get homeworkInstructions;

  /// No description provided for @homeworkTeacherFiles.
  ///
  /// In en, this message translates to:
  /// **'Attached by teacher'**
  String get homeworkTeacherFiles;

  /// No description provided for @homeworkYourSubmission.
  ///
  /// In en, this message translates to:
  /// **'Your submission'**
  String get homeworkYourSubmission;

  /// No description provided for @homeworkAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your answer (optional)'**
  String get homeworkAnswerLabel;

  /// No description provided for @homeworkAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Write your answer or a note for your teacher'**
  String get homeworkAnswerHint;

  /// No description provided for @homeworkAddAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add photo or file'**
  String get homeworkAddAttachment;

  /// No description provided for @homeworkAttachmentCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get homeworkAttachmentCamera;

  /// No description provided for @homeworkAttachmentGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get homeworkAttachmentGallery;

  /// No description provided for @homeworkAttachmentDocument.
  ///
  /// In en, this message translates to:
  /// **'Choose document'**
  String get homeworkAttachmentDocument;

  /// No description provided for @homeworkAttachmentDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: a sample file is attached. Real camera and file picking arrive with the homework API.'**
  String get homeworkAttachmentDemoNote;

  /// No description provided for @homeworkRemoveAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String homeworkRemoveAttachment(String name);

  /// No description provided for @homeworkSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit homework'**
  String get homeworkSubmit;

  /// No description provided for @homeworkSubmitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit homework?'**
  String get homeworkSubmitConfirmTitle;

  /// No description provided for @homeworkSubmitConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You can\'t edit your submission after submitting.'**
  String get homeworkSubmitConfirmMessage;

  /// No description provided for @homeworkSubmitNeedsContent.
  ///
  /// In en, this message translates to:
  /// **'Add an answer or at least one file.'**
  String get homeworkSubmitNeedsContent;

  /// No description provided for @homeworkSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Homework submitted'**
  String get homeworkSubmitted;

  /// No description provided for @homeworkSubmittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted {date}'**
  String homeworkSubmittedOn(String date);

  /// No description provided for @homeworkTeacherFeedback.
  ///
  /// In en, this message translates to:
  /// **'Teacher\'s feedback'**
  String get homeworkTeacherFeedback;

  /// No description provided for @homeworkMarks.
  ///
  /// In en, this message translates to:
  /// **'Marks: {marks}'**
  String homeworkMarks(String marks);

  /// No description provided for @resultsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No results published yet'**
  String get resultsEmpty;

  /// No description provided for @resultsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Results appear here once your school publishes them.'**
  String get resultsEmptyMessage;

  /// No description provided for @resultGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade}'**
  String resultGrade(String grade);

  /// No description provided for @resultPassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get resultPassed;

  /// No description provided for @resultNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get resultNeedsImprovement;

  /// No description provided for @resultRank.
  ///
  /// In en, this message translates to:
  /// **'Rank {rank} of {total}'**
  String resultRank(int rank, int total);

  /// No description provided for @resultPublishedOn.
  ///
  /// In en, this message translates to:
  /// **'Published {date}'**
  String resultPublishedOn(String date);

  /// No description provided for @reportCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Report card'**
  String get reportCardTitle;

  /// No description provided for @reportCardSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subject-wise marks'**
  String get reportCardSubjects;

  /// No description provided for @reportCardSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get reportCardSubject;

  /// No description provided for @reportCardMarks.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get reportCardMarks;

  /// No description provided for @reportCardGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get reportCardGrade;

  /// No description provided for @reportCardTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reportCardTotal;

  /// No description provided for @reportCardRemark.
  ///
  /// In en, this message translates to:
  /// **'Class teacher\'s remark'**
  String get reportCardRemark;

  /// No description provided for @reportCardDownload.
  ///
  /// In en, this message translates to:
  /// **'Download report card'**
  String get reportCardDownload;

  /// No description provided for @reportCardDownloadPending.
  ///
  /// In en, this message translates to:
  /// **'Download will be available once the results API is connected.'**
  String get reportCardDownloadPending;

  /// No description provided for @feesStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get feesStatusPaid;

  /// No description provided for @feesNoPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get feesNoPaymentsYet;

  /// No description provided for @feesReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get feesReceipt;

  /// No description provided for @feesReceiptNo.
  ///
  /// In en, this message translates to:
  /// **'Receipt no.'**
  String get feesReceiptNo;

  /// No description provided for @feesPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get feesPaidOn;

  /// No description provided for @feesPaymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment mode'**
  String get feesPaymentMode;

  /// No description provided for @feesStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get feesStudent;

  /// No description provided for @feesAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get feesAmountPaid;

  /// No description provided for @feesModeCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get feesModeCheque;

  /// No description provided for @studentClassSection.
  ///
  /// In en, this message translates to:
  /// **'{className} · Section {section}'**
  String studentClassSection(String className, String section);

  /// No description provided for @studentRollNo.
  ///
  /// In en, this message translates to:
  /// **'Roll no. {rollNo}'**
  String studentRollNo(String rollNo);

  /// No description provided for @loginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sign-in isn\'t available in this build yet.'**
  String get loginUnavailable;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Attendance, homework, fees and results — all in one place.'**
  String get loginTagline;

  /// No description provided for @loginSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSignInTitle;

  /// No description provided for @loginIdHintRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration number, e.g. ABC-123'**
  String get loginIdHintRegistration;

  /// No description provided for @loginHelp.
  ///
  /// In en, this message translates to:
  /// **'Trouble signing in? Contact your school office.'**
  String get loginHelp;

  /// No description provided for @profileAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic details'**
  String get profileAcademic;

  /// No description provided for @profilePersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get profilePersonal;

  /// No description provided for @profileFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get profileFamily;

  /// No description provided for @profileContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get profileContact;

  /// No description provided for @profileRegistrationNo.
  ///
  /// In en, this message translates to:
  /// **'Registration no.'**
  String get profileRegistrationNo;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get profileSection;

  /// No description provided for @profileSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get profileSession;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get profileCategory;

  /// No description provided for @profileReligion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get profileReligion;

  /// No description provided for @profileNationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get profileNationality;

  /// No description provided for @profileFather.
  ///
  /// In en, this message translates to:
  /// **'Father\'s name'**
  String get profileFather;

  /// No description provided for @profileMother.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s name'**
  String get profileMother;

  /// No description provided for @profileEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get profileEmergencyContact;

  /// No description provided for @profileCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileCity;

  /// No description provided for @profileState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get profileState;

  /// No description provided for @profileCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy {label}'**
  String profileCopy(String label);

  /// No description provided for @profileCopied.
  ///
  /// In en, this message translates to:
  /// **'{label} copied'**
  String profileCopied(String label);

  /// No description provided for @feesPaidInSession.
  ///
  /// In en, this message translates to:
  /// **'Paid in {session}'**
  String feesPaidInSession(String session);

  /// No description provided for @feesTotalFee.
  ///
  /// In en, this message translates to:
  /// **'Total fee'**
  String get feesTotalFee;

  /// No description provided for @feesConcession.
  ///
  /// In en, this message translates to:
  /// **'Concession'**
  String get feesConcession;

  /// No description provided for @feesBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get feesBalance;

  /// No description provided for @feesLastPayment.
  ///
  /// In en, this message translates to:
  /// **'Last payment {amount} on {date}'**
  String feesLastPayment(String amount, String date);

  /// No description provided for @feesBalanceWarning.
  ///
  /// In en, this message translates to:
  /// **'{amount} is still to be paid. Please contact the school office.'**
  String feesBalanceWarning(String amount);

  /// No description provided for @feesDishonouredWarning.
  ///
  /// In en, this message translates to:
  /// **'A cheque was returned by the bank. It is not counted as paid.'**
  String get feesDishonouredWarning;

  /// No description provided for @feesMonthsPaid.
  ///
  /// In en, this message translates to:
  /// **'Months paid'**
  String get feesMonthsPaid;

  /// No description provided for @feesMonthsPaidCount.
  ///
  /// In en, this message translates to:
  /// **'{paid} of {total} months'**
  String feesMonthsPaidCount(String paid, String total);

  /// No description provided for @feesMonthPaid.
  ///
  /// In en, this message translates to:
  /// **'{month}: paid'**
  String feesMonthPaid(String month);

  /// No description provided for @feesMonthNotPaid.
  ///
  /// In en, this message translates to:
  /// **'{month}: no payment'**
  String feesMonthNotPaid(String month);

  /// No description provided for @feesPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get feesPayments;

  /// No description provided for @feesNoPaymentsMessage.
  ///
  /// In en, this message translates to:
  /// **'Fee payments recorded by the school office will appear here.'**
  String get feesNoPaymentsMessage;

  /// No description provided for @feesReceiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt {number}'**
  String feesReceiptNumber(String number);

  /// No description provided for @feesFeePayment.
  ///
  /// In en, this message translates to:
  /// **'Fee payment'**
  String get feesFeePayment;

  /// No description provided for @feesBalanceChip.
  ///
  /// In en, this message translates to:
  /// **'{amount} balance'**
  String feesBalanceChip(String amount);

  /// No description provided for @feesDishonoured.
  ///
  /// In en, this message translates to:
  /// **'Cheque returned'**
  String get feesDishonoured;

  /// No description provided for @feesFeeReceipt.
  ///
  /// In en, this message translates to:
  /// **'Fee receipt'**
  String get feesFeeReceipt;

  /// No description provided for @feesRecordedOn.
  ///
  /// In en, this message translates to:
  /// **'Recorded on'**
  String get feesRecordedOn;

  /// No description provided for @feesPeriod.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get feesPeriod;

  /// No description provided for @feesFeeAmount.
  ///
  /// In en, this message translates to:
  /// **'Fee amount'**
  String get feesFeeAmount;

  /// No description provided for @feesSettlesEarlier.
  ///
  /// In en, this message translates to:
  /// **'This payment clears the remaining amount of an earlier receipt for the same period.'**
  String get feesSettlesEarlier;

  /// No description provided for @feesChequeDetails.
  ///
  /// In en, this message translates to:
  /// **'{number}, dated {date}'**
  String feesChequeDetails(String number, String date);

  /// No description provided for @feesRemarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get feesRemarks;

  /// No description provided for @feesReceiptNotFound.
  ///
  /// In en, this message translates to:
  /// **'This receipt is not available.'**
  String get feesReceiptNotFound;

  /// No description provided for @feesOfficeNote.
  ///
  /// In en, this message translates to:
  /// **'Payments are recorded by the school office. For any correction, please contact the office.'**
  String get feesOfficeNote;

  /// No description provided for @statFeesPaid.
  ///
  /// In en, this message translates to:
  /// **'Fees paid'**
  String get statFeesPaid;

  /// No description provided for @statFeesBalance.
  ///
  /// In en, this message translates to:
  /// **'Fee balance'**
  String get statFeesBalance;

  /// No description provided for @statFeesLastPaid.
  ///
  /// In en, this message translates to:
  /// **'Last paid {date}'**
  String statFeesLastPaid(String date);

  /// No description provided for @statFeesPaidSoFar.
  ///
  /// In en, this message translates to:
  /// **'{amount} paid so far'**
  String statFeesPaidSoFar(String amount);

  /// No description provided for @noticesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notices yet'**
  String get noticesEmptyTitle;

  /// No description provided for @noticesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Notices and announcements from the school will appear here.'**
  String get noticesEmptyMessage;

  /// No description provided for @noticeHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get noticeHoliday;

  /// No description provided for @noticeAttachment.
  ///
  /// In en, this message translates to:
  /// **'Open attachment'**
  String get noticeAttachment;

  /// No description provided for @noticeVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch video'**
  String get noticeVideo;

  /// No description provided for @noticeNotFound.
  ///
  /// In en, this message translates to:
  /// **'This notice is no longer available.'**
  String get noticeNotFound;

  /// No description provided for @noticesLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Show older notices'**
  String get noticesLoadMore;

  /// No description provided for @noticesLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load older notices. Tap to try again.'**
  String get noticesLoadMoreFailed;

  /// No description provided for @noticeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get noticeDetailTitle;

  /// No description provided for @linkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link.'**
  String get linkOpenFailed;

  /// No description provided for @loginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get loginRememberMe;

  /// No description provided for @loginSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get loginSessionExpired;

  /// No description provided for @feesBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Fee details'**
  String get feesBreakdown;

  /// No description provided for @feesBreakdownFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the fee details.'**
  String get feesBreakdownFailed;

  /// No description provided for @feesHeadConcession.
  ///
  /// In en, this message translates to:
  /// **'{amount} concession'**
  String feesHeadConcession(String amount);

  /// No description provided for @feesHeadCharged.
  ///
  /// In en, this message translates to:
  /// **'Fee {amount}'**
  String feesHeadCharged(String amount);

  /// No description provided for @feesTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get feesTotal;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
