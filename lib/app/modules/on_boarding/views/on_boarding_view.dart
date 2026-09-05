import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/on_boarding_controller.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: controller.pageController,
          itemCount: controller.content.length,
          onPageChanged: (value) {
            controller.currentIndex.value = value;
          },
          itemBuilder: (context, index) {
            final data = controller.content[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  Image.asset(
                    data['image']!,
                    height: 55.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: Column(
                      children: [
                        AppTextWidget(
                          text: data['title']!,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        SizedBox(height: 2.h),
                        AppTextWidget(
                          text: data['subtitle']!,
                          height: 1.3,
                          color: AppColors.midGrey,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.content.length,
                        (dotIndex) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: controller.currentIndex.value == dotIndex
                                ? AppColors.primary
                                : AppColors.lightGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Obx(
                    () => AppButtonWidget(
                      onTap: controller.nextPage,
                      text:
                          controller.currentIndex.value ==
                              controller.content.length - 1
                          ? "Get Started"
                          : "Continue",
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
