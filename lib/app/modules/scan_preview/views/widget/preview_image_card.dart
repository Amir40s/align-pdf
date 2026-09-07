import 'dart:io';

import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/utils/l10n_utils.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/modules/scan_preview/controllers/scan_preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PreviewImageCard extends StatelessWidget {
  final ScanPreviewController controller;

  const PreviewImageCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.w),
          child: Obx(() {
            final page = controller.currentPage;

            if (page == null) {
              return const SizedBox.shrink();
            }

            final imagePath = page.displayImagePath;

            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFEDEDED),
                    padding: EdgeInsets.all(3.w),
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 3.0,
                      child: Center(
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 1.5.h,
                  left: 3.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: AppTextWidget(
                      text: context.l10n.pageNumber(
                        controller.currentPageIndex.value + 1,
                      ),
                      // text: 'Page ${controller.currentPageIndex.value + 1}',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (controller.isProcessing.value)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 2.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 8.w,
                                height: 8.w,
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2.5,
                                ),
                              ),
                              Gap(1.5.h),
                              AppTextWidget(
                                text: context.l10n.processing,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
