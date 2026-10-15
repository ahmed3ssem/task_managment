import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project_structure/config/theme/styles.dart';
import 'package:flutter_project_structure/widgets/svg_image_widget.dart';

import '../core/utils/app_colors.dart';

class EmptyDataWidget extends StatelessWidget {
  final String text;
  const EmptyDataWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SVGImageWidget(image: "", width: 125.w, height: 115.h),
          SizedBox(height: 40.h),
          Text(
            text,
            style: TextStyles.textSmall.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
