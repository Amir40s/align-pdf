import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/utils/l10n_utils.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class PreviewEmptyState extends StatelessWidget {
  const PreviewEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.document_scanner_outlined,
                size: 12.w,
                color: AppColors.primary,
              ),
            ),
            Gap(2.h),
            AppTextWidget(
              text: context.l10n.noPages,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            Gap(1.h),
            AppTextWidget(
              text: context.l10n.scanDocumentToSeeItHere,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
