import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/utils/l10n_utils.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/banner_ad_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_button.dart';
import 'package:align_pdf_ai/app/modules/scan_result/controller/scan_result_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ScanResultView extends GetView<ScanResultController> {
  const ScanResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              _buildHeader(),
              _buildSuccessIcon(),
              SizedBox(height: 2.6.h),
              Center(child: const BannerAdWidget()),
              SizedBox(height: 1.2),
              _buildTitle(context),
              SizedBox(height: 1.6.h),
              _buildDescription(context),
              SizedBox(height: 1.8.h),
              _buildPdfCard(),
              SizedBox(height: 1.8.h),
              _buildOpenButton(context),
              SizedBox(height: 1.8.h),
              _buildActionButtons(context),
              SizedBox(height: 2.8.h),
              _buildScanAnother(context),
              SizedBox(height: 1.2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 16.h,
      child: Center(
        child: AppTextWidget(
          text: 'ALIGN PDF AI',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 19.w,
      height: 19.w,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, color: Colors.white, size: 30.sp),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AppTextWidget(
      text: context.l10n.yourPdfIsReady,
      textAlign: TextAlign.center,
      fontSize: 22,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return AppTextWidget(
      text: context.l10n.documentSuccessfullyDigitized,
      textAlign: TextAlign.center,
      fontSize: 14,
      height: 1.4,
      color: AppColors.textSecondary,
    );
  }

  Widget _buildPdfCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPdfThumbnail(),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextWidget(
                  text: controller.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 1.2.h),
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 16.sp,
                      color: const Color(0xFF555555),
                    ),
                    SizedBox(width: 1.3.w),
                    AppTextWidget(
                      text: '${controller.pages} pages',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 1.6.w),
                    const Text('•'),
                    SizedBox(width: 1.6.w),
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 16.sp,
                      color: const Color(0xFF555555),
                    ),
                    SizedBox(width: 1.3.w),
                    AppTextWidget(
                      text: 'PDF',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfThumbnail() {
    return Container(
      width: 16.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Icon(Icons.picture_as_pdf, size: 24.sp, color: AppColors.primary),
    );
  }

  Widget _buildOpenButton(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: AppButtonWidget(
          text: controller.isOpening.value
              ? context.l10n.opening
              : context.l10n.openPdf,
          height: 5.7.h,
          onTap: controller.isOpening.value ? null : controller.openPdf,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOutlinedAction(
            icon: Icons.share_outlined,
            text: context.l10n.sharePdf,
            onTap: controller.sharePdf,
          ),
        ),
        SizedBox(width: 2.h),
        Expanded(
          child: _buildOutlinedAction(
            icon: Icons.download_outlined,
            text: context.l10n.saveToDevice,
            onTap: controller.savePdf,
          ),
        ),
      ],
    );
  }

  Widget _buildOutlinedAction({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,

      icon: Icon(icon, size: 19.sp, color: AppColors.primary),
      label: AppTextWidget(
        text: text,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        side: const BorderSide(color: Color(0xFFE5E5E5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
      ),
    );
  }

  Widget _buildScanAnother(BuildContext context) {
    return TextButton.icon(
      onPressed: controller.scanAnotherDocument,
      icon: Icon(
        Icons.document_scanner_outlined,
        size: 20.sp,
        color: const Color(0xFFC1121F),
      ),
      label: Text(
        context.l10n.scanAnotherDocument,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFFC1121F)),
      ),
    );
  }
}
