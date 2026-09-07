import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_appbar.dart';
import 'package:align_pdf_ai/app/modules/history/controller/history_controller.dart';
import 'package:align_pdf_ai/app/modules/home/views/widget/history_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'History'),
      body: Obx(() {
        if (controller.history.isEmpty) {
          return _EmptyHistory();
        }

        return ListView.separated(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 3.h),
          itemCount: controller.history.length,
          separatorBuilder: (_, _) => Gap(1.5.h),
          itemBuilder: (context, index) {
            final item = controller.history[index];

            return HistoryCard(
              title: item.title,
              pages: '${item.pages} pages',
              date: controller.formatDate(item.createdAt),
              onTap: () => controller.openPdf(item),
              onMoreTap: () => controller.showActions(item),
            );
          },
        );
      }),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.history_rounded,
                color: AppColors.primary,
                size: 11.w,
              ),
            ),
            Gap(2.h),
            const AppTextWidget(
              text: 'No History Yet',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            Gap(1.h),
            const AppTextWidget(
              text: 'Your created PDFs will appear here.',
              fontSize: 14,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
