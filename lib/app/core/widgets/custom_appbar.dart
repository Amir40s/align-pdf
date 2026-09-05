import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '/app/core/theme/app_colors.dart';
import '/app/core/widgets/app_text_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showBack;
  final Color backgroundColor;
  final Color titleColor;
  final Widget? action;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.backgroundColor = AppColors.transparent,
    this.titleColor = Colors.black,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBack
          ? GestureDetector(
              onTap: onBack ?? () => Get.back(),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
            )
          : null,
      title: AppTextWidget(
        text: title,
        color: titleColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.center,
      ),
      actions: [if (action != null) action!],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(8.h);
}
