# VishwaHome — Demo App

## What this is
A **standalone demo** of the VishwaHome app with:
- Zero Firebase setup required
- Zero payment gateway
- All data pre-loaded (mock data)
- All 4 user roles explorable

## How to run

```bash
cd vishwahome_demo
flutter pub get
flutter run
```

That's it. No google-services.json, no API keys, no OTP.

## Demo accounts (tap to enter)

| Role | Name | Features |
|---|---|---|
| Super Admin | Vikram Mehta | 4 societies, feature flags, settlements |
| Society Admin | Priya Sharma | Bills, finance, complaints, fund management |
| Resident | Rajesh Kumar | Pay bills (UI only), finance view, vote, fund |
| Guard | Ramu Watchman | Log visitors, log deliveries |

## What works in demo

✅ Full UI navigation — every screen, every tab
✅ Bills screen — pending + paid with breakdown
✅ Finance screen — treasury, expenses, category breakdown
✅ Notices — read full notices
✅ Polls — vote on active polls (state persists in session)
✅ Special fund — view milestones, progress updates, pay buttons (UI only)
✅ Admin dashboard — flat list, collection stats, complaints, expenses
✅ Super Admin — 4 societies, feature flags toggle (UI), settlement review
✅ Guard — log a visitor (adds to list live), view visitor log

## What shows "Demo" popup instead of real action

- UPI payment buttons → shows the payment flow details (what would happen)
- Admin "Mark Paid" → shows snackbar
- Feature flag toggles → shows snackbar
- Notifications → not sent (no Firebase)

## Switch between roles
Tap the avatar icon (top right) → Switch Role / Logout → back to role selector

## Requirements
- Flutter 3.10+
- Dart 3.0+
- No other setup needed
