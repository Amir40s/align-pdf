import 'dart:io';

import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/core/widgets/debug_logs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExtractedTextModel {
  final String text;
  final DateTime extractedAt;

  const ExtractedTextModel({required this.text, required this.extractedAt});

  factory ExtractedTextModel.empty() {
    return ExtractedTextModel(text: '', extractedAt: DateTime.now());
  }

  bool get isEmpty => text.trim().isEmpty;

  bool get isNotEmpty => text.trim().isNotEmpty;

  ExtractedTextModel copyWith({String? text, DateTime? extractedAt}) {
    return ExtractedTextModel(
      text: text ?? this.text,
      extractedAt: extractedAt ?? this.extractedAt,
    );
  }
}

class ScannedPage {
  final String originalImagePath;

  String? processedImagePath;

  ExtractedTextModel extractedText;

  ScannedPage({
    required this.originalImagePath,
    this.processedImagePath,
    ExtractedTextModel? extractedText,
  }) : extractedText = extractedText ?? ExtractedTextModel.empty();

  String get displayImagePath {
    return processedImagePath ?? originalImagePath;
  }
}

class ScanPreviewController extends GetxController {
  final TextRecognizer textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  final RxList<ScannedPage> scannedPages = <ScannedPage>[].obs;
  final RxInt currentPageIndex = 0.obs;
  final RxBool isProcessing = false.obs;
  final RxBool isExtracting = false.obs;
  final RxBool isEnhancing = false.obs;
  final RxBool isCropping = false.obs;
  final RxBool isRotating = false.obs;

  ScannedPage? get currentPage {
    if (scannedPages.isEmpty) {
      return null;
    }

    if (currentPageIndex.value >= scannedPages.length) {
      currentPageIndex.value = scannedPages.length - 1;
    }

    return scannedPages[currentPageIndex.value];
  }

  @override
  void onInit() {
    super.onInit();

    _loadArguments();
  }

  void _loadArguments() {
    final arguments = Get.arguments;

    if (arguments is String) {
      _addPageFromPath(arguments);
    } else if (arguments is List) {
      for (final item in arguments) {
        if (item is String) {
          _addPageFromPath(item);
        }
      }
    } else if (arguments is Map) {
      final images = arguments['images'];

      if (images is List) {
        for (final item in images) {
          if (item is String) {
            _addPageFromPath(item);
          }
        }
      }
    }
  }

  void _addPageFromPath(String imagePath) {
    if (imagePath.trim().isEmpty) {
      return;
    }

    scannedPages.add(ScannedPage(originalImagePath: imagePath));
  }

  Future<void> addPageFromPath(String imagePath) async {
    if (imagePath.trim().isEmpty) {
      return;
    }

    try {
      isProcessing.value = true;

      final page = ScannedPage(originalImagePath: imagePath);
      scannedPages.add(page);
      currentPageIndex.value = scannedPages.length - 1;
      await extractTextForPage(scannedPages.length - 1);
    } catch (e) {
      debugLog('Add page error: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void selectPage(int index) {
    if (index < 0 || index >= scannedPages.length) {
      return;
    }

    currentPageIndex.value = index;
  }

  Future<bool> extractCurrentText() async {
    if (currentPage == null) {
      return false;
    }

    return extractTextForPage(currentPageIndex.value);
  }

  Future<bool> extractTextForPage(int index) async {
    if (index < 0 || index >= scannedPages.length) {
      return false;
    }

    try {
      isExtracting.value = true;
      isProcessing.value = true;

      final page = scannedPages[index];

      final imagePath = page.displayImagePath;

      debugLog(
        '========== OCR START ==========\n'
        'Page: ${index + 1}\n'
        'Image: $imagePath',
      );

      final file = File(imagePath);

      if (!await file.exists()) {
        AppSnackbar.error('OCR Error', 'Document image could not be found.');

        return false;
      }

      final inputImage = InputImage.fromFilePath(imagePath);

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      final text = recognizedText.text.trim();

      page.extractedText = ExtractedTextModel(
        text: text,
        extractedAt: DateTime.now(),
      );

      scannedPages.refresh();

      debugLog('========== OCR RESULT ==========\n${page.extractedText.text}');

      if (text.isEmpty) {
        AppSnackbar.warning(
          'No Text Found',
          'We could not find readable text in this document.',
        );

        return false;
      }

      return true;
    } catch (e) {
      debugLog('OCR error: $e');

      AppSnackbar.error(
        'Text Recognition Error',
        'Unable to extract text from this document.',
      );

      return false;
    } finally {
      isExtracting.value = false;
      isProcessing.value = false;
    }
  }

  Future<void> cropCurrentPage() async {
    final page = currentPage;

    if (page == null || isProcessing.value) {
      return;
    }

    try {
      isCropping.value = true;
      isProcessing.value = true;

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: page.displayImagePath,
        compressQuality: 95,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Document',
            toolbarColor: AppColors.white,
            toolbarWidgetColor: Colors.black,
            activeControlsWidgetColor: AppColors.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'Crop Document',
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) {
        debugLog('Crop cancelled.');
        return;
      }

      final newPath = await _copyToAppDirectory(croppedFile.path, 'crop');

      page.processedImagePath = newPath;

      scannedPages.refresh();

      debugLog('Crop completed: $newPath');

      await extractTextForPage(currentPageIndex.value);

      AppSnackbar.success('Crop Complete', 'Document cropped successfully.');
    } catch (e) {
      debugLog('Crop error: $e');

      AppSnackbar.error('Crop Error', 'Unable to crop this document.');
    } finally {
      isCropping.value = false;
      isProcessing.value = false;
    }
  }

  Future<void> rotateCurrentPage() async {
    final page = currentPage;

    if (page == null || isProcessing.value) {
      return;
    }

    try {
      isRotating.value = true;
      isProcessing.value = true;

      final imageFile = File(page.displayImagePath);

      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist.');
      }

      final bytes = await imageFile.readAsBytes();

      final decodedImage = img.decodeImage(bytes);

      if (decodedImage == null) {
        throw Exception('Unable to decode image.');
      }

      final rotatedImage = img.copyRotate(decodedImage, angle: 90);

      final newPath = await _saveImage(rotatedImage, 'rotate');

      page.processedImagePath = newPath;

      scannedPages.refresh();

      debugLog('Rotate completed: $newPath');

      await extractTextForPage(currentPageIndex.value);

      AppSnackbar.success('Rotated', 'Document rotated successfully.');
    } catch (e) {
      debugLog('Rotate error: $e');

      AppSnackbar.error('Rotate Error', 'Unable to rotate this document.');
    } finally {
      isRotating.value = false;
      isProcessing.value = false;
    }
  }

  Future<void> enhanceCurrentPage() async {
    final page = currentPage;

    if (page == null || isProcessing.value) {
      return;
    }

    try {
      isEnhancing.value = true;
      isProcessing.value = true;

      final imageFile = File(page.displayImagePath);

      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist.');
      }

      final bytes = await imageFile.readAsBytes();

      final decodedImage = img.decodeImage(bytes);

      if (decodedImage == null) {
        throw Exception('Unable to decode image.');
      }

      debugLog('Enhancing image while preserving original colors...');

      final enhancedImage = img.adjustColor(
        decodedImage,
        contrast: 1.10,
        brightness: 1.03,
        saturation: 1.05,
      );

      final newPath = await _saveImage(enhancedImage, 'enhanced');

      page.processedImagePath = newPath;

      scannedPages.refresh();

      debugLog('Enhancement completed: $newPath');

      await extractTextForPage(currentPageIndex.value);

      AppSnackbar.success(
        'Enhanced',
        'Document enhanced while preserving colors.',
      );
    } catch (e) {
      debugLog('Enhance error: $e');

      AppSnackbar.error('Enhance Error', 'Unable to enhance this document.');
    } finally {
      isEnhancing.value = false;
      isProcessing.value = false;
    }
  }

  Future<void> deleteCurrentPage() async {
    if (scannedPages.isEmpty) {
      return;
    }

    final int index = currentPageIndex.value;

    if (index < 0 || index >= scannedPages.length) {
      return;
    }

    try {
      final ScannedPage page = scannedPages[index];

      debugLog('========== DELETE PAGE ==========');
      debugLog('Deleting page: ${index + 1}');
      debugLog('Total pages before: ${scannedPages.length}');
      debugLog('Original: ${page.originalImagePath}');
      debugLog('Processed: ${page.processedImagePath}');

      if (page.processedImagePath != null) {
        final processedFile = File(page.processedImagePath!);

        if (await processedFile.exists()) {
          await processedFile.delete();
          debugLog('Processed image deleted.');
        }
      }

      scannedPages.removeAt(index);
      scannedPages.refresh();

      if (scannedPages.isEmpty) {
        currentPageIndex.value = 0;
      } else if (index >= scannedPages.length) {
        currentPageIndex.value = scannedPages.length - 1;
      } else {
        currentPageIndex.value = index;
      }

      debugLog('Total pages after: ${scannedPages.length}');
      debugLog('Current page index: ${currentPageIndex.value}');
      debugLog('================================');

      AppSnackbar.success(
        'Page Deleted',
        'Page ${index + 1} has been removed.',
      );
    } catch (e) {
      debugLog('Delete page error: $e');

      AppSnackbar.error('Delete Error', 'Unable to delete this page.');
    }
  }

  void reorderPages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    if (oldIndex < 0 ||
        oldIndex >= scannedPages.length ||
        newIndex < 0 ||
        newIndex >= scannedPages.length) {
      return;
    }

    final page = scannedPages.removeAt(oldIndex);

    scannedPages.insert(newIndex, page);

    if (currentPageIndex.value == oldIndex) {
      currentPageIndex.value = newIndex;
    } else if (oldIndex < currentPageIndex.value &&
        newIndex >= currentPageIndex.value) {
      currentPageIndex.value--;
    } else if (oldIndex > currentPageIndex.value &&
        newIndex <= currentPageIndex.value) {
      currentPageIndex.value++;
    }

    debugLog('Pages reordered: $oldIndex → $newIndex');
  }

  Future<void> retakeCurrentPage() async {
    if (scannedPages.isEmpty) {
      return;
    }

    final index = currentPageIndex.value;

    debugLog('Retaking page ${index + 1}');

    Get.back(result: {'action': 'retake', 'pageIndex': index});
  }

  Future<void> requestAddPage() async {
    final List<String> currentImages = scannedPages
        .map((page) => page.displayImagePath)
        .toList();

    debugLog('========== REQUEST ADD PAGE ==========');
    debugLog('Pages being returned: ${currentImages.length}');
    debugLog(currentImages.toString());

    Get.back(result: {'action': 'add_page', 'images': currentImages});
  }

  Future<String?> generatePdf() async {
    if (scannedPages.isEmpty) {
      AppSnackbar.warning('No Document', 'Please add at least one page.');

      return null;
    }

    try {
      isProcessing.value = true;

      final pdf = pw.Document();

      for (int i = 0; i < scannedPages.length; i++) {
        final page = scannedPages[i];

        final imageFile = File(page.displayImagePath);

        if (!await imageFile.exists()) {
          debugLog('Image missing for page ${i + 1}');
          continue;
        }

        final imageBytes = await imageFile.readAsBytes();

        final image = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (context) {
              return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
            },
          ),
        );
      }

      final directory = await getApplicationDocumentsDirectory();

      final fileName = 'align_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      debugLog('PDF created: ${file.path}');

      return file.path;
    } catch (e) {
      debugLog('PDF generation error: $e');

      AppSnackbar.error('PDF Error', 'Unable to generate PDF.');

      return null;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> done() async {
    if (isProcessing.value) return;

    try {
      isProcessing.value = true;

      final pdfPath = await generatePdf();

      if (pdfPath == null) {
        return;
      }

      debugLog('========== FINAL PDF ==========');
      debugLog('Generated PDF: $pdfPath');

      final pdfFile = File(pdfPath);

      if (!await pdfFile.exists()) {
        AppSnackbar.error(
          'PDF Error',
          'Generated PDF file could not be found.',
        );
        return;
      }

      final bytes = await pdfFile.readAsBytes();

      final fileName = 'align_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

      debugLog('Opening PDF save dialog...');
      debugLog('File name: $fileName');
      debugLog('PDF bytes: ${bytes.length}');

      final Uri? savedFile = await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: 'application/pdf',
        dialogTitle: 'Save PDF',
      );

      // User cancelled the save dialog.
      if (savedFile == null) {
        debugLog('PDF SAVE CANCELLED BY USER');
        return;
      }

      debugLog('========== PDF SAVED ==========');
      debugLog('Saved PDF URI: $savedFile');

      AppSnackbar.success(
        'PDF Saved',
        '$fileName has been saved successfully.',
      );

      Get.back(
        result: {
          'action': 'done',
          'pdfPath': savedFile.toString(),
          'pages': scannedPages.length,
          'fileName': fileName,
        },
      );
    } catch (e, stackTrace) {
      debugLog('========== PDF SAVE ERROR ==========');
      debugLog(e.toString());
      debugLog(stackTrace.toString());

      AppSnackbar.error('PDF Error', 'Unable to save the PDF.');
    } finally {
      isProcessing.value = false;
    }
  }

  Future<String> _saveImage(img.Image image, String prefix) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final path = '${directory.path}/$fileName';

    final bytes = img.encodeJpg(image, quality: 95);

    await File(path).writeAsBytes(bytes);

    return path;
  }

  Future<String> _copyToAppDirectory(String sourcePath, String prefix) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final destination = File('${directory.path}/$fileName');

    await File(sourcePath).copy(destination.path);

    return destination.path;
  }

  @override
  void onClose() {
    textRecognizer.close();

    super.onClose();
  }
}
