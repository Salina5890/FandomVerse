import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final isReady = false.obs;
  final isExiting = false.obs;
  bool _navigating = false;

  @override
  void onInit() {
    super.onInit();
    _prepareSplash();
  }

  Future<void> _prepareSplash() async {
    // Give the entrance animation enough time to breathe. Navigation is
    // intentionally tap-driven so the splash never disappears unexpectedly.
    await Future.delayed(const Duration(milliseconds: 2800));
    isReady.value = true;
  }

  Future<void> continueToApp() async {
    if (!isReady.value || _navigating) return;
    _navigating = true;
    isExiting.value = true;

    await Future.delayed(const Duration(milliseconds: 650));

    if (_authService.isLoggedIn) {
      if (_authService.isAdmin) {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.fanMain);
      }
    } else {
      Get.offAllNamed(AppRoutes.userType);
    }
  }
}
