import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF8AA7);
  static const background = Color(0xFF150629);
  static const surface = Color(0xFF301A4D);
  static const textPrimary = Color(0xFFEFDFFF);
  static const neonBlue = Color(0xFF00F0FF);
  static const neonPink = Color(0xFFFF8AA7);
  static const neonLime = Color(0xFFCCFF00);
}

class AppTextStyles {
  static const fontFamily = 'PlusJakartaSans';

  static TextStyle plusJakarta({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      surface: AppColors.surface,
      background: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textPrimary),
    ),
  );
}
