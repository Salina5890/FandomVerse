import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../controllers/glossary_controller.dart';

class GlossaryDetailView extends StatelessWidget {
  const GlossaryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final String termId = Get.parameters['id'] ?? '';
    final controller = Get.find<GlossaryController>();
    final term = controller.getTerm(termId);

    if (term == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background),
        body: Center(child: Text('Term not found.', style: AppTypography.bodyLarge)),
      );
    }

    Color diffColor = _getDifficultyColor(term.difficulty);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(term.term, style: AppTypography.displayMedium),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: diffColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    border: Border.all(color: diffColor),
                  ),
                  child: Text(term.difficulty.toUpperCase(), style: AppTypography.caption.copyWith(color: diffColor)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (term.fandomName != null) ...[
              Text('Fandom: ${term.fandomName}', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
              const SizedBox(height: AppSpacing.xl),
            ],
            
            Text('Definition', style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Text(term.definition, style: AppTypography.bodyLarge),
            ),
            
            if (term.example != null) ...[
              const SizedBox(height: AppSpacing.xl),
              Text('Example usage', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text('"${term.example}"', style: AppTypography.bodyMedium.copyWith(fontStyle: FontStyle.italic)),
              ),
            ],

            if (term.relatedTerms.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              Text('Related Terms', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: term.relatedTerms.map((rt) => Chip(
                  label: Text(rt, style: AppTypography.chipLabel),
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String diff) {
    switch (diff) {
      case 'beginner': return AppColors.success;
      case 'intermediate': return AppColors.warning;
      case 'advanced': return AppColors.error;
      default: return AppColors.primary;
    }
  }
}
