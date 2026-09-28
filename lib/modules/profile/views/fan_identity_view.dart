import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/seed_data_service.dart';

class FanIdentityView extends StatelessWidget {
  const FanIdentityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Fan Identity', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Obx(() {
        final user = auth.currentUser.value;
        if (user == null) return const SizedBox();
        
        final userBadges = SeedDataService.badges.where((b) => user.badgeIds.contains(b.id)).toList();
        final userFandoms = SeedDataService.fandoms.where((f) => user.selectedFandomIds.contains(f.id)).toList();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Badges', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.BADGES),
                    child: Text('View All', style: AppTypography.buttonMedium.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (userBadges.isEmpty)
                Text('No badges earned yet.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary))
              else
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: userBadges.map((badge) => GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.BADGE_DETAIL, parameters: {'id': badge.id}),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: Text(badge.iconUrl, style: const TextStyle(fontSize: 32)),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(badge.name, style: AppTypography.caption.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                  )).toList(),
                ),
                
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Fandoms', style: AppTypography.headingMedium.copyWith(color: AppColors.textPrimary)),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.MY_FANDOMS),
                    child: Text('Edit', style: AppTypography.buttonMedium.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (userFandoms.isEmpty)
                Text('No fandoms selected.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary))
              else
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: userFandoms.map((f) => Chip(
                    label: Text(f.name, style: AppTypography.chipLabel.copyWith(color: AppColors.textPrimary)),
                    backgroundColor: AppColors.surface,
                    side: BorderSide(color: AppColors.borderSubtle),
                  )).toList(),
                ),
            ],
          ),
        );
      }),
    );
  }
}
