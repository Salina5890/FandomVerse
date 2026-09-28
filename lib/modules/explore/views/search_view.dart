import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/search_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchView extends GetView<FVSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FVSearchController>()) {
      Get.put(FVSearchController());
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Search Explore', style: AppTypography.headingMedium),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: FVTextField(
              label: '',
              hint: 'Search fandoms, content, tags...',
              controller: controller.searchController,
              prefixIcon: const FVIcon(PhosphorIconsRegular.magnifyingGlass),
            ),
          ),
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Row(
                  children: controller.categories.map((cat) {
                    final isSelected = controller.selectedCategory.value == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(cat, style: AppTypography.chipLabel.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary)),
                        selected: isSelected,
                        onSelected: (_) => controller.setCategory(cat),
                        backgroundColor: AppColors.surface,
                        selectedColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
                      ),
                    );
                  }).toList(),
                ),
              )),
          const SizedBox(height: AppSpacing.sm),
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: Row(children: [
              _filter(controller.contentTypes, controller.selectedContentType.value, controller.setContentType, 'Type'),
              _filter(controller.creators, controller.selectedCreator.value, controller.setCreator, 'Creator'),
              _filter(controller.tags, controller.selectedTag.value, controller.setTag, 'Tag'),
            ]),
          )),
          const SizedBox(height: AppSpacing.base),
          Expanded(
            child: Obx(() {
              if (controller.fandomResults.isEmpty && controller.contentResults.isEmpty) {
                return Center(
                  child: Text('No results found.', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.base),
                children: [
                  if (controller.fandomResults.isNotEmpty) ...[
                    Text('Fandoms', style: AppTypography.headingSmall),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.fandomResults.length,
                        itemBuilder: (context, index) {
                          final fandom = controller.fandomResults[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.fandomDetail.replaceFirst(':id', fandom.id)),
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: AppSpacing.sm),
                              child: Column(
                                children: [
                                  FVImage(
                                    imageUrl: fandom.imageUrl,
                                    width: 80,
                                    height: 80,
                                    isCircular: true,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    fandom.name,
                                    style: AppTypography.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (controller.contentResults.isNotEmpty) ...[
                    Text('Content', style: AppTypography.headingSmall),
                    const SizedBox(height: AppSpacing.sm),
                    ...controller.contentResults.map((content) => GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.contentDetail.replaceFirst(':id', content.id)),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(AppRadius.card),
                            ),
                            child: Row(
                              children: [
                                FVImage(
                                  imageUrl: content.thumbnailUrl ?? '',
                                  width: 80,
                                  height: 80,
                                  borderRadius: AppRadius.sm,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(content.title, style: AppTypography.bodyLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(content.fandomName ?? '', style: AppTypography.bodySmall.copyWith(color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
  Widget _filter(List<String> items, String value, ValueChanged<String> onChanged, String label) => Padding(
    padding: const EdgeInsets.only(right: AppSpacing.sm),
    child: PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (_) => items.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
      child: Chip(label: Text(value == 'All' ? label : value)),
    ),
  );

}
