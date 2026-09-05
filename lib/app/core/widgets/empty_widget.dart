import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/theme/app_colors.dart';
import '/app/core/widgets/app_text_widget.dart';
import 'package:sizer/sizer.dart';

class CustomEmptyWidget extends StatefulWidget {
  final String? message;
  final IconData icon;

  const CustomEmptyWidget({
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
  });

  @override
  State<CustomEmptyWidget> createState() => _CustomEmptyWidgetState();
}

class _CustomEmptyWidgetState extends State<CustomEmptyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translate;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _translate = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _translate,
            builder: (_, child) {
              return Transform.translate(
                offset: Offset(0, _translate.value),
                child: child,
              );
            },
            child: Container(
              width: 14.w,
              height: 14.w,
              margin: EdgeInsets.symmetric(vertical: 2.5.h),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Icon(widget.icon, size: 7.w, color: AppColors.white),
            ),
          ),
          AppTextWidget(
            text: widget.message ?? "no_data_available".tr,
            textAlign: TextAlign.center,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.midGrey,
          ),
          // SizedBox(height: 1.h),
          // AppTextWidget(
          //   text: "Pull to refresh or try again",
          //   textAlign: TextAlign.center,
          //   fontSize: 14,
          //   color: AppColors.midGrey.withAlpha(200),
          // ),
        ],
      ),
    );
  }
}
