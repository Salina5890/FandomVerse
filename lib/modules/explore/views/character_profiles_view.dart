import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/character_controller.dart';

class CharacterProfilesView extends GetView<CharacterController> {
  const CharacterProfilesView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CharacterController>()) {
      Get.put(CharacterController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Character Profiles', style: AppTypography.headingMedium),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.characters.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.base),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.75,
          ),
          itemCount: controller.characters.length,
          itemBuilder: (context, index) {
            final character = controller.characters[index];
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.characterDetail.replaceFirst(':id', character.id)),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: FVImage(
                        imageUrl: character.imageUrl ?? '',
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: AppRadius.card, // Only top corners ideally, but ok
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(character.name, style: AppTypography.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(character.fandomName ?? '', style: AppTypography.caption.copyWith(color: AppColors.primary)),
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
