import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';
import 'package:flutter_project_structure/widgets/error_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingItem extends StatefulWidget {
  const LoadingItem({super.key});

  @override
  State<LoadingItem> createState() => _LoadingItemState();
}

class _LoadingItemState extends State<LoadingItem> {
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return showError
        ? ErrorWidgetItem(onTap: () {})
        : Center(
            child: LoadingAnimationWidget.waveDots(
              color: AppColors.secondColor,
              size: ScreenUtil().setHeight(100),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          showError = true;
        });
      }
    });
  }
}
