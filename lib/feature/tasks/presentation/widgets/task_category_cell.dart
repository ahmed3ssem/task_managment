// ============================================================================
// File: task_category_cell.dart
// Description: Interactive category cell widget for the horizontal filter list.
//              Renders a 45x45 number badge and localized category label with
//              Brand Green Accent styling and smooth touch feedback.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/utils/app_colors.dart';

/// [TaskCategoryCell] is an interactive item in the task categories filter list.
///
/// Visual Specifications:
/// - Selected State:
///   - Badge Background: Brand primary green (#568F22)
///   - Badge Number: White (#FFFFFF), bold weight (w700)
///   - Category Label: Primary text color (#2D2D2D / #FFFFFF in dark mode), bold weight (w700)
/// - Unselected State:
///   - Badge Background: Card white (#FFFFFF) with subtle border (#E2E2E2 / #3B3B3B)
///   - Badge Number: Muted grey (#797979), medium weight (w500)
///   - Category Label: Muted grey (#797979), medium weight (w500)
class TaskCategoryCell extends StatelessWidget {
  /// Category label text (e.g. "All", "Marketing").
  final String title;

  /// Number of tasks within this category displayed in the square badge.
  final int count;

  /// Whether this category is currently selected/active.
  final bool isSelected;

  /// Callback executed when this cell is tapped.
  final VoidCallback onTap;

  const TaskCategoryCell({
    super.key,
    required this.title,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    // ------------------------------------------------------------------------
    // Color Palette Selection (Brand Green Accent Theme)
    // ------------------------------------------------------------------------
    final Color selectedBadgeBg = AppColors.primaryColor;
    final Color unselectedBadgeBg = isDark
        ? AppColors.darkCard
        : AppColors.white;
    final Color badgeBorderColor = isDark
        ? AppColors.darkBorder
        : const Color(0xFFE2E2E2);

    final Color selectedBadgeTextColor = AppColors.white;
    final Color unselectedBadgeTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textMuted;

    final Color selectedTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textDark;
    final Color unselectedTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textMuted;

    // ------------------------------------------------------------------------
    // UI Structure
    // ------------------------------------------------------------------------
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 4.w,
            vertical: 4.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 45x45 Square Badge displaying task count
              Container(
                width: 45.w,
                height: 45.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? selectedBadgeBg : unselectedBadgeBg,
                  borderRadius: BorderRadius.circular(4.r),
                  border: isSelected
                      ? null
                      : Border.all(color: badgeBorderColor, width: 1.w),
                ),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? selectedBadgeTextColor
                        : unselectedBadgeTextColor,
                    fontFamily: TextStyles.textLarge.fontFamily,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              // Category Name Label
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontFamily: TextStyles.textLarge.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
