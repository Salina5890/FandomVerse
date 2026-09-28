import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../controllers/checkout_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Checkout',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildOrderSummary(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Shipping Address',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FVTextField(
              label: 'Full Name',
              hint: 'John Doe',
              controller: controller.nameController,
            ),
            const SizedBox(height: AppSpacing.md),
            FVTextField(
              label: 'Address',
              hint: '123 Main St',
              controller: controller.addressController,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FVTextField(
                    label: 'City',
                    hint: 'New York',
                    controller: controller.cityController,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FVTextField(
                    label: 'Zip Code',
                    hint: '10001',
                    controller: controller.zipController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Payment Method',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _PaymentMethodCard(
                      title: 'Credit Card',
                      icon: PhosphorIconsRegular.creditCard,
                      isSelected:
                          controller.selectedPaymentMethod.value ==
                              'credit_card',
                      onTap: () => controller.selectedPaymentMethod.value =
                          'credit_card',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _PaymentMethodCard(
                      title: 'Digital Wallet',
                      icon: PhosphorIconsRegular.wallet,
                      isSelected:
                          controller.selectedPaymentMethod.value ==
                              'digital_wallet',
                      onTap: () => controller.selectedPaymentMethod.value =
                          'digital_wallet',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FVButton(
              text: 'Place Order',
              onPressed: controller.placeOrder,
              variant: FVButtonVariant.primary,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            ...controller.cartController.cartItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.cartItem.quantity}x ${item.product.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '\$${(item.product.effectivePrice * item.cartItem.quantity).toStringAsFixed(2)}',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: AppColors.borderSubtle),
            _summaryRow(
              'Shipping',
              '\$${controller.cartController.shipping.toStringAsFixed(2)}',
            ),
            const SizedBox(height: AppSpacing.sm),
            _summaryRow(
              'Total',
              '\$${controller.cartController.total.toStringAsFixed(2)}',
              total: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool total = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (total
                  ? AppTypography.headingSmall
                  : AppTypography.bodyMedium)
              .copyWith(color: AppColors.textPrimary),
        ),
        Text(
          value,
          style: (total
                  ? AppTypography.headingMedium
                  : AppTypography.labelLarge)
              .copyWith(color: total ? AppColors.primary : AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
          ),
        ),
        child: Column(
          children: [
            FVIcon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
