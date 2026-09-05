import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmer(
  BuildContext context, {
  double? height,
  double? width,
  Color? baseColor,
  Color? highlightColor,
  double? borderRadius,
}) {
  return Shimmer.fromColors(
    baseColor: baseColor ?? Colors.grey[300]!,
    highlightColor: highlightColor ?? Colors.grey[100]!,
    child: Container(
      height: height ?? Get.height * .046,
      width: width ?? Get.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
      ),
    ),
  );
}
