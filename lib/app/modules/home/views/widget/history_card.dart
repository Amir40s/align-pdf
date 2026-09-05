import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String pages;
  final String date;

  const HistoryCard({
    super.key,
    required this.title,
    required this.pages,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 3.h),
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
              color: Color(0xFFFFEEEE),
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                    AppTextWidget(
                      text: pages,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    AppTextWidget(
                      text: '  ·  ',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    AppTextWidget(
                      text: date,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(2.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: SizedBox(
              width: 8.w,
              height: 10.w,
              child: Center(child: Icon(Icons.more_vert, size: 6.w)),
            ),
          ),
        ],
      ),
    );
  }
}
