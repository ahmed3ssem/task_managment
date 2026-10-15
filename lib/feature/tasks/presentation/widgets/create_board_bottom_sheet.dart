// ============================================================================
// File: create_board_bottom_sheet.dart
// Description: Modal bottom sheet for creating a new Task Board.
//              Features rounded top corners, board name field, department dropdown
//              (single item: Marketing), multiline description field, and validation.
//              Dispatches board persistence via [TasksCubit] into Firebase RTDB.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_strings.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';

/// [CreateBoardBottomSheet] presents a bottom sheet form for adding a new board.
///
/// Fields:
/// - Board Name: Text input (validated non-empty)
/// - Board Department: Dropdown containing only "Marketing" (validated selected)
/// - Board Description: Multiline text input (validated non-empty)
///
/// On Save:
/// - Validates all inputs.
/// - Persists board (name, department, description, date) into Firebase Realtime Database.
class CreateBoardBottomSheet extends StatefulWidget {
  const CreateBoardBottomSheet({super.key});

  /// Static helper to display this bottom sheet with rounded top corners.
  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<TasksCubit>(),
          child: const CreateBoardBottomSheet(),
        );
      },
    );
  }

  @override
  State<CreateBoardBottomSheet> createState() => _CreateBoardBottomSheetState();
}

class _CreateBoardBottomSheetState extends State<CreateBoardBottomSheet> {
  // --------------------------------------------------------------------------
  // Form Keys & Controllers
  // --------------------------------------------------------------------------

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  /// Selected department value from dropdown (initialized to null to require user selection).
  String? _selectedDepartment;

  /// Available department items in the dropdown (strictly "Marketing").
  final List<String> _departmentOptions = const ['Marketing'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // Action Handlers
  // --------------------------------------------------------------------------

  /// Validates form inputs and initiates board persistence via [TasksCubit].
  void _onSavePressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TasksCubit>().createBoard(
        name: _nameController.text,
        department: _selectedDepartment ?? '',
        description: _descriptionController.text,
      );
    }
  }

  // --------------------------------------------------------------------------
  // UI Building
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is CreateBoardSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                LocalStrings.boardCreatedSuccessfully,
                style: const TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
          Navigator.of(context).pop(state.board);
        } else if (state is CreateBoardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.redAlert,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateBoardLoading;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsetsDirectional.only(
            start: 24.w,
            end: 24.w,
            top: 12.h,
            bottom: bottomInset + 24.h,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
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

                  // Header Row: Title & Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalStrings.createBoard,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textDark,
                          fontFamily: TextStyles.textLarge.fontFamily,
                        ),
                      ),
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

                  // 1. Board Name Field
                  _buildFieldLabel(context, LocalStrings.boardName, isDark),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _nameController,
                    enabled: !isLoading,
                    style: _inputTextStyle(isDark),
                    decoration: _inputDecoration(
                      hintText: LocalStrings.enterBoardName,
                      isDark: isDark,
                      prefixIcon: Icons.space_dashboard_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return LocalStrings.nameRequired;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // 2. Board Department Dropdown Field
                  _buildFieldLabel(
                    context,
                    LocalStrings.boardDepartment,
                    isDark,
                  ),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedDepartment,
                    isExpanded: true,
                    dropdownColor: isDark
                        ? AppColors.darkCard
                        : AppColors.white,
                    style: _inputTextStyle(isDark),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textMuted,
                    ),
                    decoration: _inputDecoration(
                      hintText: LocalStrings.selectDepartment,
                      isDark: isDark,
                      prefixIcon: Icons.business_center_outlined,
                    ),
                    items: _departmentOptions.map((dept) {
                      return DropdownMenuItem<String>(
                        value: dept,
                        child: Text(
                          LocalStrings.marketing,
                          style: _inputTextStyle(isDark),
                        ),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (val) {
                            setState(() {
                              _selectedDepartment = val;
                            });
                          },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalStrings.departmentRequired;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // 3. Board Description Field (Multiline)
                  _buildFieldLabel(
                    context,
                    LocalStrings.boardDescription,
                    isDark,
                  ),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: _descriptionController,
                    enabled: !isLoading,
                    minLines: 3,
                    maxLines: 5,
                    textAlignVertical: TextAlignVertical.top,
                    style: _inputTextStyle(isDark),
                    decoration: _inputDecoration(
                      hintText: LocalStrings.enterBoardDescription,
                      isDark: isDark,
                      prefixIcon: Icons.description_outlined,
                      isMultiline: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return LocalStrings.descriptionRequired;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24.h),

                  // 4. Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _onSavePressed(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor: AppColors.primaryColor
                            .withValues(alpha: 0.6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 22.sp,
                              height: 22.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 20.sp,
                                  color: AppColors.white,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  LocalStrings.save,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                    fontFamily: TextStyles.textLarge.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // Helper Styling Methods
  // --------------------------------------------------------------------------

  Widget _buildFieldLabel(BuildContext context, String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
        fontFamily: TextStyles.textLarge.fontFamily,
      ),
    );
  }

  TextStyle _inputTextStyle(bool isDark) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
      fontFamily: TextStyles.textLarge.fontFamily,
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required bool isDark,
    required IconData prefixIcon,
    bool isMultiline = false,
  }) {
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE2E2E2);

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
        fontFamily: TextStyles.textLarge.fontFamily,
      ),
      prefixIcon: isMultiline
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 12.h,
                    start: 14.w,
                    end: 10.w,
                  ),
                  child: Icon(
                    prefixIcon,
                    size: 18.sp,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted,
                  ),
                ),
              ],
            )
          : Icon(
              prefixIcon,
              size: 18.sp,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
      prefixIconConstraints: isMultiline
          ? BoxConstraints(minWidth: 42.w, minHeight: 44.h)
          : null,
      filled: true,
      fillColor: isDark ? AppColors.darkCard : AppColors.white,
      contentPadding: EdgeInsetsDirectional.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: borderColor, width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: borderColor, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.redAlert, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.redAlert, width: 1.5.w),
      ),
    );
  }
}
