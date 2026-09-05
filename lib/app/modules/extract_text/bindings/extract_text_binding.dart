import 'package:get/get.dart';

import '../controllers/extract_text_controller.dart';

class ExtractTextBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExtractTextController>(
      () => ExtractTextController(),
    );
  }
}
