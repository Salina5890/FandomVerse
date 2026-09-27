import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../theme/admin_theme.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdminDashboardController>()
        ? Get.find<AdminDashboardController>()
        : Get.put(AdminDashboardController());
    final searchController = TextEditingController();

    return HoloScaffold(
      title: 'USER MANAGEMENT',
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
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (v) => controller.userSearchQuery.value = v,
                    style: AdminTheme.body(color: AdminTheme.textPrimary),
                    cursorColor: AdminTheme.cyan,
                    decoration: InputDecoration(
                      hintText: 'Search name or email…',
                      hintStyle: AdminTheme.body(
                        size: 13,
                        color: AdminTheme.textFaint,
                      ),
                      prefixIcon: Icon(
                        PhosphorIconsRegular.magnifyingGlass,
                        size: 18,
                        color: AdminTheme.textSecondary,
                      ),
                      suffixIcon: Obx(
                        () => controller.userSearchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  PhosphorIconsRegular.xCircle,
                                  size: 16,
                                  color: AdminTheme.textSecondary,
                                ),
                                onPressed: () {
                                  searchController.clear();
                                  controller.userSearchQuery.value = '';
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                      filled: true,
                      fillColor: AdminTheme.bgPanelRaised,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AdminTheme.hairline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AdminTheme.hairline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: AdminTheme.cyan,
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                HoloIconAction(
                  icon: PhosphorIconsBold.plus,
                  color: AdminTheme.cyan,
                  tooltip: 'Add User',
                  onPressed: () => _openUserForm(context, controller),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = controller.filteredUsers;
              if (list.isEmpty) {
                return Center(
                  child: Text('No matching users.', style: AdminTheme.mono()),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final user = list[i];
                  final regDate = DateFormat('MMM d, yyyy')
                      .format(user.createdAt);
                  final roleColor = user.isAdmin
                      ? AdminTheme.magenta
                      : AdminTheme.cyan;

                  return HoloPanel(
                    glowColor: roleColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AdminTheme.holoBorder,
                                boxShadow: AdminTheme.glow(
                                  roleColor,
                                  alpha: .3,
                                ),
                              ),
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : 'U',
                                style: AdminTheme.display(
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          user.name,
                                          style: AdminTheme.body(
                                            w: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      HoloBadge(
                                        text: user.role.toUpperCase(),
                                        color: roleColor,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.email,
                                    style: AdminTheme.mono(size: 11.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: AdminTheme.hairline, height: 22),
                        Row(
                          children: [
                            Icon(
                              PhosphorIconsRegular.calendarBlank,
                              size: 13,
                              color: AdminTheme.textFaint,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Joined $regDate',
                              style: AdminTheme.mono(size: 11),
                            ),
                            const Spacer(),
                            HoloIconAction(
                              icon: PhosphorIconsRegular.eye,
                              color: AdminTheme.cyan,
                              tooltip: 'View',
                              onPressed: () => _viewProfile(context, user),
                            ),
                            const SizedBox(width: 6),
                            HoloIconAction(
                              icon: PhosphorIconsRegular.pencilSimple,
                              color: AdminTheme.amber,
                              tooltip: 'Edit',
                              onPressed: () => _openUserForm(
                                context,
                                controller,
                                existing: user,
                              ),
                            ),
                            const SizedBox(width: 6),
                            HoloIconAction(
                              icon: PhosphorIconsRegular.trash,
                              color: AdminTheme.red,
                              tooltip: 'Remove',
                              onPressed: () => showHoloConfirm(
                                title: 'Remove User',
                                message: 'Remove "${user.name}" permanently?',
                                confirmLabel: 'Remove',
                                onConfirm: () => controller.deleteUser(user.id),
                              ),
                            ),
                          ],
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

  void _openUserForm(
    BuildContext context,
    AdminDashboardController controller, {
    UserModel? existing,
  }) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');

    showHoloSheet(
      context: context,
      title: existing == null ? 'Add User' : 'Edit User',
      children: [
        HoloTextField(label: 'Full Name', controller: nameCtrl),
        const SizedBox(height: 12),
        HoloTextField(
          label: 'Email Address',
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        HoloButton(
          label: existing == null ? 'Save User' : 'Update User',
          icon: PhosphorIconsBold.checkCircle,
          onPressed: () {
            if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty) {
              Get.snackbar('Missing Fields', 'Enter both name and email.');
              return;
            }
            if (existing == null) {
              controller.addUser(name: nameCtrl.text, email: emailCtrl.text);
            } else {
              controller.editUser(
                id: existing.id,
                name: nameCtrl.text,
                email: emailCtrl.text,
              );
            }
            Get.back();
          },
        ),
      ],
    );
  }

  void _viewProfile(BuildContext context, UserModel user) {
    final regDate = DateFormat('MMMM d, yyyy').format(user.createdAt);
    showHoloSheet(
      context: context,
      title: user.name,
      children: [
        _infoRow('User ID', user.id),
        _infoRow('Email', user.email),
        _infoRow('Role', user.role.toUpperCase()),
        _infoRow('Registered', regDate),
        _infoRow(
          'Fandoms',
          user.selectedFandomIds.isEmpty
              ? 'None'
              : user.selectedFandomIds.join(', '),
        ),
        _infoRow('Badges', '${user.badgeIds.length} earned'),
        if (user.bio != null && user.bio!.isNotEmpty)
          _infoRow('Bio', user.bio!),
        const SizedBox(height: 8),
        HoloButton(
          label: 'Close',
          style: HoloButtonStyle.outline,
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label.toUpperCase(),
              style: AdminTheme.mono(size: 10.5),
            ),
          ),
          Expanded(child: Text(value, style: AdminTheme.body(size: 13))),
        ],
      ),
    );
  }
}
