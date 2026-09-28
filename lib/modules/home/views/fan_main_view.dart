import 'package:flutter/material.dart';

import '../../../core/widgets/fv_icon.dart';

import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../ai_helper/views/ai_helper_view.dart';
import '../../events/views/events_view.dart';
import '../../profile/views/profile_view.dart';
import '../../store/views/store_view.dart';
import '../controllers/fan_main_controller.dart';
import 'explore_view.dart';
import 'fan_home_view.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

class FanMainView extends StatelessWidget {
  const FanMainView({super.key});

  // Kept as canonical `const` widget instances (not built fresh per rebuild)
  // so Flutter's `identical(oldWidget, newWidget)` check still lets it skip
  // rebuilding a tab that isn't the one that just changed — the same
  // optimization the original fixed `const [...]` page list relied on.
  static const List<Widget> _tabs = [
    FanHomeView(),
    ExploreView(),
    EventsView(),
    StoreView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FanMainController>()
        ? Get.find<FanMainController>()
        : Get.put(FanMainController());

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        // Only build the tabs the user has actually opened. Unvisited tabs stay
        // as a cheap placeholder in the stack (no controller/data created for
        // them) until the first time they're tapped; visited tabs stay resident
        // afterwards so switching back to them doesn't reload their state.
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            for (var i = 0; i < _tabs.length; i++)
              controller.visitedTabs.contains(i)
                  ? _tabs[i]
                  : const SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: _FanNavigation(controller: controller),
        floatingActionButton: _AiLauncher(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class _FanNavigation extends StatelessWidget {
  final FanMainController controller;
  const _FanNavigation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(.96),
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.28),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                label: 'nav_home'.tr,
                icon: PhosphorIconsRegular.house,
                activeIcon: PhosphorIconsFill.house,
                controller: controller,
              ),
              _NavItem(
                index: 1,
                label: 'nav_explore'.tr,
                icon: PhosphorIconsRegular.compass,
                activeIcon: PhosphorIconsRegular.compass,
                controller: controller,
              ),
              _NavItem(
                index: 2,
                label: 'nav_events'.tr,
                icon: PhosphorIconsRegular.calendarBlank,
                activeIcon: PhosphorIconsRegular.calendarBlank,
                controller: controller,
              ),
              _NavItem(
                index: 3,
                label: 'nav_store'.tr,
                icon: PhosphorIconsRegular.shoppingBag,
                activeIcon: PhosphorIconsRegular.shoppingBag,
                controller: controller,
              ),
              _NavItem(
                index: 4,
                label: 'nav_profile'.tr,
                icon: PhosphorIconsRegular.user,
                activeIcon: PhosphorIconsRegular.user,
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final FanMainController controller;
  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final selected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(.13)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedScale(
          scale: selected ? 1 : .96,
          duration: const Duration(milliseconds: 220),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: FVIcon(
                  selected ? activeIcon : icon,
                  key: ValueKey(selected),
                  color: selected
                      ? AppColors.primaryLight
                      : AppColors.textSecondary,
                  size: 23,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: AppTypography.navLabel.copyWith(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiLauncher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(
        const AiHelperView(),
        isScrollControlled: true,
        ignoreSafeArea: false,
      ),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(.38),
              blurRadius: 22,
              spreadRadius: -2,
            ),
          ],
        ),
        child: const FVIcon(
          PhosphorIconsRegular.sparkle,
          color: Colors.white,
          size: 23,
        ),
      ),
    );
  }
}
