import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../app/routes/app_routes.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/utils/url_detector.dart';
import '../../data/models/scan_result_model.dart';
import '../../data/repositories/scan_repository.dart';

enum ScanMode { qrAndBarcode, qrOnly, barcodeOnly }

class ScannerController extends GetxController {
  final _repo = Get.find<ScanRepository>();

  late MobileScannerController cameraController;

  final isTorchOn = false.obs;
  final isProcessing = false.obs;
  final hasPermission = false.obs;
  final scanMode = ScanMode.qrAndBarcode.obs;
  final scannedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
    _requestPermission();
  }

  void _initCamera() {
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    hasPermission.value = status.isGranted;
    if (!status.isGranted) {
      Get.snackbar(
        'Camera Permission Required',
        'Please grant camera access to use the scanner',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A2236),
        colorText: const Color(0xFFE8EBF5),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings',
              style: TextStyle(color: Color(0xFF00E5FF))),
        ),
      );
    }
  }

  Future<void> onBarcodeDetected(BarcodeCapture capture) async {
    if (isProcessing.value) return;
    if (capture.barcodes.isEmpty) return;

    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    isProcessing.value = true;

    // Haptic + sound feedback
    await HapticService.scanSuccess();
    SystemSound.play(SystemSoundType.click);

    final type = UrlDetector.detect(rawValue);
    final result = ScanResultModel(
      rawValue: rawValue,
      format: barcode.format.name,
      scannedAt: DateTime.now(),
      type: type,
    );

    await _repo.saveScan(result);
    scannedCount.value++;

    // Navigate to result
    await Get.toNamed(AppRoutes.result, arguments: result);

    // Reset processing flag after returning
    await Future.delayed(const Duration(milliseconds: 500));
    isProcessing.value = false;
  }

  void toggleTorch() {
    isTorchOn.toggle();
    cameraController.toggleTorch();
  }

  void flipCamera() {
    cameraController.switchCamera();
  }

  void setScanMode(ScanMode mode) {
    scanMode.value = mode;
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
