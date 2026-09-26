import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/models/fandom_model.dart';

class MyFandomsController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final RxList<String> selectedFandomIds = <String>[].obs;
  final isLoading = false.obs;
  
  late final List<FandomModel> allFandoms;
  
  @override
  void onInit() {
    super.onInit();
    allFandoms = SeedDataService.fandoms;
    final user = _auth.currentUser.value;
    if (user != null) {
      selectedFandomIds.addAll(user.selectedFandomIds);
    }
  }
  
  void toggleFandom(String id) {
    if (selectedFandomIds.contains(id)) {
      selectedFandomIds.remove(id);
    } else {
      selectedFandomIds.add(id);
    }
  }
  
  void saveFandoms() async {
    isLoading.value = true;
    try {
      await _auth.updateFandoms(selectedFandomIds.toList());
      Get.back();
      Get.snackbar('Success', 'Fandoms updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update fandoms');
    } finally {
      isLoading.value = false;
    }
  }
}
