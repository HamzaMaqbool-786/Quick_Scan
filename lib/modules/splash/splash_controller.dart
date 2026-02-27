import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  void goToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}
