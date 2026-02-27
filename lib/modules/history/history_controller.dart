import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../app/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/scan_result_model.dart';
import '../../data/repositories/scan_repository.dart';

enum ScanFilter { all, url, email, phone, barcode, favorites }

class HistoryController extends GetxController {
  final _repo = Get.find<ScanRepository>();

  final allScans = <ScanResultModel>[].obs;
  final filteredScans = <ScanResultModel>[].obs;
  final searchQuery = ''.obs;
  final activeFilter = ScanFilter.all.obs;
  final isSelectionMode = false.obs;
  final selectedItems = <ScanResultModel>{}.obs;

  late final searchController = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();

    // Reactive filtering
    ever(searchQuery, (_) => _applyFilter());
    ever(activeFilter, (_) => _applyFilter());
  }

  @override
  void onResumed() {
    loadHistory();
  }

  void loadHistory() {
    allScans.assignAll(_repo.getAllScans());
    _applyFilter();
  }

  void _applyFilter() {
    List<ScanResultModel> result = List.from(allScans);

    // Apply type filter
    switch (activeFilter.value) {
      case ScanFilter.url:
        result = result.where((s) => s.type == ScanType.url).toList();
        break;
      case ScanFilter.email:
        result = result.where((s) => s.type == ScanType.email).toList();
        break;
      case ScanFilter.phone:
        result = result.where((s) => s.type == ScanType.phone).toList();
        break;
      case ScanFilter.barcode:
        result = result.where((s) => s.format != 'qrCode').toList();
        break;
      case ScanFilter.favorites:
        result = result.where((s) => s.isFavorite).toList();
        break;
      case ScanFilter.all:
        break;
    }

    // Apply search
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isNotEmpty) {
      result = result
          .where((s) => s.rawValue.toLowerCase().contains(q))
          .toList();
    }

    filteredScans.assignAll(result);
  }

  void setFilter(ScanFilter filter) {
    activeFilter.value = filter;
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
  }

  Future<void> deleteScan(ScanResultModel scan) async {
    await _repo.deleteScan(scan);
    loadHistory();
    _showUndoSnackbar(scan);
  }

  void _showUndoSnackbar(ScanResultModel deletedScan) {
    Get.snackbar(
      'Scan Deleted',
      deletedScan.rawValue.length > 40
          ? '${deletedScan.rawValue.substring(0, 40)}...'
          : deletedScan.rawValue,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () async {
          await _repo.saveScan(deletedScan);
          loadHistory();
          Get.closeCurrentSnackbar();
        },
        child: const Text('UNDO', style: TextStyle(color: AppColors.primary)),
      ),
    );
  }

  void copyToClipboard(ScanResultModel scan) {
    Clipboard.setData(ClipboardData(text: scan.rawValue));
    Fluttertoast.showToast(
      msg: 'Copied to clipboard!',
      backgroundColor: AppColors.surface,
      textColor: AppColors.textPrimary,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> toggleFavorite(ScanResultModel scan) async {
    await _repo.toggleFavorite(scan);
    loadHistory();
  }

  void openScanResult(ScanResultModel scan) {
    Get.toNamed(AppRoutes.result, arguments: scan);
  }

  // Multi-select
  void toggleSelectionMode() {
    isSelectionMode.toggle();
    if (!isSelectionMode.value) {
      selectedItems.clear();
    }
  }

  void toggleSelection(ScanResultModel scan) {
    if (selectedItems.contains(scan)) {
      selectedItems.remove(scan);
    } else {
      selectedItems.add(scan);
    }
    if (selectedItems.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  Future<void> deleteSelected() async {
    for (final scan in selectedItems) {
      await _repo.deleteScan(scan);
    }
    selectedItems.clear();
    isSelectionMode.value = false;
    loadHistory();
    Fluttertoast.showToast(
      msg: 'Scans deleted',
      backgroundColor: AppColors.surface,
      textColor: AppColors.textPrimary,
    );
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    loadHistory();
    Fluttertoast.showToast(
      msg: 'History cleared',
      backgroundColor: AppColors.surface,
      textColor: AppColors.textPrimary,
    );
  }
}
