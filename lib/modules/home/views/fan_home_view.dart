import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/widgets/fv_icon.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_logo.dart';
import '../../../core/widgets/fv_theme_toggle.dart';
import '../../../data/models/content_model.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/fandom_model.dart';
import '../controllers/fan_home_controller.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/widgets/fv_animations.dart';

class FanHomeView extends StatelessWidget {
  const FanHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FanHomeController>()
        ? Get.find<FanHomeController>()
        : Get.put(FanHomeController());
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) return const _HomeSkeleton();

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.card,
          onRefresh: () async => controller.onInit(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context).fvIn(0)),
              SliverToBoxAdapter(child: _buildHero(context, size).fvIn(1)),
              SliverToBoxAdapter(child: _buildQuickActions(context).fvIn(2)),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  eyebrow: 'DISCOVER',
                  title: 'Trending fandoms',
                  action: 'Explore all',
                  onTap: () => Get.toNamed(AppRoutes.fanExplore),
                ),
              ),
              SliverToBoxAdapter(child: _buildFandoms(context, controller)),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  eyebrow: 'FOR YOU',
                  title: 'Latest from your universe',
                  action: 'See all',
                  onTap: () => Get.toNamed(AppRoutes.fanExplore),
                ),
              ),
              SliverToBoxAdapter(child: _buildContent(context, controller)),
              SliverToBoxAdapter(child: _buildHubBanner(context).fvIn(1)),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  eyebrow: 'HAPPENING SOON',
                  title: 'Events worth showing up for',
                  action: 'View calendar',
                  onTap: () => Get.toNamed(AppRoutes.eventCalendar),
                ),
              ),
              SliverToBoxAdapter(child: _buildEvents(context, controller)),
              const SliverToBoxAdapter(child: SizedBox(height: 36)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FVLogo(width: 40, showWordmark: false),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, fan.',
                            style: AppTypography.headingSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Your universe, all in one place.',
                            style: AppTypography.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: FVThemeToggle(),
            ),
            const SizedBox(width: 8),
            _IconButton(
              icon: PhosphorIconsRegular.magnifyingGlass,
              onTap: () => Get.toNamed(AppRoutes.search),
            ),
            const SizedBox(width: 5),
            _IconButton(
              icon: PhosphorIconsRegular.bell,
              badge: '3',
              onTap: () => Get.toNamed(AppRoutes.notifications),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: SizedBox(
        height: size.width > 600 ? 330 : 285,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: FVImage(
                imageUrl: 'https://images.unsplash.com/photo-1534809027769-b00d750a6bac?w=1400&q=85',
                fit: BoxFit.cover,
                borderRadius: 28,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.transparent,
                    Color(0x990A0A0F),
                    Color(0xF20A0A0F),
                  ],
                  stops: [0.05, 0.48, 1],
                ),
              ),
            ),
            Positioned(
              top: 18,
              right: 18,
              child: _GlassPill(
                icon: PhosphorIconsRegular.fire,
                text: 'TRENDING NOW',
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR NEXT\nOBSESSION',
                    style: AppTypography.displayMedium.copyWith(fontSize: 34),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover stories, characters, lore and events from the fandoms you love.',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withOpacity(.78),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () => Get.toNamed(AppRoutes.fanExplore),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const FVIcon(
                          PhosphorIconsRegular.compass,
                          size: 18,
                        ),
                        label: Text(
                          'Explore universe',
                          style: AppTypography.buttonSmall,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _CircleAction(
                        icon: PhosphorIconsRegular.bookmarkSimple,
                        onTap: () => Get.toNamed(AppRoutes.bookmarks),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      ('Saved', PhosphorIconsFill.bookmarkSimple, AppRoutes.bookmarks),
      ('Fan Hub', PhosphorIconsRegular.bookOpen, AppRoutes.fanHub),
      ('Nearby', PhosphorIconsRegular.navigationArrow, AppRoutes.nearbyEvents),
      ('Shop', PhosphorIconsRegular.shoppingBag, AppRoutes.fanStore),
    ];

    return SizedBox(
      height: 82,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final item = actions[index];
          return GestureDetector(
            onTap: () => Get.toNamed(item.$3),
            child: Container(
              width: 108,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FVIcon(
                    item.$2,
                    size: 23,
                    color: index == 1 ? AppColors.cyan : AppColors.primaryLight,
                  ),
                  Text(item.$1, style: AppTypography.labelMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFandoms(BuildContext context, FanHomeController controller) {
    return _FandomCarousel(fandoms: controller.featuredFandoms.toList());
  }

  Widget _buildContent(BuildContext context, FanHomeController controller) {
    return SizedBox(
      height: 262,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: controller.featuredContent.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, index) =>
            _ContentCard(content: controller.featuredContent[index])
                .fvInX(index),
      ),
    );
  }

  Widget _buildHubBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.fanHub),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppColors.cyanGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.18),
                blurRadius: 28,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.2),
                  shape: BoxShape.circle,
                ),
                child: const FVIcon(
                  PhosphorIconsRegular.bookOpen,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FAN HUB',
                      style: AppTypography.overline.copyWith(
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Go deeper into the stories you love.',
                      style: AppTypography.headingMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const FVIcon(
                PhosphorIconsRegular.arrowRight,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvents(BuildContext context, FanHomeController controller) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: controller.upcomingEvents.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, index) =>
            _EventCard(event: controller.upcomingEvents[index]).fvInX(index),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String action;
  final VoidCallback onTap;
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(title, style: AppTypography.headingXL),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              action,
              style: AppTypography.labelMedium.copyWith(color: AppColors.cyan),
            ),
          ),
        ],
      ),
    );
  }
}

class _FandomCarousel extends StatefulWidget {
  final List<FandomModel> fandoms;
  const _FandomCarousel({required this.fandoms});

  @override
  State<_FandomCarousel> createState() => _FandomCarouselState();
}

class _FandomCarouselState extends State<_FandomCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: .82, initialPage: 0);
    if (widget.fandoms.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted || !_pageController.hasClients) return;
        final next = (_page + 1) % widget.fandoms.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fandoms.isEmpty) return const SizedBox(height: 214);
    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.fandoms.length,
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (_, index) => AnimatedScale(
              scale: index == _page ? 1 : .96,
              duration: const Duration(milliseconds: 280),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _FandomCard(
                  fandom: widget.fandoms[index],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.fandoms.length, (index) {
            final active = index == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: active ? AppColors.primaryLight : AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FandomCard extends StatelessWidget {
  final FandomModel fandom;
  const _FandomCard({required this.fandom});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.fandomDetail, arguments: fandom),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FVImage(
                imageUrl: fandom.coverImageUrl,
                width: double.infinity,
                height: 202,
                borderRadius: 20,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE60A0A0F)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fandom.category.toUpperCase(),
                    style: AppTypography.overline.copyWith(
                      color: AppColors.cyan,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fandom.name,
                    style: AppTypography.headingSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_formatCount(fandom.memberCount)} fans',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final ContentModel content;
  const _ContentCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.contentDetail, arguments: content),
      child: SizedBox(
        width: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: FVImage(
                    imageUrl: content.imageUrl ?? content.thumbnailUrl ?? '',
                    width: 270,
                    height: 148,
                    borderRadius: 18,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: _GlassPill(
                    icon: PhosphorIconsRegular.lightning,
                    text: content.contentType.label.toUpperCase(),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: _CircleAction(
                    icon: PhosphorIconsRegular.bookmarkSimple,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content.fandomName ?? 'Fandom Verse',
              style: AppTypography.caption.copyWith(
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content.title,
              style: AppTypography.headingMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              '${content.readTimeMinutes} min read  •  ${content.author}',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.eventDetail, arguments: event),
      child: SizedBox(
        width: 285,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              SizedBox(
                width: 105,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FVImage(imageUrl: event.imageUrl ?? '', borderRadius: 0),
                    Container(color: Colors.black.withOpacity(.28)),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(.88),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('MMM')
                                  .format(event.eventDate)
                                  .toUpperCase(),
                              style: AppTypography.overline.copyWith(
                                color: AppColors.cyan,
                              ),
                            ),
                            Text(
                              DateFormat('dd').format(event.eventDate),
                              style: AppTypography.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.category.toUpperCase(),
                        style: AppTypography.overline.copyWith(
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.title,
                        style: AppTypography.headingMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FVIcon(
                            PhosphorIconsRegular.mapPin,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${event.city} • ${event.venue}',
                              style: AppTypography.caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: FVIcon(icon, size: 21, color: AppColors.textPrimary),
          ),
          if (badge != null)
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badge!,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: 40,
          height: 40,
          color: Colors.white.withOpacity(.12),
          child: FVIcon(icon, size: 19, color: Colors.white),
        ),
      ),
    ),
  );
}

class _GlassPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _GlassPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          color: Colors.black.withOpacity(.35),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FVIcon(icon, size: 13, color: AppColors.cyan),
              const SizedBox(width: 5),
              Text(
                text,
                style: AppTypography.overline.copyWith(
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: 285,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 80,
            child: Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i == 3 ? 0 : 10),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 190,
            height: 25,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 202,
            child: Row(
              children: List.generate(
                2,
                (i) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i == 1 ? 0 : 12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCount(int count) {
  if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K';
  return count.toString();
}
