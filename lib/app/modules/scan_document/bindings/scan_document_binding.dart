import 'package:get/get.dart';

import '../controllers/scan_document_controller.dart';

class ScanDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanDocumentController>(
      () => ScanDocumentController(),
    );
  }
}
