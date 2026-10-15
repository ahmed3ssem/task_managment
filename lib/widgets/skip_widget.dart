import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme/styles.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/local_strings.dart';

class SkipWidget extends StatelessWidget {
  final VoidCallback onTap;
  const SkipWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'skip'.tr,
            style: TextStyles.textMedium5.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          Positioned(
            bottom: 3.h, // adjust slightly
            child: Container(
              width: 40.w, // adjust to match text width
              height: 1.5.h,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
