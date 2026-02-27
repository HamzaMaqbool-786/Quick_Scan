import 'package:flutter/material.dart';
import 'package:quickscan/modules/result/result_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
Widget buildMetaCard(ResultController controller) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Scan Details', style: AppTextStyles.monoLabel),
        const SizedBox(height: 16),
        _MetaRow('Format', controller.scan.format),
        const Divider(color: AppColors.border, height: 24),
        _MetaRow('Characters', '${controller.scan.rawValue.length}'),
        const Divider(color: AppColors.border, height: 24),
        _MetaRow('Date', DateFormatter.formatDate(controller.scan.scannedAt)),
        const Divider(color: AppColors.border, height: 24),
        _MetaRow('Time', DateFormatter.formatShort(controller.scan.scannedAt)),
      ],
    ),
  );
}
class _MetaRow extends StatelessWidget {
  final String label, value;
  const _MetaRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value, style: AppTextStyles.monoSmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
