import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../data/models/misc_models.dart';
import '../../../data/services/auth_service.dart';

class BadgesController extends GetxController {
  final List<BadgeModel> allBadges = SeedDataService.badges;
  final AuthService _auth = Get.find<AuthService>();
  
  bool isOwned(String badgeId) {
    return _auth.currentUser.value?.badgeIds.contains(badgeId) ?? false;
  }
}
