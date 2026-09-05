import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/theme/app_colors.dart';
import '/app/core/widgets/app_text_widget.dart';
import 'package:sizer/sizer.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;

  const CustomErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.w, color: Colors.redAccent),
          SizedBox(height: 2.h),
          AppTextWidget(
            text: message ?? "something_went_wrong".tr,
            textAlign: TextAlign.center,
            fontSize: 16,
            color: Colors.redAccent,
          ),
          if (onRetry != null) ...[
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: AppTextWidget(text: "retry".tr),
            ),
          ],
        ],
      ),
    );
  }
}
