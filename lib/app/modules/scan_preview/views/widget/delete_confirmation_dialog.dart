import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DeleteConfirmationDialog {
  static void show({required int totalPages, required VoidCallback onConfirm}) {
    if (totalPages <= 1) {
      AppSnackbar.warning('Cannot Delete', 'At least one page is required.');
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
        title: AppTextWidget(
          text: 'Delete Page?',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        content: AppTextWidget(
          text: 'Are you sure you want to remove this page?',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AppTextWidget(
              text: 'Cancel',
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: AppTextWidget(
              text: 'Delete',
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
