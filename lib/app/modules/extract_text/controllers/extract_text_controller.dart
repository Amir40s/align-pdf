import 'dart:convert';

import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/core/widgets/debug_logs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExtractTextController extends GetxController {
  final RxString extractedText = ''.obs;
  final RxString imagePath = ''.obs;

  final RxBool isEditing = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isCopying = false.obs;
  final RxBool isSearchablePdf = false.obs;

  late TextEditingController textController;

  @override
  void onInit() {
    super.onInit();

    textController = TextEditingController();

    _loadArguments();
  }

  void _loadArguments() {
    final arguments = Get.arguments;

    debugLog('========== EXTRACT TEXT ARGUMENTS ==========');
    debugLog(arguments.toString());

    if (arguments is Map) {
      final text = arguments['text'];
      final image = arguments['imagePath'];

      if (text is String) {
        extractedText.value = text;
        textController.text = text;
      }

      if (image is String) {
        imagePath.value = image;
      }
    } else if (arguments is String) {
      extractedText.value = arguments;
      textController.text = arguments;
    }

    debugLog('Extracted text length: ${extractedText.value.length}');

    debugLog('Image path: ${imagePath.value}');
  }

  void startEditing() {
    isEditing.value = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      textController.selection = TextSelection.collapsed(
        offset: textController.text.length,
      );
    });
  }

  void finishEditing() {
    extractedText.value = textController.text.trim();

    isEditing.value = false;

    debugLog('OCR text edited. New length: ${extractedText.value.length}');
  }

  void cancelEditing() {
    textController.text = extractedText.value;

    isEditing.value = false;
  }

  Future<void> copyText() async {
    if (isCopying.value) {
      return;
    }

    final text = textController.text.trim().isNotEmpty
        ? textController.text.trim()
        : extractedText.value.trim();

    if (text.isEmpty) {
      AppSnackbar.warning(
        'Nothing to Copy',
        'There is no extracted text to copy.',
      );

      return;
    }

    try {
      isCopying.value = true;

      await Clipboard.setData(ClipboardData(text: text));

      debugLog('========== OCR TEXT COPIED ==========');
      debugLog('Characters copied: ${text.length}');

      AppSnackbar.success('Copied', 'Text copied to clipboard.');
    } catch (e) {
      debugLog('Copy text error: $e');

      AppSnackbar.error('Copy Error', 'Unable to copy text to clipboard.');
    } finally {
      isCopying.value = false;
    }
  }

  Future<void> saveText() async {
    if (isSaving.value) return;

    final text = textController.text.trim().isNotEmpty
        ? textController.text.trim()
        : extractedText.value.trim();

    if (text.isEmpty) {
      AppSnackbar.warning(
        'Nothing to Save',
        'There is no extracted text to save.',
      );
      return;
    }

    try {
      isSaving.value = true;

      extractedText.value = text;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'align_pdf_text_$timestamp.txt';

      debugLog('========== SAVING TXT FILE ==========');
      debugLog('File name: $fileName');
      debugLog('Text length: ${text.length}');

      // Convert text into bytes.
      final bytes = Uint8List.fromList(utf8.encode(text));

      debugLog('Opening system save dialog...');

      final Uri? savedFile = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: 'text/plain',
        dialogTitle: 'Save Text File',
      );

      // User cancelled the save dialog.
      if (savedFile == null) {
        debugLog('TXT SAVE CANCELLED BY USER');
        return;
      }

      debugLog('========== TXT FILE SAVED ==========');
      debugLog('Saved file URI: $savedFile');

      AppSnackbar.success(
        'Text Saved',
        '$fileName has been saved successfully.',
      );

      Get.back(
        result: {
          'action': 'save',
          'text': text,
          'filePath': savedFile.toString(),
          'fileName': fileName,
        },
      );
    } catch (e, stackTrace) {
      debugLog('========== TXT SAVE ERROR ==========');
      debugLog(e.toString());
      debugLog(stackTrace.toString());

      AppSnackbar.error('Save Error', 'Unable to save the TXT file.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> openSearchablePdf() async {
    if (isSaving.value) {
      return;
    }

    try {
      isSearchablePdf.value = true;

      debugLog('========== SEARCHABLE PDF ==========');

      await Future.delayed(const Duration(milliseconds: 300));

      AppSnackbar.success('Searchable PDF', 'Searchable PDF option selected.');
    } catch (e) {
      debugLog('Searchable PDF error: $e');

      AppSnackbar.error('PDF Error', 'Unable to create searchable PDF.');
    } finally {
      isSearchablePdf.value = false;
    }
  }

  void discard() {
    Get.back(result: {'action': 'discard'});
  }

  @override
  void onClose() {
    textController.dispose();

    super.onClose();
  }
}
