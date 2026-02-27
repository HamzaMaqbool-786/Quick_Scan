import 'package:get/get.dart';
import '../../data/models/scan_result_model.dart';
import '../../data/repositories/scan_repository.dart';
import '../../app/routes/app_routes.dart';

class HomeController extends GetxController {
  final _repo = Get.find<ScanRepository>();

  final recentScans = <ScanResultModel>[].obs;
  final totalScans = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecent();
  }

  @override
  void onResumed() {
    loadRecent();
  }

  void loadRecent() {
    final all = _repo.getAllScans();
    recentScans.assignAll(all.take(5).toList());
    totalScans.value = _repo.totalCount;
  }

  void goToScanner() => Get.toNamed(AppRoutes.scanner);
  void goToHistory() => Get.toNamed(AppRoutes.history);
  void goToSettings() => Get.toNamed(AppRoutes.settings);

  void openScanResult(ScanResultModel scan) {
    Get.toNamed(AppRoutes.result, arguments: scan);
  }
}
