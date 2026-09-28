import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_button.dart';
import '../controllers/cart_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Cart', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FVIcon(PhosphorIconsRegular.shoppingBag, size: 80, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.md),
                Text('Your cart is empty', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.sm),
                Text('Looks like you haven\'t added anything yet.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.lg),
                FVButton(
                  text: 'Start Shopping',
                  onPressed: () => Get.offAllNamed(AppRoutes.fanMain),
                  variant: FVButtonVariant.primary,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final itemDetail = controller.cartItems[index];
                  final product = itemDetail.product;
                  final cartItem = itemDetail.cartItem;

                  return Dismissible(
                    key: Key(cartItem.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                      child: const FVIcon(PhosphorIconsRegular.trash, color: Colors.white),
                    ),
                    onDismissed: (_) => controller.removeItem(cartItem.id),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          FVImage(
                            imageUrl: product.imageUrl ?? 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80',
                            width: 80,
                            height: 80,
                            borderRadius: AppSpacing.sm,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '\$${product.effectivePrice.toStringAsFixed(2)}',
                                  style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    _buildQuantityBtn(PhosphorIconsRegular.minus, () => controller.updateQuantity(cartItem.id, cartItem.quantity - 1)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                                      child: Text(
                                        '${cartItem.quantity}',
                                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                                      ),
                                    ),
                                    _buildQuantityBtn(PhosphorIconsRegular.plus, () => controller.updateQuantity(cartItem.id, cartItem.quantity + 1)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        Text('\$${controller.subtotal.toStringAsFixed(2)}', style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        Text('\$${controller.shipping.toStringAsFixed(2)}', style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                    Divider(color: AppColors.borderSubtle, height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
                        Text('\$${controller.total.toStringAsFixed(2)}', style: AppTypography.headingLarge.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FVButton(
                      text: 'Proceed to Checkout',
                      onPressed: () => Get.toNamed(AppRoutes.checkout),
                      variant: FVButtonVariant.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuantityBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: FVIcon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}
