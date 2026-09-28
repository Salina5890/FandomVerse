import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_image.dart';
import '../../home/controllers/fan_main_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text('Not logged in'));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _ProfileHeader(controller: controller)),
            SliverToBoxAdapter(child: _ProfileIdentity(user: user)),
            SliverToBoxAdapter(
              child: _Stats(user: user, controller: controller),
            ),
            SliverToBoxAdapter(child: _ProfileMenu()),
            SliverToBoxAdapter(child: _Badges(controller: controller)),
            SliverToBoxAdapter(child: _Logout(controller: controller)),
            const SliverToBoxAdapter(child: SizedBox(height: 34)),
          ],
        );
      }),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  const _ProfileHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
        child: Row(
          children: [
            _CircleButton(
              icon: PhosphorIconsRegular.caretLeft,
              onTap: () {
                if (Get.isRegistered<FanMainController>()) {
                  Get.find<FanMainController>().changePage(0);
                }
              },
            ),
            const Spacer(),
            Text(
              'Profile',
              style: AppTypography.headingMedium.copyWith(fontSize: 19),
            ),
            const Spacer(),
            _CircleButton(
              icon: PhosphorIconsRegular.pencilSimple,
              onTap: () => Get.toNamed(AppRoutes.editProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardElevated.withOpacity(.75),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Center(child: FVIcon(icon, size: 19)),
        ),
      ),
    );
  }
}

class _ProfileIdentity extends StatelessWidget {
  final dynamic user;
  const _ProfileIdentity({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.editAvatar),
            child: Stack(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: FVImage(
                    imageUrl: user.avatarUrl ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300&q=85',
                    width: 98,
                    height: 98,
                    isCircular: true,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2.5),
                    ),
                    child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: AppTypography.headingMedium.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 2),
          Text(
            user.bio?.trim().isNotEmpty == true
                ? user.bio!
                : 'Fandom Verse fan',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final dynamic user;
  final ProfileController controller;
  const _Stats({required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        'Fandoms',
        '${user.selectedFandomIds?.length ?? 0}',
        PhosphorIconsRegular.stack,
      ),
      ('Badges', '${controller.userBadges?.length ?? 0}', PhosphorIconsRegular.medal),
      ('Year', '${user.createdAt?.year ?? DateTime.now().year}', PhosphorIconsRegular.calendarBlank),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Row(
        children: stats.map((item) {
          final index = stats.indexOf(item);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == stats.length - 1 ? 0 : 8,
              ),
              child: Container(
                height: 78,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FVIcon(item.$3, color: AppColors.primaryLight, size: 18),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      style: AppTypography.headingSmall.copyWith(fontSize: 17),
                    ),
                    Text(
                      item.$1,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Saved content',
        PhosphorIconsRegular.bookmarkSimple,
        AppRoutes.bookmarks,
      ),
      (
        'Purchase history',
        PhosphorIconsRegular.shoppingBag,
        AppRoutes.purchaseHistory,
      ),
      ('My fandoms', PhosphorIconsRegular.usersThree, AppRoutes.myFandoms),
      ('Activity', PhosphorIconsRegular.chartLineUp, AppRoutes.activity),
      ('Settings', PhosphorIconsRegular.gear, AppRoutes.settings),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card.withOpacity(.92),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: items.map((item) {
            final index = items.indexOf(item);
            return Column(
              children: [
                ListTile(
                  onTap: () => Get.toNamed(item.$3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 2,
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FVIcon(
                        item.$2,
                        color: AppColors.primaryLight,
                        size: 18,
                      ),
                    ),
                  ),
                  title: Text(item.$1, style: AppTypography.bodyMedium),
                  trailing: FVIcon(
                    PhosphorIconsRegular.caretRight,
                    color: AppColors.textTertiary,
                    size: 16,
                  ),
                ),
                if (index != items.length - 1)
                  Divider(
                    height: 1,
                    indent: 66,
                    endIndent: 14,
                    color: AppColors.borderSubtle,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Badges extends StatelessWidget {
  final ProfileController controller;
  const _Badges({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.userBadges.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your badges', style: AppTypography.headingSmall),
          const SizedBox(height: 9),
          SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.userBadges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final badge = controller.userBadges[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(29),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(.22),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        badge.iconEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 7),
                      Text(badge.name, style: AppTypography.labelSmall),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Logout extends StatelessWidget {
  final ProfileController controller;
  const _Logout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: OutlinedButton.icon(
        onPressed: controller.logout,
        icon: FVIcon(
          PhosphorIconsRegular.signOut,
          color: AppColors.error,
          size: 18,
        ),
        label: Text('Log out', style: TextStyle(color: AppColors.error)),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: BorderSide(color: AppColors.error.withOpacity(.28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
