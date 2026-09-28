import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../controllers/glossary_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class GlossaryView extends GetView<GlossaryController> {
  const GlossaryView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GlossaryController>()) {
      Get.put(GlossaryController());
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Fandom Glossary', style: AppTypography.headingMedium),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: FVTextField(
              label: '',
              hint: 'Search term, definition, or fandom...',
              controller: controller.searchController,
              prefixIcon: const FVIcon(PhosphorIconsRegular.magnifyingGlass),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredTerms.isEmpty) {
                return Center(
                  child: Text('No terms found.', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                );
              }

              // Group by fandom
              final Map<String, List> grouped = {};
              for (var term in controller.filteredTerms) {
                final fname = term.fandomName ?? 'General';
                grouped.putIfAbsent(fname, () => []).add(term);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.base),
                itemCount: grouped.keys.length,
                itemBuilder: (context, index) {
                  final fandomName = grouped.keys.elementAt(index);
                  final terms = grouped[fandomName]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Text(fandomName, style: AppTypography.headingSmall),
                      ),
                      ...terms.map((term) => GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.glossaryDetail.replaceFirst(':id', term.id)),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                              padding: const EdgeInsets.all(AppSpacing.base),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(AppRadius.card),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(term.term, style: AppTypography.bodyLarge),
                                        const SizedBox(height: 4),
                                        Text(
                                          term.definition,
                                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getDifficultyColor(term.difficulty).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(AppRadius.chip),
                                    ),
                                    child: Text(term.difficulty, style: AppTypography.caption.copyWith(color: _getDifficultyColor(term.difficulty))),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  );
                },
              );
            }),
          ),
        ],
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
