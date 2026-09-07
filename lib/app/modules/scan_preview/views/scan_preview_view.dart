import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/utils/l10n_utils.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_appbar.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_button.dart';
import 'package:align_pdf_ai/app/modules/scan_document/controllers/scan_document_controller.dart';
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
  void _handleBack() {
    controller.clearPreviewSession();
    if (Get.isRegistered<ScanDocumentController>()) {
      Get.find<ScanDocumentController>().clearScanSession();
    }
    Get.until((route) => route.settings.name == Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.l10n.scanPreview,
          onBack: _handleBack,
          action: Obx(
            () => Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Center(
                child: AppTextWidget(
                  text:
                      '${controller.scannedPages.length} ${context.l10n.pages}',
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
              Expanded(
                flex: 5,
                child: PreviewImageCard(controller: controller),
              ),
              Gap(2.h),
              SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 1.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildActionsRow(context),
                      Gap(1.h),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                      Gap(1.h),
                      _buildThumbnailsSection(context),
                      Gap(1.h),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                      Gap(1.h),
                      _buildBottomButtons(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PreviewActionButton(
            icon: Icons.crop_rounded,
            title: context.l10n.crop,
            onTap: () async => await controller.cropCurrentPage(),
          ),
        ),
        Expanded(
          child: PreviewActionButton(
            icon: Icons.rotate_right_rounded,
            title: context.l10n.rotate,
            onTap: () async => await controller.rotateCurrentPage(),
          ),
        ),
        Expanded(
          child: PreviewActionButton(
            icon: Icons.auto_fix_high_rounded,
            title: context.l10n.enhance,
            onTap: () async => await controller.enhanceCurrentPage(),
          ),
        ),
        Expanded(
          child: PreviewActionButton(
            icon: Icons.text_fields_rounded,
            title: context.l10n.ocr,
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
            title: context.l10n.delete,
            iconColor: Colors.red,
            onTap: () {
              DeleteConfirmationDialog.show(
                context: context,
                totalPages: controller.scannedPages.length,
                onConfirm: () => controller.deleteCurrentPage(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailsSection(BuildContext context) {
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
                    text: context.l10n.pages,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  AppTextWidget(
                    text: context.l10n.tapPageToPreview,
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

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Obx(() {
          if (controller.scannedPages.length == 1) {
            return Expanded(
              child: AppButtonWidget(
                text: context.l10n.addPage,
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
            text: context.l10n.done,
            height: 5.7.h,
            onTap: () async => await controller.done(),
          ),
        ),
      ],
    );
  }
}
