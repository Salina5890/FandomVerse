import 'package:flutter/material.dart';
import '../../../core/widgets/fv_icon.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_button.dart';
import '../controllers/profile_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const FVIcon(PhosphorIconsRegular.pencilSimple),
            onPressed: () => Get.toNamed(AppRoutes.editProfile),
          ),
          IconButton(
            icon: const FVIcon(PhosphorIconsRegular.gear),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.user.value;
        
        if (user == null) {
          return const Center(child: Text('Not logged in'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: FVImage(
                  imageUrl: user.avatarUrl ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
                  width: 100,
                  height: 100,
                  isCircular: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                user.name,
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '@${user.email.split('@').first}',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              if (user.bio != null)
                Text(
                  user.bio!,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: AppSpacing.xl),
              
              // Badges
              if (controller.userBadges.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Fan Badges', style: AppTypography.headingSmall),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.userBadges.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final badge = controller.userBadges[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(badge.iconEmoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(badge.name, style: AppTypography.labelLarge),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              
              // Menu Items
              _buildMenuItem(PhosphorIconsRegular.bookmarkSimple, 'Saved Content', () => Get.toNamed(AppRoutes.bookmarks)),
              _buildMenuItem(PhosphorIconsRegular.shoppingBag, 'Purchase History', () => Get.toNamed(AppRoutes.purchaseHistory)),
              _buildMenuItem(PhosphorIconsRegular.squaresFour, 'My Fandoms', () => Get.toNamed(AppRoutes.myFandoms)),
              _buildMenuItem(PhosphorIconsRegular.downloadSimple, 'Offline Content', () => Get.toNamed(AppRoutes.offlineContent)),
              
              const SizedBox(height: AppSpacing.xxl),
              
              FVButton(
                text: 'Log Out',
                variant: FVButtonVariant.outline,
                onPressed: controller.logout,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FVIcon(icon, color: AppColors.primaryLight),
      ),
      title: Text(title, style: AppTypography.bodyLarge),
      trailing: FVIcon(PhosphorIconsRegular.caretRight, size: 16, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
