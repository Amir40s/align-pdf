import 'package:align_pdf_ai/app/core/utils/l10n_getx_helper.dart';
import 'package:align_pdf_ai/app/core/utils/l10n_utils.dart';
import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/modules/setting/controller/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final languageController = Get.find<LanguageController>();

  Future<void> openUrl(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      AppSnackbar.error(getl10n.error, getl10n.invalidUrl);
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        AppSnackbar.error(getl10n.error, getl10n.unableToOpenLink);
      }
    } catch (e) {
      AppSnackbar.error(getl10n.error, getl10n.unableToOpenLink);
    }
  }

  void showLanguageSheet() {
    Get.bottomSheet(
      _LanguageBottomSheet(
        selectedCode: languageController.currentCode,
        onSelected: (code) async {
          await languageController.changeLanguage(code);
          Get.back();
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}

class _LanguageBottomSheet extends StatelessWidget {
  final String selectedCode;
  final ValueChanged<String> onSelected;

  const _LanguageBottomSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final languages = LanguageController.supportedLanguages;

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n.language,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              ...languages.entries.map(
                (entry) => ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(entry.value),
                  trailing: selectedCode == entry.key
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () => onSelected(entry.key),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
