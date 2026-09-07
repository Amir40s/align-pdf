import 'dart:io';

import 'package:align_pdf_ai/app/core/utils/l10n_getx_helper.dart';
import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/core/widgets/debug_logs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class ScanResultController extends GetxController {
  late final String pdfPath;
  late final String fileName;
  late final int pages;

  final isSaving = false.obs;
  final isSharing = false.obs;
  final isOpening = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>;

    pdfPath = arguments['pdfPath'] as String;
    fileName = arguments['fileName'] as String;
    pages = arguments['pages'] as int;

    debugLog('========== PDF RESULT ==========');
    debugLog('PDF Path: $pdfPath');
    debugLog('File Name: $fileName');
    debugLog('Pages: $pages');
  }

  File get pdfFile => File(pdfPath);

  Future<void> openPdf() async {
    if (isOpening.value) return;

    try {
      isOpening.value = true;

      if (!await pdfFile.exists()) {
        AppSnackbar.error(getl10n.pdfError, getl10n.pdfFileCouldNotBeFound);
        return;
      }

      final result = await OpenFilex.open(pdfPath);

      debugLog('Open PDF result: ${result.type} - ${result.message}');

      if (result.type != ResultType.done) {
        AppSnackbar.error(getl10n.pdfError, getl10n.thisPdfIsNoLongerAvailable);
      }
    } catch (e, stackTrace) {
      debugLog('Open PDF Error: $e');
      debugLog(stackTrace.toString());

      AppSnackbar.error(getl10n.pdfError, getl10n.unableToOpenPdf);
    } finally {
      isOpening.value = false;
    }
  }

  Future<void> sharePdf() async {
    if (isSharing.value) return;

    try {
      isSharing.value = true;

      if (!await pdfFile.exists()) {
        AppSnackbar.error(getl10n.pdfError, getl10n.pdfFileCouldNotBeFound);
        return;
      }

      await SharePlus.instance.share(
        ShareParams(
          text: 'PDF created with Align PDF AI',
          files: [XFile(pdfPath, name: fileName, mimeType: 'application/pdf')],
        ),
      );
    } catch (e, stackTrace) {
      debugLog('Share PDF Error: $e');
      debugLog(stackTrace.toString());

      AppSnackbar.error(getl10n.shareError, getl10n.unableToSharePdf);
    } finally {
      isSharing.value = false;
    }
  }

  Future<void> savePdf() async {
    if (isSaving.value) return;

    try {
      isSaving.value = true;

      if (!await pdfFile.exists()) {
        AppSnackbar.error(getl10n.pdfError, getl10n.pdfFileCouldNotBeFound);
        return;
      }

      final bytes = await pdfFile.readAsBytes();

      final savedFile = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: 'application/pdf',
        dialogTitle: 'Save PDF',
      );

      if (savedFile == null) {
        debugLog('PDF SAVE CANCELLED');
        return;
      }

      debugLog('PDF SAVED: $savedFile');

      AppSnackbar.success(
        getl10n.pdfSaved,
        getl10n.fileSavedSuccessfully(fileName),
        // '$fileName has been saved successfully.',
      );
    } catch (e, stackTrace) {
      debugLog('Save PDF Error: $e');
      debugLog(stackTrace.toString());

      AppSnackbar.error(getl10n.error, getl10n.unableToSavePdf);
    } finally {
      isSaving.value = false;
    }
  }

  void scanAnotherDocument() {
    Get.back();
  }
}
