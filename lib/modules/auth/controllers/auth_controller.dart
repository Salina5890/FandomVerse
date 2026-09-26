import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  void togglePasswordVisibility() => obscurePassword.toggle();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await _authService.loginWithGoogle();
      if (user == null) return;
      final firstTime = user.selectedFandomIds.isEmpty && user.badgeIds.isEmpty;
      Get.offAllNamed(firstTime ? AppRoutes.fandomSelection : AppRoutes.fanMain);
    } catch (e) {
      Get.snackbar('Google Sign-In', 'Sign-in could not be completed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    isLoading.value = true;
    try {
      final user = await _authService.loginWithApple();
      if (user == null) return;
      final firstTime = user.selectedFandomIds.isEmpty && user.badgeIds.isEmpty;
      Get.offAllNamed(firstTime ? AppRoutes.fandomSelection : AppRoutes.fanMain);
    } catch (e) {
      Get.snackbar('Apple Sign-In', 'Sign-in could not be completed. Check Apple configuration and try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginAsFan() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    isLoading.value = true;
    final success = await _authService.login(emailController.text, passwordController.text);
    isLoading.value = false;

    if (success) {
      Get.offAllNamed(AppRoutes.fanMain);
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  Future<void> registerFan() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    isLoading.value = true;
    final success = await _authService.register(nameController.text, emailController.text, passwordController.text);
    isLoading.value = false;

    if (success) {
      Get.offAllNamed(AppRoutes.fandomSelection);
    } else {
      Get.snackbar('Error', 'Registration failed');
    }
  }

  Future<void> loginAsAdmin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    isLoading.value = true;
    final success = await _authService.login(emailController.text, passwordController.text);
    isLoading.value = false;

    if (success && _authService.isAdmin) {
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else {
      Get.snackbar('Error', 'Invalid credentials or not an admin');
    }
  }
}
