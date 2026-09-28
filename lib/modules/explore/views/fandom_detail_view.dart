import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/fandom_detail_controller.dart';

class FandomDetailView extends StatelessWidget {
  const FandomDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final String fandomId = Get.parameters['id'] ?? '';
    final controller = Get.isRegistered<FandomDetailController>(tag: fandomId)
        ? Get.find<FandomDetailController>(tag: fandomId)
        : Get.put(FandomDetailController(fandomId), tag: fandomId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  FVImage(
                    imageUrl: controller.fandom.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: 0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.background,
                          Colors.transparent,
                          AppColors.background,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.fandom.name, style: AppTypography.displayMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: Text(controller.fandom.category, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text('${NumberFormat.compact().format(controller.fandom.memberCount)} Members', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Text(controller.fandom.description, style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.xl),
                  
                  if (controller.relatedContent.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Content', style: AppTypography.headingMedium),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.relatedContent.length,
                        itemBuilder: (context, index) {
                          final content = controller.relatedContent[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.contentDetail.replaceFirst(':id', content.id)),
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FVImage(
                                    imageUrl: content.thumbnailUrl ?? '',
                                    width: 140,
                                    height: 100,
                                    borderRadius: AppRadius.card,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(content.title, style: AppTypography.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  if (controller.relatedProducts.isNotEmpty) ...[
                    Text('Products', style: AppTypography.headingMedium),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.relatedProducts.length,
                        itemBuilder: (context, index) {
                          final product = controller.relatedProducts[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.productDetail.replaceFirst(':id', product.id)),
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FVImage(
                                    imageUrl: product.imageUrl ?? 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&q=80',
                                    width: 140,
                                    height: 140,
                                    borderRadius: AppRadius.card,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(product.name, style: AppTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text('\$${product.price.toStringAsFixed(2)}', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  if (controller.relatedEvents.isNotEmpty) ...[
                    Text('Events', style: AppTypography.headingMedium),
                    const SizedBox(height: AppSpacing.sm),
                    ...controller.relatedEvents.map((event) => Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                      child: Row(
                        children: [
                          FVImage(
                            imageUrl: event.imageUrl ?? '',
                            width: 60,
                            height: 60,
                            borderRadius: AppRadius.sm,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.title, style: AppTypography.bodyMedium),
                                Text(DateFormat.yMMMd().format(event.eventDate), style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
