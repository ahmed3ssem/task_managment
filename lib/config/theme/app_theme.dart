import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.grey,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: AppColors.white),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
    ),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        color: AppColors.black,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      ),
    ),
  );
}
