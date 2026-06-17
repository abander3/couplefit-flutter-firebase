import 'package:flutter/material.dart';

class AppColors {
  static const anthonyGreen = Color(0xFF1F5E3B);
  static const aspenTeal = Color(0xFF009E9A);
  static const background = Color(0xFFF7F9F7);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}
