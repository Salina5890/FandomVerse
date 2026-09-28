import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/my_fandoms_controller.dart';

class MyFandomsView extends GetView<MyFandomsController> {
  const MyFandomsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MyFandomsController>()) {
      Get.put(MyFandomsController());
    }
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('My Fandoms', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.8,
              ),
              itemCount: controller.allFandoms.length,
              itemBuilder: (context, index) {
                final fandom = controller.allFandoms[index];
                return Obx(() {
                  final isSelected = controller.selectedFandomIds.contains(fandom.id);
                  return GestureDetector(
                    onTap: () => controller.toggleFandom(fandom.id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                              child: FVImage(
                                imageUrl: fandom.bannerUrl,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Text(
                              fandom.name,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Obx(() => FVButton(
              text: 'Save Selection',
              onPressed: controller.saveFandoms,
              variant: FVButtonVariant.primary,
              isLoading: controller.isLoading.value,
            )),
          ),
        ],
      ),
    );
  }
}
