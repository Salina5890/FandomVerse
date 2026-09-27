import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/fv_theme_toggle.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../theme/admin_theme.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<AdminDashboardController>()
        ? Get.find<AdminDashboardController>()
        : Get.put(AdminDashboardController());

    return HoloScaffold(
      title: 'ADMIN // CONSOLE',

      actions: [
        // Global Fandom Verse Light / Dark mode.
        // Uses the same theme system as the Fan side.
        const FVThemeToggle(),

        const SizedBox(width: 8),

        // Existing logout functionality — unchanged.
        HoloIconAction(
          icon: PhosphorIconsRegular.signOut,
          color: AdminTheme.violet,
          tooltip: 'Logout',
          onPressed: () => showHoloConfirm(
            title: 'End Session',
            message: 'Log out of the admin console?',
            confirmLabel: 'Log Out',
            onConfirm: c.logout,
          ),
        ),

        const SizedBox(width: 8),
      ],

      body: RefreshIndicator(
        color: AdminTheme.violet,
        backgroundColor: AdminTheme.bgPanel,
        onRefresh: c.loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StatusHeader(),

              const SizedBox(height: 22),

              const _SectionLabel('OVERVIEW STATISTICS'),

              const SizedBox(height: 12),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        'Users',
                        '${c.totalUsersCount}',
                        PhosphorIconsRegular.usersThree,
                        AdminTheme.violet,
                        () => Get.toNamed(AppRoutes.adminUsers),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Posts',
                        '${c.totalPostsCount}',
                        PhosphorIconsRegular.article,
                        AdminTheme.violet,
                        () {
                          c.moderationTabIndex.value = 0;
                          Get.toNamed(AppRoutes.adminContent);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        'Events',
                        '${c.totalEventsCount}',
                        PhosphorIconsRegular.calendarBlank,
                        AdminTheme.violet,
                        () {
                          c.moderationTabIndex.value = 1;
                          Get.toNamed(AppRoutes.adminContent);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        'Merch',
                        '${c.totalProductsCount}',
                        PhosphorIconsRegular.storefront,
                        AdminTheme.violet,
                        () {
                          c.moderationTabIndex.value = 2;
                          Get.toNamed(AppRoutes.adminContent);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const _SectionLabel('QUICK NAVIGATION'),

              const SizedBox(height: 12),

              Obx(
                () => _NavTile(
                  title: 'Content & Event Moderation',
                  subtitle: 'Posts, conventions and the merchandise catalog',
                  icon: PhosphorIconsRegular.pencilSimple,
                  color: AdminTheme.violet,
                  count: c.posts.length + c.events.length + c.products.length,
                  onTap: () => Get.toNamed(AppRoutes.adminContent),
                ),
              ),

              const SizedBox(height: 10),

              Obx(
                () => _NavTile(
                  title: 'User Management',
                  subtitle: 'Browse, search, edit and remove fan accounts',
                  icon: PhosphorIconsRegular.usersThree,
                  color: AdminTheme.violet,
                  count: c.users.length,
                  onTap: () => Get.toNamed(AppRoutes.adminUsers),
                ),
              ),

              const SizedBox(height: 10),

              Obx(
                () => _NavTile(
                  title: 'Category Management',
                  subtitle: 'Fandom categories shown across the app',
                  icon: PhosphorIconsRegular.tag,
                  color: AdminTheme.violet,
                  count: c.categories.length,
                  onTap: () => Get.toNamed(AppRoutes.adminCategories),
                ),
              ),

              const SizedBox(height: 26),

              const _SectionLabel('SYSTEM ACTIVITY LOG'),

              const SizedBox(height: 12),

              Obx(() {
                final log = c.recentActivity.take(6).toList();

                if (log.isEmpty) {
                  return HoloPanel(
                    child: Text('No activity yet.', style: AdminTheme.mono()),
                  );
                }

                return HoloPanel(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  child: Column(
                    children: List.generate(log.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIconsFill.circle,
                              size: 6,
                              color: AdminTheme.violet,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                log[i],
                                style: AdminTheme.mono(
                                  size: 12.5,
                                  color: AdminTheme.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* STATUS HEADER                                                              */
/* -------------------------------------------------------------------------- */

class _StatusHeader extends StatelessWidget {
  const _StatusHeader();

  @override
  Widget build(BuildContext context) {
    return HoloPanel(
      glowColor: AdminTheme.violet,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AdminTheme.holoBorder,
              boxShadow: AdminTheme.glow(AdminTheme.violet, alpha: .28),
            ),
            child: const Icon(
              PhosphorIconsFill.shieldCheck,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WELCOME, OPERATOR', style: AdminTheme.display(size: 15)),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AdminTheme.violet,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Flexible(
                      child: Text(
                        'FandomVerse backend · SYSTEM ONLINE',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AdminTheme.mono(
                          size: 11.5,
                          color: AdminTheme.violet,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* SECTION LABEL                                                              */
/* -------------------------------------------------------------------------- */

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AdminTheme.mono(
        size: 12,
        color: AdminTheme.textFaint,
        w: FontWeight.w700,
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* STAT CARD                                                                  */
/* -------------------------------------------------------------------------- */

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard(this.label, this.value, this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return HoloPanel(
      glowColor: color,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HoloIconBox(icon: icon, color: color, size: 18),
              Icon(
                PhosphorIconsRegular.caretRight,
                size: 14,
                color: AdminTheme.textFaint,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(value, style: AdminTheme.display(size: 26, color: color)),

          const SizedBox(height: 2),

          Text(label.toUpperCase(), style: AdminTheme.mono(size: 11)),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/* NAVIGATION TILE                                                            */
/* -------------------------------------------------------------------------- */

class _NavTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoloPanel(
      glowColor: color,
      onTap: onTap,
      child: Row(
        children: [
          HoloIconBox(icon: icon, color: color, size: 20),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AdminTheme.body(w: FontWeight.w700)),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AdminTheme.body(
                    size: 12,
                    color: AdminTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          HoloBadge(text: '$count', color: color),

          const SizedBox(width: 8),

          Icon(
            PhosphorIconsRegular.caretRight,
            size: 14,
            color: AdminTheme.textFaint,
          ),
        ],
      ),
    );
  }
}
