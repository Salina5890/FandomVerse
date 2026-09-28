import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_button.dart';
import '../controllers/product_detail_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() => IconButton(
            icon: FVIcon(
              controller.isInWishlist.value ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
              color: controller.isInWishlist.value ? AppColors.accent : Colors.white,
            ),
            onPressed: controller.toggleWishlist,
          )),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FVImage(
                imageUrl: product.imageUrl ?? 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80',
                width: double.infinity,
                height: 400,
                borderRadius: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTypography.headingLarge.copyWith(color: AppColors.textPrimary),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: product.stockQuantity > 0 ? AppColors.success.withValues(alpha: 0.2) : AppColors.error.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppSpacing.sm),
                            border: Border.all(
                              color: product.stockQuantity > 0 ? AppColors.success : AppColors.error,
                            ),
                          ),
                          child: Text(
                            product.stockQuantity > 0 ? 'In Stock' : 'Out of Stock',
                            style: AppTypography.labelSmall.copyWith(
                              color: product.stockQuantity > 0 ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${product.fandomName} • ${product.category}',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        if (product.hasDiscount) ...[
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTypography.headingMedium.copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          '\$${product.effectivePrice.toStringAsFixed(2)}',
                          style: AppTypography.headingLarge.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      product.description,
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Quantity', style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(AppRadius.button),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const FVIcon(PhosphorIconsRegular.minus),
                                onPressed: controller.decrementQuantity,
                              ),
                              Obx(() => SizedBox(
                                width: 32,
                                child: Text(
                                  '${controller.quantity.value}',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                                ),
                              )),
                              IconButton(
                                icon: const FVIcon(PhosphorIconsRegular.plus),
                                onPressed: controller.incrementQuantity,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        if (product.stockQuantity > 0)
                          Text(
                            '${product.stockQuantity} available',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: product.tags.map((tag) => Chip(
                        label: Text(tag, style: AppTypography.chipLabel.copyWith(color: AppColors.textPrimary)),
                        backgroundColor: AppColors.surface,
                        side: BorderSide(color: AppColors.border),
                      )).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: AppShadows.cardShadow,
        ),
        child: SafeArea(
          child: Obx(() {
            final product = controller.product.value;
            final isOutOfStock = product != null && product.stockQuantity <= 0;
            final qty = controller.quantity.value;
            return FVButton(
              text: isOutOfStock ? 'Out of Stock' : 'Add to Cart${qty > 1 ? ' ($qty)' : ''}',
              onPressed: isOutOfStock ? () {} : controller.addToCart,
              variant: isOutOfStock ? FVButtonVariant.outline : FVButtonVariant.primary,
            );
          }),
        ),
      ),
    );
  }
}
