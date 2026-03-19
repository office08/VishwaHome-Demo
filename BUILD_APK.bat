@echo off
setlocal EnableDelayedExpansion
title VishwaHome Demo — APK Builder
color 0A

echo.
echo  ============================================
echo   VishwaHome Demo APK Builder for Windows
echo  ============================================
echo.

REM ── Step 1: Check if Flutter already installed ──────────────
echo [1/5] Checking Flutter...
where flutter >nul 2>&1
if %errorlevel% == 0 (
    echo       Flutter already installed. Skipping download.
    goto :CHECK_JAVA
)

REM ── Check PowerShell available ──────────────────────────────
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PowerShell not found. Please install Flutter manually.
    echo Visit: https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)

echo       Flutter not found. Downloading now...
echo       This will take 3-5 minutes (download ~700MB)...
echo.

REM ── Download Flutter SDK ─────────────────────────────────────
set FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip
set FLUTTER_ZIP=%TEMP%\flutter_sdk.zip
set FLUTTER_DIR=C:\flutter

if not exist "%FLUTTER_DIR%" mkdir "%FLUTTER_DIR%"

echo       Downloading Flutter SDK...
powershell -Command "& { $ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%FLUTTER_URL%' -OutFile '%FLUTTER_ZIP%' }"
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Download failed. Check your internet connection.
    echo Please manually download Flutter from: https://flutter.dev
    pause
    exit /b 1
)

echo       Extracting Flutter SDK to C:\flutter ...
powershell -Command "Expand-Archive -Path '%FLUTTER_ZIP%' -DestinationPath 'C:\' -Force"
del "%FLUTTER_ZIP%"

REM ── Add Flutter to PATH for this session ────────────────────
set PATH=%PATH%;C:\flutter\flutter\bin

echo       Flutter installed at C:\flutter\flutter\bin
echo.

:CHECK_JAVA
REM ── Step 2: Check Java ───────────────────────────────────────
echo [2/5] Checking Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  WARNING: Java (JDK) not found.
    echo  Flutter needs Java to build Android APKs.
    echo.
    echo  Please install Java JDK 17:
    echo  https://adoptium.net/temurin/releases/?version=17
    echo.
    echo  After installing Java, run this script again.
    pause
    exit /b 1
)
echo       Java found.

REM ── Step 3: Accept Android licenses ─────────────────────────
echo.
echo [3/5] Accepting Android licenses (may take 1 min)...
echo       If asked, type "y" and press Enter for each prompt.
echo.
flutter doctor --android-licenses >nul 2>&1
echo       Licenses accepted.

REM ── Step 4: Get packages ─────────────────────────────────────
echo.
echo [4/5] Getting Flutter packages...
cd /d "%~dp0"
flutter pub get
if %errorlevel% neq 0 (
    echo.
    echo ERROR: flutter pub get failed.
    echo Make sure you have internet connection.
    pause
    exit /b 1
)
echo       Packages downloaded successfully.

REM ── Step 5: Build APK ────────────────────────────────────────
echo.
echo [5/5] Building APK... (this takes 2-4 minutes)
echo       Please wait...
echo.
flutter build apk --debug --no-tree-shake-icons
if %errorlevel% neq 0 (
    echo.
    echo ERROR: APK build failed.
    echo Run "flutter doctor" in Command Prompt to see what's missing.
    pause
    exit /b 1
)

REM ── Done! ────────────────────────────────────────────────────
set APK_PATH=%~dp0build\app\outputs\flutter-apk\app-debug.apk

echo.
echo  ============================================
echo   BUILD SUCCESSFUL!
echo  ============================================
echo.
echo   APK file is here:
echo   %APK_PATH%
echo.
echo   To install on your Android phone:
echo   1. Copy the APK file to your phone
echo   2. Open it on your phone
echo   3. Allow "Install unknown apps" if asked
echo.

REM ── Open the folder automatically ────────────────────────────
explorer "%~dp0build\app\outputs\flutter-apk\"

echo   (The APK folder has been opened for you)
echo.
pause
