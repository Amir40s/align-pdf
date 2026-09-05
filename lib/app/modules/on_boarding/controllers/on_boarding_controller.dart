import 'package:align_pdf_ai/app/core/services/app_storage.dart';
import 'package:align_pdf_ai/app/routes/app_pages.dart';
import 'package:align_pdf_ai/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentIndex = 0.obs;

  final List<Map<String, String>> content = [
    {
      'image': Assets.images.onBoarding.path,
      'title': 'Scan Any Document',
      'subtitle':
          'Capture receipts, invoices, notes and documents with your camera.',
    },
    {
      'image': Assets.images.onBoarding1.path,
      'title': 'Let AI Fix the Mess',
      'subtitle': 'Automatically straighten, clean shadows, enhance text and correct perspective with a single tap.',
    },
    {
      'image': Assets.images.onBoarding2.path,
      'title': '',
      'subtitle': 'Extract text from your scans using OCR and create searchable, editable PDFs.',
    },
  ];
  @override
  void onInit() {
    super.onInit();
  }

  void nextPage() {
    if (currentIndex < content.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      skip();
    }
  }

  void skip() {
    AppStorage.setOnboardingSeen();
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
