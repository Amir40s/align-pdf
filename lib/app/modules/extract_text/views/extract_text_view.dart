import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_appbar.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/extract_text_controller.dart';
import 'widget/extract_document_preview.dart';
import 'widget/raw_text_card.dart';

class ExtractTextView extends GetView<ExtractTextController> {
  const ExtractTextView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Extract Text',
        action: Obx(
          () => IconButton(
            onPressed: controller.isCopying.value ? null : controller.copyText,
            icon: controller.isCopying.value
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Icon(
                    Icons.content_copy_rounded,
                    size: 25,
                    color: AppColors.primary,
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExtractDocumentPreview(imagePath: controller.imagePath),
                    Gap(3.h),
                    Container(
                      height: 5.2.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.8.w),
                        border: Border.all(color: const Color(0xFFE5E1DF)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.025),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 2.5.w,
                            height: 2.5.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF12B886),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gap(1.w),
                          AppTextWidget(
                            text: 'OCR Complete',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF624B46),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 1.w,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 5.w,
                                  color: AppColors.primary,
                                ),
                                Gap(1.2.w),
                                AppTextWidget(
                                  fontSize: 15,
                                  text: 'Searchable PDF',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(1.h),
                    RawTextCard(controller: controller),
                  ],
                ),
              ),
            ),
            Gap(2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  Obx(
                    () => AppButtonWidget(
                      onTap: controller.isSaving.value
                          ? null
                          : controller.saveText,
                      height: 58,
                      text: controller.isSaving.value ? '' : 'Save Text',
                      textColor: Colors.white,
                      color: AppColors.primary,
                      leading: controller.isSaving.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.save_outlined,
                              size: 25,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: controller.discard,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: AppTextWidget(
                        text: 'Discard',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
