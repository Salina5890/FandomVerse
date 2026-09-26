import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_logo.dart';
import '../../../core/widgets/fv_text_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/widgets/fv_animations.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: FVLogo(width: 108, showWordmark: false)).fvPop(),
            const SizedBox(height: AppSpacing.lg),
            Text('Forgot Password', style: AppTypography.displayMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Enter your email and we\'ll send you a link to reset your password.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FVTextField(
              label: 'Email',
              hint: 'your@email.com',
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: FVIcon(PhosphorIconsRegular.envelopeSimple, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            FVButton(
              text: 'Send Reset Link',
              onPressed: () {
                if (emailCtrl.text.isNotEmpty) {
                  Get.snackbar(
                    'Reset Request Saved',
                    'No email backend is configured in this build. The reset request was recorded locally for implementation testing.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.surface,
                    colorText: AppColors.textPrimary,
                  );
                  Future.delayed(const Duration(seconds: 2), () => Get.back());
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Back to Login',
                  style: AppTypography.buttonSmall.copyWith(
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
