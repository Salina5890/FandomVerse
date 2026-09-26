import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../controllers/store_controller.dart';
import '../../../data/models/product_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<StoreController>() ? Get.find<StoreController>() : Get.put(StoreController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          IconButton(
            icon: const FVIcon(PhosphorIconsRegular.shoppingCart),
            onPressed: () => Get.toNamed(AppRoutes.cart),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: FVTextField(
              label: '',
              hint: 'Search merchandise...',
              prefixIcon: FVIcon(PhosphorIconsRegular.magnifyingGlass, color: AppColors.textSecondary),
              onChanged: controller.setQuery,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoriesList(controller),
              const SizedBox(height: AppSpacing.lg),
              
              _buildSectionTitle('Featured Merch'),
              _buildHorizontalProductsList(controller, controller.featuredProducts),
              
              const SizedBox(height: AppSpacing.xl),
              
              _buildSectionTitle('All Products'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                child: Align(alignment: Alignment.centerRight, child: PopupMenuButton<ProductSort>(
                  onSelected: controller.setSort,
                  child: const Chip(label: Text('Sort')),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: ProductSort.featured, child: Text('Featured')),
                    PopupMenuItem(value: ProductSort.priceLowHigh, child: Text('Price: Low → High')),
                    PopupMenuItem(value: ProductSort.priceHighLow, child: Text('Price: High → Low')),
                    PopupMenuItem(value: ProductSort.newest, child: Text('Newest')),
                  ],
                )),
              ),
              _buildVerticalProductsGrid(controller, controller.filteredProducts),
              
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.headingMedium),
          Text('See All', style: AppTypography.buttonSmall.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(StoreController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Row(children: controller.categoryNames.map((name) {
        final selected = controller.selectedCategory.value == name;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: ChoiceChip(
            label: Text(name),
            selected: selected,
            onSelected: (_) => controller.setCategory(name),
          ),
        );
      }).toList()),
    );
  }

  Widget _buildHorizontalProductsList(StoreController controller, List<ProductModel> products) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.productDetail.replaceFirst(':id', product.id))
                  ?.then((_) => controller.refreshWishlistState()),
              child: _buildProductCard(controller, product),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalProductsGrid(StoreController controller, List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.productDetail.replaceFirst(':id', product.id))
              ?.then((_) => controller.refreshWishlistState()),
          child: _buildProductCard(controller, product),
        );
      },
    );
  }

  Widget _buildProductCard(StoreController controller, ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FVImage(
              imageUrl: product.imageUrl ?? '',
              width: double.infinity,
              borderRadius: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.fandomName ?? '',
                  style: AppTypography.caption.copyWith(color: AppColors.primaryLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTypography.headingSmall.copyWith(color: AppColors.accent),
                    ),
                    Obx(() {
                      final isSaved = controller.isWishlisted(product.id);
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.toggleWishlist(product),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: FVIcon(
                            isSaved ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
                            size: 20,
                            color: isSaved ? AppColors.accent : AppColors.textSecondary,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
