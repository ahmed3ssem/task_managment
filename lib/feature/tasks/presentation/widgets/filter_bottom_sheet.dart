// ============================================================================
// File: filter_bottom_sheet.dart
// Description: Modal bottom sheet for filtering task boards by:
//              1. Creation Date (interactive date picker calendar)
//              2. Department (dropdown list populated from Firebase data)
//              3. Owning Status (dropdown with strictly "Owner" option)
//              Includes Reset and Apply actions with validation according to Figma specs.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_strings.dart';

/// [TaskFilterCriteria] holds the active filter parameters applied to task boards.
class TaskFilterCriteria {
  final DateTime? creationDate;
  final String? department;
  final String? owningStatus;

  const TaskFilterCriteria({
    this.creationDate,
    this.department,
    this.owningStatus,
  });

  /// True if no filter conditions are set.
  bool get isEmpty =>
      creationDate == null &&
      (department == null || department!.trim().isEmpty) &&
      (owningStatus == null || owningStatus!.trim().isEmpty);

  /// True if at least one filter criterion is active.
  bool get isNotEmpty => !isEmpty;
}

/// [FilterBottomSheet] presents the Figma-designed filter modal bottom sheet.
class FilterBottomSheet extends StatefulWidget {
  final TaskFilterCriteria? initialFilter;
  final List<String> availableDepartments;

  const FilterBottomSheet({
    super.key,
    this.initialFilter,
    this.availableDepartments = const [],
  });

  /// Static helper to display the filter modal bottom sheet.
  static Future<TaskFilterCriteria?> show(
    BuildContext context, {
    TaskFilterCriteria? initialFilter,
    List<String> availableDepartments = const [],
  }) {
    return showModalBottomSheet<TaskFilterCriteria>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialFilter: initialFilter,
        availableDepartments: availableDepartments,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  DateTime? _selectedDate;
  String? _selectedDepartment;
  String? _selectedOwningStatus;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _selectedDate = widget.initialFilter!.creationDate;
      _selectedDepartment = widget.initialFilter!.department;
      _selectedOwningStatus = widget.initialFilter!.owningStatus;
    }
  }

  // --------------------------------------------------------------------------
  // Action Handlers
  // --------------------------------------------------------------------------

  /// Opens the DatePicker dialog for Creation Date.
  Future<void> _pickCreationDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// Validates and applies the filter.
  void _onApplyPressed() {
    final hasDate = _selectedDate != null;
    final hasDept =
        _selectedDepartment != null && _selectedDepartment!.isNotEmpty;
    final hasStatus =
        _selectedOwningStatus != null && _selectedOwningStatus!.isNotEmpty;

    if (!hasDate && !hasDept && !hasStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocalStrings.selectAtLeastOneFilter,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.redAlert,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
      return;
    }

    final criteria = TaskFilterCriteria(
      creationDate: _selectedDate,
      department: _selectedDepartment,
      owningStatus: _selectedOwningStatus,
    );

    Navigator.of(context).pop(criteria);
  }

  /// Resets all filter fields.
  /// If an active filter was applied, closes sheet and clears the screen filter.
  void _onResetPressed() {
    final hadActiveFilter =
        widget.initialFilter != null && widget.initialFilter!.isNotEmpty;
    final hadSelections =
        _selectedDate != null ||
        (_selectedDepartment != null && _selectedDepartment!.isNotEmpty) ||
        (_selectedOwningStatus != null && _selectedOwningStatus!.isNotEmpty);

    if (!hadActiveFilter && !hadSelections) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocalStrings.selectAtLeastOneFilter,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.redAlert,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
      return;
    }

    setState(() {
      _selectedDate = null;
      _selectedDepartment = null;
      _selectedOwningStatus = null;
    });

    // If filter was previously applied to the screen, dismiss sheet and restore all items
    if (hadActiveFilter) {
      Navigator.of(context).pop(const TaskFilterCriteria());
    }
  }

  // --------------------------------------------------------------------------
  // UI Building
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final systemBottomPadding = MediaQuery.of(context).padding.bottom;

    // Distinct departments list for dropdown
    final deptItems = widget.availableDepartments.isEmpty
        ? const ['Marketing']
        : widget.availableDepartments;

    final String creationDateLabel = LocalStrings.creationDate
        .replaceAll(':', '')
        .trim();
    final String departmentLabel = LocalStrings.department
        .replaceAll(':', '')
        .trim();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(-3, 4),
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.only(
        start: 24.w,
        end: 24.w,
        top: 12.h,
        bottom:
            bottomInset +
            (systemBottomPadding > 0 ? systemBottomPadding : 16.h) +
            20.h,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle Indicator
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFDCDCDC),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Header: Circular Icon Badge + "Filter" Title + Close Button
              Row(
                children: [
                  // 30x30 Figma Grey Circle Badge with Tuning Icon
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9E9E9E),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.tune_rounded,
                        size: 16.sp,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Text(
                    LocalStrings.filter,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : const Color(0xFF2D2D2D),
                      fontFamily: TextStyles.textLarge.fontFamily,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textMuted,
                      size: 22.sp,
                    ),
                    splashRadius: 20.r,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // 1. Creation Date Field (Tap opens Calendar)
              _buildFieldLabel(context, creationDateLabel, isDark),
              SizedBox(height: 6.h),
              InkWell(
                onTap: () => _pickCreationDate(context),
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  height: 42.h,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFE2E2E2),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('d MMM yyyy').format(_selectedDate!)
                            : LocalStrings.selectDate,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: _selectedDate != null
                              ? (isDark
                                    ? AppColors.darkTextPrimary
                                    : const Color(0xFF2D2D2D))
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : const Color(0xFF797979)),
                          fontFamily: TextStyles.textLarge.fontFamily,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18.sp,
                        color: const Color(0xFF797979),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // 2. Department Dropdown Field
              _buildFieldLabel(context, departmentLabel, isDark),
              SizedBox(height: 6.h),
              Container(
                height: 42.h,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE2E2E2),
                    width: 1.w,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDepartment,
                    isExpanded: true,
                    hint: Text(
                      departmentLabel,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF797979),
                        fontFamily: TextStyles.textLarge.fontFamily,
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22.sp,
                      color: const Color(0xFF797979),
                    ),
                    dropdownColor: isDark
                        ? AppColors.darkCard
                        : AppColors.white,
                    items: deptItems.map((dept) {
                      return DropdownMenuItem<String>(
                        value: dept,
                        child: Text(
                          dept,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : const Color(0xFF2D2D2D),
                            fontFamily: TextStyles.textLarge.fontFamily,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedDepartment = val;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // 3. Owning Status Dropdown Field (Strictly "Owner")
              _buildFieldLabel(context, LocalStrings.owningStatus, isDark),
              SizedBox(height: 6.h),
              Container(
                height: 42.h,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE2E2E2),
                    width: 1.w,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedOwningStatus,
                    isExpanded: true,
                    hint: Text(
                      LocalStrings.owningStatus,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF797979),
                        fontFamily: TextStyles.textLarge.fontFamily,
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22.sp,
                      color: const Color(0xFF797979),
                    ),
                    dropdownColor: isDark
                        ? AppColors.darkCard
                        : AppColors.white,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'Owner',
                        child: Text(
                          LocalStrings.owner,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : const Color(0xFF2D2D2D),
                            fontFamily: TextStyles.textLarge.fontFamily,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedOwningStatus = val;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // 4. Action Buttons Row: Reset & Apply
              Row(
                children: [
                  // Reset Button (Figma: rgba(204, 204, 204, 0.8), 8px radius)
                  Expanded(
                    child: SizedBox(
                      height: 42.h,
                      child: ElevatedButton(
                        onPressed: _onResetPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFCCCCCC,
                          ).withValues(alpha: 0.8),
                          foregroundColor: const Color(0xFF2D2D2D),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          LocalStrings.reset,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D2D2D),
                            fontFamily: TextStyles.textLarge.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 14.w),

                  // Apply Button (Matching Create Board: AppColors.primaryColor, 8px radius)
                  Expanded(
                    child: SizedBox(
                      height: 42.h,
                      child: ElevatedButton(
                        onPressed: _onApplyPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shadowColor: Colors.black.withValues(alpha: 0.04),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          LocalStrings.apply,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                            fontFamily: TextStyles.textLarge.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Additional bottom clearance so buttons are never obscured
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : const Color(0xFF2D2D2D),
        fontFamily: TextStyles.textLarge.fontFamily,
      ),
    );
  }
}
