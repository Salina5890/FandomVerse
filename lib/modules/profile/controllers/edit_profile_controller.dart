import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/storage/local_storage_service.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  final isLoading = false.obs;
  final isChangingPassword = false.obs;
  final isDeleting = false.obs;

  String get avatarUrl =>
      _authService.currentUser.value?.avatarUrl ??
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80';

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      bioController.text = user.bio ?? '';
    }
  }

  Future<void> saveProfile() async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    final updatedUser = user.copyWith(
      name: nameController.text,
      bio: bioController.text,
    );
    
    await _storageService.saveUser(updatedUser);
    _authService.currentUser.value = updatedUser;
    
    isLoading.value = false;
    Get.back();
    Get.snackbar('Success', 'Profile updated successfully', snackPosition: SnackPosition.BOTTOM);
  }

  Future<bool> changePassword(String current, String next) async {
    isChangingPassword.value = true;
    final ok = await _authService.changePassword(current, next);
    isChangingPassword.value = false;
    if (ok) {
      Get.snackbar('Success', 'Password updated', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Could not update password', 'Check both fields and try again',
          snackPosition: SnackPosition.BOTTOM);
    }
    return ok;
  }

  Future<void> deleteAccount() async {
    isDeleting.value = true;
    await _authService.deleteAccount();
    isDeleting.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
