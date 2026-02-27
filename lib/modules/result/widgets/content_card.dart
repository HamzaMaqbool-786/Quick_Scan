import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickscan/modules/result/result_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/url_detector.dart';
Widget buildContentCard(ResultController  controller) {
  final typeIcon = UrlDetector.getIcon(controller.scan.type);
  final typeLabel = UrlDetector.getDisplayType(controller.scan.type);

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primaryBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(typeIcon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Text(
              typeLabel.toUpperCase(),
              style: AppTextStyles.monoLabel,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SelectableText(
          controller.scan.rawValue,
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 12),
        Text(
          DateFormatter.formatFull(controller.scan.scannedAt),
          style: AppTextStyles.monoSmall,
        ),
      ],
    ),
  );
}
