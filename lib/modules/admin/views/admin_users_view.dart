import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../data/models/user_model.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdminDashboardController>()
        ? Get.find<AdminDashboardController>()
        : Get.put(AdminDashboardController());

    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('User Management'),
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
            // Search Bar & Add Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (val) => controller.userSearchQuery.value = val,
                          decoration: InputDecoration(
                            hintText: 'Search user by name or email...',
                            prefixIcon: const FVIcon(PhosphorIconsRegular.magnifyingGlass, size: 20),
                            suffixIcon: Obx(() => controller.userSearchQuery.value.isNotEmpty
                                ? IconButton(
                                    icon: const FVIcon(PhosphorIconsRegular.xCircle, size: 18),
                                    onPressed: () {
                                      searchController.clear();
                                      controller.userSearchQuery.value = '';
                                    },
                                  )
                                : const SizedBox.shrink()),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: AppColors.card,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FVButton(
                        text: 'Add User',
                        icon: const FVIcon(PhosphorIconsBold.plus, color: Colors.white, size: 16),
                        onPressed: () => _openUserForm(context, controller),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Users List / Table
            Expanded(
              child: Obx(() {
                final usersList = controller.filteredUsers;
                if (usersList.isEmpty) {
                  return Center(
                    child: Text(
                      'No matching users found.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: usersList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final user = usersList[i];
                    final regDate = DateFormat('MMM d, yyyy').format(user.createdAt);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: user.isAdmin
                                    ? AppColors.cyan.withValues(alpha: 0.18)
                                    : AppColors.primary.withValues(alpha: 0.18),
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                  style: TextStyle(
                                    color: user.isAdmin ? AppColors.cyan : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                                        Text(user.name, style: AppTypography.headingSmall),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: user.isAdmin
                                                ? AppColors.cyan.withValues(alpha: 0.15)
                                                : AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            user.role.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: user.isAdmin ? AppColors.cyan : AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user.email,
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              // Action Icons: View, Edit, Delete
                              IconButton(
                                icon: FVIcon(PhosphorIconsRegular.eye, size: 18, color: AppColors.cyan),
                                tooltip: 'View Full Profile',
                                onPressed: () => _viewProfileModal(context, user),
                              ),
                              IconButton(
                                icon: FVIcon(PhosphorIconsRegular.pencilSimple, size: 18, color: AppColors.primary),
                                tooltip: 'Edit User Details',
                                onPressed: () => _openUserForm(context, controller, existing: user),
                              ),
                              IconButton(
                                icon: FVIcon(PhosphorIconsRegular.trash, size: 18, color: AppColors.error),
                                tooltip: 'Remove User',
                                onPressed: () => _confirmDeleteUser(context, user, controller),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Selected Fandoms
                              Expanded(
                                child: Row(
                                  children: [
                                    FVIcon(PhosphorIconsRegular.heart, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        user.selectedFandomIds.isEmpty
                                            ? 'No fandoms selected'
                                            : 'Fandoms: ${user.selectedFandomIds.join(', ')}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Registration Date
                              Row(
                                children: [
                                  FVIcon(PhosphorIconsRegular.calendarCheck, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Joined: $regDate',
                                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
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
      ),
    );
  }

  void _openUserForm(BuildContext context, AdminDashboardController controller, {UserModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    String selectedRole = existing?.role ?? 'fan';

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
              existing == null ? 'Add User' : 'Edit User Details',
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: 16),
            FVTextField(label: 'Full Name', controller: nameCtrl),
            const SizedBox(height: 12),
            FVTextField(label: 'Email Address', controller: emailCtrl, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            FVButton(
              text: existing == null ? 'Save User' : 'Update User',
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty) {
                  Get.snackbar('Check Fields', 'Please enter user name and email address.');
                  return;
                }
                if (existing == null) {
                  controller.addUser(
                    name: nameCtrl.text,
                    email: emailCtrl.text,
                    role: selectedRole,
                  );
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
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _viewProfileModal(BuildContext context, UserModel user) {
    final regDate = DateFormat('MMMM d, yyyy').format(user.createdAt);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: AppTypography.headingMedium),
                      const SizedBox(height: 2),
                      Text(user.email, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'ROLE: ${user.role.toUpperCase()}',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const FVIcon(PhosphorIconsRegular.x),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            _infoRow('User ID', user.id),
            const SizedBox(height: 10),
            _infoRow('Registration Date', regDate),
            const SizedBox(height: 10),
            _infoRow('Selected Fandoms', user.selectedFandomIds.isEmpty ? 'None' : user.selectedFandomIds.join(', ')),
            const SizedBox(height: 10),
            _infoRow('Earned Badges', user.badgeIds.isEmpty ? 'None yet' : '${user.badgeIds.length} Badges'),
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _infoRow('Bio', user.bio!),
            ],
            const SizedBox(height: 24),
            FVButton(
              text: 'Close Profile',
              variant: FVButtonVariant.outline,
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
        Expanded(
          child: Text(value, style: AppTypography.bodyMedium),
        ),
      ],
    );
  }

  void _confirmDeleteUser(BuildContext context, UserModel user, AdminDashboardController controller) {
    Get.defaultDialog(
      title: 'Remove User',
      titleStyle: AppTypography.headingMedium,
      middleText: 'Are you sure you want to remove user "${user.name}"?',
      middleTextStyle: AppTypography.bodyMedium,
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back();
        controller.deleteUser(user.id);
      },
    );
  }
}
