import 'package:get/get.dart';

import '../controllers/scan_preview_controller.dart';

class ScanPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanPreviewController>(
      () => ScanPreviewController(),
    );
  }
}
