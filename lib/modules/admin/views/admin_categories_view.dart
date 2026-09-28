import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../theme/admin_theme.dart';

class AdminCategoriesView extends StatelessWidget {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdminDashboardController>()
        ? Get.find<AdminDashboardController>()
        : Get.put(AdminDashboardController());

    return HoloScaffold(
      title: 'CATEGORIES',
      leading: IconButton(
        icon: Icon(
          PhosphorIconsRegular.caretLeft,
          color: AdminTheme.textPrimary,
        ),
        onPressed: () => Navigator.of(context).canPop()
            ? Navigator.of(context).pop()
            : Get.offNamed(AppRoutes.adminDashboard),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    '${controller.categories.length} CATEGORIES',
                    style: AdminTheme.mono(
                      size: 12,
                      color: AdminTheme.textFaint,
                      w: FontWeight.w700,
                    ),
                  ),
                ),
                HoloIconAction(
                  icon: PhosphorIconsBold.plus,
                  color: AdminTheme.cyan,
                  tooltip: 'Add Category',
                  onPressed: () => _openCategoryForm(context, controller),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final cats = controller.categories;

              if (cats.isEmpty) {
                return Center(
                  child: Text('No categories yet.', style: AdminTheme.mono()),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final cat = cats[i];

                  final catId = cat['id']?.toString() ?? '';

                  final catName = cat['name']?.toString() ?? 'Category';

                  final catDesc =
                      cat['description']?.toString() ??
                      'Fandom Universe category';

                  return HoloPanel(
                    glowColor: AdminTheme.amber,
                    child: Row(
                      children: [
                        HoloIconBox(
                          icon: PhosphorIconsRegular.tag,
                          color: AdminTheme.amber,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                catName,
                                style: AdminTheme.body(w: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                catDesc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AdminTheme.mono(size: 11),
                              ),
                            ],
                          ),
                        ),
                        HoloIconAction(
                          icon: PhosphorIconsRegular.pencilSimple,
                          color: AdminTheme.amber,
                          tooltip: 'Edit',
                          onPressed: () => _openCategoryForm(
                            context,
                            controller,
                            existing: cat,
                          ),
                        ),
                        const SizedBox(width: 6),
                        HoloIconAction(
                          icon: PhosphorIconsRegular.trash,
                          color: AdminTheme.red,
                          tooltip: 'Delete',
                          onPressed: () => showHoloConfirm(
                            title: 'Delete Category',
                            message: 'Delete "$catName"?',
                            confirmLabel: 'Delete',
                            onConfirm: () => controller.deleteCategory(catId),
                          ),
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
    );
  }

  void _openCategoryForm(
    BuildContext context,
    AdminDashboardController controller, {
    Map<String, dynamic>? existing,
  }) {
    final nameCtrl = TextEditingController(
      text: existing?['name']?.toString() ?? '',
    );

    final descCtrl = TextEditingController(
      text: existing?['description']?.toString() ?? '',
    );

    final iconCtrl = TextEditingController(
      text: existing?['icon']?.toString() ?? 'tag',
    );

    showHoloSheet(
      context: context,
      title: existing == null ? 'Add New Category' : 'Edit Category',
      children: [
        HoloTextField(label: 'Category Name', controller: nameCtrl),
        const SizedBox(height: 12),
        HoloTextField(label: 'Short Description', controller: descCtrl),
        const SizedBox(height: 12),
        HoloTextField(label: 'Icon Identifier', controller: iconCtrl),
        const SizedBox(height: 20),
        HoloButton(
          label: existing == null ? 'Save Category' : 'Update Category',
          icon: PhosphorIconsBold.checkCircle,
          onPressed: () {
            if (nameCtrl.text.trim().isEmpty) {
              Get.snackbar('Required', 'Enter a category name.');
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
    );
  }
}
