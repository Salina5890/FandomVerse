import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_button.dart';
import '../controllers/fan_hub_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FanHubView extends GetView<FanHubController> {
  const FanHubView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FanHubController>()) {
      Get.put(FanHubController());
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Fan Hub', style: AppTypography.headingMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Featured Content', style: AppTypography.headingMedium),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 200,
              child: Obx(() => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.featuredContent.length,
                    itemBuilder: (context, index) {
                      final content = controller.featuredContent[index];
                      return GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.contentDetail.replaceFirst(':id', content.id)),
                        child: Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: AppSpacing.md),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              FVImage(
                                imageUrl: content.thumbnailUrl ?? '',
                                width: double.infinity,
                                height: double.infinity,
                                borderRadius: AppRadius.card,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.card),
                                  gradient: LinearGradient(
                                    colors: [Colors.black87, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: AppSpacing.sm,
                                left: AppSpacing.sm,
                                right: AppSpacing.sm,
                                child: Text(content.title, style: AppTypography.headingSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Glossary', style: AppTypography.headingMedium),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.glossary),
                  child: Text('See All', style: AppTypography.buttonMedium.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Obx(() => Column(
                  children: controller.teaserGlossary.map((term) => Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(term.term, style: AppTypography.bodyLarge),
                                Text(term.fandomName ?? '', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                            FVIcon(PhosphorIconsRegular.caretRight, color: AppColors.textSecondary),
                          ],
                        ),
                      )).toList(),
                )),
            
            const SizedBox(height: AppSpacing.xl),
            Text('Deep Dive', style: AppTypography.headingMedium),
            const SizedBox(height: AppSpacing.sm),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.5,
              children: [
                _buildDeepDiveTile('Hidden Trivia', PhosphorIconsRegular.lightbulb, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'trivia'))),
                _buildDeepDiveTile('Advanced Lore', PhosphorIconsRegular.bookOpen, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'lore'))),
                _buildDeepDiveTile('Behind the Scenes', PhosphorIconsRegular.filmSlate, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'behindScenes'))),
                _buildDeepDiveTile('Editorials', PhosphorIconsRegular.notePencil, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'editorial'))),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            
            FVButton(
              text: 'Character Profiles',
              onPressed: () => Get.toNamed(AppRoutes.characterProfiles),
              variant: FVButtonVariant.primary,
              icon: const FVIcon(PhosphorIconsRegular.userFocus),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepDiveTile(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FVIcon(icon, color: AppColors.cyan, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }
}
