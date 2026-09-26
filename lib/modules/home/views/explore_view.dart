import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../controllers/explore_controller.dart';
import '../../../data/models/content_model.dart';
import '../../../data/services/seed_data_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ExploreController>() ? Get.find<ExploreController>() : Get.put(ExploreController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.search),
              child: AbsorbPointer(
                child: FVTextField(
                  label: '',
                  hint: 'Search fandoms, characters, lore...',
                  prefixIcon: FVIcon(PhosphorIconsRegular.magnifyingGlass, color: AppColors.textSecondary),
                ),
              ),
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
              _buildTrendingFandoms(),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionTitle('Beginner Fan Hub', 'Perfect for newcomers'),
              _buildHorizontalContentList(controller.beginnerHub),
              
              const SizedBox(height: AppSpacing.xl),
              
              _buildSectionTitle('Deep Dives', 'Lore, trivia & behind the scenes'),
              _buildHorizontalContentList(controller.deepDives),
              
              const SizedBox(height: AppSpacing.xl),
              
              _buildSectionTitle('Latest News', 'Stay updated'),
              _buildVerticalContentList(controller.latestNews),
              
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTrendingFandoms() {
    final fandoms = SeedDataService.fandoms.where((f) => f.isFeatured).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding), child: Text('Trending Fandoms', style: AppTypography.headingMedium)),
      const SizedBox(height: AppSpacing.sm),
      SizedBox(height: 190, child: PageView.builder(
        controller: PageController(viewportFraction: .82),
        itemCount: fandoms.length,
        itemBuilder: (_, index) {
          final fandom = fandoms[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.fandomDetail.replaceFirst(':id', fandom.id)),
              child: Stack(fit: StackFit.expand, children: [
                FVImage(imageUrl: fandom.coverImageUrl, borderRadius: 18),
                DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AppColors.background.withValues(alpha: .88)]))),
                Positioned(left: 16, right: 16, bottom: 14, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(fandom.name, style: AppTypography.headingSmall),
                  Text('${fandom.category} • ${fandom.memberCount.toString()} fans', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ])),
              ]),
            ),
          );
        },
      )),
    ]);
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.headingMedium),
              Text('See All', style: AppTypography.buttonSmall.copyWith(color: AppColors.accent)),
            ],
          ),
          Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildHorizontalContentList(List<ContentModel> items) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final content = items[index];
          return SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FVImage(
                    imageUrl: content.imageUrl ?? 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=400&q=80',
                    width: 160,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(content.contentType.icon, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        content.fandomName ?? '',
                        style: AppTypography.caption.copyWith(color: AppColors.primaryLight),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  content.title,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalContentList(List<ContentModel> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final content = items[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              if (content.imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: FVImage(
                    imageUrl: content.imageUrl!,
                    width: 100,
                    height: 100,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: AppTypography.headingSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${content.readTimeMinutes} min read',
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
