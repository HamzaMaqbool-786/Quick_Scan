import 'package:flutter/material.dart';
import 'package:quickscan/modules/home/home_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

Widget buildAppBar(HomeController controller) {
  return SliverAppBar(
    floating: true,
    backgroundColor: AppColors.background,
    expandedHeight: 70,
    titleSpacing: 20,
    title: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryDim,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primaryBorder),
          ),
          child: const Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text('QuickScan', style: AppTextStyles.displaySmall),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.history_rounded, color: AppColors.textSecondary),
        onPressed: controller.goToHistory,
        tooltip: 'History',
      ),
      IconButton(
        icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
        onPressed: controller.goToSettings,
        tooltip: 'Settings',
      ),
      const SizedBox(width: 8),
    ],
  );
}
