import 'package:align_pdf_ai/l10n/app_localizations.dart';
import 'package:get/get.dart';

AppLocalizations get getl10n {
  final context = Get.context;
  assert(
    context != null,
    'AppLocalizations accessed before GetMaterialApp was built.',
  );
  return AppLocalizations.of(context!)!;
}
