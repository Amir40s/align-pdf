import 'package:align_pdf_ai/app/modules/setting/controller/setting_controller.dart';
import 'package:get/get.dart';

class SettingViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
