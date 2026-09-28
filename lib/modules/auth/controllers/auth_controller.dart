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
  final RxString adminErrorMessage = ''.obs;

  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  void togglePasswordVisibility() => obscurePassword.toggle();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (trimmed.length > 30) {
      return 'Name cannot exceed 30 characters';
    }
    // Disallow strings made purely of dots, symbols, or whitespace (e.g. "...", "---")
    if (RegExp(r'^[\W_]+$').hasMatch(trimmed)) {
      return 'Name cannot consist only of symbols or dots';
    }
    // Disallow disallowed characters (allow letters, numbers, spaces, and single hyphens/apostrophes)
    if (!RegExp(r"^[a-zA-Z0-9][a-zA-Z0-9 _'-]*$").hasMatch(trimmed)) {
      return 'Name can only contain letters, numbers, and spaces';
    }
    // Must contain at least two letters (not just digits)
    final letterCount = RegExp(r'[a-zA-Z]').allMatches(trimmed).length;
    if (letterCount < 2) {
      return 'Name must contain at least 2 letters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email (e.g. fan@verse.com)';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
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
    emailError.value = validateEmail(emailController.text) ?? '';
    passwordError.value = validatePassword(passwordController.text) ?? '';

    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      Get.snackbar(
        'Check Credentials',
        emailError.value.isNotEmpty ? emailError.value : passwordError.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final success = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (success) {
        Get.offAllNamed(AppRoutes.fanMain);
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerFan() async {
    nameError.value = validateName(nameController.text) ?? '';
    emailError.value = validateEmail(emailController.text) ?? '';
    passwordError.value = validatePassword(passwordController.text) ?? '';

    if (nameError.value.isNotEmpty || emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      final err = nameError.value.isNotEmpty
          ? nameError.value
          : emailError.value.isNotEmpty
              ? emailError.value
              : passwordError.value;
      Get.snackbar('Validation Notice', err, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final success = await _authService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (success) {
        Get.offAllNamed(AppRoutes.fandomSelection);
      } else {
        Get.snackbar('Error', 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Registration Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginAsAdmin() async {
    adminErrorMessage.value = '';
    emailError.value = validateEmail(emailController.text) ?? '';
    passwordError.value = validatePassword(passwordController.text) ?? '';

    if (emailError.value.isNotEmpty || passwordError.value.isNotEmpty) {
      adminErrorMessage.value = 'Please enter both valid admin email and password.';
      Get.snackbar('Check Fields', adminErrorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final success = await _authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (success && _authService.isAdmin) {
        adminErrorMessage.value = '';
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        adminErrorMessage.value = 'Invalid admin credentials. Please verify and try again.';
        Get.snackbar('Login Failed', adminErrorMessage.value, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      adminErrorMessage.value = 'Login error occurred.';
      Get.snackbar('Login Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
