import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_animations.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_theme_toggle.dart';
import '../controllers/admin_dashboard_controller.dart';

/// Admin area — mockup screens 26–31: Dashboard, User Management,
/// Content Management, Merchandise Management, Category Management.
class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  static const _titles = [
    'Admin Dashboard',
    'User Management',
    'Content Management',
    'Event Management',
    'Merchandise Management',
    'Category Management',
  ];
  static const _addLabels = ['', 'Add User', 'Add Content', 'Add Event', 'Add Product', 'Add Category'];

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<AdminDashboardController>() ? Get.find<AdminDashboardController>() : Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: AppColors.background,
      // Only the title reads an observable, so only it sits inside an Obx.
      appBar: AppBar(
        title: Obx(() => Text(_titles[c.selectedMenuIndex.value], style: AppTypography.headingMedium)),
        actions: [
          const Padding(padding: EdgeInsets.only(right: 4), child: FVThemeToggle()),
          IconButton(icon: const FVIcon(PhosphorIconsRegular.signOut), onPressed: c.logout),
        ],
      ),
      body: Obx(() {
        final i = c.selectedMenuIndex.value; // observable read inside Obx
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          child: KeyedSubtree(
            key: ValueKey(i),
            child: i == 0 ? _Overview(c) : _ManageList(c, i, _addLabels[i]),
          ),
        );
      }),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: c.selectedMenuIndex.value,
            onDestinationSelected: c.changeMenu,
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary.withOpacity(.16),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(icon: FVIcon(PhosphorIconsRegular.squaresFour), label: 'Home'),
              NavigationDestination(icon: FVIcon(PhosphorIconsRegular.users), label: 'Users'),
              NavigationDestination(icon: FVIcon(PhosphorIconsRegular.article), label: 'Content'),
              NavigationDestination(icon: FVIcon(PhosphorIconsRegular.calendarBlank), label: 'Events'),
              NavigationDestination(icon: FVIcon(PhosphorIconsRegular.storefront), label: 'Products'),
              NavigationDestination(icon: FVIcon(PhosphorIconsRegular.tag), label: 'Categories'),
            ],
          )),
    );
  }
}

class _Overview extends StatelessWidget {
  final AdminDashboardController c;
  const _Overview(this.c);

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            Row(children: [
              Expanded(child: _Stat('Users', '${c.users.length}', PhosphorIconsRegular.users, AppColors.primary).fvIn(0)),
              const SizedBox(width: 12),
              Expanded(child: _Stat('Content', '${c.content.length}', PhosphorIconsRegular.article, AppColors.rose).fvIn(1)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _Stat('Events', '${c.events.length}', PhosphorIconsRegular.calendarBlank, AppColors.cyan).fvIn(2)),
              const SizedBox(width: 12),
              Expanded(child: _Stat('Products', '${c.products.length}', PhosphorIconsRegular.storefront, AppColors.accent).fvIn(3)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _Stat('Categories', '${c.categories.length}', PhosphorIconsRegular.tag, AppColors.plum).fvIn(4)),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ]),
            const SizedBox(height: 24),
            Text('Recent Activity', style: AppTypography.headingMedium),
            const SizedBox(height: 12),
            ...List.generate(
              c.activity.length.clamp(0, 8),
              (i) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  FVIcon(PhosphorIconsRegular.lightning, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(c.activity[i], style: AppTypography.bodyMedium)),
                ]),
              ).fvIn(i + 5),
            ),
          ],
        ));
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(.35)),
        boxShadow: [BoxShadow(color: color.withOpacity(.12), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(.15), borderRadius: BorderRadius.circular(10)),
          child: FVIcon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 14),
        Text(value, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _ManageList extends StatelessWidget {
  final AdminDashboardController c;
  final int menu;
  final String addLabel;
  const _ManageList(this.c, this.menu, this.addLabel);

  @override
  Widget build(BuildContext context) {
    final list = c.listFor(menu);
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (list.isEmpty) {
              return Center(child: Text('Nothing here yet.', style: AppTypography.bodyMedium));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final e = list[i];
                return Dismissible(
                  key: ValueKey(e.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => c.remove(menu, e),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(14)),
                    child: const FVIcon(PhosphorIconsRegular.trash, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showEdit(context, e),
                        child: Ink(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary.withOpacity(.18),
                              child: Text(
                                e.title.isEmpty ? '?' : e.title[0].toUpperCase(),
                                style: AppTypography.headingSmall.copyWith(color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.headingSmall),
                                const SizedBox(height: 2),
                                Text(e.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                              ]),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.14),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(e.tag, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                            ),
                            const SizedBox(width: 6),
                            FVIcon(PhosphorIconsRegular.pencilSimple, size: 16, color: AppColors.textTertiary),
                          ]),
                        ),
                      ),
                    ),
                  ).fvIn(i),
                );
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: FVButton(text: addLabel, icon: const FVIcon(PhosphorIconsBold.plus, size: 18, color: Colors.white), onPressed: () => _showAdd(context)),
        ),
      ],
    );
  }

  void _showAdd(BuildContext context) {
    final title = TextEditingController();
    final sub = TextEditingController();
    _showForm(context, heading: addLabel, title: title, sub: sub, onSave: () => c.add(menu, title.text, sub.text));
  }

  void _showEdit(BuildContext context, AdminEntry e) {
    final title = TextEditingController(text: e.title);
    final sub = TextEditingController(text: e.subtitle);
    _showForm(
      context,
      heading: 'Edit ${e.title}',
      title: title,
      sub: sub,
      onSave: () => c.edit(menu, e, title.text, sub.text),
      onDelete: () => c.remove(menu, e),
    );
  }

  void _showForm(
    BuildContext context, {
    required String heading,
    required TextEditingController title,
    required TextEditingController sub,
    required VoidCallback onSave,
    VoidCallback? onDelete,
  }) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(heading, style: AppTypography.headingMedium),
          const SizedBox(height: 14),
          TextField(controller: title, decoration: const InputDecoration(hintText: 'Name / title')),
          const SizedBox(height: 10),
          TextField(controller: sub, decoration: const InputDecoration(hintText: 'Details')),
          const SizedBox(height: 16),
          FVButton(
            text: 'Save',
            onPressed: () {
              onSave();
              Get.back();
            },
          ),
          if (onDelete != null) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                onDelete();
                Get.back();
              },
              icon: FVIcon(PhosphorIconsRegular.trash, size: 18, color: AppColors.error),
              label: Text('Delete', style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
            ),
          ],
        ]),
      ),
      isScrollControlled: true,
    );
  }
}
