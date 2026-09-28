import 'package:get/get.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/storage/local_storage_service.dart';

class BadgeSelectionController extends GetxController {
  final RxList<BadgeModel> badges = <BadgeModel>[].obs;
  final RxSet<String> selectedIds = <String>{}.obs;
  final RxBool isLoading = false.obs;
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    badges.value = SeedDataService.badges;
    selectedIds.addAll(_authService.currentUser.value?.badgeIds ?? const []);
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      if (selectedIds.length < 3) {
        selectedIds.add(id);
      } else {
        Get.snackbar('Limit Reached', 'You can only select up to 3 badges for your profile.');
      }
    }
  }

  void skipAndContinue() {
    Get.offAllNamed(AppRoutes.fanMain);
  }

  void saveAndContinue() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    final user = _authService.currentUser.value;
    if (user != null) {
      final updated = user.copyWith(badgeIds: selectedIds.toList());
      final storage = Get.find<LocalStorageService>();
      await storage.saveUser(updated);
      _authService.currentUser.value = updated;
    }
    isLoading.value = false;
    
    Get.offAllNamed(AppRoutes.fanMain);
  }
}
