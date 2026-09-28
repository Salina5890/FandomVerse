import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/models/content_model.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/deep_dive_controller.dart';

class DeepDiveCategoryView extends StatelessWidget {
  const DeepDiveCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final String typeStr = Get.parameters['type'] ?? 'lore';
    final controller = Get.isRegistered<DeepDiveController>() ? Get.find<DeepDiveController>() : Get.put(DeepDiveController());
    
    ContentType contentType;
    String title;
    RxList<ContentModel> items;

    switch (typeStr) {
      case 'trivia':
        contentType = ContentType.trivia;
        title = 'Hidden Trivia';
        items = controller.triviaContent;
        break;
      case 'behindScenes':
        contentType = ContentType.behindScenes;
        title = 'Behind the Scenes';
        items = controller.btsContent;
        break;
      case 'editorial':
        contentType = ContentType.editorial;
        title = 'Editorials';
        items = controller.editorialContent;
        break;
      case 'lore':
      default:
        contentType = ContentType.lore;
        title = 'Advanced Lore';
        items = controller.loreContent;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(title, style: AppTypography.headingMedium),
      ),
      body: Obx(() {
        if (items.isEmpty) {
          return Center(child: Text('No content found.', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.base),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final content = items[index];
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.contentDetail.replaceFirst(':id', content.id)),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FVImage(
                      imageUrl: content.thumbnailUrl ?? '',
                      width: double.infinity,
                      height: 180,
                      borderRadius: AppRadius.card, // Only top technically but it's okay
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(contentType.icon, style: TextStyle(color: AppColors.cyan, fontSize: 16)),
                              const SizedBox(width: AppSpacing.xs),
                              Text(contentType.label, style: AppTypography.labelSmall.copyWith(color: AppColors.cyan)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(content.title, style: AppTypography.headingSmall),
                          const SizedBox(height: AppSpacing.xs),
                          Text(content.description, style: AppTypography.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
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
