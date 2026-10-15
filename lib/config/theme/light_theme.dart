import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_constant.dart';

class LightTheme {
  const LightTheme._();

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    dividerColor: Colors.transparent,

    primaryColor: AppColors.primaryColor,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondColor,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
    ),

    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstance.radiusTiny),
        side: const BorderSide(
          color: AppColors.lightBorder,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstance.radiusTiny),
        borderSide: const BorderSide(
          color: AppColors.lightBorder,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstance.radiusTiny),
        borderSide: const BorderSide(
          color: AppColors.lightBorder,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstance.radiusTiny),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstance.radiusTiny),
        borderSide: const BorderSide(
          color: AppColors.lightError,
        ),
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColors.lightTextPrimary,
      ),
      bodyMedium: TextStyle(
        color: AppColors.lightTextPrimary,
      ),
      bodySmall: TextStyle(
        color: AppColors.lightTextSecondary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          vertical: AppConstance.vPadding,
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppConstance.radiusTiny,
          ),
        ),
      ),
    ),

    iconTheme: const IconThemeData(
      color: AppColors.lightTextPrimary,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 0.5,
    ),
  );
}