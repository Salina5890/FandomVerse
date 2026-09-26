import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_theme_toggle.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdminDashboardController>()
        ? Get.find<AdminDashboardController>()
        : Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Console'),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: FVThemeToggle(),
          ),
          IconButton(
            icon: const FVIcon(PhosphorIconsRegular.signOut),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context, controller),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.85),
                        AppColors.cyan.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: const FVIcon(
                          PhosphorIconsFill.shieldCheck,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, Admin',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fandom Verse Pocket Edition • Management Overview',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Summary Cards / Stats
                Text('Overview Statistics', style: AppTypography.headingMedium),
                const SizedBox(height: 12),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            title: 'Total Users',
                            count: '${controller.totalUsersCount}',
                            icon: PhosphorIconsRegular.users,
                            accentColor: AppColors.primary,
                            onTap: () => Get.toNamed(AppRoutes.adminUsers),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title: 'Total Posts',
                            count: '${controller.totalPostsCount}',
                            icon: PhosphorIconsRegular.article,
                            accentColor: AppColors.rose,
                            onTap: () {
                              controller.moderationTabIndex.value = 0;
                              Get.toNamed(AppRoutes.adminContent);
                            },
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 12),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            title: 'Total Events',
                            count: '${controller.totalEventsCount}',
                            icon: PhosphorIconsRegular.calendarBlank,
                            accentColor: AppColors.cyan,
                            onTap: () {
                              controller.moderationTabIndex.value = 1;
                              Get.toNamed(AppRoutes.adminContent);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title: 'Merchandise',
                            count: '${controller.totalProductsCount}',
                            icon: PhosphorIconsRegular.storefront,
                            accentColor: AppColors.accent,
                            onTap: () {
                              controller.moderationTabIndex.value = 2;
                              Get.toNamed(AppRoutes.adminContent);
                            },
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: AppSpacing.xl),

                // Quick Navigation Menu
                Text('Quick Management Navigation', style: AppTypography.headingMedium),
                const SizedBox(height: 12),
                _NavMenuTile(
                  title: 'Content & Event Moderation',
                  subtitle: 'Manage articles, conventions, and merchandise catalog',
                  icon: PhosphorIconsRegular.pencilSimple,
                  color: AppColors.rose,
                  badgeText: '${controller.posts.length + controller.events.length + controller.products.length}',
                  onTap: () => Get.toNamed(AppRoutes.adminContent),
                ),
                const SizedBox(height: 10),
                _NavMenuTile(
                  title: 'User Management',
                  subtitle: 'Browse fans, search accounts, edit roles, and view profiles',
                  icon: PhosphorIconsRegular.usersThree,
                  color: AppColors.primary,
                  badgeText: '${controller.users.length}',
                  onTap: () => Get.toNamed(AppRoutes.adminUsers),
                ),
                const SizedBox(height: 10),
                _NavMenuTile(
                  title: 'Category Management',
                  subtitle: 'Add, update or delete fandom categories (Anime, Gaming, etc.)',
                  icon: PhosphorIconsRegular.tag,
                  color: AppColors.plum,
                  badgeText: '${controller.categories.length}',
                  onTap: () => Get.toNamed(AppRoutes.adminCategories),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Recent Activity
                Text('Recent Activity Logs', style: AppTypography.headingMedium),
                const SizedBox(height: 12),
                Obx(() => Column(
                      children: controller.recentActivity.take(4).map((act) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: FVIcon(
                                  PhosphorIconsRegular.checkCircle,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(act, style: AppTypography.bodyMedium),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )),
                const SizedBox(height: AppSpacing.lg),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context, controller),
                  icon: FVIcon(PhosphorIconsRegular.signOut, color: AppColors.error),
                  label: Text('Log Out of Admin Console', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AdminDashboardController controller) {
    Get.defaultDialog(
      title: 'Confirm Logout',
      titleStyle: AppTypography.headingMedium,
      middleText: 'Are you sure you want to log out of the admin console?',
      middleTextStyle: AppTypography.bodyMedium,
      textConfirm: 'Log Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FVIcon(icon, color: accentColor, size: 20),
                  ),
                  FVIcon(
                    PhosphorIconsRegular.caretRight,
                    color: AppColors.textTertiary,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                count,
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavMenuTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String badgeText;
  final VoidCallback onTap;

  const _NavMenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: FVIcon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.headingSmall),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FVIcon(
                PhosphorIconsRegular.caretRight,
                color: AppColors.textTertiary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
