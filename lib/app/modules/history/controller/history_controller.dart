import 'dart:io';

import 'package:align_pdf_ai/app/core/services/history_storage_service.dart';
import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/modules/history/model/history_model.dart';
import 'package:align_pdf_ai/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class HistoryController extends GetxController {
  final history = <HistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    final data = HistoryStorageService.instance.getHistory();
    history.assignAll(data.map(HistoryItem.fromMap).toList());
  }

  Future<void> openPdf(HistoryItem item) async {
    final file = File(item.filePath);
    if (!await file.exists()) {
      AppSnackbar.warning('File Not Found', 'This PDF is no longer available.');
      return;
    }
    final result = await OpenFilex.open(item.filePath, type: 'application/pdf');
    if (result.type != ResultType.done) {
      AppSnackbar.error(
        'Unable to Open',
        result.message.isNotEmpty
            ? result.message
            : 'This PDF could not be opened.',
      );
    }
  }

  Future<void> sharePdf(HistoryItem item) async {
    final file = File(item.filePath);
    if (!await file.exists()) {
      AppSnackbar.error('File Not Found', 'This PDF is no longer available.');
      return;
    }

    await SharePlus.instance.share(
      ShareParams(files: [XFile(item.filePath)], text: item.title),
    );
  }

  Future<void> deletePdf(HistoryItem item) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete PDF'),
        content: const Text('Are you sure you want to delete this PDF?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }
    final file = File(item.filePath);
    if (await file.exists()) {
      await file.delete();
    }
    await HistoryStorageService.instance.deleteHistory(item.id);

    loadHistory();
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadLatestDocuments();
    }
  }

  void showActions(HistoryItem item) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.open_in_new_rounded),
                title: const Text('Open PDF'),
                onTap: () {
                  Get.back();
                  openPdf(item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share'),
                onTap: () {
                  Get.back();
                  sharePdf(item);
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Delete'),
                onTap: () {
                  Get.back();
                  deletePdf(item);
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
