import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickscan/modules/result/widgets/content_card.dart';
import 'package:quickscan/modules/result/widgets/meta_card.dart';
import 'package:quickscan/modules/result/widgets/primary_action.dart';
import 'package:quickscan/modules/result/widgets/secondary_Action.dart';
import 'package:quickscan/modules/result/widgets/success_banner.dart';
import 'result_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';


class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text('Scan Result', style: AppTextStyles.displaySmall.copyWith(fontSize: 18)),
        actions: [
          // Favorite button
          Obx(() => IconButton(
                icon: Icon(
                  controller.isFavorite.value
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: controller.isFavorite.value
                      ? AppColors.warning
                      : AppColors.textMuted,
                ),
                onPressed: controller.toggleFavorite,
              )),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () => _showDeleteDialog(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSuccessBanner(controller),
            const SizedBox(height: 20),
            buildContentCard(controller),
            const SizedBox(height: 20),
            buildPrimaryActions(controller),
            const SizedBox(height: 20),
            buildMetaCard(controller),
            const SizedBox(height: 20),
            buildSecondaryActions(controller),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }






  void _showDeleteDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Scan', style: AppTextStyles.displaySmall.copyWith(fontSize: 18)),
        content: Text('Remove this scan from history?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteScan();
            },
            child: Text('Delete', style: AppTextStyles.labelMedium.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}


