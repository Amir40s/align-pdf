import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/modules/home/views/widget/history_card.dart';
import 'package:align_pdf_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controllers/home_controller.dart';
import '/app/core/widgets/app_text_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Gap(1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.lightGrey)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: SizedBox(
                      width: 8.w,
                      height: 8.w,
                      child: Center(child: Icon(Icons.menu, size: 8.1.w)),
                    ),
                  ),
                  Gap(3.w),
                  Expanded(
                    child: AppTextWidget(
                      text: 'ALIGN PDF AI',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Icon(
                      Icons.settings,
                      size: 8.4.w,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: AppTextWidget(
                            text: 'Good morning',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        Gap(2.w),
                        AppTextWidget(text: '👋', fontSize: 22, height: 1),
                      ],
                    ),
                    Gap(2.2.h),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SCAN_DOCUMENT);
                      },
                      child: Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.7.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3.0.w),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 11.w,
                              height: 11.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 6.7.w,
                                ),
                              ),
                            ),
                            Gap(1.5.h),
                            AppTextWidget(
                              text: 'Scan Document',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.05,
                            ),
                            Gap(0.8.h),
                            AppTextWidget(
                              text: 'Capture a document with AI',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            Gap(1.h),
                          ],
                        ),
                      ),
                    ),
                    Gap(3.0.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppTextWidget(
                            text: 'Recent Documents',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: AppTextWidget(
                            text: 'View all',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Gap(2.2.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.documents.length,
                        separatorBuilder: (context, index) {
                          return Gap(1.h);
                        },
                        itemBuilder: (context, index) {
                          final document = controller.documents[index];

                          return HistoryCard(
                            title: document['title'] ?? '',
                            pages: document['pages'] ?? '',
                            date: document['date'] ?? '',
                          );
                        },
                      ),
                    ),
                    Gap(3.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
