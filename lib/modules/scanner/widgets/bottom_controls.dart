import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../scanner_controller.dart';

class BottomControls extends GetView<ScannerController> {
  const BottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xCC000000)],
          ),
        ),
        child: Column(
          children: [
            // Mode selector
            Obx(() => Container(
              decoration: BoxDecoration(
                color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ModeTab(
                    label: 'All',
                    selected: controller.scanMode.value == ScanMode.qrAndBarcode,
                    onTap: () => controller.setScanMode(ScanMode.qrAndBarcode),
                  ),
                  _ModeTab(
                    label: 'QR',
                    selected: controller.scanMode.value == ScanMode.qrOnly,
                    onTap: () => controller.setScanMode(ScanMode.qrOnly),
                  ),
                  _ModeTab(
                    label: 'Barcode',
                    selected: controller.scanMode.value == ScanMode.barcodeOnly,
                    onTap: () => controller.setScanMode(ScanMode.barcodeOnly),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Text(
              'Point camera at a QR code or barcode',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
class _ModeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.monoSmall.copyWith(
            color: selected ? AppColors.background : Colors.white70,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
