# Foundation roadmap

The foundation is built in small, reviewed steps. Each step ends with a passing
quality gate, a test on a real device and review before the next one starts.
ERP business modules (students, fees, attendance, …) start only after the
foundation is approved.

Order is **design first**, so every step after step 1 produces something
visible to review on the phone. Device screenshots for each step are saved
locally in `screenshots/step-NN-<name>/` (git-ignored).

| Step | Scope | Status |
|---|---|---|
| 1 | Project setup: package ID, Android flavors (app × env: staging, prod), min OS, strict lints, formatter, Git, CI, docs, ADR structure, agent rules | **Done** (tested on device) |
| 2 | Design system: color tokens and brand palette, typography (Roboto), spacing, radius, elevation, motion, breakpoints, light/dark/system themes, runtime institution branding abstraction. Riverpod bootstrap, preferences storage, localization setup (English + Hindi). **Theme preview screen** | **Done** (tested on device) |
| 3 | Shared components (buttons, inputs, cards, chips, avatar, dialogs), UI states (skeleton, empty, error, offline), adaptive navigation shell (bottom bar on phone, rail on tablet), GoRouter basics. **Login screen UI** (not connected) | **Done** (tested on device) |
| 4 | Core + network: `Result`/`Failure`, logger, environment config (staging URL, cleartext for staging only), secure token storage, Dio client and interceptors, error mapping, connectivity. **Real login against staging API** | Planned |
| 5 | Session, tenant/branch context, permissions & module entitlements, route guards, deep links, logout. **API contract proposal for the backend team** | Planned |
| 6 | Firebase: Crashlytics, Analytics, push notifications (FCM + local, topics, notification deep links) per flavor | Planned |
| — | **UI design phase** (APIs not available yet — screens use mock repositories; data needs recorded in `docs/api/data-needs/`) | |
| UI-1 | Student dashboard, attendance calendar and summary, profile, settings, More menu | **Done** (tested on device) |
| UI-2 | Academics: weekly timetable, homework with submission (text + files), exams and report cards (marks and grades) | **Done** (tested on device) |
| UI-3 | Fees: term-wise and monthly installments, online payment (demo gateway) and pay-at-office, payment history, receipts | **Replaced by API-2** — dues and payment return with the fee dues API |
| UI-4 | Communication: notices (done in API-2), notifications | Planned |
| API-1 | Real login (secure token, session guard, auto sign-out on expiry), real profile and attendance on staging; login and profile redesign | **In review** |
| API-2 | Fees rebuilt on real receipts (`GetFee`: paid, concession, balance, months paid, receipts); notice board (`NoticeBoard`: list, pages, detail, attachments, video); dashboard uses both | **In review** |
| — | iOS flavors & build verification (needs a Mac or cloud macOS CI) | Deferred |

## Open decisions

- Final product name, app icon and brand color (placeholder: "School ERP").
- Production API URL (not decided).
- Login API hardening (credentials in the request body, HTTPS in production).
- Audience-specific apps (e.g. parent/student vs staff) — flavor structure leaves room; not built.
