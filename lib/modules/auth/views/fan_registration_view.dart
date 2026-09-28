import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_ai_floating_button.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_logo.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_animations.dart';
import '../controllers/auth_controller.dart';

class FanRegistrationView extends StatelessWidget {
  const FanRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : Get.put(AuthController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const FVIcon(PhosphorIconsRegular.caretLeft),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: const FVAiFloatingButton(heroTag: 'register_ai_fab'),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: FVLogo(width: 145)).fvPop(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Join the Verse',
                    style: AppTypography.displayMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Create an account to explore your favorite fandoms.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FVTextField(
                    label: 'Display Name',
                    hint: 'e.g. AnimeHunter99',
                    controller: controller.nameController,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateName,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 _'-]")),
                      LengthLimitingTextInputFormatter(30),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FVTextField(
                    label: 'Email',
                    hint: 'Enter your email address',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Obx(() => FVTextField(
                    label: 'Password',
                    hint: 'Create a password (min 6 characters)',
                    controller: controller.passwordController,
                    isPassword: controller.obscurePassword.value,
                    textInputAction: TextInputAction.done,
                    validator: controller.validatePassword,
                    onFieldSubmitted: (_) {
                      if (formKey.currentState?.validate() ?? false) {
                        controller.registerFan();
                      }
                    },
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
                    text: 'Register',
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        controller.registerFan();
                      }
                    },
                    isLoading: controller.isLoading.value,
                    variant: FVButtonVariant.primary,
                  )),
                  const SizedBox(height: AppSpacing.md),
                  Obx(() => Row(
                    children: [
                      Expanded(child: OutlinedButton.icon(
                        onPressed: controller.isLoading.value ? null : controller.loginWithGoogle,
                        icon: const FVIcon(Icons.g_mobiledata, size: 26),
                        label: const Text('Continue with Google'),
                      )),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: OutlinedButton.icon(
                        onPressed: controller.isLoading.value ? null : controller.loginWithApple,
                        icon: const FVIcon(Icons.apple, size: 22),
                        label: const Text('Continue with Apple'),
                      )),
                    ],
                  )),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'Login',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
