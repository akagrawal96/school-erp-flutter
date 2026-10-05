# Data needs — Module 3: Fees

- **Status (Sept 2026):** the app now shows real receipts from
  `StudentApi/GetFee` (paid amount, months paid, receipts). Dues, installments
  and online payment below are the **target design**; the app shows them again
  once the fee dues API exists — see
  [change-requests-2026-09.md](../change-requests-2026-09.md#2-fees).
- Conventions as in [module 1](module-01-dashboard-attendance.md). **All money
  is integer paise.**

## 1. Fees overview

`GET /students/me/fees` → `FeesRepository.getOverview`

Also used by the dashboard's "Fees due" card (the dashboard endpoint no longer
needs `feeDue`).

| Field | Type | Notes |
|---|---|---|
| `academicYearLabel` | string | `"2026–27"` |
| `installments[]` | list | See below, in due-date order |
| `paymentOptions.onlinePaymentEnabled` | bool | Shows or hides "Pay now" |
| `paymentOptions.officeDetails` | string? | Free text written by the institution: place, timings, accepted modes |

### Installment

| Field | Type | Notes |
|---|---|---|
| `id` | string | |
| `title` | string | "Term 2 tuition fee", "Transport fee — October" |
| `schedule` | enum | `annual`, `term`, `monthly`, `oneTime` — each institution chooses |
| `dueDate` | date | |
| `components[]` | list | `name`, `amountInPaise` — the fee breakdown |
| `paidInPaise` | int | Supports partial payments |
| `lateFeeInPaise` | int | Applied when unpaid after `dueDate` |

The app derives status (paid, partly paid, overdue, due within 30 days,
upcoming) and "due now" totals. If the institution's late-fee rules are more
complex (per-day fines, caps, waivers), the backend should send
`payableInPaise` and the app will show that instead of calculating.

## 2. Payments and receipts

`GET /students/me/fees/payments` → `getPayments` (newest first)
`GET /students/me/fees/payments/{id}` → `getPayment`

`id`, `receiptNo`, `paidOn` (timestamp), `amountInPaise`, `mode`
(`upi`, `card`, `netBanking`, `cash`, `cheque`, `bankTransfer`),
`reference?` (gateway transaction ID / cheque no.), `items[]` (`name`,
`amountInPaise`), `receiptPdfUrl?` (for Download / Share).

Payments made at the school office must appear here too, so parents have one
history.

## 3. Online payment (gateway)

The app must **never** decide by itself that a payment succeeded. Proposed
flow (Razorpay shown; PayU or Cashfree work the same way):

1. App → `POST /students/me/fees/orders` with `installmentIds[]`.
   Backend recalculates the amount (never trust the app's total), creates a
   gateway order and returns `orderId`, `amountInPaise`, `gatewayKey`.
2. App opens the gateway checkout (UPI, cards, net banking) with that order.
3. Gateway returns a payment ID and signature to the app.
4. App → `POST /students/me/fees/orders/{orderId}/verify` with the gateway
   response. Backend verifies the signature, marks installments paid, creates
   the receipt, returns the `FeePayment`.
5. Backend also listens to the gateway **webhook**, so a payment is recorded
   even if the app is closed mid-payment.

App handles: user cancelled (nothing charged), failure (show "No money was
deducted"), and pending/unknown (show "We'll update this shortly" and refresh).

## Questions for the backend team

1. Which payment gateway does the school use, and who holds the merchant account?
2. Can parents choose which installments to pay, or must they pay the oldest first?
3. Are partial payments of one installment allowed online?
4. Are convenience fees (gateway charges) added to the parent's amount?
