import 'dart:io';

import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/core/widgets/debug_logs.dart';
import 'package:align_pdf_ai/app/routes/app_pages.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ScanDocumentController extends GetxController
    with WidgetsBindingObserver {
  CameraController? cameraController;

  final ImagePicker imagePicker = ImagePicker();

  final TextRecognizer textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  late final bool isAddingPage;

  final RxBool isCameraInitialized = false.obs;
  final RxBool isProcessing = false.obs;
  final RxBool documentDetected = false.obs;
  final RxBool flashEnabled = false.obs;

  final RxString extractedText = ''.obs;

  final RxList<String> scannedImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    debugLog('========================================');
    debugLog('SCAN DOCUMENT CONTROLLER INIT');
    debugLog('========================================');

    final arguments = Get.arguments;

    isAddingPage = arguments is Map && arguments['mode'] == 'add_page';

    debugLog('Scan mode: ${isAddingPage ? 'ADD PAGE' : 'NORMAL SCAN'}');

    WidgetsBinding.instance.addObserver(this);

    initializeCamera();
  }

  Future<void> initializeCamera() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      return;
    }

    try {
      debugLog('========== CAMERA INITIALIZATION ==========');

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        AppSnackbar.error(
          'Camera Error',
          'No camera was found on this device.',
        );
        return;
      }

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
      );

      cameraController = controller;

      await controller.initialize();

      if (isClosed) {
        await controller.dispose();
        return;
      }

      await controller.setFlashMode(FlashMode.auto);

      isCameraInitialized.value = true;
      isProcessing.value = false;

      debugLog('Camera initialized successfully.');
    } catch (e) {
      isCameraInitialized.value = false;
      isProcessing.value = false;

      debugLog('Camera initialization error: $e');

      AppSnackbar.error('Camera Error', 'Unable to initialize camera.');
    }
  }

  Future<void> toggleFlash() async {
    final controller = cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }

    try {
      flashEnabled.toggle();

      await controller.setFlashMode(
        flashEnabled.value ? FlashMode.torch : FlashMode.off,
      );

      debugLog('Flash: ${flashEnabled.value ? 'ON' : 'OFF'}');
    } catch (e) {
      debugLog('Flash error: $e');
    }
  }

  Future<void> captureDocument() async {
    final controller = cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        isProcessing.value) {
      return;
    }

    try {
      isProcessing.value = true;

      final XFile image = await controller.takePicture();
      final String imagePath = image.path;

      debugLog('Captured image: $imagePath');

      if (isAddingPage) {
        debugLog('ADD PAGE MODE: Returning captured image without OCR.');

        resetProcessingState();

        await controller.dispose();

        cameraController = null;
        isCameraInitialized.value = false;

        Get.back(result: {'action': 'add_page', 'imagePath': imagePath});

        return;
      }

      final bool hasText = await extractText(imagePath);

      if (!hasText) {
        documentDetected.value = false;

        AppSnackbar.error(
          'No Text Found',
          'We couldn\'t find any text in this document. Please scan again.',
        );

        return;
      }

      scannedImages.add(imagePath);

      documentDetected.value = true;

      debugLog(
        '========== IMAGE ADDED ==========\n'
        'Total pages: ${scannedImages.length}',
      );

      await openPreview();
    } catch (e) {
      debugLog('Capture error: $e');

      AppSnackbar.error(
        'Scan Error',
        'Something went wrong while scanning the document.',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void resetProcessingState() {
    isProcessing.value = false;
    documentDetected.value = false;
    extractedText.value = '';

    debugLog('Scanner processing state reset.');
  }

  void closeScanner() {
    resetProcessingState();

    debugLog('Closing scanner.');

    Get.back(result: {'action': 'cancel'});
  }

  Future<void> openPreview() async {
    if (scannedImages.isEmpty) {
      debugLog('openPreview() called but no images exist.');
      return;
    }

    final List<String> imagesToPreview = List<String>.from(scannedImages);

    debugLog('========================================');

    debugLog(
      '========== OPEN PREVIEW ==========\n'
      'Pages: ${imagesToPreview.length}',
    );

    for (int i = 0; i < imagesToPreview.length; i++) {
      debugLog('Preview Page ${i + 1}: ${imagesToPreview[i]}');
    }

    final result = await Get.toNamed(
      Routes.SCAN_PREVIEW,
      arguments: imagesToPreview,
    );

    debugLog(
      '========== PREVIEW RESULT ==========\n'
      '$result',
    );

    if (result == null) {
      debugLog('Preview returned null.');
      return;
    }

    if (result is! Map) {
      debugLog('Preview returned unexpected result type.');
      return;
    }

    final action = result['action'];

    debugLog('Preview action: $action');

    if (action == 'add_page') {
      final images = result['images'];

      if (images is List) {
        final List<String> updatedImages = images
            .whereType<String>()
            .where((path) => path.trim().isNotEmpty)
            .toList();

        debugLog(
          '========== SYNC FROM PREVIEW ==========\n'
          'Old pages: ${scannedImages.length}\n'
          'New pages: ${updatedImages.length}',
        );

        scannedImages.assignAll(updatedImages);

        debugLog(
          'Scanner list synchronized successfully.\n'
          'Current pages: ${scannedImages.length}',
        );

        return;
      }

      debugLog('add_page action received but images are invalid.');

      return;
    }

    if (action == 'retake') {
      final pageIndex = result['pageIndex'];

      if (pageIndex is int) {
        debugLog('Retake requested for page: ${pageIndex + 1}');

        if (pageIndex >= 0 && pageIndex < scannedImages.length) {
          scannedImages.removeAt(pageIndex);

          debugLog(
            'Retake page removed.\n'
            'Remaining pages: ${scannedImages.length}',
          );
        }
      }

      return;
    }

    if (action == 'done') {
      final pdfPath = result['pdfPath'];

      debugLog('PDF completed: $pdfPath');

      return;
    }
  }

  Future<void> pickImageFromGallery() async {
    if (isProcessing.value) {
      return;
    }

    try {
      if (isAddingPage) {
        debugLog(
          '========== ADD PAGE GALLERY ==========\n'
          'Selecting one image.\n'
          'OCR: SKIPPED',
        );

        final XFile? image = await imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
        );

        if (image == null) {
          debugLog('Gallery selection cancelled.');
          return;
        }

        debugLog('Gallery image selected: ${image.path}');

        resetProcessingState();

        Get.back(result: {'action': 'add_page', 'imagePath': image.path});

        return;
      }

      isProcessing.value = true;

      debugLog(
        '========== NORMAL GALLERY SCAN ==========\n'
        'Selecting multiple images.',
      );

      final List<XFile> pickedImages = await imagePicker.pickMultiImage(
        imageQuality: 100,
        limit: 20,
      );

      if (pickedImages.isEmpty) {
        debugLog('No gallery images selected.');
        return;
      }

      debugLog('Gallery images selected: ${pickedImages.length}');

      int addedPages = 0;

      for (final XFile pickedImage in pickedImages) {
        final String imagePath = pickedImage.path;

        debugLog('Processing gallery image: $imagePath');

        final bool hasText = await extractText(imagePath);

        if (!hasText) {
          debugLog('Skipping image because no text was found.');
          continue;
        }

        scannedImages.add(imagePath);
        addedPages++;
      }

      debugLog(
        '========== GALLERY RESULT ==========\n'
        'Selected: ${pickedImages.length}\n'
        'Added: $addedPages\n'
        'Total pages: ${scannedImages.length}',
      );

      if (addedPages == 0) {
        documentDetected.value = false;

        AppSnackbar.error(
          'No Documents Found',
          'None of the selected images contained readable text.',
        );

        return;
      }

      documentDetected.value = true;

      await openPreview();
    } catch (e) {
      debugLog('Gallery picker error: $e');

      AppSnackbar.error(
        'Gallery Error',
        'Unable to select or process the image.',
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> extractText(String imagePath) async {
    try {
      debugLog(
        '========== OCR START ==========\n'
        'Image: $imagePath',
      );

      final inputImage = InputImage.fromFilePath(imagePath);

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      final String text = recognizedText.text.trim();

      extractedText.value = text;

      debugLog('========== OCR RESULT ==========');
      debugLog(text);
      debugLog('================================');

      if (text.isEmpty) {
        extractedText.value = '';
        return false;
      }

      return true;
    } catch (e) {
      debugLog('OCR error: $e');

      extractedText.value = '';

      AppSnackbar.error(
        'Text Recognition Error',
        'Unable to read text from this document.',
      );

      return false;
    }
  }

  Future<String?> generatePdf() async {
    if (scannedImages.isEmpty) {
      AppSnackbar.warning(
        'No Document',
        'Please scan at least one document first.',
      );

      return null;
    }

    try {
      debugLog(
        '========== GENERATING PDF ==========\n'
        'Pages: ${scannedImages.length}',
      );

      final pdf = pw.Document();

      int validPages = 0;

      for (int i = 0; i < scannedImages.length; i++) {
        final imagePath = scannedImages[i];
        final file = File(imagePath);

        if (!await file.exists()) {
          debugLog('Image missing for page ${i + 1}: $imagePath');
          continue;
        }

        final imageBytes = await file.readAsBytes();
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

        validPages++;
      }

      if (validPages == 0) {
        AppSnackbar.error('PDF Error', 'No valid document images were found.');

        return null;
      }

      final directory = await getApplicationDocumentsDirectory();

      final fileName = 'align_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      debugLog(
        '========== PDF CREATED ==========\n'
        'Path: ${file.path}\n'
        'Pages: $validPages',
      );

      return file.path;
    } catch (e) {
      debugLog('PDF generation error: $e');

      AppSnackbar.error('PDF Error', 'Unable to generate PDF.');

      return null;
    }
  }

  Future<void> finishScan() async {
    if (scannedImages.isEmpty) {
      AppSnackbar.warning(
        'No Document',
        'Please scan at least one document first.',
      );

      return;
    }

    if (isProcessing.value) {
      return;
    }

    try {
      isProcessing.value = true;

      final pdfPath = await generatePdf();

      if (pdfPath == null) {
        return;
      }

      debugLog(
        '========== FINAL PDF ==========\n'
        '$pdfPath',
      );
    } catch (e) {
      debugLog('Finish scan error: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void retake() {
    documentDetected.value = false;
    extractedText.value = '';

    if (scannedImages.isNotEmpty) {
      scannedImages.removeLast();
    }

    debugLog(
      'Retake last page.\n'
      'Remaining pages: ${scannedImages.length}',
    );
  }

  void clearScanSession() {
    debugLog('========== CLEAR SCAN SESSION ==========');

    scannedImages.clear();
    extractedText.value = '';
    documentDetected.value = false;
    isProcessing.value = false;

    debugLog('Scan session cleared.');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      final controller = cameraController;

      if (controller != null && controller.value.isInitialized) {
        controller.dispose();

        cameraController = null;
        isCameraInitialized.value = false;

        debugLog('Camera disposed because app was paused.');
      }

      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (cameraController == null && !isClosed) {
        debugLog('App resumed. Initializing camera...');

        initializeCamera();
      }
    }
  }

  @override
  void onClose() {
    debugLog('========== SCAN DOCUMENT CONTROLLER CLOSE ==========');

    WidgetsBinding.instance.removeObserver(this);

    cameraController?.dispose();
    cameraController = null;

    isCameraInitialized.value = false;
    isProcessing.value = false;

    textRecognizer.close();

    super.onClose();
  }
}
