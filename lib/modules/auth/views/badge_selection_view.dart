import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../controllers/badge_selection_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BadgeSelectionView extends StatelessWidget {
  const BadgeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BadgeSelectionController>() ? Get.find<BadgeSelectionController>() : Get.put(BadgeSelectionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fan Identity'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: controller.skipAndContinue,
            child: const Text('Skip'),
          ),
        ],
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
                    'Choose your Badges',
                    style: AppTypography.displayMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Select up to 3 badges to display on your profile. These represent your fandom expertise.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
                itemCount: controller.badges.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final badge = controller.badges[index];
                  final isSelected = controller.selectedIds.contains(badge.id);

                  return GestureDetector(
                    onTap: () => controller.toggleSelection(badge.id),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.accent : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(badge.iconEmoji, style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(badge.name, style: AppTypography.headingSmall),
                                const SizedBox(height: 4),
                                Text(
                                  badge.description,
                                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            FVIcon(PhosphorIconsRegular.checkCircle, color: AppColors.accent),
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
                text: 'Finish Setup',
                onPressed: controller.saveAndContinue,
                isLoading: controller.isLoading.value,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
