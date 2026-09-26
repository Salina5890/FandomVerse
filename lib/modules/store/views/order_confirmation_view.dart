import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderConfirmationView extends StatelessWidget {
  const OrderConfirmationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final orderId = args['orderId'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: FVIcon(PhosphorIconsRegular.checkCircle, color: AppColors.success, size: 80),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Order Placed!',
                style: AppTypography.headingXL.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Thank you for your purchase.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Order ID: $orderId',
                style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              FVButton(
                text: 'Continue Shopping',
                onPressed: () => Get.offAllNamed(AppRoutes.fanMain),
                variant: FVButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
