import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import 'message_widget.dart';

class SnackBarService {
  static void show(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: AppColors.white, fontFamily: 'Tajawal'),
      ),
      backgroundColor: AppColors.primaryColor,
      duration: const Duration(seconds: 4),
    );
    MessageWidget.scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
