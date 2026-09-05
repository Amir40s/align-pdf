import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppSnackbar {
  static void success(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.green.withAlpha(230),
      icon: Icons.check_circle_rounded,
      isWarning: false,
    );
  }

  static void error(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.red.withAlpha(230),
      icon: Icons.error_rounded,
      isWarning: false,
    );
  }

  static void warning(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_rounded,
      isWarning: true,
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required bool isWarning,
  }) {
    final Color contentColor = Colors.white;

    Get.snackbar(
      "",
      "",
      titleText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: contentColor,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 14, color: contentColor),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      borderRadius: 14,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      icon: Icon(icon, color: contentColor),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
    );
  }
}
