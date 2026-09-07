import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final selectedLanguage = 'English'.obs;

  Future<void> openUrl(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      AppSnackbar.error('Error', 'Invalid URL.');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        AppSnackbar.error('Error', 'Unable to open this link.');
      }
    } catch (e) {
      AppSnackbar.error('Error', 'Unable to open this link.');
    }
  }

  void showLanguageSheet() {
    Get.bottomSheet(
      _LanguageBottomSheet(
        selectedLanguage: selectedLanguage.value,
        onSelected: (language) {
          selectedLanguage.value = language;
          Get.back();
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}

class _LanguageBottomSheet extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onSelected;

  const _LanguageBottomSheet({
    required this.selectedLanguage,
    required this.onSelected,
  });

  static const languages = [
    'English',
    'Arabic',
    'Hebrew',
    'German',
    'Spanish',
    'French',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Language',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            ...languages.map(
              (language) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(language),
                trailing: selectedLanguage == language
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => onSelected(language),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
