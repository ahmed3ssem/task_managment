import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_colors.dart';
import 'theme_cubit.dart';

class ThemeHelper {
  const ThemeHelper._();

  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color primaryColor(BuildContext context) => AppColors.primaryColor;

  static Color secondaryColor(BuildContext context) => AppColors.secondColor;

  static Color backgroundColor(BuildContext context) => isDarkMode(context)
      ? AppColors.darkBackground
      : AppColors.lightBackground;

  static Color surfaceColor(BuildContext context) =>
      isDarkMode(context) ? AppColors.darkSurface : AppColors.lightSurface;

  static Color cardColor(BuildContext context) =>
      isDarkMode(context) ? AppColors.darkCard : AppColors.lightCard;

  static Color borderColor(BuildContext context) =>
      isDarkMode(context) ? AppColors.darkBorder : AppColors.lightBorder;

  static Color textPrimaryColor(BuildContext context) => isDarkMode(context)
      ? AppColors.darkTextPrimary
      : AppColors.lightTextPrimary;

  static Color textSecondaryColor(BuildContext context) => isDarkMode(context)
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary;

  static Color errorColor(BuildContext context) =>
      isDarkMode(context) ? AppColors.darkError : AppColors.lightError;

  // Success & Warning
  static Color successColor(BuildContext context) => AppColors.green;

  static Color warningColor(BuildContext context) => AppColors.orange;

  // Common Colors
  static Color whiteColor(BuildContext context) => AppColors.white;

  static Color blackColor(BuildContext context) => AppColors.black;

  static Color redColor(BuildContext context) => AppColors.red;

  static Color hyperlinkColor(BuildContext context) => AppColors.hyperLink;

  /// Toggle between light and dark mode
  static void toggleThemeMode(BuildContext context) {
    context.read<ThemeCubit>().toggleTheme();
  }
}
