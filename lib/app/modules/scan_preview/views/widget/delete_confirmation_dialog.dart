import 'package:align_pdf_ai/app/core/utils/l10n_utils.dart';
import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DeleteConfirmationDialog {
  static void show({
    required int totalPages,
    required VoidCallback onConfirm,
    required BuildContext context,
  }) {
    if (totalPages <= 1) {
      AppSnackbar.warning(
        context.l10n.cannotDelete,
        context.l10n.atLeastOnePageRequired,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
        title: AppTextWidget(
          text: context.l10n.deletePageQuestion,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        content: AppTextWidget(
          text: context.l10n.areYouSureDeletePdf,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AppTextWidget(
              text: context.l10n.cancel,
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
              text: context.l10n.delete,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
