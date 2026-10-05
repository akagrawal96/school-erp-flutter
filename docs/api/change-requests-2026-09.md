# API change requests — September 2026

Requests for the backend developer after connecting login, profile,
attendance, fees and the notice board. Each item says what the app needs and why. All examples are fake.

## 1. Attendance — `GET StudentApi/GetStudentAttendence` ✅ connected

Works today. The app turns the list into the calendar, monthly view and yearly
percentage. Please confirm or add:

| # | Request | Why |
|---|---|---|
| A1 | **List of all `AttStatus` codes.** App assumes `1 = present`, `2 = absent`. What are leave, half day, late, holiday? | Unknown codes are currently ignored, which lowers accuracy |
| A2 | **Which session is returned?** The test account's `SessionCode` is 2025 but records are from Jun–Aug 2024 | The app opens on the latest month with data; please confirm current-session data is returned |
| A3 | Optional `?session=2025` or `?from=&to=` filter | Avoids sending years of history on every open |
| A4 | Holidays and weekly offs (either in this list with a holiday code, or a separate `GetHolidays`) | So holidays show on the calendar instead of blank days |
| A5 | Optional `Remark` and `MarkedBy` per day | Shown when a parent taps an absent day |
| A6 | Minimum attendance % of the institution (e.g. 75) | App shows "Required: 75%" and warns below it; currently assumed |

Nice to have: fix the spelling `Attendence` → `Attendance` in a new version of the endpoint.

## 2. Fees

### What the app does today — `GET StudentApi/GetFee?pageNo=` ✅ connected

The Fees screen is built from the receipts: amount paid this session, total
fee, concession, balance, a 12-month "months paid" grid and every receipt with
its details. All pages are loaded (`hasNextPage`) because the totals need all
receipts.

How the app reads each row (please confirm):

| Field | App's reading |
|---|---|
| `FLID` | Receipt number, unique per deposit |
| `DepositDate`, `EntryDate` | `dd-MM-yyyy`; "Paid on" and "Recorded on" |
| `TotalConfiguredAmount` | Fee charged for the months in `DepositedTerms`. **`0` = this deposit pays the rest of an earlier receipt for the same month** (e.g. April paid in two parts) |
| `TotalDepositedAmount`, `TotalConcessionAmount` | Paid and waived; balance = fee − concession − paid, summed over all receipts |
| `DepositedTerms` | Month names; the year is worked out from the payment date |
| `ChequeNo`, `ChequeDate` | Shown as the payment mode when present |
| `DepositRemarks` | Shown as "Remarks" (usually the UTR) |
| `IsDishonouredStatus` | `""` = normal. The app treats `Y`/`Yes`/`1`/`true` as a bounced cheque (not counted as paid) |

### Fee details — `GET StudentApi/GetFeeData?pageNo=&FLID=` ✅ connected

The receipt page shows each fee head (tuition, transport, late fee…) with its
fee, concession and paid amount, grouped by month when a receipt covers
several months. Heads with all amounts `0` are hidden. All pages are loaded
(10 rows per page = one per head and month). The `FLID` filter works here.

### Questions and small fixes on `GetFee`

| # | Request | Why |
|---|---|---|
| F1 | **`FLID` filter is ignored**: `GetFee?pageNo=1&FLID=<receipt>` returns every receipt of the student, not one | The app works around it (finds the receipt in the list); a working filter or `GetFeeReceipt?FLID=` is needed for links from notifications |
| F2 | **Values of `IsDishonouredStatus`** (what is sent for a bounced cheque?) | A wrong reading shows a bounced cheque as paid, or the reverse |
| F3 | Confirm the reading of `TotalConfiguredAmount = 0` above | Totals and balance depend on it |
| F4 | `DepositedTerms` with the year, as a list: `["2025-05","2025-06"]` | Month names have no year; a late payment for March in April is ambiguous |
| F5 | `PaymentMode` (cash, UPI, card, cheque, bank transfer) and `TransactionRef` as separate fields | Today the mode is only known for cheques; the UTR is inside free-text remarks |
| F6 | Which session is returned, and optional `?session=2025` | App assumes the current session; shows the session of the latest paid month |
| F7 | Remove `SName`, `RegNo`, `PrimaryContactNo` from each row | Already known from the profile; less personal data per request |
| F8 | `ReceiptPdfUrl` | "Download receipt" button |

### Still needed for "what is due" — `GET StudentApi/GetFeeDues`

Receipts only show what was **paid**. To show "Due now", overdue warnings,
upcoming installments and later "Pay now", the app needs the fee plan:

```json
{
  "session": "2025-26",
  "totalAmount": 60000, "totalConcession": 4800, "totalPaid": 36000, "balance": 19200,
  "installments": [
    {
      "id": "2025-12", "title": "December 2025", "schedule": "monthly",
      "dueDate": "2025-12-10",
      "heads": [ { "name": "Tuition fee", "amount": 4600 }, { "name": "Transport", "amount": 1000 } ],
      "concession": 700, "lateFine": 0, "paid": 0, "balance": 4900
    }
  ],
  "onlinePaymentEnabled": false,
  "officeDetails": "Accounts office, Mon–Sat 9 AM – 1 PM"
}
```

`schedule` is `monthly` / `term` / `annual` / `oneTime`, so the same API works
for schools, colleges and coaching. Online payment flow: see
[module-03-fees.md](data-needs/module-03-fees.md#3-online-payment-gateway).

## 3. Notice board — `GET StudentApi/NoticeBoard?pageNo=` ✅ connected

The app shows the list (10 per page, "Show older notices"), a detail page
with cover image, attachment and video, and the latest three on Home. Rows with
`IsPublish = false` or `IsDelete = true` are hidden.

| # | Request | Why |
|---|---|---|
| N1 | **Meaning of `NotificationTypeID`** (5 in the sample) | Could show "Exam", "Event", "Holiday" labels and filters |
| N2 | For `IsHoliday = true`: **the holiday date(s)** (`HolidayFrom`, `HolidayTo`) | `NoticeDate` is the posting date; with real dates the attendance calendar can mark holidays (see A4) |
| N3 | Confirm `NoticeDocPath` and `CoverImagePath` are relative to the server root, and `VideoURL` is a full link | The app joins relative paths with the server address |
| N4 | Single notice: `NoticeBoard?ID=` | Opening a notice from a push notification |
| N5 | Optional `IsRead` per student and a "mark as read" call | Unread badge on Home |
| N6 | Drop internal fields from the student API (`UserID`, `ModifyBy`, `IsDelete`, `IntituteNoticeID`, …) | Only what the app shows |

## 4. Login — `POST StudentApi/MemberLogin_Password` ✅ connected

Works today. Planned hardening: send credentials in the request body and use
HTTPS for production. The login response now also has
`PrimaryContactNo` and `BranchCode`; the app keeps only the token and
`StudentID` and loads everything else from the profile.

| # | Request | Why |
|---|---|---|
| L1 | **Longer sessions: a refresh token** (`refreshToken` in the login response + `POST StudentApi/RefreshToken`), or a longer `expiresIn` (e.g. 30 days) | The token lasts 8 hours (`expiresIn: 28800`), so parents must sign in again every day. With a refresh token the app renews the session silently |
| L2 | Return HTTP **401** (not 200 with `status: false`) for an expired or invalid token on every API | The app signs the user out on 401 and asks them to sign in again |

Until L1 exists, the app offers **Remember me**: the login ID and password are
kept in encrypted storage (Android Keystore / iOS Keychain, never in plain
preferences) so the form is filled in; the user only taps "Sign in".

## 5. Profile — `GET StudentApi/getProfile` ✅ connected

Works today. Requests:

| # | Request | Why |
|---|---|---|
| P1 | `RollNo` and `DateOfBirth` | Shown on profile and dashboard |
| P2 | Photo and logo paths as full URLs, or confirm they are relative to the server root | App currently joins them with the server address |
| P3 | Do not send `AadharNo` to the app unless it is displayed | Less personal data on phones |
