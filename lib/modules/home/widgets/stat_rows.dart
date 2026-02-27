import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickscan/modules/home/home_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
Widget buildStatsRow(HomeController controller) {
  return Obx(() => Row(
    children: [
      _StatCard(
        label: 'TOTAL SCANS',
        value: controller.totalScans.value.toString(),
        icon: Icons.qr_code_rounded,
        color: AppColors.primary,
      ),
      const SizedBox(width: 12),
      _StatCard(
        label: 'SAVED',
        value: controller.recentScans.isEmpty ? '0' : 'ACTIVE',
        icon: Icons.save_outlined,
        color: AppColors.success,
      ),
    ],
  ));
}
class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppTextStyles.displaySmall.copyWith(fontSize: 20, color: color)),
                Text(label, style: AppTextStyles.monoSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
