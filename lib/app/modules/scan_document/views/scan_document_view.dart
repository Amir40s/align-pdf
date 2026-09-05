import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/modules/scan_document/views/widget/scaning_frame.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/scan_document_controller.dart';

class ScanDocumentView extends GetView<ScanDocumentController> {
  const ScanDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ScanDocumentController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isCameraInitialized.value ||
            controller.cameraController == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return SafeArea(
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildCamera(),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.18)),
              ),
              Positioned(
                top: 3.h,
                left: 5.w,
                right: 5.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleButton(
                      icon: Icons.close,
                      onTap: () {
                        Get.back();
                      },
                    ),

                    Obx(
                      () => GestureDetector(
                        onTap: controller.toggleFlash,
                        child: Container(
                          height: 5.6.h,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.flash_on_rounded,
                                color: Colors.white,
                                size: 5.w,
                              ),
                              Gap(2.w),
                              AppTextWidget(
                                text: 'Flash',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              Gap(1.w),
                              AppTextWidget(
                                text: controller.flashEnabled.value
                                    ? 'On'
                                    : 'Off',
                                fontSize: 16,
                                color: controller.flashEnabled.value
                                    ? AppColors.primary
                                    : Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    AppTextWidget(
                      text: 'Scan Document',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                    Gap(1.h),
                    AppTextWidget(
                      text: 'Place your document within the frame',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 26.h,
                left: 10.w,
                right: 10.w,
                bottom: 30.h,
                child: const ScanningFrame(),
              ),
              Obx(() {
                if (!controller.documentDetected.value) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 29.h,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 5.w,
                          ),
                          Gap(2.w),
                          AppTextWidget(
                            text: 'Document detected',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 21.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.28),
                  ),
                  child: Column(
                    children: [
                      Gap(1.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.1.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 5.w,
                            ),
                            Gap(2.w),
                            AppTextWidget(
                              text: 'Keep steady and avoid shadows',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: _bottomAction(
                              icon: Icons.photo_library_outlined,
                              title: 'Gallery',
                              onTap: () async {
                                await controller.pickImageFromGallery();
                              },
                            ),
                          ),
                          Expanded(child: _buildCaptureButton()),
                          Expanded(
                            child: _bottomAction(
                              icon: Icons.library_add_outlined,
                              title: 'Multi-Page',
                              onTap: () async {
                                await controller.captureDocument();
                              },
                            ),
                          ),
                        ],
                      ),
                      Gap(2.h),
                    ],
                  ),
                ),
              ),
              if (controller.isProcessing.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.45),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
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
                            Gap(2.h),
                            AppTextWidget(
                              text: 'Processing document...',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            Gap(0.7.h),
                            AppTextWidget(
                              text: 'Extracting text with AI',
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCamera() {
    final cameraController = controller.cameraController!;

    return Positioned.fill(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: cameraController.value.previewSize?.height ?? 100,
          height: cameraController.value.previewSize?.width ?? 100,
          child: CameraPreview(cameraController),
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 13.w,
        height: 13.w,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 7.w),
        ),
      ),
    );
  }

  Widget _bottomAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 7.w),
          Gap(0.7.h),
          AppTextWidget(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: () async {
        await controller.captureDocument();
      },
      child: Container(
        width: 19.w,
        height: 19.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1.w),
        ),
        padding: EdgeInsets.all(1.3.w),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(
              color: Colors.white.withOpacity(0.65),
              width: 0.7.w,
            ),
          ),
        ),
      ),
    );
  }
}
