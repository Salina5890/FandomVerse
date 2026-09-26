import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_button.dart';
import '../controllers/wishlist_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Wishlist', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.wishlistProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FVIcon(PhosphorIconsRegular.heart, size: 80, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.md),
                Text('Your wishlist is empty', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: controller.wishlistProducts.length,
          itemBuilder: (context, index) {
            final product = controller.wishlistProducts[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      FVImage(
                        imageUrl: product.imageUrl ?? 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80',
                        width: double.infinity,
                        height: 140,
                        borderRadius: AppSpacing.sm,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const FVIcon(PhosphorIconsRegular.x, color: Colors.white, size: 20),
                          onPressed: () => controller.removeFromWishlist(product.id),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
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
                        FVButton(
                          text: 'Add to Cart',
                          onPressed: () => controller.addToCart(product),
                          variant: FVButtonVariant.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
