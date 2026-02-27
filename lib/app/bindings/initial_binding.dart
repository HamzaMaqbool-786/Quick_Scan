import 'package:get/get.dart';
import '../../data/repositories/scan_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent global repository — shared across all modules
    Get.put<ScanRepository>(ScanRepository(), permanent: true);
  }
}
