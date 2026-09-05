import 'package:get/get.dart';

import '../modules/extract_text/bindings/extract_text_binding.dart';
import '../modules/extract_text/views/extract_text_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/on_boarding/bindings/on_boarding_binding.dart';
import '../modules/on_boarding/views/on_boarding_view.dart';
import '../modules/scan_document/bindings/scan_document_binding.dart';
import '../modules/scan_document/views/scan_document_view.dart';
import '../modules/scan_preview/bindings/scan_preview_binding.dart';
import '../modules/scan_preview/views/scan_preview_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.SCAN_DOCUMENT,
      page: () => const ScanDocumentView(),
      binding: ScanDocumentBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SCAN_PREVIEW,
      page: () => const ScanPreviewView(),
      binding: ScanPreviewBinding(),
    ),
    GetPage(
      name: _Paths.EXTRACT_TEXT,
      page: () => const ExtractTextView(),
      binding: ExtractTextBinding(),
    ),
  ];
}
