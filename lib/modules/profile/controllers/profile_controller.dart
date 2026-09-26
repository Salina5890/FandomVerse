import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/seed_data_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<BadgeModel> userBadges = <BadgeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to user changes
    ever(_authService.currentUser, (UserModel? u) {
      user.value = u;
      _loadUserBadges();
    });
    
    user.value = _authService.currentUser.value;
    _loadUserBadges();
  }

  void _loadUserBadges() {
    if (user.value == null) {
      userBadges.clear();
      return;
    }
    
    final badgeIds = user.value!.badgeIds;
    final allBadges = SeedDataService.badges;
    userBadges.value = allBadges.where((b) => badgeIds.contains(b.id)).toList();
  }

  void logout() {
    _authService.logout();
  }
}
