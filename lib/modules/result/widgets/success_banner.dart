import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickscan/modules/result/result_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/scan_type_badge.dart';

Widget buildSuccessBanner(ResultController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppColors.successDim,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.success.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.check_circle_outline_rounded,
            color: AppColors.success, size: 20),
        const SizedBox(width: 10),
        Text(
          'Scan successful!',
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.success),
        ),
        const Spacer(),
        ScanTypeBadge(type: controller.scan.type),
      ],
    ),
  );
}
