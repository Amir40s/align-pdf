import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final _box = GetStorage();

  static const _onboardingKey = 'onboarding_seen';
  static const _languageKey = "selected_language";

  // Onboarding
  static void setOnboardingSeen() {
    _box.write(_onboardingKey, true);
  }

  static bool isOnboardingSeen() {
    return _box.read(_onboardingKey) ?? false;
  }

  static void clearAll() {
    _box.erase();
  }

  static void setLanguage(String lang) {
    _box.write(_languageKey, lang);
  }

  static String getLanguage() {
    return _box.read(_languageKey) ?? "";
  }
}
