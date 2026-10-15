// ============================================================================
// File: task_search_bar.dart
// Description: A dedicated search input widget designed for Task Management.
//              Implements Figma specs with 8px rounded corners, search icon,
//              localized placeholder, and dynamic clear action.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../config/theme/theme_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/local_strings.dart';

/// [TaskSearchBar] provides a customized search field for filtering tasks by task name.
///
/// Key Responsibilities:
/// - Renders an 8px rounded search box styled per Figma specs.
/// - Displays a leading minimalistic magnifier icon.
/// - Shows localized placeholder text ("Search" / "بحث").
/// - Dynamically displays a trailing clear ('X') button when user inputs text.
/// - Invokes [onChanged] with the current query and [onClear] to reset task filters.
class TaskSearchBar extends StatefulWidget {
  /// Optional external controller. If null, an internal controller is managed.
  final TextEditingController? controller;

  /// Callback triggered whenever the search text changes.
  final ValueChanged<String>? onChanged;

  /// Callback triggered when the clear ('X') button is tapped to reset the list.
  final VoidCallback? onClear;

  /// Optional custom hint text; defaults to localized [LocalStrings.search].
  final String? hintText;

  const TaskSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hintText,
  });

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  // --------------------------------------------------------------------------
  // State & Controllers
  // --------------------------------------------------------------------------

  late final TextEditingController _internalController;

  /// Provides the active controller, favoring the external one if supplied.
  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    // Initialize fallback internal controller if none passed
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    // Listen to text updates to toggle clear button visibility
    _effectiveController.addListener(_onTextChanged);
  }

  /// Rebuilds widget when text changes between empty and non-empty.
  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // Action Handlers
  // --------------------------------------------------------------------------

  /// Clears the search field, notifies parent listeners to reset list state,
  /// and unfocuses the keyboard.
  void _clearSearch() {
    _effectiveController.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    FocusScope.of(context).unfocus();
  }

  // --------------------------------------------------------------------------
  // UI Building
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final hasText = _effectiveController.text.isNotEmpty;

    // Corner radius of 8px as required by Figma design
    final borderRadius = BorderRadius.circular(15.r);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E2E2),
            width: 1.w,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: TextField(
          controller: _effectiveController,
          onChanged: widget.onChanged,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textDark,
            fontFamily: TextStyles.textLarge.fontFamily,
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: 12.w,
              vertical: 11.h,
            ),
            // Localized placeholder text
            hintText: widget.hintText ?? LocalStrings.search,
            hintStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
              fontFamily: TextStyles.textLarge.fontFamily,
            ),
            // Leading search magnifier icon (Figma minimalistic magnifier)
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 14.w, end: 10.w),
              child: Icon(
                Icons.search_rounded,
                size: 22.sp,
                color: AppColors.textMuted,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 44.w,
              minHeight: 44.h,
            ),
            // Dynamic trailing close/clear button: visible only when text is entered
            suffixIcon: hasText
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20.sp,
                      color: AppColors.textMuted,
                    ),
                    splashRadius: 18.r,
                    onPressed: _clearSearch,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
