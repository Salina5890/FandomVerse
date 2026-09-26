import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminCategoriesView extends StatelessWidget {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdminDashboardController>()
        ? Get.find<AdminDashboardController>()
        : Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Category Management'),
        leading: IconButton(
          icon: const FVIcon(PhosphorIconsRegular.caretLeft),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Get.offNamed(AppRoutes.adminDashboard);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        '${controller.categories.length} Categories',
                        style: AppTypography.headingSmall,
                      )),
                  FVButton(
                    text: 'Add New Category',
                    icon: const FVIcon(PhosphorIconsBold.plus, color: Colors.white, size: 16),
                    onPressed: () => _openCategoryForm(context, controller),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final cats = controller.categories;
                if (cats.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: cats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final cat = cats[i];
                    final catId = cat['id']?.toString() ?? '';
                    final catName = cat['name']?.toString() ?? 'Category';
                    final catDesc = cat['description']?.toString() ?? 'Fandom Universe category';

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.plum.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FVIcon(PhosphorIconsRegular.tag, color: AppColors.plum, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(catName, style: AppTypography.headingSmall),
                                const SizedBox(height: 2),
                                Text(
                                  catDesc,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: FVIcon(PhosphorIconsRegular.pencilSimple, size: 18, color: AppColors.primary),
                            tooltip: 'Edit Category',
                            onPressed: () => _openCategoryForm(context, controller, existing: cat),
                          ),
                          IconButton(
                            icon: FVIcon(PhosphorIconsRegular.trash, size: 18, color: AppColors.error),
                            tooltip: 'Delete Category',
                            onPressed: () => _confirmDeleteCategory(context, catId, catName, controller),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategoryForm(
    BuildContext context,
    AdminDashboardController controller, {
    Map<String, dynamic>? existing,
  }) {
    final nameCtrl = TextEditingController(text: existing?['name']?.toString() ?? '');
    final descCtrl = TextEditingController(text: existing?['description']?.toString() ?? '');
    final iconCtrl = TextEditingController(text: existing?['icon']?.toString() ?? 'tag');

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              existing == null ? 'Add New Category' : 'Edit Category',
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: 16),
            FVTextField(label: 'Category Name (e.g. Anime, Gaming, Comics)', controller: nameCtrl),
            const SizedBox(height: 12),
            FVTextField(label: 'Short Description', controller: descCtrl),
            const SizedBox(height: 12),
            FVTextField(label: 'Icon / Image identifier', controller: iconCtrl),
            const SizedBox(height: 20),
            FVButton(
              text: existing == null ? 'Save Category' : 'Update Category',
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) {
                  Get.snackbar('Required', 'Please enter a category name.');
                  return;
                }
                if (existing == null) {
                  controller.addCategory(
                    name: nameCtrl.text,
                    description: descCtrl.text,
                    icon: iconCtrl.text,
                  );
                } else {
                  controller.editCategory(
                    id: existing['id'].toString(),
                    name: nameCtrl.text,
                    description: descCtrl.text,
                    icon: iconCtrl.text,
                  );
                }
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _confirmDeleteCategory(
    BuildContext context,
    String id,
    String name,
    AdminDashboardController controller,
  ) {
    Get.defaultDialog(
      title: 'Delete Category',
      titleStyle: AppTypography.headingMedium,
      middleText: 'Are you sure you want to delete category "$name"?',
      middleTextStyle: AppTypography.bodyMedium,
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back();
        controller.deleteCategory(id);
      },
    );
  }
}
