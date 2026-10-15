// ============================================================================
// File: task_action_buttons_row.dart
// Description: Action buttons row positioned beneath the search bar.
//              Contains the "Filter" button and "Create Board" primary button,
//              styled according to Figma specs and matching TaskCategoryCell active theme.
//              Uses proportional flex sizing to ensure 100% responsiveness on mobile.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_strings.dart';

/// [TaskActionButtonsRow] renders the secondary actions row:
/// 1. "Filter" Button (flex: 2): Opens filter bottom sheet modal.
/// 2. "Create Board" Button (flex: 3): Primary CTA styled in brand green (#568F22)
///    matching the active category cell, opens the board creation bottom sheet.
class TaskActionButtonsRow extends StatelessWidget {
  /// Callback triggered when the Filter button is tapped.
  final VoidCallback? onFilterTap;

  /// Callback triggered when the Create Board button is tapped.
  final VoidCallback? onCreateBoardTap;

  const TaskActionButtonsRow({
    super.key,
    this.onFilterTap,
    this.onCreateBoardTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    // Using Expanded with a 2:3 ratio (matching Figma's 100px:150px ratio)
    // guarantees that neither button overflows on narrow mobile screens.
    return Row(
      children: [
        // 1. Filter Button (Figma width: 100px -> flex: 2)
        Expanded(flex: 2, child: _buildFilterButton(context, isDark)),

        SizedBox(width: 12.w),

        // 2. Create Board Button (Figma width: 150px -> flex: 3)
        Expanded(flex: 3, child: _buildCreateBoardButton(context)),
      ],
    );
  }

  /// Builds the Filter Button according to Figma specs:
  /// - Background: White (#FFFFFF) in light mode, dark card in dark mode.
  /// - Border: 1px subtle outline (#E2E2E2 / darkBorder).
  /// - Icon: Minimalist tuning/filter icon (Icons.tune_rounded).
  /// - Text: Localized "Filter" in muted grey (#797979).
  Widget _buildFilterButton(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            onFilterTap ??
            () {
              // Future implementation: showFilterBottomSheet(context);
            },
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 38.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E2E2),
              width: 1.w,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 20,
                      offset: const Offset(-3, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20.sp,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textMuted,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  LocalStrings.filter,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted,
                    fontFamily: TextStyles.textLarge.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the Create Board Button according to Figma specs with active color match:
  /// - Background: Brand primary green (#568F22) matching active TaskCategoryCell.
  /// - Border: Primary green outline with subtle elevation.
  /// - Icon: Kanban / Board icon (Icons.space_dashboard_outlined) in white.
  /// - Text: Localized "Create Board" in crisp white.
  Widget _buildCreateBoardButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            onCreateBoardTap ??
            () {
              // Future implementation: showCreateBoardBottomSheet(context);
            },
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 38.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryColor, width: 1.w),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.space_dashboard_outlined,
                size: 20.sp,
                color: AppColors.white,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  LocalStrings.createBoard,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontFamily: TextStyles.textLarge.fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
