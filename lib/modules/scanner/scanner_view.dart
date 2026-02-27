import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quickscan/modules/scanner/widgets/PermissionDenied.dart';
import 'package:quickscan/modules/scanner/widgets/ProcessingOverlay.dart';
import 'package:quickscan/modules/scanner/widgets/bottom_controls.dart';
import 'package:quickscan/modules/scanner/widgets/top_bar.dart';
import 'scanner_controller.dart';

import '../../widgets/scanner_overlay.dart';

class ScannerView extends GetView<ScannerController> {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.hasPermission.value) {
          return const PermissionDenied();
        }
        return Stack(
          children: [
            // Camera feed
            MobileScanner(
              controller: controller.cameraController,
              onDetect: controller.onBarcodeDetected,
            ),

            // Overlay
            const ScannerOverlay(),

            // Top bar
            const TopBar(),

            // Bottom controls
            const BottomControls(),

            // Processing indicator
            Obx(() => controller.isProcessing.value
                ? const ProcessingOverlay()
                : const SizedBox()),
          ],
        );
      }),
    );
  }
}





