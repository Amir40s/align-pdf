import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<Map<String, String>> documents = [
    {'title': 'Invoice September', 'pages': '4 pages', 'date': 'Today'},
    {'title': 'Project Notes', 'pages': '6 pages', 'date': 'Yesterday'},
    {'title': 'Passport', 'pages': '2 pages', 'date': 'Aug 30'},
    {'title': 'Passport', 'pages': '2 pages', 'date': 'Aug 30'},
  ];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
