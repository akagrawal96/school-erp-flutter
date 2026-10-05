import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_erp/core/errors/app_exception.dart';
import 'package:school_erp/core/network/api_client.dart';
import 'package:school_erp/core/storage/token_storage.dart';
import 'package:school_erp/features/attendance/data/repositories/api_attendance_repository.dart';
import 'package:school_erp/features/attendance/domain/entities/attendance.dart';
import 'package:school_erp/features/authentication/data/repositories/api_auth_repository.dart';
import 'package:school_erp/features/authentication/domain/repositories/auth_repository.dart';
import 'package:school_erp/features/fees/data/repositories/api_fees_repository.dart';
import 'package:school_erp/features/notices/data/repositories/api_notice_repository.dart';
import 'package:school_erp/features/profile/data/repositories/api_student_profile_repository.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/in_memory_token_storage.dart';

// All data below is fictional.
final _now = DateTime(2026, 9, 18, 10);

void main() {
  late InMemoryTokenStorage tokens;
  late int unauthorizedCalls;

  ApiClient client(FakeHttpAdapter adapter) => ApiClient(
    baseUrl: Uri.parse('http://example.test/api/'),
    tokenStorage: tokens,
    clock: () => _now,
    onUnauthorized: () => unauthorizedCalls++,
    adapter: adapter,
  );

  setUp(() {
    tokens = InMemoryTokenStorage();
    unauthorizedCalls = 0;
  });

  group('ApiAuthRepository', () {
    String? savedStudentId;

    ApiAuthRepository repository(FakeHttpAdapter adapter) => ApiAuthRepository(
      client: client(adapter),
      tokenStorage: tokens,
      clock: () => _now,
      saveStudentId: (id) async => savedStudentId = id,
    );

    test('stores the token with its expiry and the student ID', () async {
      final adapter = FakeHttpAdapter(
        (_) => (
          200,
          envelope({
            'RegNo': 'TEST-001',
            'SName': 'TEST STUDENT',
            'StudentID': 42,
            'SessionCode': 2025,
            'token': 'fake.jwt.token',
            'tokenType': 'Bearer',
            'expiresIn': 28800,
          }),
        ),
      );

      await repository(adapter).signIn(loginId: 'TEST-001', password: 'secret');

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.path, 'StudentApi/MemberLogin_Password');
      expect(request.queryParameters, {'LoginId': 'TEST-001', 'LoginPass': 'secret'});
      expect(tokens.token!.value, 'fake.jwt.token');
      expect(tokens.token!.expiresAt, _now.add(const Duration(hours: 8)));
      expect(savedStudentId, '42');
    });

    test('status false means invalid credentials; nothing is stored', () async {
      final adapter = FakeHttpAdapter(
        (_) => (200, envelope(null, status: false, message: 'Invalid login')),
      );

      await expectLater(
        repository(adapter).signIn(loginId: 'x', password: 'y'),
        throwsA(
          isA<AuthFailure>().having(
            (f) => f.reason,
            'reason',
            AuthFailureReason.invalidCredentials,
          ),
        ),
      );
      expect(tokens.token, isNull);
    });

    test('connection errors become network failures', () async {
      final adapter = FakeHttpAdapter(
        (options) => throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        ),
      );

      await expectLater(
        repository(adapter).signIn(loginId: 'x', password: 'y'),
        throwsA(isA<AuthFailure>().having((f) => f.reason, 'reason', AuthFailureReason.network)),
      );
    });

    test('sign out clears the token', () async {
      tokens.token = AuthToken(value: 't', expiresAt: _now.add(const Duration(hours: 1)));
      await repository(FakeHttpAdapter((_) => (200, envelope(null)))).signOut();
      expect(tokens.token, isNull);
    });
  });

  group('ApiClient session handling', () {
    test('sends the bearer token', () async {
      tokens.token = AuthToken(value: 'abc', expiresAt: _now.add(const Duration(hours: 1)));
      final adapter = FakeHttpAdapter((_) => (200, envelope(<String, Object?>{})));

      await client(adapter).get('StudentApi/getProfile');

      expect(adapter.requests.single.headers['Authorization'], 'Bearer abc');
    });

    test('an expired token ends the session without calling the server', () async {
      tokens.token = AuthToken(value: 'abc', expiresAt: _now.subtract(const Duration(minutes: 1)));
      final adapter = FakeHttpAdapter((_) => (200, envelope(null)));

      await expectLater(
        client(adapter).get('StudentApi/getProfile'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(adapter.requests, isEmpty);
      expect(tokens.token, isNull);
      expect(unauthorizedCalls, 1);
    });

    test('HTTP 401 ends the session', () async {
      tokens.token = AuthToken(value: 'abc', expiresAt: _now.add(const Duration(hours: 1)));
      final adapter = FakeHttpAdapter((_) => (401, {'message': 'Unauthorized'}));

      await expectLater(
        client(adapter).get('StudentApi/getProfile'),
        throwsA(isA<UnauthorizedException>()),
      );
      expect(tokens.token, isNull);
      expect(unauthorizedCalls, 1);
    });
  });

  test('profile is mapped and cleaned up', () async {
    final adapter = FakeHttpAdapter(
      (_) => (
        200,
        envelope({
          'RegNo': 'TEST-001',
          'AdmissionNo': null,
          'SName': 'TEST  STUDENT',
          'FName': 'MR.RAVI KUMAR ',
          'MName': 'MRS.ASHA KUMARI',
          'PrimaryContactNo': '9000000001',
          'StudentAddress': '12,  SAMPLE ROAD ',
          'StudentPhotoPath': null,
          'EmergencyContactNo': '9000000002',
          'SessionCode': 2025,
          'CourseName': 'CLASS 1',
          'BatchName': 'A',
          'GenderName': 'Male',
          'CityName': 'Patna ',
          'StateName': 'BIHAR',
          'StudentStatusName': 'Active',
          'BranchName': 'SAMPLE PUBLIC SCHOOL',
          'BranchLogo': 'documents/logo.jpg',
        }),
      ),
    );
    final repository = ApiStudentProfileRepository(
      client: client(adapter),
      studentId: () async => '42',
      fileUrl: (path) => path == null ? null : Uri.parse('http://example.test/').resolve(path),
    );

    final student = await repository.getCurrentStudent();

    expect(student.studentId, '42');
    expect(student.name, 'Test Student');
    expect(student.firstName, 'Test');
    expect(student.fatherName, 'Mr. Ravi Kumar');
    expect(student.motherName, 'Mrs. Asha Kumari');
    expect(student.className, 'Class 1');
    expect(student.section, 'A');
    expect(student.sessionLabel, '2025–26');
    expect(student.institutionName, 'Sample Public School');
    expect(student.city, 'Patna');
    expect(student.state, 'Bihar');
    expect(student.address, '12, SAMPLE ROAD');
    expect(student.admissionNo, isNull);
    expect(student.photoUrl, isNull);
    expect(student.institutionLogoUrl.toString(), 'http://example.test/documents/logo.jpg');
  });

  test('attendance records become months and a yearly summary', () async {
    final adapter = FakeHttpAdapter(
      (_) => (
        200,
        envelope([
          {'AttDate': '2024-08-23T00:00:00', 'AttStatus': 1},
          {'AttDate': '2024-08-22T00:00:00', 'AttStatus': 2},
          {'AttDate': '2024-07-19T00:00:00', 'AttStatus': 1},
          {'AttDate': '2024-07-18T00:00:00', 'AttStatus': 9},
        ]),
      ),
    );
    final repository = ApiAttendanceRepository(client: client(adapter), clock: () => _now);

    final overview = await repository.getOverview();
    expect(overview.academicYearStart, DateTime(2024, 4));
    expect(overview.academicYearLabel, '2024–25');
    expect(overview.lastRecordedOn, DateTime(2024, 8, 23));
    expect(overview.summary.present, 2);
    expect(overview.summary.absent, 1);
    expect(overview.summary.workingDays, 3, reason: 'unknown code 9 is not counted');

    final august = await repository.getMonth(DateTime(2024, 8));
    expect(august.days.map((d) => d.status), [AttendanceStatus.absent, AttendanceStatus.present]);
    expect((await repository.getMonth(DateTime(2024, 9))).days, isEmpty);
  });

  Map<String, Object?> paged(List<Object?> data, {required int page, required bool hasNext}) => {
    ...envelope(data),
    'pagination': {
      'pageNo': page,
      'pageSize': 20,
      'totalRecords': 3,
      'totalPages': 2,
      'hasNextPage': hasNext,
      'hasPreviousPage': page > 1,
    },
  };

  test('fee receipts are loaded from every page and mapped', () async {
    Map<String, Object?> row(int id, String date, String terms, {String dishonoured = ''}) => {
      'RegNo': 'TEST-001',
      'SName': 'TEST STUDENT',
      'FLID': id,
      'DepositDate': date,
      'TotalConfiguredAmount': 5300,
      'TotalDepositedAmount': 4600,
      'TotalConcessionAmount': 700,
      'DepositedTerms': terms,
      'ChequeNo': null,
      'ChequeDate': null,
      'DepositRemarks': ' UTR 000000000001 ',
      'EntryDate': date,
      'IsDishonouredStatus': dishonoured,
    };
    final adapter = FakeHttpAdapter(
      (options) => switch (options.queryParameters['pageNo']) {
        1 => (
          200,
          paged(
            [row(3, '01-12-2025', 'NOVEMBER'), row(2, '18-07-2025', 'MAY,JUNE,JULY')],
            page: 1,
            hasNext: true,
          ),
        ),
        _ => (
          200,
          paged([row(1, '07-04-2025', 'APRIL', dishonoured: 'Y')], page: 2, hasNext: false),
        ),
      },
    );

    final receipts = await ApiFeesRepository(client: client(adapter)).getReceipts();

    expect(adapter.requests.map((r) => r.path), everyElement('StudentApi/GetFee'));
    expect(adapter.requests.map((r) => r.queryParameters['pageNo']), [1, 2]);
    expect(receipts.map((r) => r.id), ['3', '2', '1']);
    final first = receipts.first;
    expect(first.depositedOn, DateTime(2025, 12));
    expect(first.recordedOn, isNull, reason: 'same as the deposit date');
    expect(first.periods.single.month, DateTime(2025, 11));
    expect(first.feeInPaise, 530000);
    expect(first.paidInPaise, 460000);
    expect(first.concessionInPaise, 70000);
    expect(first.remarks, 'UTR 000000000001');
    expect(first.isDishonoured, isFalse);
    expect(receipts[1].periods.map((p) => p.month), [
      DateTime(2025, 5),
      DateTime(2025, 6),
      DateTime(2025, 7),
    ]);
    expect(receipts.last.isDishonoured, isTrue);
  });

  test('notices are mapped; unpublished ones are skipped; file paths use the server', () async {
    final adapter = FakeHttpAdapter(
      (_) => (
        200,
        paged(
          [
            {
              'ID': 7,
              'NoticeDate': '2026-09-21T00:00:00',
              'NoticeTitle': ' SPORTS DAY ',
              'NoticeDesc': 'Line one.\nLine two. ',
              'NoticeDocPath': 'documents/notice.pdf',
              'VideoURL': 'https://example.com/video',
              'IsPublish': true,
              'IsHoliday': true,
              'IsDelete': false,
              'EntryDate': '2026-09-21T13:17:52.71',
              'CoverImagePath': null,
            },
            {'ID': 8, 'NoticeTitle': 'Draft', 'NoticeDate': '2026-09-22', 'IsPublish': false},
          ],
          page: 1,
          hasNext: false,
        ),
      ),
    );
    final repository = ApiNoticeRepository(
      client: client(adapter),
      fileUrl: (path) => path == null ? null : Uri.parse('http://example.test/').resolve(path),
    );

    final page = await repository.getNotices();

    expect(adapter.requests.single.path, 'StudentApi/NoticeBoard');
    expect(adapter.requests.single.queryParameters, {'pageNo': 1});
    expect(page.hasMore, isFalse);
    final notice = page.notices.single;
    expect(notice.id, '7');
    expect(notice.title, 'SPORTS DAY');
    expect(notice.body, 'Line one.\nLine two.');
    expect(notice.postedOn, DateTime(2026, 9, 21));
    expect(notice.isHoliday, isTrue);
    expect(notice.attachmentUrl.toString(), 'http://example.test/documents/notice.pdf');
    expect(notice.videoUrl.toString(), 'https://example.com/video');
    expect(notice.coverImageUrl, isNull);
  });

  test('fee details of a receipt are loaded from every page', () async {
    Map<String, Object?> head(String name, num fee, num paid, num concession) => {
      'DepositDate': '2025-12-01T00:00:00',
      'FeeTermName': 'NOVEMBER',
      'FeeParticularsName': name,
      'ConfiguredFeeAmount': fee,
      'DepositedFeeAmount': paid,
      'ConcessionAmount': concession,
    };
    final adapter = FakeHttpAdapter(
      (options) => switch (options.queryParameters['pageNo']) {
        1 => (
          200,
          paged([head('TUITION FEE', 2000, 1600, 400)], page: 1, hasNext: true),
        ),
        _ => (
          200,
          paged(
            [head('LATE FEE', 300, 0, 300), head('EXAM FEE', 0, 0, 0)],
            page: 2,
            hasNext: false,
          ),
        ),
      },
    );

    final items = await ApiFeesRepository(client: client(adapter)).getReceiptItems('42');

    expect(adapter.requests.map((r) => r.path), everyElement('StudentApi/GetFeeData'));
    expect(adapter.requests.first.queryParameters, {'FLID': '42', 'pageNo': 1});
    expect(items.map((i) => i.name), ['Tuition Fee', 'Late Fee', 'Exam Fee']);
    expect(items.first.period?.month, DateTime(2025, 11));
    expect(items.first.feeInPaise, 200000);
    expect(items.first.paidInPaise, 160000);
    expect(items.first.concessionInPaise, 40000);
    expect(items.last.isEmpty, isTrue);
  });
}
