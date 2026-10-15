import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import '../config/theme/styles.dart';

class ButtonWidget extends StatelessWidget {
  final String btName;
  final VoidCallback onTap;

  const ButtonWidget({super.key, required this.btName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 16.w, right: 16.w),
        padding: EdgeInsets.symmetric(vertical: 17.h),
        decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: AppColors.primaryColor),
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(200.r),
        ),
        child: Text(
          btName,
          textAlign: TextAlign.center,
          style: TextStyles.textMedium3.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
