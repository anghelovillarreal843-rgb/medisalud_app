import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF27214B);
  static const navyDeep = Color(0xFF1B1839);
  static const blue = Color(0xFF2E5BD8);
  static const teal = Color(0xFF0F9488);
  static const green = Color(0xFF15803D);
  static const amber = Color(0xFFB45309);
  static const red = Color(0xFFB91C1C);

  static const background = Color(0xFFF6F4EF);
  static const surface = Color(0xFFFFFCF7);
  static const text = Color(0xFF211D16);
  static const muted = Color(0xFF6F6A5E);
  static const border = Color(0xFFEAE5DA);
  static const line = Color(0xFFF2EEE4);

  static const softBlue = Color(0xFFE7EEFB);
  static const softTeal = Color(0xFFE0F2EF);
  static const softGreen = Color(0xFFE3F2E7);
  static const softAmber = Color(0xFFF9EDDA);
  static const softRed = Color(0xFFFDECEC);
  static const softSlate = Color(0xFFF1EDE6);
}

abstract final class AppRadius {
  static const card = 20.0;
  static const input = 14.0;
  static const pill = 999.0;
}

abstract final class AppShadows {
  static const card = [
    BoxShadow(color: Color(0x0F1B1839), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const floating = [
    BoxShadow(color: Color(0x1F1B1839), blurRadius: 40, offset: Offset(0, 18)),
  ];
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      primary: AppColors.blue,
      secondary: AppColors.teal,
      surface: AppColors.surface,
      error: AppColors.red,
    ),
  );

  final textTheme = base.textTheme.copyWith(
    displaySmall: const TextStyle(
      fontSize: 32,
      height: 1.18,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
      letterSpacing: -0.4,
    ),
    headlineMedium: const TextStyle(
      fontSize: 24,
      height: 1.28,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
      letterSpacing: -0.2,
    ),
    headlineSmall: const TextStyle(
      fontSize: 21,
      height: 1.32,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
      letterSpacing: -0.2,
    ),
    titleLarge: const TextStyle(
      fontSize: 17,
      height: 1.35,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    ),
    titleMedium: const TextStyle(
      fontSize: 14,
      height: 1.35,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    ),
    titleSmall: const TextStyle(
      fontSize: 12.5,
      height: 1.35,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    ),
    bodyLarge: const TextStyle(
      fontSize: 14.5,
      height: 1.55,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
    ),
    bodyMedium: const TextStyle(
      fontSize: 13,
      height: 1.55,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
    ),
    bodySmall: const TextStyle(
      fontSize: 11.5,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: AppColors.muted,
    ),
    labelLarge: const TextStyle(
      fontSize: 13,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: AppColors.blue,
    ),
    labelMedium: const TextStyle(
      fontSize: 11.5,
      height: 1.25,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    textTheme: textTheme,
    dividerColor: AppColors.border,
    splashFactory: InkSparkle.splashFactory,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F4EE),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      labelStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      prefixIconColor: AppColors.muted,
      suffixIconColor: AppColors.muted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.input),
        borderSide: const BorderSide(color: AppColors.red, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        backgroundColor: AppColors.surface,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.navyDeep,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.navyDeep,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.blue,
      linearTrackColor: AppColors.softSlate,
    ),
  );
}
