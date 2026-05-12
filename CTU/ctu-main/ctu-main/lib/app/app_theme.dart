// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF8B0000);
  static const Color primaryDark = Color(0xFF6B0000);
  static const Color primaryLight = Color(0xFFB71C1C);
  static const Color accent = Color(0xFFC62828);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color divider = Color(0xFFE0E0E0);

  // Event type colors
  static const Color academic = Color(0xFF1565C0);
  static const Color examination = Color(0xFFB71C1C);
  static const Color holiday = Color(0xFF2E7D32);
  static const Color extracurricular = Color(0xFFE65100);
  static const Color meeting = Color(0xFF6A1B9A);

  static Color eventColor(dynamic type) {
    switch (type.toString().split('.').last) {
      case 'academic':
        return academic;
      case 'examination':
        return examination;
      case 'holiday':
        return holiday;
      case 'extracurricular':
        return extracurricular;
      case 'meeting':
        return meeting;
      default:
        return primary;
    }
  }
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF9E9E9E),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
