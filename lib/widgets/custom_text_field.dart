import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final bool? isFocused;
  final TextInputType? keyboardType;
  final String? iconAsset;
  final String? activeIconAsset;
  final bool obscureText;
  final bool isEnabled;
  final Widget? suffixIcon;
  final double? padding;
  final Color? borderColor;
  final String? Function(String? value)? validator;
  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.isFocused = false,
    this.keyboardType,
    this.iconAsset,
    this.activeIconAsset,
    this.obscureText = false,
    this.suffixIcon,
    this.isEnabled = true,
    this.padding = 40,
    this.borderColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: padding!.w),
      child: TextFormField(
        validator: validator,
        enabled: isEnabled,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          hintStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: isFocused!
                  ? AppColors.secondColor
                  : borderColor ?? AppColors.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: isFocused!
                  ? AppColors.secondColor
                  : borderColor ?? AppColors.primaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(
              color: isFocused!
                  ? AppColors.secondColor
                  : AppColors.primaryColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(color: borderColor ?? AppColors.black),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: activeIconAsset == null
              ? null
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    isFocused! ? activeIconAsset ?? '' : iconAsset ?? '',
                    width: 18.w,
                    height: 13.h,
                  ),
                ),
        ),
      ),
    );
  }
}
