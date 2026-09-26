import 'package:get/get.dart';
import '../../../data/models/fandom_model.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';

class FandomSelectionController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final RxList<FandomModel> fandoms = <FandomModel>[].obs;
  final RxSet<String> selectedIds = <String>{}.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFandoms();
  }

  void _loadFandoms() {
    fandoms.value = SeedDataService.fandoms;
    if (_authService.currentUser.value != null) {
      selectedIds.addAll(_authService.currentUser.value!.selectedFandomIds);
    }
  }

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  Future<void> saveAndContinue() async {
    if (selectedIds.isEmpty) {
      Get.snackbar('Selection Required', 'Please select at least one fandom to continue.');
      return;
    }
    
    isLoading.value = true;
    await _authService.updateFandoms(selectedIds.toList());
    isLoading.value = false;
    
    Get.toNamed(AppRoutes.badgeSelection);
  }
}
