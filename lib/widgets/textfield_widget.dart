import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';

class TextFieldWidget extends StatefulWidget {
  final double height;
  final double width;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final String? hintText;
  final bool isPasswordTextField;
  final TextInputType keyboardType;

  const TextFieldWidget({
    super.key,
    required this.height,
    required this.width,
    required this.controller,
    this.prefixIcon,
    this.hintText,
    required this.isPasswordTextField,
    required this.keyboardType,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = widget.isPasswordTextField;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: widget.height.sp,
      //width: widget.width.sp,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: passwordVisible,
        style: TextStyle(
          fontSize: 17.sp,
          color: AppColors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.height,
            horizontal: 10.sp,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.grey,
            ), //<-- SEE HERE
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            //<-- SEE HERE
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.grey,
            ), //<-- SEE HERE
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: widget.isPasswordTextField
              ? IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          border: InputBorder.none,
          prefixIcon: widget.prefixIcon,
        ),
      ),
    );
  }
}
