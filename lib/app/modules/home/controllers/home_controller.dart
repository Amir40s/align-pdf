import 'dart:io';

import 'package:align_pdf_ai/app/core/services/history_storage_service.dart';
import 'package:align_pdf_ai/app/core/utils/l10n_getx_helper.dart';
import 'package:align_pdf_ai/app/core/widgets/app_snackbar.dart';
import 'package:align_pdf_ai/app/modules/history/model/history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class HomeController extends GetxController {
  final documents = <HistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLatestDocuments();
  }

  void loadLatestDocuments() {
    final data = HistoryStorageService.instance.getHistory();

    documents.assignAll(data.map(HistoryItem.fromMap).take(5).toList());
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return getl10n.goodMorning;
    } else if (hour < 17) {
      return getl10n.goodAfternoon;
    } else if (hour < 21) {
      return getl10n.goodEvening;
    } else {
      return getl10n.goodNight;
    }
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return getl10n.today;
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return getl10n.yesterday;
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> openPdf(HistoryItem item) async {
    final file = File(item.filePath);

    if (!await file.exists()) {
      AppSnackbar.error(
        getl10n.fileNotFound,
        getl10n.thisPdfIsNoLongerAvailable,
      );
      return;
    }

    final result = await OpenFilex.open(item.filePath, type: 'application/pdf');

    if (result.type != ResultType.done) {
      AppSnackbar.error(getl10n.unableToOpen, result.message);
    }
  }

  Future<void> sharePdf(HistoryItem item) async {
    final file = File(item.filePath);

    if (!await file.exists()) {
      AppSnackbar.error(
        getl10n.fileNotFound,
        getl10n.thisPdfIsNoLongerAvailable,
      );
      return;
    }

    await SharePlus.instance.share(
      ShareParams(files: [XFile(item.filePath)], text: item.title),
    );
  }

  Future<void> deletePdf(HistoryItem item) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(getl10n.deletePdf),
        content: Text(getl10n.areYouSureDeletePdf),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(getl10n.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(getl10n.delete),
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

    loadLatestDocuments();
  }

  void showActions(HistoryItem item) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_new_rounded),
                title: Text(getl10n.openPdf),
                onTap: () {
                  Get.back();
                  openPdf(item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: Text(getl10n.share),
                onTap: () {
                  Get.back();
                  sharePdf(item);
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: Text(getl10n.delete),
                onTap: () {
                  Get.back();
                  deletePdf(item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
