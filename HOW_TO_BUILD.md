# VishwaHome Demo — Windows APK Build Guide

## Fastest way (3 steps)

### Step 1 — Install Flutter
1. Go to: https://docs.flutter.dev/get-started/install/windows
2. Download the Flutter SDK zip (~700MB)
3. Extract to `C:\flutter`
4. Add `C:\flutter\flutter\bin` to your Windows PATH
   - Search "Environment Variables" in Start Menu
   - Click "Path" → Edit → New → paste `C:\flutter\flutter\bin`
   - Click OK → restart Command Prompt

### Step 2 — Build APK
Open Command Prompt, navigate to this folder, then run:

```
flutter pub get
flutter build apk --debug
```

### Step 3 — Get your APK
File will be at:
```
build\app\outputs\flutter-apk\app-debug.apk
```

Copy this file to your Android phone and install it.
(Allow "Install unknown apps" when prompted on phone)

---

## If Flutter is already installed

Just open Command Prompt in this folder and run:
```
flutter pub get
flutter build apk --debug
```

Done in under 5 minutes.

---

## Demo accounts in the app

| Role | Tap to login | What you see |
|---|---|---|
| Super Admin | Vikram Mehta | All 4 societies, feature flags, settlements |
| Society Admin | Priya Sharma | Bills, finance, complaints, special fund |
| Resident | Rajesh Kumar | Pay bills (demo), expenses, polls, fund |
| Guard | Ramu Watchman | Log visitors, delivery tracking |

## Switch between roles
Tap avatar (top right) → Switch Role → choose another role
