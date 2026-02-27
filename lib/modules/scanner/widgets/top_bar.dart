import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../scanner_controller.dart';

class TopBar extends GetView<ScannerController> {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Get.back(),
            ),
            Expanded(
              child: Text('Scan Code',
                  style: AppTextStyles.displaySmall
                      .copyWith(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center),
            ),
            Obx(() => IconButton(
              icon: Icon(
                controller.isTorchOn.value
                    ? Icons.flashlight_on_rounded
                    : Icons.flashlight_off_rounded,
                color: controller.isTorchOn.value
                    ? AppColors.warning
                    : Colors.white,
                size: 24,
              ),
              onPressed: controller.toggleTorch,
            )),
          ],
        ),
      ),
    );
  }
}
