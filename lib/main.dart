import 'package:align_pdf_ai/app/core/theme/app_theme.dart';
import 'package:align_pdf_ai/app/modules/setting/controller/language_controller.dart';
import 'package:align_pdf_ai/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(LanguageController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'Align Pdf Ai',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,

          locale: languageController.locale.value,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          fallbackLocale: const Locale('en'),
        );
      },
    );
  }
}
