import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/services/seed_data_service.dart';
import '../../../app/routes/app_routes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StoreCategoriesView extends StatelessWidget {
  const StoreCategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = SeedDataService.categories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Categories', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              // Navigate to search or a generic product list with category filter
              // Get.toNamed(AppRoutes.storeSearch, arguments: {'category': category.name});
            },
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FVIcon(PhosphorIconsRegular.squaresFour, color: AppColors.primary, size: 32),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    category.name,
                    style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
