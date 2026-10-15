import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';
import '../PrefHelper/helper.dart';

class TextStyles {
  static String get _fontFamily {
    final lang = Helper.getLanguage();
    if (lang == 'en') return 'Cambay';
    return 'Tajawal';
  }

  static TextStyle get textXLarge => TextStyle(
    fontSize: 32.sp,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textLarge => TextStyle(
    fontSize: 28.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w800,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textLarge2 => TextStyle(
    fontSize: 24.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w800,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textLarge3 => TextStyle(
    fontSize: 20.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w800,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textMedium2 => TextStyle(
    fontSize: 20.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textMedium => TextStyle(
    fontSize: 18.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  /// Mobile Arabic/H3 - 18sp, bold, line height 22, primary dark green (e.g. continue with email button)
  static TextStyle get textMediumPrimary => TextStyle(
    fontSize: 18.sp,
    color: AppColors.darkGreen,
    fontWeight: FontWeight.w700,
    height: 22 / 18,
    fontFamily: _fontFamily,
  );

  static TextStyle get textMedium3 => TextStyle(
    fontSize: 16.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textMedium4 => TextStyle(
    fontSize: 15.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textMedium5 => TextStyle(
    fontSize: 17.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textMedium6 => TextStyle(
    fontSize: 22.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
    height: 1.5,
    fontFamily: _fontFamily,
  );

  static TextStyle get textSmall => TextStyle(
    fontSize: 17.sp,
    height: 1.5,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
  );

  static TextStyle get textXSmall => TextStyle(
    fontSize: 16.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
  );

  static TextStyle get textXXSmall => TextStyle(
    fontSize: 15.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
  );

  static TextStyle get textXXXSmall => TextStyle(
    fontSize: 14.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
  );

  static TextStyle get textXXXXSmall => TextStyle(
    fontSize: 14.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
  );

  static TextStyle get textExtraSmall => TextStyle(
    fontSize: 13.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
  );

  static TextStyle get textExtraSmall2 => TextStyle(
    fontSize: 13.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
  );

  static TextStyle get textExtraSmall3 => TextStyle(
    fontSize: 10.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
  );

  static TextStyle get textExtraSmall4 => TextStyle(
    fontSize: 11.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
  );

  static TextStyle get textExtraSmall5 => TextStyle(
    fontSize: 14.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
  );
}
