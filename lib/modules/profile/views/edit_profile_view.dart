import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/edit_profile_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_animations.dart';
import '../../../core/widgets/fv_button.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_text_field.dart';

/// Edit Profile — hub screen for everything a fan can change about their
/// account: avatar, name, bio, followed fandoms, password, and account
/// deletion. Reachable from the profile app bar's edit icon.
class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<EditProfileController>()) {
      Get.put(EditProfileController());
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Edit Profile', style: AppTypography.headingMedium),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.editAvatar),
                child: Stack(
                  children: [
                    Obx(() => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 3),
                          ),
                          child: FVImage(imageUrl: controller.avatarUrl, width: 96, height: 96, isCircular: true),
                        )),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 2),
                        ),
                        child: const FVIcon(PhosphorIconsBold.camera, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ).fvIn(0),
            const SizedBox(height: AppSpacing.xl),
            FVTextField(
              label: 'Name',
              hint: 'Enter your name',
              controller: controller.nameController,
            ).fvIn(1),
            const SizedBox(height: AppSpacing.md),
            FVTextField(
              label: 'Email',
              hint: 'Your email',
              controller: controller.emailController,
            ).fvIn(2),
            const SizedBox(height: AppSpacing.md),
            FVTextField(
              label: 'Bio',
              hint: 'Tell us about yourself',
              controller: controller.bioController,
              maxLines: 5,
            ).fvIn(3),
            const SizedBox(height: AppSpacing.xl),
            Obx(() => FVButton(
              text: 'Save',
              onPressed: controller.saveProfile,
              isLoading: controller.isLoading.value,
              variant: FVButtonVariant.primary,
            )).fvIn(4),
            const SizedBox(height: AppSpacing.xl),
            _Row(
              icon: PhosphorIconsRegular.squaresFour,
              label: 'Manage My Fandoms',
              onTap: () => Get.toNamed(AppRoutes.myFandoms),
            ).fvIn(5),
            _Row(
              icon: PhosphorIconsRegular.lockKey,
              label: 'Change Password',
              onTap: () => _showChangePassword(context),
            ).fvIn(6),
            const SizedBox(height: AppSpacing.lg),
            _Row(
              icon: PhosphorIconsRegular.trash,
              label: 'Delete Account',
              danger: true,
              onTap: () => _confirmDelete(context),
            ).fvIn(7),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    final current = TextEditingController();
    final next = TextEditingController();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Change Password', style: AppTypography.headingMedium),
          const SizedBox(height: 14),
          FVTextField(label: 'Current password', hint: '••••••••', controller: current, isPassword: true),
          const SizedBox(height: 10),
          FVTextField(label: 'New password', hint: 'At least 6 characters', controller: next, isPassword: true),
          const SizedBox(height: 16),
          Obx(() => FVButton(
                text: 'Update Password',
                isLoading: controller.isChangingPassword.value,
                onPressed: () async {
                  final ok = await controller.changePassword(current.text, next.text);
                  if (ok) Get.back();
                },
              )),
        ]),
      ),
      isScrollControlled: true,
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete your account?', style: AppTypography.headingSmall),
        content: Text(
          'This permanently removes your profile, bookmarks, wishlist, cart and order history from this device. This can\'t be undone.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          Obx(() => TextButton(
                onPressed: controller.isDeleting.value
                    ? null
                    : () async {
                        await controller.deleteAccount();
                        if (Get.isDialogOpen ?? false) Get.back();
                      },
                child: Text(
                  controller.isDeleting.value ? 'Deleting…' : 'Delete',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                ),
              )),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  const _Row({required this.icon, required this.label, required this.onTap, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.textPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (danger ? AppColors.error : AppColors.primary).withOpacity(.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FVIcon(icon, size: 18, color: danger ? AppColors.error : AppColors.primaryLight),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: AppTypography.bodyLarge.copyWith(color: color))),
              FVIcon(PhosphorIconsRegular.caretRight, size: 16, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
