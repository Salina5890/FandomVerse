import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DeepDiveView extends StatelessWidget {
  const DeepDiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Deep Dive', style: AppTypography.headingMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explore deeper into your favorite universes.', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.2,
                children: [
                  _buildDeepDiveTile('Hidden Trivia', PhosphorIconsRegular.lightbulb, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'trivia'))),
                  _buildDeepDiveTile('Advanced Lore', PhosphorIconsRegular.bookOpen, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'lore'))),
                  _buildDeepDiveTile('Behind the Scenes', PhosphorIconsRegular.filmSlate, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'behindScenes'))),
                  _buildDeepDiveTile('Editorials', PhosphorIconsRegular.notePencil, () => Get.toNamed(AppRoutes.deepDiveCategory.replaceFirst(':type', 'editorial'))),
                ],
              ),
            ),
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
            FVIcon(icon, color: AppColors.cyan, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTypography.headingSmall),
          ],
        ),
      ),
    );
  }
}
