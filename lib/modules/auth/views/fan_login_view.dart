import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/routes/app_routes.dart';
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

class FanLoginView extends StatelessWidget {
  const FanLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : Get.put(AuthController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fan Login'),
        leading: IconButton(
          icon: const FVIcon(PhosphorIconsRegular.caretLeft),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: const FVAiFloatingButton(heroTag: 'login_ai_fab'),
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
                    'Welcome back, Fan',
                    style: AppTypography.displayMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Enter your details to dive back into the verse.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FVTextField(
                    label: 'Email',
                    hint: 'demo@fandomverse.app',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Obx(() => FVTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: controller.passwordController,
                    isPassword: controller.obscurePassword.value,
                    textInputAction: TextInputAction.done,
                    validator: controller.validatePassword,
                    onFieldSubmitted: (_) {
                      if (formKey.currentState?.validate() ?? false) {
                        controller.loginAsFan();
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
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.buttonSmall.copyWith(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Obx(() => FVButton(
                    text: 'Login',
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        controller.loginAsFan();
                      }
                    },
                    isLoading: controller.isLoading.value,
                    variant: FVButtonVariant.primary,
                  )),
                  const SizedBox(height: AppSpacing.md),
                  Row(
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
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New to Fandom Verse? ',
                        style: AppTypography.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.fanRegister),
                        child: Text(
                          'Register',
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
