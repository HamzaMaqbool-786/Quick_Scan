import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickscan/modules/result/result_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

Widget buildSecondaryActions(ResultController controller) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.border),
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
      label: Text('Scan Another', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
      onPressed: controller.scanAgain,
    ),
  );
}
