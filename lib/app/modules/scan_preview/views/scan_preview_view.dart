import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_appbar.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_button.dart';
import 'package:align_pdf_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/scan_preview_controller.dart';
import 'widget/delete_confirmation_dialog.dart';
import 'widget/preview_action_button.dart';
import 'widget/preview_empty_state.dart';
import 'widget/preview_image_card.dart';
import 'widget/preview_thumbnail_item.dart';

class ScanPreviewView extends GetView<ScanPreviewController> {
  const ScanPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Scan Preview",
        action: Obx(
          () => Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Center(
              child: AppTextWidget(
                text: '${controller.scannedPages.length} Pages',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.scannedPages.isEmpty) {
          return const PreviewEmptyState();
        }

        return Column(
          children: [
            Expanded(flex: 5, child: PreviewImageCard(controller: controller)),
            Gap(2.h),
            SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildActionsRow(),
                    Gap(1.h),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    Gap(1.h),
                    _buildThumbnailsSection(),
                    Gap(1.h),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    Gap(1.h),
                    _buildBottomButtons(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionsRow() {
    return Row(
      children: [
        Expanded(
          child: PreviewActionButton(
            icon: Icons.crop_rounded,
            title: 'Crop',
            onTap: () async => await controller.cropCurrentPage(),
          ),
        ),
        Expanded(
          child: PreviewActionButton(
            icon: Icons.rotate_right_rounded,
            title: 'Rotate',
            onTap: () async => await controller.rotateCurrentPage(),
          ),
        ),
        Expanded(
          child: PreviewActionButton(
            icon: Icons.auto_fix_high_rounded,
            title: 'Enhance',
            onTap: () async => await controller.enhanceCurrentPage(),
          ),
        ),
        Expanded(
          child: PreviewActionButton(
            icon: Icons.text_fields_rounded,
            title: 'OCR',
            onTap: () async {
              final page = controller.currentPage;

              if (page == null) {
                return;
              }
              if (page.extractedText.isNotEmpty) {
                Get.toNamed(
                  Routes.EXTRACT_TEXT,
                  arguments: {
                    'text': page.extractedText.text,
                    'imagePath': page.displayImagePath,
                  },
                );

                return;
              }
              final success = await controller.extractCurrentText();

              if (!success) {
                return;
              }
              final updatedPage = controller.currentPage;

              if (updatedPage == null) {
                return;
              }

              Get.toNamed(
                Routes.EXTRACT_TEXT,
                arguments: {
                  'text': updatedPage.extractedText.text,
                  'imagePath': updatedPage.displayImagePath,
                },
              );
            },
          ),
        ),
        Expanded(
          child: PreviewActionButton(
            icon: Icons.delete_outline_rounded,
            title: 'Delete',
            iconColor: Colors.red,
            onTap: () {
              DeleteConfirmationDialog.show(
                totalPages: controller.scannedPages.length,
                onConfirm: () => controller.deleteCurrentPage(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailsSection() {
    return Obx(() {
      if (controller.scannedPages.length == 1) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 13.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget(
                    text: 'Pages',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  AppTextWidget(
                    text: 'Tap a page to preview',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            Gap(1.h),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.scannedPages.length + 1,
                  separatorBuilder: (_, _) => Gap(2.w),
                  itemBuilder: (context, index) {
                    if (index == controller.scannedPages.length) {
                      return AddPageThumbnailButton(
                        onTap: () => controller.requestAddPage(),
                      );
                    }

                    return Obx(() {
                      final isSelected =
                          controller.currentPageIndex.value == index;
                      return PreviewThumbnailItem(
                        page: controller.scannedPages[index],
                        pageIndex: index,
                        isSelected: isSelected,
                        onTap: () => controller.selectPage(index),
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Obx(() {
          if (controller.scannedPages.length == 1) {
            return Expanded(
              child: AppButtonWidget(
                text: "Add Page",
                height: 5.7.h,
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                onTap: () => controller.requestAddPage(),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        Gap(3.w),
        Expanded(
          child: AppButtonWidget(
            text: "Create PDF",
            height: 5.7.h,
            onTap: () async => await controller.done(),
          ),
        ),
      ],
    );
  }
}
