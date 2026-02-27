import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/scan_repository.dart';

class SettingsController extends GetxController {
  final _repo = Get.find<ScanRepository>();
  final _storage = GetStorage();

  final autoOpenUrl = false.obs;
  final vibrationEnabled = true.obs;
  final saveHistory = true.obs;
  final historyLimit = 100.obs;

  final totalScans = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    totalScans.value = _repo.totalCount;
  }

  void _loadSettings() {
    autoOpenUrl.value = _storage.read(AppConstants.keyAutoOpenUrl) ?? AppConstants.defaultAutoOpenUrl;
    vibrationEnabled.value = _storage.read(AppConstants.keyVibrationEnabled) ?? AppConstants.defaultVibrationEnabled;
    saveHistory.value = _storage.read(AppConstants.keySaveHistory) ?? AppConstants.defaultSaveHistory;
    historyLimit.value = _storage.read(AppConstants.keyHistoryLimit) ?? AppConstants.defaultHistoryLimit;
  }

  void toggleAutoOpenUrl(bool val) {
    autoOpenUrl.value = val;
    _storage.write(AppConstants.keyAutoOpenUrl, val);
  }

  void toggleVibration(bool val) {
    vibrationEnabled.value = val;
    _storage.write(AppConstants.keyVibrationEnabled, val);
  }

  void toggleSaveHistory(bool val) {
    saveHistory.value = val;
    _storage.write(AppConstants.keySaveHistory, val);
  }

  void setHistoryLimit(int limit) {
    historyLimit.value = limit;
    _storage.write(AppConstants.keyHistoryLimit, limit);
    Get.back();
    Fluttertoast.showToast(
      msg: 'History limit set to $limit',
      backgroundColor: AppColors.surface,
      textColor: AppColors.textPrimary,
    );
  }

  void showHistoryLimitDialog() {
    final limits = [50, 100, 500, 1000];
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF111827),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('History Limit',
                style: TextStyle(
                    color: Color(0xFFE8EBF5),
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...limits.map((l) => ListTile(
                  title: Text('$l scans',
                      style: const TextStyle(color: Color(0xFFE8EBF5))),
                  trailing: Obx(() => historyLimit.value == l
                      ? const Icon(Icons.check_rounded, color: Color(0xFF00E5FF))
                      : const SizedBox()),
                  onTap: () => setHistoryLimit(l),
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> clearHistory() async {
    await _repo.clearAll();
    totalScans.value = 0;
    Fluttertoast.showToast(
      msg: 'History cleared',
      backgroundColor: AppColors.surface,
      textColor: AppColors.textPrimary,
    );
  }
}

// Simple GetStorage mock (use get_storage package in real app)
class GetStorage {
  static final Map<String, dynamic> _data = {};
  T? read<T>(String key) => _data[key] as T?;
  Future<void> write(String key, dynamic value) async => _data[key] = value;
}
