import 'package:align_pdf_ai/app/modules/scan_result/controller/scan_result_controller.dart';
import 'package:get/get.dart';

class ScanResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanResultController>(() => ScanResultController());
  }
}
