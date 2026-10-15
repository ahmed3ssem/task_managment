import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/local_strings.dart';

class CustomBottomLoading extends StatelessWidget {
  final bool isPaginationLoading, isPaginationFailed;
  final double bottomPadding;
  final VoidCallback onReLoading;

  const CustomBottomLoading({
    super.key,
    required this.isPaginationLoading,
    required this.isPaginationFailed,
    required this.onReLoading,
    this.bottomPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (isPaginationLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "loadingMore".tr,
              style: const TextStyle(color: AppColors.grey, fontSize: 12),
            ),
            SizedBox(height: bottomPadding),
          ],
        ),
      );
    } else if (isPaginationFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: onReLoading, icon: const Icon(Icons.refresh)),
            Text(
              "refresh".tr,
              style: const TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
