import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  static const String _storageKey = 'language';
  static const String _defaultLanguage = 'en';
  final GetStorage _storage = GetStorage();
  final locale = const Locale(_defaultLanguage).obs;
  static const supportedLanguages = {
    'en': 'English',
    'de': 'Deutsch',
    'es': 'Español',
    'fr': 'Français',
    'ar': 'العربية',
    'he': 'עברית',
  };

  @override
  void onInit() {
    super.onInit();
    final code = _storage.read<String>(_storageKey) ?? _defaultLanguage;
    locale.value = Locale(code);
    Get.updateLocale(locale.value);
  }

  Future<void> changeLanguage(String code) async {
    if (code == currentCode) return;
    if (!supportedLanguages.containsKey(code)) return;
    locale.value = Locale(code);
    await _storage.write(_storageKey, code);
    Get.updateLocale(locale.value);
  }

  String get currentCode => locale.value.languageCode;
  String get currentName =>
      supportedLanguages[currentCode] ?? supportedLanguages[_defaultLanguage]!;
}
