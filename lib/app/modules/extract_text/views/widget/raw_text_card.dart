import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:align_pdf_ai/app/modules/extract_text/controllers/extract_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RawTextCard extends StatelessWidget {
  final ExtractTextController controller;

  const RawTextCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFECE7E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRawTextHeader(),
          Container(height: 1, color: const Color(0xFFF0ECEA)),
          _buildTextContent(),
        ],
      ),
    );
  }

  Widget _buildRawTextHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const Text(
            'RAW TEXT',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Color(0xFF624B46),
            ),
          ),
          const Spacer(),
          Obx(() {
            if (!controller.isEditing.value) {
              return InkWell(
                onTap: controller.startEditing,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 22,
                    color: Color(0xFF624B46),
                  ),
                ),
              );
            }

            return Row(
              children: [
                GestureDetector(
                  onTap: controller.cancelEditing,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF77706D),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: controller.finishEditing,
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Obx(() {
      if (controller.isEditing.value) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: controller.textController,
            maxLines: null,
            minLines: 20,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontSize: 18,
              height: 1.55,
              color: Color(0xFF292625),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Extracted text...',
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
        child: _buildFormattedText(controller.extractedText.value),
      );
    });
  }

  Widget _buildFormattedText(String text) {
    if (text.trim().isEmpty) {
      return const Text(
        'No text found.',
        style: TextStyle(fontSize: 17, color: Colors.grey),
      );
    }

    final lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < lines.length; i++) _buildTextLine(lines[i]),
      ],
    );
  }

  Widget _buildTextLine(String line) {
    final trimmed = line.trim();

    if (trimmed.isEmpty) {
      return const SizedBox(height: 12);
    }

    final lower = trimmed.toLowerCase();

    // Main heading
    if (lower == 'invoice' ||
        lower == 'receipt' ||
        lower == 'bill' ||
        lower == 'quotation') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          trimmed,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Color(0xFF252323),
          ),
        ),
      );
    }

    // Section headings
    if (lower.endsWith(':') &&
        (lower.contains('billed') ||
            lower.contains('bill to') ||
            lower.contains('items') ||
            lower.contains('customer') ||
            lower.contains('total') ||
            lower.contains('from'))) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trimmed,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF624B46),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: const Color(0xFFE6E0DE)),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: _highlightImportantText(trimmed),
    );
  }

  Widget _highlightImportantText(String text) {
    final regex = RegExp(
      r'(\$[\d,]+(?:\.\d{2})?|'
      r'\b\d{1,3}(?:,\d{3})*(?:\.\d{2})?\b|'
      r'\b(?:January|February|March|April|May|June|July|August|September|October|November|December)\b'
      r'(?:\s+\d{1,2},?\s+\d{4})?)',
      caseSensitive: false,
    );

    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
          color: Color(0xFF292625),
        ),
      );
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(
            backgroundColor: Color(0xFFFFE9E6),
            fontWeight: FontWeight.w500,
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
          color: Color(0xFF292625),
        ),
        children: spans,
      ),
    );
  }
}
