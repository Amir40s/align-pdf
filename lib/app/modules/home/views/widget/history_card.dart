import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String pages;
  final String date;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const HistoryCard({
    super.key,
    required this.title,
    required this.pages,
    required this.date,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 10.1.w,
              height: 10.1.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(1.9.w),
              ),
              child: Center(
                child: Icon(
                  Icons.description_outlined,
                  color: AppColors.primary,
                  size: 6.4.w,
                ),
              ),
            ),
            Gap(3.8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget(
                    text: title,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(0.8.h),
                  Row(
                    children: [
                      AppTextWidget(text: pages, fontSize: 14),
                      const AppTextWidget(text: '  ·  ', fontSize: 14),
                      AppTextWidget(text: date, fontSize: 14),
                    ],
                  ),
                ],
              ),
            ),
            Gap(2.w),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onMoreTap,
              child: SizedBox(
                width: 8.w,
                height: 10.w,
                child: const Center(child: Icon(Icons.more_vert)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
