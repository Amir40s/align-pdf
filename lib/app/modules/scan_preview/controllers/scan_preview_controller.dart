// import 'dart:io';
// import 'dart:isolate';

// import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
// import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
// import 'package:align_pdf_ai/app/core/widgets/debug_logs.dart';
// import 'package:align_pdf_ai/app/routes/app_pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_cropper/image_cropper.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class ExtractedTextModel {
//   final String text;
//   final DateTime extractedAt;

//   const ExtractedTextModel({required this.text, required this.extractedAt});

//   factory ExtractedTextModel.empty() {
//     return ExtractedTextModel(text: '', extractedAt: DateTime.now());
//   }

//   bool get isEmpty => text.trim().isEmpty;

//   bool get isNotEmpty => text.trim().isNotEmpty;

//   ExtractedTextModel copyWith({String? text, DateTime? extractedAt}) {
//     return ExtractedTextModel(
//       text: text ?? this.text,
//       extractedAt: extractedAt ?? this.extractedAt,
//     );
//   }
// }

// class ScannedPage {
//   final String originalImagePath;

//   String? processedImagePath;

//   ExtractedTextModel extractedText;

//   ScannedPage({
//     required this.originalImagePath,
//     this.processedImagePath,
//     ExtractedTextModel? extractedText,
//   }) : extractedText = extractedText ?? ExtractedTextModel.empty();

//   String get displayImagePath {
//     return processedImagePath ?? originalImagePath;
//   }
// }

// class ScanPreviewController extends GetxController {
//   final TextRecognizer textRecognizer = TextRecognizer(
//     script: TextRecognitionScript.latin,
//   );
//   final RxList<ScannedPage> scannedPages = <ScannedPage>[].obs;
//   final RxInt currentPageIndex = 0.obs;
//   final RxBool isProcessing = false.obs;
//   final RxBool isExtracting = false.obs;
//   final RxBool isEnhancing = false.obs;
//   final RxBool isCropping = false.obs;
//   final RxBool isRotating = false.obs;

//   ScannedPage? get currentPage {
//     if (scannedPages.isEmpty) {
//       return null;
//     }

//     if (currentPageIndex.value >= scannedPages.length) {
//       currentPageIndex.value = scannedPages.length - 1;
//     }

//     return scannedPages[currentPageIndex.value];
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     _loadArguments();
//   }

//   void _loadArguments() {
//     final arguments = Get.arguments;

//     if (arguments is String) {
//       _addPageFromPath(arguments);
//     } else if (arguments is List) {
//       for (final item in arguments) {
//         if (item is String) {
//           _addPageFromPath(item);
//         }
//       }
//     } else if (arguments is Map) {
//       final images = arguments['images'];

//       if (images is List) {
//         for (final item in images) {
//           if (item is String) {
//             _addPageFromPath(item);
//           }
//         }
//       }
//     }
//   }

//   void _addPageFromPath(String imagePath) {
//     if (imagePath.trim().isEmpty) {
//       return;
//     }

//     scannedPages.add(ScannedPage(originalImagePath: imagePath));
//   }

//   Future<void> addPageFromPath(String imagePath) async {
//     if (imagePath.trim().isEmpty) {
//       return;
//     }

//     final page = ScannedPage(originalImagePath: imagePath);

//     scannedPages.add(page);
//     currentPageIndex.value = scannedPages.length - 1;

//     debugLog(
//       'Page added successfully.\n'
//       'Total pages: ${scannedPages.length}',
//     );
//   }

//   void selectPage(int index) {
//     if (index < 0 || index >= scannedPages.length) {
//       return;
//     }

//     currentPageIndex.value = index;
//   }

//   Future<bool> extractCurrentText() async {
//     if (currentPage == null) {
//       return false;
//     }

//     return extractTextForPage(currentPageIndex.value);
//   }

//   Future<bool> extractTextForPage(int index) async {
//     if (index < 0 || index >= scannedPages.length) {
//       return false;
//     }

//     try {
//       isExtracting.value = true;
//       isProcessing.value = true;

//       final page = scannedPages[index];

//       final imagePath = page.displayImagePath;

//       debugLog(
//         '========== OCR START ==========\n'
//         'Page: ${index + 1}\n'
//         'Image: $imagePath',
//       );

//       final file = File(imagePath);

//       if (!await file.exists()) {
//         AppSnackbar.error('OCR Error', 'Document image could not be found.');

//         return false;
//       }

//       final inputImage = InputImage.fromFilePath(imagePath);

//       final RecognizedText recognizedText = await textRecognizer.processImage(
//         inputImage,
//       );

//       final text = recognizedText.text.trim();

//       page.extractedText = ExtractedTextModel(
//         text: text,
//         extractedAt: DateTime.now(),
//       );

//       scannedPages.refresh();

//       debugLog('========== OCR RESULT ==========\n${page.extractedText.text}');

//       if (text.isEmpty) {
//         AppSnackbar.warning(
//           'No Text Found',
//           'We could not find readable text in this document.',
//         );

//         return false;
//       }

//       return true;
//     } catch (e) {
//       debugLog('OCR error: $e');

//       AppSnackbar.error(
//         'Text Recognition Error',
//         'Unable to extract text from this document.',
//       );

//       return false;
//     } finally {
//       isExtracting.value = false;
//       isProcessing.value = false;
//     }
//   }

//   Future<void> cropCurrentPage() async {
//     final page = currentPage;

//     if (page == null || isProcessing.value) {
//       return;
//     }

//     try {
//       isCropping.value = true;
//       isProcessing.value = true;

//       final CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: page.displayImagePath,
//         compressQuality: 95,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Document',
//             toolbarColor: AppColors.white,
//             toolbarWidgetColor: Colors.black,
//             activeControlsWidgetColor: AppColors.primary,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//             showCropGrid: true,
//           ),
//           IOSUiSettings(
//             title: 'Crop Document',
//             doneButtonTitle: 'Done',
//             cancelButtonTitle: 'Cancel',
//             aspectRatioLockEnabled: false,
//             resetAspectRatioEnabled: true,
//           ),
//         ],
//       );

//       if (croppedFile == null) {
//         debugLog('Crop cancelled.');
//         return;
//       }

//       final newPath = await _copyToAppDirectory(croppedFile.path, 'crop');

//       page.processedImagePath = newPath;

//       scannedPages.refresh();

//       debugLog('Crop completed: $newPath');

//       await extractTextForPage(currentPageIndex.value);

//       AppSnackbar.success('Crop Complete', 'Document cropped successfully.');
//     } catch (e) {
//       debugLog('Crop error: $e');

//       AppSnackbar.error('Crop Error', 'Unable to crop this document.');
//     } finally {
//       isCropping.value = false;
//       isProcessing.value = false;
//     }
//   }

//   Future<void> rotateCurrentPage() async {
//     final page = currentPage;

//     if (page == null || isProcessing.value) {
//       return;
//     }

//     try {
//       isRotating.value = true;
//       isProcessing.value = true;

//       final imageFile = File(page.displayImagePath);

//       if (!await imageFile.exists()) {
//         throw Exception('Image file does not exist.');
//       }

//       final bytes = await imageFile.readAsBytes();

//       final decodedImage = img.decodeImage(bytes);

//       if (decodedImage == null) {
//         throw Exception('Unable to decode image.');
//       }

//       final rotatedImage = img.copyRotate(decodedImage, angle: 90);

//       final newPath = await _saveImage(rotatedImage, 'rotate');

//       page.processedImagePath = newPath;

//       scannedPages.refresh();

//       debugLog('Rotate completed: $newPath');

//       await extractTextForPage(currentPageIndex.value);

//       AppSnackbar.success('Rotated', 'Document rotated successfully.');
//     } catch (e) {
//       debugLog('Rotate error: $e');

//       AppSnackbar.error('Rotate Error', 'Unable to rotate this document.');
//     } finally {
//       isRotating.value = false;
//       isProcessing.value = false;
//     }
//   }

//   Future<void> enhanceCurrentPage() async {
//     final page = currentPage;

//     if (page == null || isProcessing.value) {
//       return;
//     }

//     try {
//       isEnhancing.value = true;
//       isProcessing.value = true;

//       final imageFile = File(page.displayImagePath);

//       if (!await imageFile.exists()) {
//         throw Exception('Image file does not exist.');
//       }

//       final bytes = await imageFile.readAsBytes();

//       final decodedImage = img.decodeImage(bytes);

//       if (decodedImage == null) {
//         throw Exception('Unable to decode image.');
//       }

//       debugLog('Enhancing image while preserving original colors...');

//       final enhancedImage = img.adjustColor(
//         decodedImage,
//         contrast: 1.10,
//         brightness: 1.03,
//         saturation: 1.05,
//       );

//       final newPath = await _saveImage(enhancedImage, 'enhanced');

//       page.processedImagePath = newPath;

//       scannedPages.refresh();

//       debugLog('Enhancement completed: $newPath');

//       await extractTextForPage(currentPageIndex.value);

//       AppSnackbar.success(
//         'Enhanced',
//         'Document enhanced while preserving colors.',
//       );
//     } catch (e) {
//       debugLog('Enhance error: $e');

//       AppSnackbar.error('Enhance Error', 'Unable to enhance this document.');
//     } finally {
//       isEnhancing.value = false;
//       isProcessing.value = false;
//     }
//   }

//   Future<void> deleteCurrentPage() async {
//     if (scannedPages.isEmpty) {
//       return;
//     }

//     final int index = currentPageIndex.value;

//     if (index < 0 || index >= scannedPages.length) {
//       return;
//     }

//     try {
//       final ScannedPage page = scannedPages[index];

//       debugLog('========== DELETE PAGE ==========');
//       debugLog('Deleting page: ${index + 1}');
//       debugLog('Total pages before: ${scannedPages.length}');
//       debugLog('Original: ${page.originalImagePath}');
//       debugLog('Processed: ${page.processedImagePath}');

//       if (page.processedImagePath != null) {
//         final processedFile = File(page.processedImagePath!);

//         if (await processedFile.exists()) {
//           await processedFile.delete();
//           debugLog('Processed image deleted.');
//         }
//       }

//       scannedPages.removeAt(index);
//       scannedPages.refresh();

//       if (scannedPages.isEmpty) {
//         currentPageIndex.value = 0;
//       } else if (index >= scannedPages.length) {
//         currentPageIndex.value = scannedPages.length - 1;
//       } else {
//         currentPageIndex.value = index;
//       }

//       debugLog('Total pages after: ${scannedPages.length}');
//       debugLog('Current page index: ${currentPageIndex.value}');
//       debugLog('================================');

//       AppSnackbar.success(
//         'Page Deleted',
//         'Page ${index + 1} has been removed.',
//       );
//     } catch (e) {
//       debugLog('Delete page error: $e');

//       AppSnackbar.error('Delete Error', 'Unable to delete this page.');
//     }
//   }

//   void reorderPages(int oldIndex, int newIndex) {
//     if (oldIndex < newIndex) {
//       newIndex -= 1;
//     }

//     if (oldIndex < 0 ||
//         oldIndex >= scannedPages.length ||
//         newIndex < 0 ||
//         newIndex >= scannedPages.length) {
//       return;
//     }

//     final page = scannedPages.removeAt(oldIndex);

//     scannedPages.insert(newIndex, page);

//     if (currentPageIndex.value == oldIndex) {
//       currentPageIndex.value = newIndex;
//     } else if (oldIndex < currentPageIndex.value &&
//         newIndex >= currentPageIndex.value) {
//       currentPageIndex.value--;
//     } else if (oldIndex > currentPageIndex.value &&
//         newIndex <= currentPageIndex.value) {
//       currentPageIndex.value++;
//     }

//     debugLog('Pages reordered: $oldIndex → $newIndex');
//   }

//   Future<void> retakeCurrentPage() async {
//     if (scannedPages.isEmpty) {
//       return;
//     }

//     final index = currentPageIndex.value;

//     debugLog('Retaking page ${index + 1}');

//     Get.back(result: {'action': 'retake', 'pageIndex': index});
//   }

//   Future<void> requestAddPage() async {
//     final result = await Get.toNamed(
//       Routes.SCAN_DOCUMENT,
//       arguments: {'mode': 'add_page'},
//     );

//     if (result is! Map) return;

//     final action = result['action'];

//     if (action == 'add_page') {
//       final imagePath = result['imagePath'];

//       if (imagePath is String && imagePath.isNotEmpty) {
//         await addPageFromPath(imagePath);
//       }
//     }
//   }

//   Future<void> done() async {
//     if (isProcessing.value) return;

//     try {
//       isProcessing.value = true;

//       final imagePaths = scannedPages
//           .map((page) => page.displayImagePath)
//           .toList();

//       final directory = await getApplicationDocumentsDirectory();

//       final pdfPath = await Isolate.run(
//         () => generatePdfInIsolate(imagePaths, directory.path),
//       );

//       if (pdfPath == null) return;

//       final fileName = 'align_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

//       Get.offNamed(
//         Routes.PDF_RESULT,
//         arguments: {
//           'pdfPath': pdfPath,
//           'pages': imagePaths.length,
//           'fileName': fileName,
//         },
//       );
//     } catch (e, stackTrace) {
//       debugLog(e.toString());
//       debugLog(stackTrace.toString());

//       AppSnackbar.error('PDF Error', 'Unable to create the PDF.');
//     } finally {
//       isProcessing.value = false;
//     }
//   }

//   Future<String> _saveImage(img.Image image, String prefix) async {
//     final directory = await getApplicationDocumentsDirectory();

//     final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

//     final path = '${directory.path}/$fileName';

//     final bytes = img.encodeJpg(image, quality: 95);

//     await File(path).writeAsBytes(bytes);

//     return path;
//   }

//   Future<String> _copyToAppDirectory(String sourcePath, String prefix) async {
//     final directory = await getApplicationDocumentsDirectory();

//     final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

//     final destination = File('${directory.path}/$fileName');

//     await File(sourcePath).copy(destination.path);

//     return destination.path;
//   }

//   void clearPreviewSession() {
//     scannedPages.clear();
//     currentPageIndex.value = 0;
//   }

//   @override
//   void onClose() {
//     textRecognizer.close();
//     scannedPages.clear();
//     currentPageIndex.value = 0;
//     super.onClose();
//   }
// }

// Future<String?> generatePdfInIsolate(
//   List<String> imagePaths,
//   String directoryPath,
// ) async {
//   try {
//     final pdf = pw.Document();

//     for (final imagePath in imagePaths) {
//       final file = File(imagePath);

//       if (!await file.exists()) continue;

//       final bytes = await file.readAsBytes();
//       final image = pw.MemoryImage(bytes);

//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           margin: pw.EdgeInsets.zero,
//           build: (_) =>
//               pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
//         ),
//       );
//     }

//     final fileName = 'align_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

//     final file = File('$directoryPath/$fileName');

//     await file.writeAsBytes(await pdf.save());

//     return file.path;
//   } catch (e) {
//     return null;
//   }
// }

import 'dart:io';
import 'dart:isolate';

import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/core/widgets/debug_logs.dart';
import 'package:align_pdf_ai/app/routes/app_pages.dart';
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
  // ============================================================
  // OCR
  // ============================================================

  final TextRecognizer textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  // ============================================================
  // STATE
  // ============================================================

  final RxList<ScannedPage> scannedPages = <ScannedPage>[].obs;

  final RxInt currentPageIndex = 0.obs;

  final RxBool isProcessing = false.obs;
  final RxBool isExtracting = false.obs;
  final RxBool isEnhancing = false.obs;
  final RxBool isCropping = false.obs;
  final RxBool isRotating = false.obs;

  // ============================================================
  // CURRENT PAGE
  // ============================================================

  ScannedPage? get currentPage {
    if (scannedPages.isEmpty) {
      return null;
    }

    if (currentPageIndex.value >= scannedPages.length) {
      currentPageIndex.value = scannedPages.length - 1;
    }

    return scannedPages[currentPageIndex.value];
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    _loadArguments();
  }

  // ============================================================
  // LOAD INITIAL SCANNED IMAGES
  // ============================================================

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

    debugLog('Preview initialized with ${scannedPages.length} page(s).');
  }

  // ============================================================
  // INTERNAL PAGE ADD
  // ============================================================

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

    final page = ScannedPage(originalImagePath: imagePath);

    scannedPages.add(page);

    currentPageIndex.value = scannedPages.length - 1;

    debugLog(
      '========== PAGE ADDED ==========\n'
      'Image: $imagePath\n'
      'Total pages: ${scannedPages.length}\n'
      'Current page: ${currentPageIndex.value + 1}\n'
      'OCR: SKIPPED\n'
      '================================',
    );
  }

  // ============================================================
  // SELECT PAGE
  // ============================================================

  void selectPage(int index) {
    if (index < 0 || index >= scannedPages.length) {
      return;
    }

    currentPageIndex.value = index;

    debugLog('Selected page: ${index + 1}');
  }

  // ============================================================
  // OCR CURRENT PAGE
  // ============================================================

  Future<bool> extractCurrentText() async {
    if (currentPage == null) {
      return false;
    }

    return extractTextForPage(currentPageIndex.value);
  }

  // ============================================================
  // OCR PAGE
  // ============================================================

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

      debugLog(
        '========== OCR RESULT ==========\n'
        '$text',
      );

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

  // ============================================================
  // CROP CURRENT PAGE
  // ============================================================

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

  // ============================================================
  // ROTATE CURRENT PAGE
  // ============================================================

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

  // ============================================================
  // ENHANCE CURRENT PAGE
  // ============================================================

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

  // ============================================================
  // DELETE CURRENT PAGE
  // ============================================================

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

      debugLog(
        '========== DELETE PAGE ==========\n'
        'Deleting page: ${index + 1}\n'
        'Total pages before: ${scannedPages.length}\n'
        'Original: ${page.originalImagePath}\n'
        'Processed: ${page.processedImagePath}',
      );

      // Delete processed copy if it exists.
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

      debugLog(
        'Total pages after: ${scannedPages.length}\n'
        'Current page index: ${currentPageIndex.value}\n'
        '================================',
      );

      AppSnackbar.success(
        'Page Deleted',
        'Page ${index + 1} has been removed.',
      );
    } catch (e) {
      debugLog('Delete page error: $e');

      AppSnackbar.error('Delete Error', 'Unable to delete this page.');
    }
  }

  // ============================================================
  // REORDER PAGES
  // ============================================================

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

  // ============================================================
  // RETAKE CURRENT PAGE
  // ============================================================

  Future<void> retakeCurrentPage() async {
    if (scannedPages.isEmpty) {
      return;
    }

    final index = currentPageIndex.value;

    debugLog('Retaking page ${index + 1}');

    Get.back(result: {'action': 'retake', 'pageIndex': index});
  }

  // ============================================================
  // ADD PAGE FROM SCANNER
  // ============================================================

  Future<void> requestAddPage() async {
    final result = await Get.toNamed(
      Routes.SCAN_DOCUMENT,
      arguments: {'mode': 'add_page'},
    );

    if (result is! Map) {
      return;
    }

    final action = result['action'];

    if (action == 'add_page') {
      final imagePath = result['imagePath'];

      if (imagePath is String && imagePath.isNotEmpty) {
        await addPageFromPath(imagePath);
      }
    }
  }

  // ============================================================
  // GENERATE PDF
  // ============================================================

  Future<void> done() async {
    if (isProcessing.value) {
      return;
    }

    if (scannedPages.isEmpty) {
      AppSnackbar.warning(
        'No Pages',
        'Please add at least one page before creating the PDF.',
      );

      return;
    }

    try {
      isProcessing.value = true;

      final imagePaths = scannedPages
          .map((page) => page.displayImagePath)
          .toList();

      debugLog(
        '========== PDF GENERATION ==========\n'
        'Pages: ${imagePaths.length}',
      );

      final directory = await getApplicationDocumentsDirectory();

      final pdfPath = await Isolate.run(
        () => generatePdfInIsolate(imagePaths, directory.path),
      );

      if (pdfPath == null) {
        AppSnackbar.error('PDF Error', 'Unable to create the PDF.');

        return;
      }

      final fileName = 'align_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

      debugLog('PDF generated: $pdfPath');

      Get.offNamed(
        Routes.PDF_RESULT,
        arguments: {
          'pdfPath': pdfPath,
          'pages': imagePaths.length,
          'fileName': fileName,
        },
      );
    } catch (e, stackTrace) {
      debugLog(e.toString());

      debugLog(stackTrace.toString());

      AppSnackbar.error('PDF Error', 'Unable to create the PDF.');
    } finally {
      isProcessing.value = false;
    }
  }

  // ============================================================
  // SAVE IMAGE
  // ============================================================

  Future<String> _saveImage(img.Image image, String prefix) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final path = '${directory.path}/$fileName';

    final bytes = img.encodeJpg(image, quality: 95);

    await File(path).writeAsBytes(bytes);

    return path;
  }

  // ============================================================
  // COPY IMAGE TO APP DIRECTORY
  // ============================================================

  Future<String> _copyToAppDirectory(String sourcePath, String prefix) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final destination = File('${directory.path}/$fileName');

    await File(sourcePath).copy(destination.path);

    return destination.path;
  }

  // ============================================================
  // CLEAR PREVIEW SESSION
  // ============================================================

  void clearPreviewSession() {
    scannedPages.clear();
    currentPageIndex.value = 0;

    debugLog('Preview session cleared.');
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    textRecognizer.close();

    scannedPages.clear();
    currentPageIndex.value = 0;

    super.onClose();
  }
}

// ================================================================
// PDF GENERATION ISOLATE
// ================================================================

Future<String?> generatePdfInIsolate(
  List<String> imagePaths,
  String directoryPath,
) async {
  try {
    final pdf = pw.Document();

    for (final imagePath in imagePaths) {
      final file = File(imagePath);

      if (!await file.exists()) {
        continue;
      }

      final bytes = await file.readAsBytes();

      final image = pw.MemoryImage(bytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) {
            return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
          },
        ),
      );
    }

    final fileName = 'align_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File('$directoryPath/$fileName');

    await file.writeAsBytes(await pdf.save());

    return file.path;
  } catch (e) {
    return null;
  }
}
