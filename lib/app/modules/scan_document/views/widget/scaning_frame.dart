import 'package:align_pdf_ai/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScanningFrame extends StatefulWidget {
  const ScanningFrame({super.key});

  @override
  State<ScanningFrame> createState() => _ScanningFrameState();
}

class _ScanningFrameState extends State<ScanningFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final double scanPosition =
                _animationController.value * constraints.maxHeight;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Document corners
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: DocumentFramePainter(color: AppColors.primary),
                ),

                // Animated laser
                Positioned(
                  top: scanPosition,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.8),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // Soft scanning glow underneath the laser
                Positioned(
                  top: scanPosition - 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.0),
                          AppColors.primary.withOpacity(0.12),
                          AppColors.primary.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class DocumentFramePainter extends CustomPainter {
  final Color color;

  DocumentFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.8.w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const double cornerLength = 45;

    final double left = 0;
    final double top = 0;
    final double right = size.width;
    final double bottom = size.height;

    final path = Path();

    path.moveTo(left + cornerLength, top);
    path.lineTo(left, top);
    path.lineTo(left, top + cornerLength);

    path.moveTo(right - cornerLength, top);
    path.lineTo(right, top);
    path.lineTo(right, top + cornerLength);

    path.moveTo(left, bottom - cornerLength);
    path.lineTo(left, bottom);
    path.lineTo(left + cornerLength, bottom);

    path.moveTo(right - cornerLength, bottom);
    path.lineTo(right, bottom);
    path.lineTo(right, bottom - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DocumentFramePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
