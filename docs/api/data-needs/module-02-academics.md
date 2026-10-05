# Data needs — Module 2: Academics (timetable, homework, results)

- **Status:** UI designed with mock data; APIs not built yet.
- Conventions as in [module 1](module-01-dashboard-attendance.md).

## 1. Timetable

`GET /students/me/timetable?date=2026-10-14` → `TimetableRepository.getDay`

Also used by the dashboard's "Today's classes" (the dashboard endpoint no
longer needs `todayClasses`).

`periods[]`: `number`, `subject`, `teacher`, `start`, `end` (timestamps with
offset), `room?`. Empty list on holidays.

Alternative: `GET /students/me/timetable/week?start=2026-10-12` returning
days → periods, if the backend prefers one call per week.

## 2. Homework

`GET /students/me/homework?status=open|submitted|all` → `HomeworkRepository.getAll`
`GET /students/me/homework/{id}` → `getById`

| Field | Type | Notes |
|---|---|---|
| `id` | string | |
| `subject`, `title`, `instructions`, `teacher` | string | |
| `assignedOn`, `dueDate` | date | Overdue = no submission and today > dueDate |
| `attachments[]` | list | `name`, `sizeBytes`, `kind` (`image`/`pdf`/`document`), `url` |
| `submission` | object? | `submittedAt`, `answer?`, `attachments[]`, `feedback?`, `marksObtained?`, `maxMarks?` |

### Submit

`POST /students/me/homework/{id}/submission` (`multipart/form-data`)

- `answer` (optional text)
- `files[]` (images, PDF, documents)
- Response: the updated homework item.

Questions for backend:
1. Maximum file size and count per submission? (UI will show the limit.)
2. Can a student re-submit before the due date, or is the first submission final?
   (UI currently treats it as final and warns before submitting.)
3. Are late submissions allowed after the due date?

## 3. Results

`GET /students/me/exams` → `ResultsRepository.getExams` (published only, newest first)

`id`, `name`, `publishedOn`, `percentage`, `grade`, `passed`

`GET /students/me/exams/{id}/report-card` → `getReportCard`

| Field | Type | Notes |
|---|---|---|
| `exam` | object | As above |
| `subjects[]` | list | `subject`, `marksObtained`, `maxMarks`, `grade` |
| `rank`, `classSize` | int? | Hidden when the institution doesn't publish ranks |
| `remark` | string? | Class teacher's remark |
| `reportCardPdfUrl` | string? | For "Download report card" |

**Grades come from the backend.** Institutions use different schemes (CBSE
8-point, state boards, percentage-only, college GPA), so the app displays the
`grade` string it receives and never calculates it.
