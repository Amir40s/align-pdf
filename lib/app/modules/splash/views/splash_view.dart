import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/utils/l10n_utils.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  Assets.images.appIcon.path,
                  width: 35.w,
                  height: 35.w,
                  fit: BoxFit.contain,
                ),
              ),
              Gap(3.h),
              AppTextWidget(
                text: 'ALIGN PDF AI',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                textAlign: TextAlign.center,
              ),
              Gap(1.2.h),
              AppTextWidget(
                text: context.l10n.scanAlignSimplify,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.primary,
                ),
              ),
              Gap(2.h),
              AppTextWidget(
                text: context.l10n.makingDocumentsSmarter,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                textAlign: TextAlign.center,
              ),
              Gap(4.h),
            ],
          ),
        ),
      ),
    );
  }
}
