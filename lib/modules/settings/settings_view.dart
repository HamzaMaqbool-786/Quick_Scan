import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickscan/modules/settings/widgets/card_widget.dart';
import 'package:quickscan/modules/settings/widgets/divider.dart';
import 'package:quickscan/modules/settings/widgets/section_label.dart';
import 'package:quickscan/modules/settings/widgets/setting_tile.dart';
import 'settings_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
        title: Text('Settings', style: AppTextStyles.displaySmall.copyWith(fontSize: 22)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionLabel('SCANNING'),
            buildCard([
              Obx(() => SettingsTile(
                    icon: Icons.link_rounded,
                    iconColor: AppColors.primary,
                    title: 'Auto-open URLs',
                    subtitle: 'Automatically open scanned URLs in browser',
                    trailing: Switch(
                      value: controller.autoOpenUrl.value,
                      onChanged: controller.toggleAutoOpenUrl,
                    ),
                  )),
              divider(),
              Obx(() => SettingsTile(
                    icon: Icons.vibration_rounded,
                    iconColor: AppColors.success,
                    title: 'Vibration',
                    subtitle: 'Vibrate on successful scan',
                    trailing: Switch(
                      value: controller.vibrationEnabled.value,
                      onChanged: controller.toggleVibration,
                    ),
                  )),
            ]),
            const SizedBox(height: 24),
            buildSectionLabel('HISTORY'),
            buildCard([
              Obx(() => SettingsTile(
                    icon: Icons.save_outlined,
                    iconColor: AppColors.secondary,
                    title: 'Save Scan History',
                    subtitle: 'Store scanned codes locally',
                    trailing: Switch(
                      value: controller.saveHistory.value,
                      onChanged: controller.toggleSaveHistory,
                    ),
                  )),
              divider(),
              Obx(() => SettingsTile(
                    icon: Icons.storage_rounded,
                    iconColor: AppColors.warning,
                    title: 'History Limit',
                    subtitle: '${controller.historyLimit.value} scans max',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted),
                    onTap: controller.showHistoryLimitDialog,
                  )),
              divider(),
              Obx(() => SettingsTile(
                    icon: Icons.bar_chart_rounded,
                    iconColor: AppColors.primary,
                    title: 'Total Scans',
                    subtitle: '${controller.totalScans.value} codes scanned',
                  )),
            ]),
            const SizedBox(height: 24),
            buildSectionLabel('DATA'),
            buildCard([
              SettingsTile(
                icon: Icons.delete_sweep_outlined,
                iconColor: AppColors.error,
                title: 'Clear All History',
                subtitle: 'Permanently delete all scan records',
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textMuted),
                onTap: () => _showClearDialog(),
              ),
            ]),
            const SizedBox(height: 24),
            buildSectionLabel('ABOUT'),
            buildCard([
              const SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.textMuted,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              divider(),
              const SettingsTile(
                icon: Icons.code_rounded,
                iconColor: AppColors.textMuted,
                title: 'Built with',
                subtitle: 'Flutter · GetX · Hive · mobile_scanner',
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }




  void _showClearDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Clear History',
            style: AppTextStyles.displaySmall.copyWith(fontSize: 18)),
        content: Text('This will permanently delete all scan history.',
            style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearHistory();
            },
            child: Text('Clear',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

