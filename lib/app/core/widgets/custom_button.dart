import 'dart:math';
import 'package:flutter/material.dart';
import '/app/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

import 'app_text_widget.dart';

class AppButtonWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? color;
  final FontWeight? fontWeight;
  final bool showShadow;
  final bool isGradient;
  final VoidCallback? onTap;
  final double? fontSize;
  final Widget? trailing;
  final Widget? leading;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final bool isLoading;
  final Color? borderColor;

  const AppButtonWidget({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
    this.padding,
    this.margin,
    this.width,
    this.borderRadius,
    this.color,
    this.fontWeight,
    this.trailing,
    this.leading,
    this.fontSize,
    this.showShadow = false,
    this.isGradient = false,
    this.isLoading = false,
    this.height,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width,
        height: height ?? 7.h,
        decoration: BoxDecoration(
          gradient: isGradient
              ? LinearGradient(
                  colors: [
                    Color(0xffBD93F9),
                    Color(0xff5558FF).withOpacity(0.62),
                  ],
                )
              : null,
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: -2,
                    blurRadius: 19.3,
                    offset: Offset(0, 7),
                  ),
                ]
              : [],
          color:
              color ??
              (borderColor != null ? Colors.transparent : AppColors.primary),
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 2.5.w),
        margin: margin ?? EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLoading ? 0 : 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null)
                    Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: SizedBox(child: leading!),
                    ),
                  AppTextWidget(
                    text: text,
                    fontWeight: fontWeight ?? FontWeight.w600,
                    fontSize: fontSize ?? 16,
                    color: textColor ?? Colors.white,
                  ),
                  if (trailing != null)
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: SizedBox(child: trailing!),
                    ),
                ],
              ),
            ),
            if (isLoading) LoadingIndicator(color: textColor ?? Colors.white),
          ],
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatefulWidget {
  final Color color;
  const LoadingIndicator({super.key, required this.color});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double scale =
                1 + 0.5 * sin((_controller.value * 2 * pi) + (index * pi / 2));
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
