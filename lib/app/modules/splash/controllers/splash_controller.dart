import 'dart:async';

import 'package:align_pdf_ai/app/core/services/ads_service.dart';
import 'package:align_pdf_ai/app/core/services/app_storage.dart';
import 'package:align_pdf_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    _startup();
  }

  Future<void> _startup() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      final isLoaded = await AdsService.instance.waitForAppOpenAd();
      if (isLoaded) {
        AdsService.instance.showAppOpenAd(onComplete: _startSplash);
      } else {
        _startSplash();
      }
    } catch (e) {
      _startSplash();
    }
  }

  void _startSplash() {
    Timer(const Duration(seconds: 2), () {
      final bool onboardingSeen = AppStorage.isOnboardingSeen();

      if (onboardingSeen) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.ON_BOARDING);
      }
    });
  }
}
