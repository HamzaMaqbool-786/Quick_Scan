import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../history_controller.dart';

class HistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HistoryController c;
  const HistoryAppBar({super.key, required this.c});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // ✅ One Obx — reads isSelectionMode & selectedItems.length both inside
    return Obx(() {
      final selMode = c.isSelectionMode.value;
      final selCount = c.selectedItems.length;
      return AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: selMode
            ? Text('$selCount selected',
            style: AppTextStyles.displaySmall.copyWith(fontSize: 18))
            : Text('History',
            style: AppTextStyles.displaySmall.copyWith(fontSize: 22)),
        actions: selMode
            ? [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.error),
            onPressed: () => _showDeleteSelectedDialog(selCount),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textMuted),
            onPressed: c.toggleSelectionMode,
          ),
        ]
            : [
          IconButton(
            icon: const Icon(Icons.checklist_rounded,
                color: AppColors.textMuted),
            onPressed: c.toggleSelectionMode,
            tooltip: 'Select',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined,
                color: AppColors.textMuted),
            onPressed: _showClearAllDialog,
            tooltip: 'Clear All',
          ),
          const SizedBox(width: 4),
        ],
      );
    });
  }

  void _showClearAllDialog() {
    Get.dialog(AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Clear History',
          style: AppTextStyles.displaySmall.copyWith(fontSize: 18)),
      content: Text('This will permanently delete all scan history.',
          style: AppTextStyles.bodyMedium),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text('Cancel',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            c.clearAll();
          },
          child: Text('Clear All',
              style:
              AppTextStyles.labelMedium.copyWith(color: AppColors.error)),
        ),
      ],
    ));
  }

  // ✅ count passed as plain int — no Obx needed inside dialog
  void _showDeleteSelectedDialog(int count) {
    Get.dialog(AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Delete Selected',
          style: AppTextStyles.displaySmall.copyWith(fontSize: 18)),
      content: Text('Delete $count selected scans?',
          style: AppTextStyles.bodyMedium),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text('Cancel',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            c.deleteSelected();
          },
          child: Text('Delete',
              style:
              AppTextStyles.labelMedium.copyWith(color: AppColors.error)),
        ),
      ],
    ));
  }
}
