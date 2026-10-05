// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'स्कूल ईआरपी';

  @override
  String buildFlavorLabel(String flavor) {
    return 'बिल्ड: $flavor';
  }

  @override
  String get designPreviewTitle => 'डिज़ाइन सिस्टम';

  @override
  String get designPreviewSubtitle => 'ऐप में उपयोग होने वाले रंग, टाइपोग्राफ़ी और कंपोनेंट।';

  @override
  String get appearanceSectionTitle => 'रूप-रंग';

  @override
  String get themeModeLabel => 'थीम';

  @override
  String get themeModeSystem => 'सिस्टम';

  @override
  String get themeModeLight => 'लाइट';

  @override
  String get themeModeDark => 'डार्क';

  @override
  String get languageLabel => 'भाषा';

  @override
  String get languageSystem => 'सिस्टम';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get brandingSectionTitle => 'संस्थान ब्रांडिंग';

  @override
  String get brandingSectionDescription =>
      'हर संस्थान अपना ब्रांड रंग लागू कर सकता है। टेक्स्ट अपने-आप पढ़ने योग्य बना रहता है।';

  @override
  String get brandingDefault => 'डिफ़ॉल्ट';

  @override
  String get brandingSampleGreenValley => 'ग्रीन वैली स्कूल';

  @override
  String get brandingSampleRoyalPublic => 'रॉयल पब्लिक स्कूल';

  @override
  String get brandingSampleSunrise => 'सनराइज़ कोचिंग';

  @override
  String get colorsSectionTitle => 'रंग';

  @override
  String get typographySectionTitle => 'टाइपोग्राफ़ी';

  @override
  String get typographySampleText => 'कक्षा 8-अ की उपस्थिति दर्ज की गई';

  @override
  String get spacingSectionTitle => 'स्पेसिंग और कोने';

  @override
  String get spacingLabel => 'स्पेसिंग';

  @override
  String get radiusLabel => 'कोनों की गोलाई';

  @override
  String get componentsSectionTitle => 'कंपोनेंट';

  @override
  String get sampleCardTitle => 'शुल्क अनुस्मारक';

  @override
  String get sampleCardBody =>
      'सत्र 2 का शुल्क 15 अक्टूबर तक देय है। विलंब शुल्क से बचने के लिए ऑनलाइन भुगतान करें।';

  @override
  String get samplePrimaryAction => 'अभी भुगतान करें';

  @override
  String get sampleSecondaryAction => 'विवरण देखें';

  @override
  String get sampleTextAction => 'बाद में';

  @override
  String get sampleFieldLabel => 'छात्र का नाम';

  @override
  String get sampleFieldHint => 'पूरा नाम दर्ज करें';

  @override
  String get statusPaid => 'भुगतान हो गया';

  @override
  String get statusDue => 'देय';

  @override
  String get statusOverdue => 'बकाया';

  @override
  String get statusNew => 'नया';

  @override
  String get actionRetry => 'फिर से कोशिश करें';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionConfirm => 'पुष्टि करें';

  @override
  String get actionGoHome => 'होम पर जाएं';

  @override
  String get loadingLabel => 'लोड हो रहा है';

  @override
  String get showPassword => 'पासवर्ड दिखाएं';

  @override
  String get hidePassword => 'पासवर्ड छिपाएं';

  @override
  String get errorGenericTitle => 'कुछ गलत हो गया';

  @override
  String get errorGenericMessage =>
      'कृपया फिर से कोशिश करें। समस्या बनी रहे तो अपने संस्थान से संपर्क करें।';

  @override
  String get errorOfflineTitle => 'आप ऑफ़लाइन हैं';

  @override
  String get errorOfflineMessage => 'अपना इंटरनेट कनेक्शन जांचें और फिर से कोशिश करें।';

  @override
  String get notFoundTitle => 'पेज नहीं मिला';

  @override
  String get notFoundMessage => 'आपके द्वारा खोला गया पेज मौजूद नहीं है या हटा दिया गया है।';

  @override
  String get loginWelcomeTitle => 'फिर से स्वागत है';

  @override
  String get loginWelcomeSubtitle => 'अपने संस्थान द्वारा दी गई लॉगिन आईडी से साइन इन करें।';

  @override
  String get loginIdLabel => 'लॉगिन आईडी';

  @override
  String get loginIdHint => 'जैसे पंजीकरण संख्या';

  @override
  String get loginIdRequired => 'अपनी लॉगिन आईडी दर्ज करें';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get passwordRequired => 'अपना पासवर्ड दर्ज करें';

  @override
  String get loginForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get loginForgotPasswordHelp =>
      'पासवर्ड रीसेट करने के लिए अपने संस्थान के कार्यालय से संपर्क करें।';

  @override
  String get loginSubmit => 'साइन इन करें';

  @override
  String get loginInvalidCredentials => 'लॉगिन आईडी या पासवर्ड गलत है।';

  @override
  String get navHome => 'होम';

  @override
  String get navComponents => 'कंपोनेंट';

  @override
  String get navDesign => 'डिज़ाइन';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get homeEmptyTitle => 'आपका डैशबोर्ड यहां दिखाई देगा';

  @override
  String get homeEmptyMessage =>
      'आपके संस्थान और भूमिका के लिए चालू मॉड्यूल इस स्क्रीन पर दिखेंगे।';

  @override
  String get profileDemoUserName => 'डेमो उपयोगकर्ता';

  @override
  String get profileDemoUserRole => 'स्टेजिंग पूर्वावलोकन खाता';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signOutConfirmTitle => 'साइन आउट करें?';

  @override
  String get signOutConfirmMessage =>
      'फिर से साइन इन करने के लिए आपको अपनी लॉगिन आईडी और पासवर्ड की ज़रूरत होगी।';

  @override
  String get galleryButtons => 'बटन';

  @override
  String get galleryInputs => 'इनपुट';

  @override
  String get galleryContent => 'कंटेंट';

  @override
  String get galleryStates => 'स्क्रीन स्थितियां';

  @override
  String get galleryDialogs => 'डायलॉग';

  @override
  String get galleryPrimary => 'सेव करें';

  @override
  String get gallerySecondary => 'एक्सपोर्ट करें';

  @override
  String get galleryText => 'छोड़ें';

  @override
  String get galleryDestructive => 'रिकॉर्ड हटाएं';

  @override
  String get galleryDisabled => 'अक्षम';

  @override
  String get galleryToggleLoading => 'लोडिंग दिखाएं';

  @override
  String get galleryFieldErrorExample => 'यह फ़ील्ड आवश्यक है';

  @override
  String get galleryShowDialog => 'पुष्टि डायलॉग दिखाएं';

  @override
  String get galleryDialogTitle => 'यह रिकॉर्ड हटाएं?';

  @override
  String get galleryDialogMessage => 'यह कार्रवाई वापस नहीं की जा सकती।';

  @override
  String get galleryDeleted => 'रिकॉर्ड हटा दिया गया';

  @override
  String get galleryEmptyTitle => 'अभी कोई रिकॉर्ड नहीं';

  @override
  String get galleryEmptyMessage => 'आपके द्वारा जोड़े गए रिकॉर्ड यहां दिखेंगे।';

  @override
  String get galleryAddRecord => 'रिकॉर्ड जोड़ें';

  @override
  String get gallerySampleName => 'अनन्या शर्मा';

  @override
  String get galleryStatLabel => 'आज की उपस्थिति';

  @override
  String get galleryStatSupporting => 'कल से +3%';

  @override
  String get galleryCardTitle => 'टैप करने योग्य कार्ड';

  @override
  String get galleryCardBody => 'कार्ड संबंधित जानकारी को समूहित करते हैं और विवरण खोल सकते हैं।';

  @override
  String get navAttendance => 'उपस्थिति';

  @override
  String get navAcademics => 'पढ़ाई';

  @override
  String get navFees => 'शुल्क';

  @override
  String get navMore => 'और';

  @override
  String get greetingMorning => 'सुप्रभात';

  @override
  String get greetingAfternoon => 'नमस्कार';

  @override
  String get greetingEvening => 'शुभ संध्या';

  @override
  String dashboardGreeting(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String studentClassRoll(String className, String section, String rollNo) {
    return 'कक्षा $className-$section · रोल नं. $rollNo';
  }

  @override
  String get notificationsTooltip => 'सूचनाएं';

  @override
  String get todayAttendanceTitle => 'आज की उपस्थिति';

  @override
  String get statAttendanceThisYear => 'उपस्थिति';

  @override
  String get statAttendanceSupporting => 'इस शैक्षणिक वर्ष';

  @override
  String get statHomeworkPending => 'होमवर्क';

  @override
  String get statHomeworkSupporting => 'इस हफ़्ते बाकी';

  @override
  String get quickActionsTitle => 'त्वरित विकल्प';

  @override
  String get quickTimetable => 'समय सारणी';

  @override
  String get quickHomework => 'होमवर्क';

  @override
  String get quickResults => 'परिणाम';

  @override
  String get quickNotices => 'सूचनाएं';

  @override
  String get todayClassesTitle => 'आज की कक्षाएं';

  @override
  String get todayClassesEmpty => 'आज कोई कक्षा नहीं';

  @override
  String get classNow => 'अभी';

  @override
  String get classDone => 'पूर्ण';

  @override
  String get latestNoticesTitle => 'नई सूचनाएं';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get comingSoonTitle => 'जल्द आ रहा है';

  @override
  String get comingSoonMessage =>
      'इस मॉड्यूल की स्क्रीन डिज़ाइन की जा रही हैं और अगले अपडेट में दिखेंगी।';

  @override
  String get attendanceStatusPresent => 'उपस्थित';

  @override
  String get attendanceStatusAbsent => 'अनुपस्थित';

  @override
  String get attendanceStatusLate => 'देर से';

  @override
  String get attendanceStatusHalfDay => 'आधा दिन';

  @override
  String get attendanceStatusLeave => 'छुट्टी';

  @override
  String get attendanceStatusHoliday => 'अवकाश';

  @override
  String get attendanceStatusNotMarked => 'अभी दर्ज नहीं';

  @override
  String get attendanceOverallTitle => 'कुल उपस्थिति';

  @override
  String attendanceAcademicYear(String year) {
    return 'शैक्षणिक वर्ष $year';
  }

  @override
  String attendanceDaysCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString दिन';
  }

  @override
  String attendanceWorkingDays(int count) {
    return '$count कार्य दिवस';
  }

  @override
  String attendanceBelowRequired(String percent) {
    return 'आवश्यक $percent से कम है। परीक्षा में बैठने के लिए नियमित उपस्थिति ज़रूरी है।';
  }

  @override
  String attendanceRequired(String percent) {
    return 'आवश्यक: $percent';
  }

  @override
  String get previousMonth => 'पिछला महीना';

  @override
  String get nextMonth => 'अगला महीना';

  @override
  String get attendanceAbsencesTitle => 'अनुपस्थिति और देरी';

  @override
  String get attendanceNoAbsences => 'इस महीने पूरी उपस्थिति। शाबाश!';

  @override
  String get attendanceMonthNoData => 'कोई उपस्थिति दर्ज नहीं';

  @override
  String get attendanceMonthNoDataMessage => 'इस महीने की उपस्थिति अभी दर्ज नहीं की गई है।';

  @override
  String get attendanceRemarkLabel => 'टिप्पणी';

  @override
  String attendanceMarkedBy(String name) {
    return '$name द्वारा दर्ज';
  }

  @override
  String get moreNotices => 'सूचनाएं और घोषणाएं';

  @override
  String get moreProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get moreSettings => 'सेटिंग्स';

  @override
  String get moreSettingsSubtitle => 'थीम और भाषा';

  @override
  String get moreDeveloperSection => 'डेवलपर टूल (केवल स्टेजिंग)';

  @override
  String get profileStudentDetails => 'छात्र विवरण';

  @override
  String get profileContactDetails => 'अभिभावक और संपर्क';

  @override
  String get profileAdmissionNo => 'प्रवेश संख्या';

  @override
  String get profileClass => 'कक्षा';

  @override
  String get profileRollNo => 'रोल नं.';

  @override
  String get profileDateOfBirth => 'जन्म तिथि';

  @override
  String get profileGuardian => 'अभिभावक';

  @override
  String get profilePhone => 'संपर्क नंबर';

  @override
  String get profileAddress => 'पता';

  @override
  String get profileInstitution => 'विद्यालय';

  @override
  String get timetableNoClasses => 'इस दिन कोई कक्षा नहीं';

  @override
  String get timetableNoClassesMessage => 'छुट्टी का आनंद लें!';

  @override
  String get homeworkFilterOpen => 'करना है';

  @override
  String get homeworkFilterSubmitted => 'जमा';

  @override
  String get homeworkFilterAll => 'सभी';

  @override
  String get homeworkStatusPending => 'बाकी';

  @override
  String get homeworkStatusOverdue => 'समय निकल गया';

  @override
  String get homeworkStatusSubmitted => 'जमा किया';

  @override
  String get homeworkStatusReviewed => 'जांचा गया';

  @override
  String get homeworkDueToday => 'आज देय';

  @override
  String get homeworkDueTomorrow => 'कल देय';

  @override
  String homeworkDueOn(String date) {
    return '$date को देय';
  }

  @override
  String homeworkWasDue(String date) {
    return '$date को देय था';
  }

  @override
  String get homeworkEmptyOpen => 'कुछ बाकी नहीं';

  @override
  String get homeworkEmptyOpenMessage => 'आपका सारा काम पूरा है। नया होमवर्क यहां दिखेगा।';

  @override
  String get homeworkEmpty => 'अभी कोई होमवर्क नहीं';

  @override
  String homeworkAssignedBy(String teacher, String date) {
    return '$teacher · $date को दिया गया';
  }

  @override
  String get homeworkInstructions => 'निर्देश';

  @override
  String get homeworkTeacherFiles => 'शिक्षक द्वारा संलग्न';

  @override
  String get homeworkYourSubmission => 'आपका जमा कार्य';

  @override
  String get homeworkAnswerLabel => 'आपका उत्तर (वैकल्पिक)';

  @override
  String get homeworkAnswerHint => 'अपना उत्तर या शिक्षक के लिए संदेश लिखें';

  @override
  String get homeworkAddAttachment => 'फ़ोटो या फ़ाइल जोड़ें';

  @override
  String get homeworkAttachmentCamera => 'फ़ोटो लें';

  @override
  String get homeworkAttachmentGallery => 'गैलरी से चुनें';

  @override
  String get homeworkAttachmentDocument => 'दस्तावेज़ चुनें';

  @override
  String get homeworkAttachmentDemoNote =>
      'डेमो मोड: एक नमूना फ़ाइल जोड़ी गई है। असली कैमरा और फ़ाइल चयन होमवर्क API के साथ आएगा।';

  @override
  String homeworkRemoveAttachment(String name) {
    return '$name हटाएं';
  }

  @override
  String get homeworkSubmit => 'होमवर्क जमा करें';

  @override
  String get homeworkSubmitConfirmTitle => 'होमवर्क जमा करें?';

  @override
  String get homeworkSubmitConfirmMessage => 'जमा करने के बाद आप इसे बदल नहीं पाएंगे।';

  @override
  String get homeworkSubmitNeedsContent => 'कोई उत्तर या कम से कम एक फ़ाइल जोड़ें।';

  @override
  String get homeworkSubmitted => 'होमवर्क जमा हो गया';

  @override
  String homeworkSubmittedOn(String date) {
    return '$date को जमा किया';
  }

  @override
  String get homeworkTeacherFeedback => 'शिक्षक की प्रतिक्रिया';

  @override
  String homeworkMarks(String marks) {
    return 'अंक: $marks';
  }

  @override
  String get resultsEmpty => 'अभी कोई परिणाम घोषित नहीं';

  @override
  String get resultsEmptyMessage => 'विद्यालय द्वारा घोषित होने पर परिणाम यहां दिखेंगे।';

  @override
  String resultGrade(String grade) {
    return 'ग्रेड $grade';
  }

  @override
  String get resultPassed => 'उत्तीर्ण';

  @override
  String get resultNeedsImprovement => 'सुधार आवश्यक';

  @override
  String resultRank(int rank, int total) {
    return '$total में से रैंक $rank';
  }

  @override
  String resultPublishedOn(String date) {
    return '$date को घोषित';
  }

  @override
  String get reportCardTitle => 'रिपोर्ट कार्ड';

  @override
  String get reportCardSubjects => 'विषयवार अंक';

  @override
  String get reportCardSubject => 'विषय';

  @override
  String get reportCardMarks => 'अंक';

  @override
  String get reportCardGrade => 'ग्रेड';

  @override
  String get reportCardTotal => 'कुल';

  @override
  String get reportCardRemark => 'कक्षा शिक्षक की टिप्पणी';

  @override
  String get reportCardDownload => 'रिपोर्ट कार्ड डाउनलोड करें';

  @override
  String get reportCardDownloadPending => 'परिणाम API जुड़ने के बाद डाउनलोड उपलब्ध होगा।';

  @override
  String get feesStatusPaid => 'जमा';

  @override
  String get feesNoPaymentsYet => 'अभी कोई भुगतान नहीं';

  @override
  String get feesReceipt => 'रसीद';

  @override
  String get feesReceiptNo => 'रसीद संख्या';

  @override
  String get feesPaidOn => 'भुगतान तिथि';

  @override
  String get feesPaymentMode => 'भुगतान का तरीका';

  @override
  String get feesStudent => 'छात्र';

  @override
  String get feesAmountPaid => 'जमा राशि';

  @override
  String get feesModeCheque => 'चेक';

  @override
  String studentClassSection(String className, String section) {
    return '$className · सेक्शन $section';
  }

  @override
  String studentRollNo(String rollNo) {
    return 'रोल नं. $rollNo';
  }

  @override
  String get loginUnavailable => 'इस बिल्ड में अभी साइन इन उपलब्ध नहीं है।';

  @override
  String get loginTagline => 'उपस्थिति, होमवर्क, शुल्क और परिणाम — सब एक जगह।';

  @override
  String get loginSignInTitle => 'जारी रखने के लिए साइन इन करें';

  @override
  String get loginIdHintRegistration => 'पंजीकरण संख्या, जैसे ABC-123';

  @override
  String get loginHelp => 'साइन इन में परेशानी? अपने विद्यालय कार्यालय से संपर्क करें।';

  @override
  String get profileAcademic => 'शैक्षणिक विवरण';

  @override
  String get profilePersonal => 'व्यक्तिगत विवरण';

  @override
  String get profileFamily => 'परिवार';

  @override
  String get profileContact => 'संपर्क';

  @override
  String get profileRegistrationNo => 'पंजीकरण संख्या';

  @override
  String get profileSection => 'सेक्शन';

  @override
  String get profileSession => 'सत्र';

  @override
  String get profileGender => 'लिंग';

  @override
  String get profileCategory => 'श्रेणी';

  @override
  String get profileReligion => 'धर्म';

  @override
  String get profileNationality => 'राष्ट्रीयता';

  @override
  String get profileFather => 'पिता का नाम';

  @override
  String get profileMother => 'माता का नाम';

  @override
  String get profileEmergencyContact => 'आपातकालीन संपर्क';

  @override
  String get profileCity => 'शहर';

  @override
  String get profileState => 'राज्य';

  @override
  String profileCopy(String label) {
    return '$label कॉपी करें';
  }

  @override
  String profileCopied(String label) {
    return '$label कॉपी किया गया';
  }

  @override
  String feesPaidInSession(String session) {
    return '$session में जमा';
  }

  @override
  String get feesTotalFee => 'कुल शुल्क';

  @override
  String get feesConcession => 'छूट';

  @override
  String get feesBalance => 'बकाया';

  @override
  String feesLastPayment(String amount, String date) {
    return 'अंतिम भुगतान $amount, $date को';
  }

  @override
  String feesBalanceWarning(String amount) {
    return '$amount का भुगतान अभी बाकी है। कृपया स्कूल कार्यालय से संपर्क करें।';
  }

  @override
  String get feesDishonouredWarning => 'एक चेक बैंक से वापस आ गया है। उसे जमा नहीं माना गया है।';

  @override
  String get feesMonthsPaid => 'जमा किए गए महीने';

  @override
  String feesMonthsPaidCount(String paid, String total) {
    return '$total में से $paid महीने';
  }

  @override
  String feesMonthPaid(String month) {
    return '$month: जमा';
  }

  @override
  String feesMonthNotPaid(String month) {
    return '$month: कोई भुगतान नहीं';
  }

  @override
  String get feesPayments => 'भुगतान';

  @override
  String get feesNoPaymentsMessage => 'स्कूल कार्यालय में दर्ज शुल्क भुगतान यहाँ दिखेंगे।';

  @override
  String feesReceiptNumber(String number) {
    return 'रसीद $number';
  }

  @override
  String get feesFeePayment => 'शुल्क भुगतान';

  @override
  String feesBalanceChip(String amount) {
    return '$amount बकाया';
  }

  @override
  String get feesDishonoured => 'चेक वापस';

  @override
  String get feesFeeReceipt => 'शुल्क रसीद';

  @override
  String get feesRecordedOn => 'दर्ज करने की तिथि';

  @override
  String get feesPeriod => 'अवधि';

  @override
  String get feesFeeAmount => 'शुल्क राशि';

  @override
  String get feesSettlesEarlier => 'यह भुगतान इसी अवधि की पिछली रसीद की शेष राशि चुकाता है।';

  @override
  String feesChequeDetails(String number, String date) {
    return '$number, दिनांक $date';
  }

  @override
  String get feesRemarks => 'टिप्पणी';

  @override
  String get feesReceiptNotFound => 'यह रसीद उपलब्ध नहीं है।';

  @override
  String get feesOfficeNote =>
      'भुगतान स्कूल कार्यालय द्वारा दर्ज किए जाते हैं। किसी सुधार के लिए कृपया कार्यालय से संपर्क करें।';

  @override
  String get statFeesPaid => 'जमा शुल्क';

  @override
  String get statFeesBalance => 'बकाया शुल्क';

  @override
  String statFeesLastPaid(String date) {
    return 'अंतिम भुगतान $date';
  }

  @override
  String statFeesPaidSoFar(String amount) {
    return 'अब तक $amount जमा';
  }

  @override
  String get noticesEmptyTitle => 'अभी कोई सूचना नहीं';

  @override
  String get noticesEmptyMessage => 'स्कूल की सूचनाएँ और घोषणाएँ यहाँ दिखेंगी।';

  @override
  String get noticeHoliday => 'अवकाश';

  @override
  String get noticeAttachment => 'संलग्नक खोलें';

  @override
  String get noticeVideo => 'वीडियो देखें';

  @override
  String get noticeNotFound => 'यह सूचना अब उपलब्ध नहीं है।';

  @override
  String get noticesLoadMore => 'पुरानी सूचनाएँ देखें';

  @override
  String get noticesLoadMoreFailed =>
      'पुरानी सूचनाएँ लोड नहीं हो सकीं। फिर से कोशिश करने के लिए टैप करें।';

  @override
  String get noticeDetailTitle => 'सूचना';

  @override
  String get linkOpenFailed => 'लिंक नहीं खुल सका।';

  @override
  String get loginRememberMe => 'मुझे याद रखें';

  @override
  String get loginSessionExpired => 'आपका सत्र समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get feesBreakdown => 'शुल्क विवरण';

  @override
  String get feesBreakdownFailed => 'शुल्क विवरण लोड नहीं हो सका।';

  @override
  String feesHeadConcession(String amount) {
    return '$amount छूट';
  }

  @override
  String feesHeadCharged(String amount) {
    return 'शुल्क $amount';
  }

  @override
  String get feesTotal => 'कुल';
}
