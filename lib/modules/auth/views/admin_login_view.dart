import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_logo.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../controllers/auth_controller.dart';
import '../../../app/constants/app_constants.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/widgets/fv_animations.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : Get.put(AuthController());
    
    // Pre-fill for convenience
    controller.emailController.text = AppConstants.adminDemoEmail;
    controller.passwordController.text = AppConstants.adminDemoPassword;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Portal'),
        leading: IconButton(
          icon: const FVIcon(PhosphorIconsRegular.caretLeft),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: FVLogo(width: 96, showWordmark: false)).fvPop(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Admin Access',
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sign in to manage content and events.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              FVTextField(
                label: 'Admin Email',
                hint: AppConstants.adminDemoEmail,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              Obx(() => FVTextField(
                label: 'Password',
                hint: 'Enter your admin password',
                controller: controller.passwordController,
                isPassword: controller.obscurePassword.value,
                suffixIcon: IconButton(
                  icon: FVIcon(
                    controller.obscurePassword.value ? PhosphorIconsRegular.eyeSlash : PhosphorIconsRegular.eye,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),
              const SizedBox(height: AppSpacing.xl),
              Obx(() => FVButton(
                text: 'Login to Dashboard',
                onPressed: controller.loginAsAdmin,
                isLoading: controller.isLoading.value,
                variant: FVButtonVariant.secondary, // Cyan for admin
              )),
            ],
          ),
        ),
      ),
    );
  }
}
