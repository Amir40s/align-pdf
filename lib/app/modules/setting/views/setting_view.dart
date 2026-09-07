import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_text_widget.dart';
import 'package:align_pdf_ai/app/core/widgets/custom_appbar.dart';
import 'package:align_pdf_ai/app/modules/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Setting'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        children: [
          _PrivateTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'Change app language',
            onTap: controller.showLanguageSheet,
          ),
          SizedBox(height: 1.5.h),
          _PrivateTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () =>
                controller.openUrl('https://yourdomain.com/privacy-policy'),
          ),
          SizedBox(height: 1.5.h),
          _PrivateTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms of service',
            onTap: () => controller.openUrl('https://yourdomain.com/terms'),
          ),
          SizedBox(height: 1.5.h),
          _PrivateTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get help with Align PDF AI',
            onTap: () => controller.openUrl('https://yourdomain.com/support'),
          ),
          SizedBox(height: 1.5.h),
          _PrivateTile(
            icon: Icons.star_outline_rounded,
            title: 'Rate App',
            subtitle: 'Share your feedback',
            onTap: () => controller.openUrl(
              'https://play.google.com/store/apps/details?id=YOUR_PACKAGE',
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PrivateTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
          child: Row(
            children: [
              Container(
                width: 11.w,
                height: 11.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 0.4.h),
                    AppTextWidget(
                      text: subtitle,
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
