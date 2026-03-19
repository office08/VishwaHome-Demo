import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary        = Color(0xFF0D6E6E);
  static const primaryLight   = Color(0xFF1A9E9E);
  static const primaryDark    = Color(0xFF063333);
  static const secondary      = Color(0xFFE8841A);
  static const background     = Color(0xFFF0F4F8);
  static const surface        = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFE8F0F0);
  static const textPrimary    = Color(0xFF1A2E2E);
  static const textSecondary  = Color(0xFF4A6363);
  static const textHint       = Color(0xFF8AABAB);
  static const border         = Color(0xFFCCE0E0);
  static const success        = Color(0xFF2ECC71);
  static const warning        = Color(0xFFF39C12);
  static const error          = Color(0xFFE74C3C);
  static const info           = Color(0xFF3498DB);
  static const superAdminColor = Color(0xFF6C3483);
  static const teal           = Color(0xFF0D6E6E);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary, brightness: Brightness.light),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.soraTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface, elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.sora(
          fontSize: 18, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0, color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.textPrimary,
    ),
  );
}
