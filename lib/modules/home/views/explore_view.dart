import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/fv_icon.dart';
import '../../../core/widgets/fv_image.dart';
import '../../../core/widgets/fv_text_field.dart';
import '../../../data/models/content_model.dart';
import '../controllers/explore_controller.dart';
import 'gallery_full_screen_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ExploreController controller;

  final TextEditingController _newsSearchController = TextEditingController();
  final TextEditingController _gallerySearchController = TextEditingController();

  final List<({String label, IconData icon})> _tabs = const [
    (label: 'News', icon: PhosphorIconsRegular.newspaper),
    (label: 'Gallery', icon: PhosphorIconsRegular.image),
    (label: 'Videos', icon: PhosphorIconsRegular.videoCamera),
    (label: 'Podcasts', icon: PhosphorIconsRegular.microphone),
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ExploreController>()
        ? Get.find<ExploreController>()
        : Get.put(ExploreController());
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _newsSearchController.dispose();
    _gallerySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text('Resources Hub', style: AppTypography.headingMedium),
            Text(
              'Multimedia & Fandom Exploration',
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Search All Resources',
            icon: const FVIcon(PhosphorIconsRegular.magnifyingGlass),
            onPressed: () => Get.toNamed(AppRoutes.search),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTypography.buttonSmall.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: AppTypography.buttonSmall,
              tabs: _tabs.map((t) {
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FVIcon(t.icon, size: 16),
                      const SizedBox(width: 6),
                      Text(t.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildNewsTab(),
            _buildGalleryTab(),
            _buildVideosTab(),
            _buildPodcastsTab(),
          ],
        );
      }),
    );
  }

  // ──────────────────────────────────────────────────────────
  // 1. NEWS TAB
  // ──────────────────────────────────────────────────────────
  Widget _buildNewsTab() {
    return RefreshIndicator(
      onRefresh: () async => controller.loadExploreData(),
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.md, AppSpacing.pagePadding, 0),
              child: FVTextField(
                label: '',
                hint: 'Search latest news, lore, announcements...',
                controller: _newsSearchController,
                prefixIcon: FVIcon(PhosphorIconsRegular.magnifyingGlass, color: AppColors.textSecondary),
                suffixIcon: _newsSearchController.text.isNotEmpty
                    ? IconButton(
                        icon: const FVIcon(PhosphorIconsRegular.x),
                        onPressed: () {
                          _newsSearchController.clear();
                          controller.newsSearchQuery.value = '';
                        },
                      )
                    : null,
                onChanged: (val) => controller.newsSearchQuery.value = val,
              ),
            ),
          ),

          // Trending Fandoms Carousel
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.md, AppSpacing.pagePadding, 8),
                  child: Text('Trending Fandoms', style: AppTypography.headingSmall),
                ),
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final fandoms = [
                        {'name': 'Attack on Titan', 'image': 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&q=80'},
                        {'name': 'Cyberpunk Universe', 'image': 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80'},
                        {'name': 'Demon Slayer', 'image': 'https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=800&q=80'},
                      ];
                      final f = fandoms[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(f['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            f['name']!,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Categories Filter Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: controller.newsCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = controller.newsCategories[index];
                  return Obx(() {
                    final isSelected = controller.selectedNewsCategory.value == cat;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      backgroundColor: AppColors.card,
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      onSelected: (_) => controller.filterNewsCategory(cat),
                    );
                  });
                },
              ),
            ),
          ),

          // News Feed Items
          Obx(() {
            final items = controller.filteredNews;
            if (items.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FVIcon(PhosphorIconsRegular.newspaperClipping, size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: 12),
                      Text('No news found', style: AppTypography.headingMedium),
                      const SizedBox(height: 4),
                      Text('Try changing category or search query', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final news = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildNewsCard(news),
                    );
                  },
                  childCount: items.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNewsCard(ContentModel news) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.contentDetail.replaceFirst(':id', news.id)),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    children: [
                      FVImage(
                        imageUrl: news.imageUrl!,
                        height: 180,
                        width: double.infinity,
                        borderRadius: 0,
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            news.fandomName ?? 'News',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: AppTypography.headingSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      news.description,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        FVIcon(PhosphorIconsRegular.user, size: 14, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(news.author, style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                        const Spacer(),
                        FVIcon(PhosphorIconsRegular.clock, size: 14, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text('${news.readTimeMinutes} min read', style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // 2. GALLERY TAB (GRID + FILTERS + FULL SCREEN ON TAP)
  // ──────────────────────────────────────────────────────────
  Widget _buildGalleryTab() {
    return RefreshIndicator(
      onRefresh: () async => controller.loadExploreData(),
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.md, AppSpacing.pagePadding, 0),
              child: FVTextField(
                label: '',
                hint: 'Search 4K wallpapers, art, gaming, anime...',
                controller: _gallerySearchController,
                prefixIcon: FVIcon(PhosphorIconsRegular.magnifyingGlass, color: AppColors.textSecondary),
                suffixIcon: _gallerySearchController.text.isNotEmpty
                    ? IconButton(
                        icon: const FVIcon(PhosphorIconsRegular.x),
                        onPressed: () {
                          _gallerySearchController.clear();
                          controller.gallerySearchQuery.value = '';
                        },
                      )
                    : null,
                onChanged: (val) => controller.gallerySearchQuery.value = val,
              ),
            ),
          ),

          // Fandom Type / Category Filters
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: controller.galleryCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = controller.galleryCategories[index];
                  return Obx(() {
                    final isSelected = controller.selectedGalleryCategory.value == cat;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      backgroundColor: AppColors.card,
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      onSelected: (_) => controller.filterGalleryCategory(cat),
                    );
                  });
                },
              ),
            ),
          ),

          // Gallery 2-Column Grid
          Obx(() {
            final items = controller.filteredGalleries;
            if (items.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FVIcon(PhosphorIconsRegular.images, size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: 12),
                      Text('No gallery images found', style: AppTypography.headingMedium),
                      const SizedBox(height: 4),
                      Text('Try picking another category or query', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = items[index];
                    return _buildGalleryGridItem(item);
                  },
                  childCount: items.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGalleryGridItem(ContentModel item) {
    final imageCount = item.galleryUrls.isNotEmpty ? item.galleryUrls.length : 1;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image with Hero tag
            Hero(
              tag: 'gallery_${item.id}',
              child: FVImage(
                imageUrl: item.imageUrl ?? (item.galleryUrls.isNotEmpty ? item.galleryUrls.first : ''),
                fit: BoxFit.cover,
                borderRadius: 0,
              ),
            ),

            // Gradient Overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),

            // Top Badges (Fandom & Count)
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.fandomName ?? 'Art',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  if (imageCount > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FVIcon(PhosphorIconsRegular.copy, size: 10, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            '$imageCount',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Info (Title & Offline Save Button)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        item.author,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      const FVIcon(PhosphorIconsRegular.arrowsOutSimple, size: 14, color: Colors.white70),
                    ],
                  ),
                ],
              ),
            ),

            // Tap Overlay for Full Screen
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.to(() => GalleryFullScreenView(content: item)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // 3. VIDEOS TAB (CLIPS & TRAILERS)
  // ──────────────────────────────────────────────────────────
  Widget _buildVideosTab() {
    return RefreshIndicator(
      onRefresh: () async => controller.loadExploreData(),
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: controller.allVideos.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
        itemBuilder: (context, index) {
          final video = controller.allVideos[index];
          return _buildVideoCard(video);
        },
      ),
    );
  }

  Widget _buildVideoCard(ContentModel video) {
    final minutes = (video.durationSeconds ?? 300) ~/ 60;
    final seconds = (video.durationSeconds ?? 300) % 60;
    final durationStr = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail with Play Button
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                FVImage(
                  imageUrl: video.imageUrl ?? video.thumbnailUrl ?? '',
                  height: 200,
                  width: double.infinity,
                  borderRadius: 0,
                ),
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  height: 200,
                  width: double.infinity,
                ),
                // Play Icon Button
                GestureDetector(
                  onTap: () => _playVideo(video),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FVIcon(PhosphorIconsFill.play, color: Colors.white, size: 26),
                    ),
                  ),
                ),
                // Duration Pill
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      durationStr,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video.fandomName ?? 'Video',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${video.viewCount} views',
                      style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(video.title, style: AppTypography.headingSmall),
                const SizedBox(height: 4),
                Text(
                  video.description,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _playVideo(ContentModel video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(video.title, style: AppTypography.headingMedium),
                const SizedBox(height: 4),
                Text('Playing official video clip', style: AppTypography.caption.copyWith(color: AppColors.primaryLight)),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FVImage(imageUrl: video.imageUrl ?? '', height: 220, width: double.infinity),
                      Container(color: Colors.black.withValues(alpha: 0.4), height: 220),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FVIcon(PhosphorIconsFill.playCircle, size: 56, color: Colors.white),
                          SizedBox(height: 8),
                          Text('Streaming High Definition 1080p', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(video.body, style: AppTypography.bodySmall),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────
  // 4. PODCASTS TAB (EPISODES & AUDIO PLAYER)
  // ──────────────────────────────────────────────────────────
  Widget _buildPodcastsTab() {
    return RefreshIndicator(
      onRefresh: () async => controller.loadExploreData(),
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: controller.allPodcasts.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final podcast = controller.allPodcasts[index];
          return _buildPodcastCard(podcast);
        },
      ),
    );
  }

  Widget _buildPodcastCard(ContentModel podcast) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Podcast Artwork
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FVImage(
              imageUrl: podcast.imageUrl ?? 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=300&q=80',
              width: 90,
              height: 90,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    podcast.fandomName ?? 'Podcast',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  podcast.title,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${podcast.readTimeMinutes} mins • ${podcast.author}',
                  style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.rawSnackbar(
                          title: 'Now Playing',
                          message: podcast.title,
                          icon: const FVIcon(PhosphorIconsFill.play, color: Colors.white),
                          backgroundColor: AppColors.card,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(AppSpacing.md),
                          borderRadius: 14,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const FVIcon(PhosphorIconsFill.play, size: 14, color: Colors.white),
                      label: const Text('Play Episode', style: TextStyle(fontSize: 12)),
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
