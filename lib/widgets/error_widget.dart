import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import '../core/utils/local_strings.dart';

class ErrorWidgetItem extends StatelessWidget {
  final VoidCallback onTap;
  const ErrorWidgetItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // align back icon to start
      children: [
        // 🔹 Back button
        Container(
          margin: EdgeInsetsDirectional.only(top: 20.h),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.secondColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        const SizedBox(height: 20), // spacing after back icon
        // 🔹 Main content centered
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 100.r,
                  color: AppColors.secondColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'somethingWentWrong'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              Text(
                'pleaseTryAgain'.tr,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.55,
                height: 55.h,
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: onTap,
                  child: Text(
                    'reloadScreen'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
