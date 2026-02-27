import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key});

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scanLineAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight) * 0.65;
        final left = (constraints.maxWidth - size) / 2;
        final top = (constraints.maxHeight - size) / 2 - 40;

        return Stack(
          children: [
            // Dark overlay with cutout
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _OverlayPainter(
                cutoutRect: Rect.fromLTWH(left, top, size, size),
                borderRadius: 20,
              ),
            ),
            // Animated scan line
            Positioned(
              left: left + 4,
              width: size - 8,
              top: top,
              height: size,
              child: AnimatedBuilder(
                animation: _scanLineAnim,
                builder: (_, __) {
                  return Stack(
                    children: [
                      Positioned(
                        top: (_scanLineAnim.value * (size - 8)) + 4,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.primary,
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Corner brackets
            Positioned(
              left: left,
              top: top,
              child: const _CornerBracket(position: CornerPosition.topLeft, size: 28),
            ),
            Positioned(
              right: left,
              top: top,
              child: const _CornerBracket(position: CornerPosition.topRight, size: 28),
            ),
            Positioned(
              left: left,
              bottom: constraints.maxHeight - top - size,
              child: const _CornerBracket(position: CornerPosition.bottomLeft, size: 28),
            ),
            Positioned(
              right: left,
              bottom: constraints.maxHeight - top - size,
              child: const _CornerBracket(position: CornerPosition.bottomRight, size: 28),
            ),
          ],
        );
      },
    );
  }
}

// ─── Overlay painter with hole ────────────────────────────────────────────────
class _OverlayPainter extends CustomPainter {
  final Rect cutoutRect;
  final double borderRadius;

  _OverlayPainter({required this.cutoutRect, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.65);
    final fullPath = Path()..addRect(Offset.zero & size);
    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutoutRect, Radius.circular(borderRadius)));
    final combined =
        Path.combine(PathOperation.difference, fullPath, holePath);
    canvas.drawPath(combined, paint);

    // Border around cutout
    final borderPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutoutRect, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Corner bracket widget ─────────────────────────────────────────────────
enum CornerPosition { topLeft, topRight, bottomLeft, bottomRight }

class _CornerBracket extends StatelessWidget {
  final CornerPosition position;
  final double size;

  const _CornerBracket({required this.position, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CornerPainter(position: position)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final CornerPosition position;
  _CornerPainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const r = Radius.circular(4.0);
    final path = Path();

    switch (position) {
      case CornerPosition.topLeft:
        path.moveTo(size.width, 0);
        path.arcToPoint(const Offset(0, 0), radius: r);
        path.lineTo(0, size.height);
        break;
      case CornerPosition.topRight:
        path.moveTo(0, 0);
        path.arcToPoint(Offset(size.width, 0), radius: r, clockwise: false);
        path.lineTo(size.width, size.height);
        break;
      case CornerPosition.bottomLeft:
        path.moveTo(0, 0);
        path.lineTo(0, size.height);
        path.arcToPoint(Offset(size.width, size.height), radius: r);
        break;
      case CornerPosition.bottomRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.arcToPoint(Offset(0, size.height), radius: r, clockwise: false);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
