import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExtractDocumentPreview extends StatelessWidget {
  final RxString imagePath;

  const ExtractDocumentPreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 158,
        height: 216,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE9D9D6), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Obx(
          () => imagePath.value.isNotEmpty
              ? Image.file(
                  File(imagePath.value),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildEmptyPreview(),
                )
              : _buildEmptyPreview(),
        ),
      ),
    );
  }

  Widget _buildEmptyPreview() {
    return const Center(
      child: Icon(
        Icons.description_outlined,
        size: 50,
        color: Color(0xFFD0C5C2),
      ),
    );
  }
}
