import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/fandom_selection_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FandomSelectionView extends StatelessWidget {
  const FandomSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FandomSelectionController>() ? Get.find<FandomSelectionController>() : Get.put(FandomSelectionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Fandoms'),
        automaticallyImplyLeading: false, // Force them to complete onboarding
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'What are you into?',
                    style: AppTypography.displayMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Select at least one fandom to personalize your experience.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.8,
                ),
                itemCount: controller.fandoms.length,
                itemBuilder: (context, index) {
                  final fandom = controller.fandoms[index];
                  final isSelected = controller.selectedIds.contains(fandom.id);

                  return GestureDetector(
                    onTap: () => controller.toggleSelection(fandom.id),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: FVImage(imageUrl: fandom.coverImageUrl),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const FVIcon(PhosphorIconsRegular.check, size: 16, color: Colors.white),
                              ),
                            ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fandom.name,
                                  style: AppTypography.headingSmall.copyWith(color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  fandom.category,
                                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Obx(() => FVButton(
                text: 'Continue',
                onPressed: controller.selectedIds.isNotEmpty ? controller.saveAndContinue : null,
                isLoading: controller.isLoading.value,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
