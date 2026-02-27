import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

Widget buildScanButton(dynamic controller) {
  return GestureDetector(
    onTap: controller.goToScanner,
    child: Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x1A00E5FF),
            Color(0x0D7C4DFF),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryBorder, width: 1.5),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),
          // Corner decorations
          Positioned(top: 16, left: 16, child: _Corner()),
          Positioned(top: 16, right: 16, child: _Corner(flip: true)),
          Positioned(bottom: 16, left: 16, child: _Corner(bottom: true)),
          Positioned(bottom: 16, right: 16, child: _Corner(bottom: true, flip: true)),
          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDim,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryBorder, width: 2),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      color: AppColors.primary, size: 36),
                ),
                const SizedBox(height: 16),
                Text('TAP TO SCAN', style: AppTextStyles.monoLabel),
                const SizedBox(height: 6),
                Text('QR Code · Barcode · All Formats',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.04)
      ..strokeWidth = 0.5;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
class _Corner extends StatelessWidget {
  final bool flip;
  final bool bottom;
  const _Corner({this.flip = false, this.bottom = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(
        painter: _CornerPainter(flip: flip, bottom: bottom),
      ),
    );
  }
}
class _CornerPainter extends CustomPainter {
  final bool flip, bottom;
  _CornerPainter({required this.flip, required this.bottom});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (!flip && !bottom) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    } else if (flip && !bottom) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!flip && bottom) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
