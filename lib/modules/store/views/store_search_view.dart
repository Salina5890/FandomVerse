import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/store_search_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StoreSearchView extends GetView<StoreSearchController> {
  const StoreSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: FVTextField(
          label: '',
          hint: 'Search products, fandoms...',
          controller: controller.searchController,
          prefixIcon: const FVIcon(PhosphorIconsRegular.magnifyingGlass),
        ),
      ),
      body: Obx(() {
        if (controller.searchResults.isEmpty) {
          return Center(
            child: Text('No products found', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
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
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final product = controller.searchResults[index];
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.productDetail.replaceFirst(':id', product.id)),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FVImage(
                      imageUrl: product.imageUrl ?? 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80',
                      width: double.infinity,
                      height: 140,
                      borderRadius: AppSpacing.sm,
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
                            product.fandomName ?? '',
                            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Text(
                                '\$${product.effectivePrice.toStringAsFixed(2)}',
                                style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                              ),
                              if (product.hasDiscount) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
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
        );
      }),
    );
  }
}
