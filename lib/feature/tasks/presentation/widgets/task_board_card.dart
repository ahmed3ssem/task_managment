// ============================================================================
// File: task_board_card.dart
// Description: UI Card widget for individual Task Board items in the list view.
//              Implements Figma specs with custom user styling:
//              - Matching Create Board icon before name (space_dashboard_outlined)
//              - Department title with brand green accent color
//              - Polished warm badge for "Owner" role
//              - Overlapping member avatars and "+N" count
//              - Formatted creation date
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_strings.dart';
import '../../data/models/task_board_model.dart';

/// [TaskBoardCard] renders a single board card in the tasks list.
///
/// Responsibilities:
/// - Displays board icon, board name, and green-accented department.
/// - Shows role status badge ("Owner") with a modern amber/orange tint.
/// - Presents board summary description with clean typography.
/// - Displays creation date alongside member avatar stack and overflow count.
class TaskBoardCard extends StatelessWidget {
  final TaskBoardModel board;
  final VoidCallback? onTap;

  const TaskBoardCard({super.key, required this.board, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsetsDirectional.all(14.w),
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
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------------------
              // 1. Top Row: Icon + Board Name/Department + Owner Badge
              // --------------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Board Icon Container (matches Create Board button icon)
                  Container(
                    width: 40.w,
                    height: 40.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : const Color(0xFFF0F7EB),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.space_dashboard_outlined,
                      size: 22.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Board Name & Green Department
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          board.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textDark,
                            fontFamily: TextStyles.textLarge.fontFamily,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        // Department with brand green accent value
                        Text.rich(
                          TextSpan(
                            text: LocalStrings.department,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                              fontFamily: TextStyles.textLarge.fontFamily,
                            ),
                            children: [
                              TextSpan(
                                text: board.department,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                  fontFamily: TextStyles.textLarge.fontFamily,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Owner Badge (Warm subtle amber pill)
                  _buildOwnerBadge(context, isDark),
                ],
              ),

              SizedBox(height: 12.h),

              // --------------------------------------------------------------
              // 2. Middle: Description Text
              // --------------------------------------------------------------
              Text(
                board.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : const Color(0xFF6B7280),
                  fontFamily: TextStyles.textLarge.fontFamily,
                ),
              ),

              SizedBox(height: 14.h),

              // --------------------------------------------------------------
              // 3. Bottom Row: Creation Date & Assigned Members
              // --------------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Creation Date
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        text: LocalStrings.creationDate,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMuted,
                          fontFamily: TextStyles.textLarge.fontFamily,
                        ),
                        children: [
                          TextSpan(
                            text: board.creationDate,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textDark,
                              fontFamily: TextStyles.textLarge.fontFamily,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Member Avatars Stack & Counter
                  _buildMembersStack(context, isDark),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the modern "Owner" role pill replacing the dull grey Figma background.
  Widget _buildOwnerBadge(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF332011) : AppColors.lightOrange,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: isDark ? 0.4 : 0.25),
          width: 0.8.w,
        ),
      ),
      child: Text(
        LocalStrings.owner,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFFFFB74D) : AppColors.darkOrange,
          fontFamily: TextStyles.textLarge.fontFamily,
        ),
      ),
    );
  }

  /// Renders overlapping circular member avatars with an optional "+N" counter.
  Widget _buildMembersStack(BuildContext context, bool isDark) {
    // Generate up to 3 preview avatars
    final avatarCount = board.memberAvatars.length.clamp(0, 3);
    final displayedCount = avatarCount > 0 ? avatarCount : 3;

    // Pleasant background colors for fallback member avatars
    final fallbackColors = [
      const Color(0xFFE0E7FF),
      const Color(0xFFFCE7F3),
      const Color(0xFFD1FAE5),
    ];
    final fallbackTextColors = [
      const Color(0xFF4338CA),
      const Color(0xFFBE185D),
      const Color(0xFF047857),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Overlapping Avatars Stack
        SizedBox(
          height: 24.w,
          width: (displayedCount * 18.w) + 6.w,
          child: Stack(
            children: List.generate(displayedCount, (index) {
              final leftOffset = index * 18.w;
              return PositionedDirectional(
                start: leftOffset,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fallbackColors[index % fallbackColors.length],
                    border: Border.all(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      width: 1.5.w,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person_rounded,
                    size: 14.sp,
                    color:
                        fallbackTextColors[index % fallbackTextColors.length],
                  ),
                ),
              );
            }),
          ),
        ),

        // "+N" Additional Members Badge
        if (board.additionalMembersCount > 0) ...[
          SizedBox(width: 4.w),
          Text(
            '+${board.additionalMembersCount}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              fontFamily: TextStyles.textLarge.fontFamily,
            ),
          ),
        ],
      ],
    );
  }
}
