import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/utils/local_strings.dart';

class MessageWidget {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(
    String message,
    Color color,
    VoidCallback onTap, {
    String? labelText,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: color,
      action: SnackBarAction(
        textColor: Colors.white,
        label: (labelText != null && labelText.isNotEmpty)
            ? labelText
            : 'ok'.tr,
        onPressed: onTap,
      ),
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
