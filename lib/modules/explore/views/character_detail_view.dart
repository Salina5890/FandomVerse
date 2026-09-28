import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../controllers/character_controller.dart';

class CharacterDetailView extends StatelessWidget {
  const CharacterDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final String characterId = Get.parameters['id'] ?? '';
    final controller = Get.find<CharacterController>();
    final character = controller.getCharacter(characterId);

    if (character == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: Center(child: Text('Character not found', style: AppTypography.bodyLarge)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  FVImage(
                    imageUrl: character.imageUrl ?? '',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(character.name, style: AppTypography.displayMedium),
                            const SizedBox(height: AppSpacing.xs),
                            Text(character.fandomName ?? '', style: AppTypography.headingSmall.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                          border: Border.all(color: AppColors.accent),
                        ),
                        child: Text(character.role.toUpperCase(), style: AppTypography.labelSmall.copyWith(color: AppColors.accent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('About', style: AppTypography.headingMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(character.description, style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Traits', style: AppTypography.headingMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: character.traits.map((trait) => Chip(
                      label: Text(trait, style: AppTypography.chipLabel.copyWith(color: AppColors.textPrimary)),
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: AppColors.borderSubtle),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
                    )).toList(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
