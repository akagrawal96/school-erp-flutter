# Data needs — Module 1: Student dashboard, attendance, profile

- **Status:** UI designed with mock data; APIs not built yet.
- **App side:** each block below maps to one domain repository. Only its data
  layer changes when the API arrives.
- **Conventions** (full contract in step 5): JSON camelCase, dates as ISO-8601
  (`2026-10-14`), timestamps with offset (`2026-10-14T09:30:00+05:30`), money
  as integer **paise**, `Authorization: Bearer <token>` on every request.

## 1. Current student profile

`GET /students/me` → `StudentProfileRepository.getCurrentStudent`

| Field | Type | Example | Used for |
|---|---|---|---|
| `studentId` | string | `"10001"` | Identity |
| `name` | string | `"Aarav Mehta"` | Header, avatar initials |
| `admissionNo` | string | `"GVS-2019-0142"` | Profile |
| `className` | string | `"8"` | Header, profile |
| `section` | string | `"A"` | Header, profile |
| `rollNo` | string | `"14"` | Header, profile |
| `dateOfBirth` | date | `"2013-05-21"` | Profile |
| `guardianName` | string | `"Rohit Mehta"` | Profile |
| `contactNumber` | string (masked) | `"98•••••321"` | Profile |
| `address` | string | | Profile |
| `institutionName` | string | `"Green Valley Public School"` | App bar |
| `photoUrl` | string? | | Avatar (initials when absent) |

## 2. Dashboard summary

`GET /students/me/dashboard?date=2026-10-14` → `DashboardRepository.getSnapshot`

One request so the home screen loads fast on slow networks. Today's classes come
from the timetable endpoint (module 2), fees from the fees endpoint (module 3)
and the latest three notices from `StudentApi/NoticeBoard`.

| Field | Type | Notes |
|---|---|---|
| `pendingHomework` | int | Count due this week |
| `unreadNotifications` | int | Badge on the bell |

## 3. Attendance overview (academic year)

`GET /students/me/attendance/overview` → `AttendanceRepository.getOverview`

| Field | Type | Notes |
|---|---|---|
| `academicYearLabel` | string | `"2026–27"` |
| `academicYearStart`, `academicYearEnd` | date | Limits month navigation |
| `present`, `absent`, `late`, `halfDay`, `leave` | int | Year-to-date counts |
| `requiredPercentage` | number | Institution policy, e.g. `75` |

The app computes the percentage (late = attended, half day = 0.5). If the
institution uses a different formula, the backend should send `percentage`
and the app will display it as-is.

## 4. Attendance month

`GET /students/me/attendance?month=2026-10` → `AttendanceRepository.getMonth`

`days[]` — only days up to today:

| Field | Type | Notes |
|---|---|---|
| `date` | date | |
| `status` | enum | `present`, `absent`, `late`, `halfDay`, `leave`, `holiday` |
| `remark` | string? | Teacher's note / reason |
| `markedBy` | string? | Teacher name |

## Open questions for the backend team

1. Is today's attendance available in the month call as soon as it is marked?
2. Are holidays part of attendance data or a separate calendar API?
3. Is `LoginType` in the login response student vs parent? (Affects the header text.)
